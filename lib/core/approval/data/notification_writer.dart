import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_constants.dart';
import '../../constants/firebase_constants.dart';
import '../approval_request.dart';

/// Writes notification documents inside a Firestore [Transaction].
///
/// Notification documents are written to the top-level `notifications`
/// collection. A Cloud Function then picks up each new document, fans out
/// an FCM push to the relevant topic or device tokens, and marks the
/// document as `delivered: true`.
///
/// Document schema:
/// ```
/// /notifications/{notifId}
///   type:          "approval_update"
///   module:        "cash_advance"
///   documentId:    "abc123"
///   actorUid:      "uid_xyz"
///   actorName:     "John Doe"
///   action:        "approve"
///   fromStatus:    "pending_pic"
///   toStatus:      "pending_finance"
///   recipientRole: "finance"          // role to fan-out FCM to
///   recipientUid:  null               // null = broadcast to role's FCM topic
///   note:          null
///   createdAtMs:   1700000000000
///   delivered:     false
/// ```
class NotificationWriter {
  const NotificationWriter(this._firestore);

  final FirebaseFirestore _firestore;

  /// Writes a notification record inside the provided [transaction].
  ///
  /// [toStatus] drives who should be notified:
  ///  - `pending_finance` → notify the `finance` FCM topic
  ///  - any other status  → notify the submission owner by uid
  void writeInTransaction({
    required Transaction transaction,
    required ApprovalRequest request,
    required String fromStatus,
    required String toStatus,
    required String submitterUid,
  }) {
    final notifRef =
        _firestore.collection(FirebaseConstants.notificationsCollection).doc();

    final recipientRole = _recipientRole(toStatus);
    final recipientUid = _recipientUid(toStatus, submitterUid);

    transaction.set(notifRef, {
      'type': 'approval_update',
      'module': request.module.value,
      'documentId': request.documentId,
      'actorUid': request.actorUid,
      'actorName': request.actorName,
      'action': request.action.value,
      'fromStatus': fromStatus,
      'toStatus': toStatus,
      'recipientRole': recipientRole,
      'recipientUid': recipientUid,
      'note': request.note,
      'createdAtMs': DateTime.now().millisecondsSinceEpoch,
      'delivered': false,
    });
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Returns the FCM topic role when notification fans out to a role group.
  /// Null means the recipient is a specific user (see [_recipientUid]).
  String? _recipientRole(String toStatus) => switch (toStatus) {
        'pending_finance' => AppConstants.roleFinance,
        _ => null,
      };

  /// Returns the specific uid to notify.
  /// Null when the notification targets a role topic instead.
  String? _recipientUid(String toStatus, String submitterUid) =>
      switch (toStatus) {
        'pending_finance' => null,
        _ => submitterUid,
      };
}
