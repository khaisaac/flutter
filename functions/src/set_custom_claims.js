/**
 * Custom Claims — Reimbursement Hexa
 * ====================================
 * Manages Firebase Auth custom claims that encode user roles.
 *
 * Why custom claims?
 *   - Claims are cryptographically bound to the ID token and verified by
 *     both Firestore Security Rules and Firebase Storage Rules on every
 *     request — no additional Firestore read needed.
 *   - The claim payload is small (< 1 KB limit) and fast.
 *   - Roles cannot be self-assigned: only the Admin SDK (here, via an
 *     HTTPS Callable restricted to admins) can set them.
 *
 * Exported functions:
 *   setUserRole        — HTTPS Callable; admin-only; sets role claim.
 *   syncRoleOnCreate   — Auth trigger; seeds 'employee' claim on sign-up.
 *   revokeUserSessions — HTTPS Callable; admin-only; revokes all tokens.
 *
 * Setup
 * -----
 *   cd functions && npm install
 *   firebase deploy --only functions:setUserRole,functions:syncRoleOnCreate,functions:revokeUserSessions
 *
 * Dart / Flutter usage — force token refresh after role change:
 *   await FirebaseAuth.instance.currentUser?.getIdToken(true);
 */

'use strict';

const functions = require('firebase-functions');
const admin     = require('firebase-admin');

// admin.initializeApp() is called once in index.js — do not call it here.

const db   = admin.firestore();
const auth = admin.auth();

// ── Allowed role values (mirrors AppConstants in Dart) ────────────────────────
const VALID_ROLES = ['employee', 'pic_project', 'finance', 'admin'];

// ── Region — match your other Cloud Functions ─────────────────────────────────
const REGION = 'asia-southeast1';

// =============================================================================
// 1. setUserRole — HTTPS Callable (admin-only)
// =============================================================================
/**
 * Sets the `role` custom claim on a Firebase Auth user.
 *
 * Only an authenticated user whose OWN claim is already `admin` may call
 * this function. The Cloud Function validates this server-side via
 * `context.auth.token.role` — the Flutter UI role-guard is defence-in-depth
 * only and is NOT the security boundary.
 *
 * Request payload:
 * ```json
 * { "uid": "abc123", "role": "pic_project" }
 * ```
 *
 * Dart call:
 * ```dart
 * final fn = FirebaseFunctions.instanceFor(region: 'asia-southeast1')
 *                .httpsCallable('setUserRole');
 * await fn.call({'uid': targetUid, 'role': 'pic_project'});
 * // Force token refresh on the TARGET device — client polls or uses FCM.
 * ```
 *
 * After calling, the target user's client must force a token refresh to
 * pick up the new claim:
 * ```dart
 * await FirebaseAuth.instance.currentUser?.getIdToken(true);
 * ```
 */
exports.setUserRole = functions
  .region(REGION)
  .https.onCall(async (data, context) => {
    // ── Auth guard: caller must be authenticated ─────────────────────────────
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'You must be signed in to call this function.'
      );
    }

    // ── Role guard: caller must be admin ─────────────────────────────────────
    const callerRole = context.auth.token.role || 'employee';
    if (callerRole !== 'admin') {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Only admins may assign roles.'
      );
    }

    // ── Input validation ──────────────────────────────────────────────────────
    const { uid, role } = data;

    if (typeof uid !== 'string' || uid.trim() === '') {
      throw new functions.https.HttpsError('invalid-argument', 'uid must be a non-empty string.');
    }

    if (!VALID_ROLES.includes(role)) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `Invalid role "${role}". Must be one of: ${VALID_ROLES.join(', ')}.`
      );
    }

    // ── Prevent admin from demoting themselves ────────────────────────────────
    if (uid === context.auth.uid && role !== 'admin') {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Admin cannot remove their own admin role.'
      );
    }

    // ── Set the custom claim ──────────────────────────────────────────────────
    await auth.setCustomUserClaims(uid, { role });

    // ── Mirror the role into Firestore /users/{uid} ────────────────────────
    // Firestore is the source of truth for the UI; the claim is the
    // security boundary for rules evaluation.
    await db.collection('users').doc(uid).update({
      role,
      roleUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
      roleUpdatedBy: context.auth.uid,
    });

    // ── Write an audit log entry ───────────────────────────────────────────
    await db.collection('settings').doc('audit_log').collection('entries').add({
      action:       'role_change',
      targetUid:    uid,
      newRole:      role,
      performedBy:  context.auth.uid,
      performedAt:  admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(
      `[setUserRole] uid=${uid} role=${role} by=${context.auth.uid}`
    );

    return { success: true, uid, role };
  });

// =============================================================================
// 2. syncRoleOnCreate — Auth trigger
// =============================================================================
/**
 * Fires when a new Firebase Auth user is created (e.g. via Admin SDK
 * enrollment or email sign-up).
 *
 * Seeds the `employee` role as the default claim so the user is never
 * without a valid role. Admins can promote via `setUserRole`.
 *
 * Also creates a stub document in /users/{uid} so Firestore queries work
 * before the admin has filled in the profile.
 */
exports.syncRoleOnCreate = functions
  .region(REGION)
  .auth.user().onCreate(async (user) => {
    const defaultRole = 'employee';

    // Set default claim.
    await auth.setCustomUserClaims(user.uid, { role: defaultRole });

    // Create Firestore user document stub.
    await db.collection('users').doc(user.uid).set(
      {
        uid:         user.uid,
        email:       user.email || '',
        displayName: user.displayName || user.email?.split('@')[0] || 'User',
        role:        defaultRole,
        isActive:    true,
        createdAt:   admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true } // safe if doc already exists (e.g. pre-created by admin)
    );

    console.log(`[syncRoleOnCreate] uid=${user.uid} role=${defaultRole}`);
  });

// =============================================================================
// 3. revokeUserSessions — HTTPS Callable (admin-only)
// =============================================================================
/**
 * Revokes ALL refresh tokens for a given user, forcing immediate sign-out
 * on every device. Use for:
 *   - Employee offboarding
 *   - Suspicious-activity response
 *   - Role-demotion enforcement (token revocation takes effect within 1 hour
 *     for ID tokens, but instantly for sign-in attempts)
 *
 * Request payload:
 * ```json
 * { "uid": "abc123" }
 * ```
 */
exports.revokeUserSessions = functions
  .region(REGION)
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'Login required.');
    }

    const callerRole = context.auth.token.role || 'employee';
    if (callerRole !== 'admin') {
      throw new functions.https.HttpsError('permission-denied', 'Admins only.');
    }

    const { uid } = data;
    if (typeof uid !== 'string' || uid.trim() === '') {
      throw new functions.https.HttpsError('invalid-argument', 'uid required.');
    }

    // Revoke all refresh tokens.
    await auth.revokeRefreshTokens(uid);

    // Disable the account to prevent new sign-ins immediately.
    await auth.updateUser(uid, { disabled: true });

    // Reflect in Firestore.
    await db.collection('users').doc(uid).update({
      isActive:   false,
      disabledAt: admin.firestore.FieldValue.serverTimestamp(),
      disabledBy: context.auth.uid,
    });

    console.log(`[revokeUserSessions] uid=${uid} by=${context.auth.uid}`);

    return { success: true, uid };
  });

// =============================================================================
// 4. reactivateUser — HTTPS Callable (admin-only)
// =============================================================================
/**
 * Re-enables a previously disabled user account and restores their role.
 *
 * Request payload:
 * ```json
 * { "uid": "abc123", "role": "employee" }
 * ```
 */
exports.reactivateUser = functions
  .region(REGION)
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'Login required.');
    }

    const callerRole = context.auth.token.role || 'employee';
    if (callerRole !== 'admin') {
      throw new functions.https.HttpsError('permission-denied', 'Admins only.');
    }

    const { uid, role = 'employee' } = data;

    if (typeof uid !== 'string' || uid.trim() === '') {
      throw new functions.https.HttpsError('invalid-argument', 'uid required.');
    }

    if (!VALID_ROLES.includes(role)) {
      throw new functions.https.HttpsError('invalid-argument', `Invalid role: ${role}`);
    }

    await auth.updateUser(uid, { disabled: false });
    await auth.setCustomUserClaims(uid, { role });

    await db.collection('users').doc(uid).update({
      isActive:      true,
      role,
      reactivatedAt: admin.firestore.FieldValue.serverTimestamp(),
      reactivatedBy: context.auth.uid,
    });

    console.log(`[reactivateUser] uid=${uid} role=${role} by=${context.auth.uid}`);

    return { success: true, uid, role };
  });
