/**
 * Cloud Functions for Firebase — Approval Engine
 * ================================================
 * This file contains server-side logic that complements the Flutter
 * ApprovalService.  Two responsibilities:
 *
 *  1. approvalNotificationFanout — triggered when a new document is created in
 *     the `notifications` collection; fans out FCM push messages to either a
 *     topic (role-based) or a specific device token (individual user).
 *
 *  2. validateApprovalRequest (HTTPS callable) — optional server-side
 *     validation that can be called instead of the client-side Firestore
 *     transaction for higher-assurance environments (e.g. audited finance
 *     systems where you want a server-authoritative approval trail with Cloud
 *     Function logs).
 *
 * Setup
 * -----
 *   cd functions
 *   npm install firebase-admin firebase-functions
 *   firebase deploy --only functions
 *
 * Required environment / secrets
 * --------------------------------
 *   firebase functions:config:set approval.env="production"
 *
 * Firestore security rules should additionally restrict direct client writes
 * to submission documents to ONLY allow status changes that match the
 * expected pipeline — use this Cloud Function as the write authority for
 * production deployments.
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// ── Role → FCM topic mapping ──────────────────────────────────────────────

const ROLE_TOPIC = {
  pic_project: 'pic_project',
  finance: 'finance',
  admin: 'admin',
};

// ── 1. FCM Fanout on new notification document ────────────────────────────

/**
 * Triggered on every new document in /notifications/{notifId}.
 * Sends an FCM push to:
 *   - A role topic  (if `recipientRole` is set and `recipientUid` is null)
 *   - A specific user (if `recipientUid` is set — looks up device tokens from
 *     /users/{uid}/deviceTokens sub-collection)
 *
 * After sending, marks the document `delivered: true` so the function is
 * idempotent on retry.
 */
exports.approvalNotificationFanout = functions
  .region('asia-southeast1')         // nearest region for SEA deployments
  .firestore
  .document('notifications/{notifId}')
  .onCreate(async (snapshot, context) => {
    const notif = snapshot.data();

    if (notif.delivered === true) {
      console.log(`[fanout] ${context.params.notifId} already delivered, skip.`);
      return null;
    }

    const { recipientRole, recipientUid, module, documentId, action, actorName, toStatus } = notif;

    const title = _buildTitle(action, module);
    const body  = _buildBody(action, actorName, toStatus);

    let sendResult;

    if (recipientUid) {
      // Direct push to a specific user's registered device tokens
      sendResult = await _sendToUser(recipientUid, title, body, notif);
    } else if (recipientRole && ROLE_TOPIC[recipientRole]) {
      // Broadcast to all subscribers of the role topic
      const topic = ROLE_TOPIC[recipientRole];
      sendResult = await messaging.sendToTopic(topic, {
        notification: { title, body },
        data: _buildData(notif),
      });
      console.log(`[fanout] topic=${topic} result=`, sendResult);
    } else {
      console.warn('[fanout] No recipient defined — skipping push.');
      return null;
    }

    // Mark delivered to prevent duplicate sends on Cloud Function retry
    await snapshot.ref.update({ delivered: true, deliveredAtMs: Date.now() });
    return sendResult;
  });

async function _sendToUser(uid, title, body, notif) {
  const tokensSnap = await db
    .collection('users').doc(uid)
    .collection('deviceTokens').get();

  if (tokensSnap.empty) {
    console.warn(`[fanout] No device tokens for uid=${uid}`);
    return null;
  }

  const tokens = tokensSnap.docs.map(d => d.data().token).filter(Boolean);
  if (tokens.length === 0) return null;

  const result = await messaging.sendMulticast({
    tokens,
    notification: { title, body },
    data: _buildData(notif),
  });

  // Clean up invalid tokens
  const invalidTokenRefs = [];
  result.responses.forEach((res, idx) => {
    if (!res.success &&
        (res.error.code === 'messaging/invalid-registration-token' ||
         res.error.code === 'messaging/registration-token-not-registered')) {
      invalidTokenRefs.push(tokensSnap.docs[idx].ref);
    }
  });
  if (invalidTokenRefs.length > 0) {
    const batch = db.batch();
    invalidTokenRefs.forEach(ref => batch.delete(ref));
    await batch.commit();
    console.log(`[fanout] Cleaned ${invalidTokenRefs.length} stale token(s) for uid=${uid}`);
  }

  console.log(`[fanout] uid=${uid} success=${result.successCount} fail=${result.failureCount}`);
  return result;
}

function _buildData(notif) {
  return {
    type:       notif.type       ?? 'approval_update',
    module:     notif.module     ?? '',
    documentId: notif.documentId ?? '',
    action:     notif.action     ?? '',
    toStatus:   notif.toStatus   ?? '',
  };
}

function _buildTitle(action, module) {
  const moduleName = {
    cash_advance:   'Cash Advance',
    allowance:      'Allowance',
    reimbursement:  'Reimbursement',
  }[module] ?? 'Submission';

  return {
    approve:  `${moduleName} Approved`,
    reject:   `${moduleName} Rejected`,
    revise:   `${moduleName} Needs Revision`,
    mark_paid:`${moduleName} Payment Disbursed`,
    submit:   `New ${moduleName} Submission`,
  }[action] ?? `${moduleName} Updated`;
}

function _buildBody(action, actorName, toStatus) {
  return {
    approve:  `${actorName} has approved your submission.`,
    reject:   `${actorName} has rejected your submission.`,
    revise:   `${actorName} returned the submission for revision.`,
    mark_paid:`Payment has been disbursed by ${actorName}.`,
    submit:   `A new submission is pending your review.`,
  }[action] ?? `Status changed to ${toStatus}.`;
}

// ── 2. HTTPS Callable — server-authoritative approval (optional) ──────────

/**
 * validateApprovalRequest (callable)
 * -----------------------------------
 * Use this instead of the client Firestore transaction in environments that
 * require a fully server-authoritative approval trail (e.g. ISO 27001,
 * internal audit requirements where no client-side write is acceptable).
 *
 * Mirrors the validation logic in the Dart `ApprovalService`:
 *   1. Resolve pipeline step for currentStatus.
 *   2. Validate actorRole.
 *   3. Validate action.
 *   4. Read Firestore document inside a transaction.
 *   5. Stale-status guard.
 *   6. Write parent update + history + audit log + notification.
 *
 * Called from Flutter:
 * ```dart
 * final callable = FirebaseFunctions.instance.httpsCallable('validateApprovalRequest');
 * await callable.call({ ...params });
 * ```
 */
exports.validateApprovalRequest = functions
  .region('asia-southeast1')
  .https.onCall(async (data, context) => {
    // Auth guard — Cloud Functions callable automatically populates context.auth
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'Login required.');
    }

    const {
      documentId, module, currentStatus,
      action, actorRole, actorUid, actorName, note,
    } = data;

    // Basic param validation
    if (!documentId || !module || !currentStatus || !action || !actorRole) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Missing required field(s): documentId, module, currentStatus, action, actorRole.',
      );
    }

    // Collection routing
    const COLLECTION = {
      cash_advance:  'cash_advances',
      allowance:     'allowances',
      reimbursement: 'reimbursements',
    };

    const collection = COLLECTION[module];
    if (!collection) {
      throw new functions.https.HttpsError('invalid-argument', `Unknown module: ${module}`);
    }

    // Pipeline definition (mirrors Dart ApprovalPipeline._sharedSteps)
    const PIPELINE = {
      pending_pic: {
        requiredRole: 'pic_project',
        allowed:      ['approve', 'reject', 'revise'],
        onApprove:    'pending_finance',
        onReject:     'rejected',
        onRevise:     'revision',
        label:        'PIC Project Review',
      },
      pending_finance: {
        requiredRole: 'finance',
        allowed:      ['approve', 'reject', 'revise', 'mark_paid'],
        onApprove:    'approved',
        onReject:     'rejected',
        onRevise:     'revision',
        label:        'Finance Processing',
      },
    };

    const step = PIPELINE[currentStatus];
    if (!step) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        `Cannot act on a submission with status "${currentStatus}".`,
      );
    }

    if (step.requiredRole !== actorRole) {
      throw new functions.https.HttpsError(
        'permission-denied',
        `Action requires role "${step.requiredRole}", actor has "${actorRole}".`,
      );
    }

    if (!step.allowed.includes(action)) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        `Action "${action}" not allowed at step "${step.label}".`,
      );
    }

    const now = Date.now();

    await db.runTransaction(async (txn) => {
      const parentRef = db.collection(collection).doc(documentId);
      const snap = await txn.get(parentRef);

      if (!snap.exists) {
        throw new functions.https.HttpsError('not-found', `Document ${documentId} not found.`);
      }

      const actualStatus = snap.data().status;
      if (actualStatus !== currentStatus) {
        throw new functions.https.HttpsError(
          'aborted',
          `Status changed. Expected "${currentStatus}", found "${actualStatus}".`,
        );
      }

      // Determine target status
      const toStatus = action === 'mark_paid' ? 'paid'
                     : action === 'approve'   ? step.onApprove
                     : action === 'reject'    ? step.onReject
                                              : step.onRevise;

      // Parent document update
      const parentUpdate = {
        status:       toStatus,
        updatedAtMs:  now,
        lastActorUid: actorUid,
        lastActorName: actorName,
      };
      if (actorRole === 'pic_project') {
        parentUpdate.picApproverUid   = actorUid;
        parentUpdate.picApprovedAtMs  = now;
      }
      if (actorRole === 'finance') {
        parentUpdate.financeApproverUid  = actorUid;
        parentUpdate.financeApprovedAtMs = now;
      }
      if (toStatus === 'paid')     parentUpdate.paidAtMs      = now;
      if (toStatus === 'rejected') parentUpdate.rejectionNote = note ?? null;
      if (toStatus === 'revision') parentUpdate.revisionNote  = note ?? null;

      txn.update(parentRef, parentUpdate);

      // History sub-collection
      const historyRef = parentRef.collection('history').doc();
      txn.set(historyRef, {
        id: historyRef.id, actorUid, actorName, actorRole,
        action, fromStatus: currentStatus, toStatus, note: note ?? null, timestampMs: now,
      });

      // Audit log
      const logRef = db.collection('approvals').doc();
      txn.set(logRef, {
        id: logRef.id, module, documentId, actorUid, actorName, actorRole,
        action, fromStatus: currentStatus, toStatus, note: note ?? null, timestampMs: now,
      });

      // Notification document (triggers approvalNotificationFanout)
      const submitterUid = snap.data().createdByUid ?? '';
      const notifRef = db.collection('notifications').doc();
      txn.set(notifRef, {
        type: 'approval_update', module, documentId, actorUid, actorName,
        action, fromStatus: currentStatus, toStatus,
        recipientRole: toStatus === 'pending_finance' ? 'finance' : null,
        recipientUid:  toStatus === 'pending_finance' ? null : submitterUid,
        note: note ?? null, createdAtMs: now, delivered: false,
      });
    });

    return { success: true };
  });
