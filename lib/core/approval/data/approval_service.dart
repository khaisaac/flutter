import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../constants/enums.dart';
import '../../constants/firebase_constants.dart';
import '../../errors/exceptions.dart';
import '../../errors/failures.dart';
import '../../utils/typedefs.dart';
import '../approval_enums.dart';
import '../approval_request.dart';
import '../approval_step.dart';
import 'approval_log_model.dart';
import 'notification_writer.dart';

/// Core approval engine.
///
/// [ApprovalService.runApproval] is the single entry-point for every
/// state-change in every financial module.  It executes a Firestore
/// transaction that:
///
///  1. Reads the current parent document (optimistic-lock snapshot).
///  2. Validates actor role against the pipeline step for [currentStatus].
///  3. Validates the requested action is allowed at this step.
///  4. Validates the document's actual Firestore status matches the status
///     the actor saw when they opened the UI (stale-state guard).
///  5. Determines the target [SubmissionStatus] (approve / reject / revise).
///  6. Writes the updated status + timestamps back to the parent document.
///  7. Appends a history entry to the `{collection}/{id}/history` sub-collection.
///  8. Writes a top-level `approvals` log entry for audit/reporting.
///  9. Writes a `notifications` document for the Cloud Function FCM fanout.
///
/// All writes happen atomically inside a single [Transaction], so a partial
/// failure leaves the database unchanged.
class ApprovalService {
  ApprovalService({
    required FirebaseFirestore firestore,
    required NotificationWriter notificationWriter,
  })  : _firestore = firestore,
        _notificationWriter = notificationWriter;

  final FirebaseFirestore _firestore;
  final NotificationWriter _notificationWriter;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Execute an approval action described by [request].
  ///
  /// Returns [Right(true)] on success or [Left(Failure)] on any error.
  FutureEither<bool> runApproval(ApprovalRequest request) async {
    try {
      await _firestore.runTransaction((txn) async {
        await _executeApprovalTransaction(txn, request);
      });
      return const Right(true);
    } on ApprovalException catch (e) {
      return Left(_mapApprovalException(e));
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Firestore error during approval.',
          code: e.code,
        ),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ── Transaction core ───────────────────────────────────────────────────────

  Future<void> _executeApprovalTransaction(
    Transaction txn,
    ApprovalRequest request,
  ) async {
    final pipeline = ApprovalPipeline.forModule(request.module);

    // ── 1. Resolve the pipeline step for this status ───────────────────────
    final step = pipeline.stepForStatus(request.currentStatus);
    if (step == null) {
      throw InvalidApprovalStateException(
        status: request.currentStatus.value,
      );
    }

    // ── 2. Validate actor role ─────────────────────────────────────────────
    if (!step.isAuthorised(request.actorRole)) {
      throw UnauthorizedApprovalException(
        requiredRole: step.requiredRole,
        actorRole: request.actorRole,
      );
    }

    // ── 3. Validate action is permitted at this step ───────────────────────
    if (!step.canActWith(request.action)) {
      throw DisallowedActionException(
        action: request.action.value,
        step: step.label,
      );
    }

    // ── 4. Read parent document and perform stale-status check ────────────
    final collection = request.module.collection;
    final parentRef = _firestore.collection(collection).doc(request.documentId);
    final snapshot = await txn.get(parentRef);

    if (!snapshot.exists) {
      throw FirestoreException(
        message: 'Document ${request.documentId} not found in $collection.',
        code: 'document-not-found',
      );
    }

    final data = snapshot.data()!;
    final actualStatus = data['status'] as String? ?? '';

    if (actualStatus != request.currentStatus.value) {
      throw StaleStatusException(
        expected: request.currentStatus.value,
        actual: actualStatus,
      );
    }

    // ── 5. Determine target status ─────────────────────────────────────────
    final toStatus = _resolveTargetStatus(step, request.action);
    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;

    // ── 6. Update parent document ─────────────────────────────────────────
    final parentUpdate = <String, dynamic>{
      'status': toStatus.value,
      'updatedAtMs': nowMs,
      'lastActorUid': request.actorUid,
      'lastActorName': request.actorName,
      ...?request.extraFields,
      // Track per-step approver fields for quick queries:
      if (request.actorRole == 'pic_project') ...{
        'picApproverUid': request.actorUid,
        'picApprovedAtMs': nowMs,
      },
      if (request.actorRole == 'finance') ...{
        'financeApproverUid': request.actorUid,
        'financeApprovedAtMs': nowMs,
      },
      if (toStatus == SubmissionStatus.paid) 'paidAtMs': nowMs,
      if (toStatus == SubmissionStatus.rejected) 'rejectionNote': request.note,
      if (toStatus == SubmissionStatus.revision) 'revisionNote': request.note,
    };

    txn.update(parentRef, parentUpdate);

    // ── 7. Append to history sub-collection ───────────────────────────────
    final historyRef = parentRef
        .collection(FirebaseConstants.historySubCollection)
        .doc();

    txn.set(historyRef, {
      'id': historyRef.id,
      'actorUid': request.actorUid,
      'actorName': request.actorName,
      'actorRole': request.actorRole,
      'action': request.action.value,
      'fromStatus': request.currentStatus.value,
      'toStatus': toStatus.value,
      'note': request.note,
      'timestampMs': nowMs,
    });

    // ── 8. Write to top-level approvals audit log ─────────────────────────
    final logRef =
        _firestore.collection(FirebaseConstants.approvalsCollection).doc();

    final logModel = ApprovalLogModel(
      id: logRef.id,
      module: request.module.value,
      documentId: request.documentId,
      actorUid: request.actorUid,
      actorName: request.actorName,
      actorRole: request.actorRole,
      action: request.action.value,
      fromStatus: request.currentStatus.value,
      toStatus: toStatus.value,
      note: request.note,
      timestampMs: nowMs,
    );

    txn.set(logRef, logModel.toFirestore());

    // ── 9. Write notification document for CF push fanout ─────────────────
    final submitterUid = data['createdByUid'] as String? ?? '';
    _notificationWriter.writeInTransaction(
      transaction: txn,
      request: request,
      fromStatus: request.currentStatus.value,
      toStatus: toStatus.value,
      submitterUid: submitterUid,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  SubmissionStatus _resolveTargetStatus(
    ApprovalStep step,
    ApprovalAction action,
  ) =>
      switch (action) {
        ApprovalAction.approve => step.onApprove,
        ApprovalAction.reject => step.onReject,
        ApprovalAction.revise => step.onRevise ?? step.onReject,
        ApprovalAction.markPaid => SubmissionStatus.paid,
        ApprovalAction.submit =>
          throw InvalidApprovalStateException(status: 'submit'),
      };

  Failure _mapApprovalException(ApprovalException e) => switch (e) {
        InvalidApprovalStateException() =>
          InvalidApprovalStateFailure(status: e.code ?? ''),
        UnauthorizedApprovalException() => UnauthorizedApprovalFailure(
            requiredRole: '',
            actorRole: '',
          ),
        DisallowedActionException() => DisallowedActionFailure(
            action: '',
            step: '',
          ),
        StaleStatusException() => StaleStatusFailure(
            expected: '',
            actual: '',
          ),
        _ => ApprovalFailure(message: e.message),
      };
}
