import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval_log_model.freezed.dart';
part 'approval_log_model.g.dart';

/// Firestore model for a single entry written into the `approvals` collection
/// (top-level log) and each submission's `history` sub-collection simultaneously.
///
/// Schema example:
/// ```
/// /approvals/{logId}
///   module:       "cash_advance"
///   documentId:   "abc123"
///   actorUid:     "uid_xyz"
///   actorName:    "John Doe"
///   actorRole:    "pic_project"
///   action:       "approve"
///   fromStatus:   "pending_pic"
///   toStatus:     "pending_finance"
///   note:         null
///   timestampMs:  1700000000000
/// ```
@freezed
class ApprovalLogModel with _$ApprovalLogModel {
  const factory ApprovalLogModel({
    required String id,

    /// Which financial module this log entry belongs to.
    required String module,

    /// The Firestore document ID of the submission.
    required String documentId,

    /// Firebase UID of the actor who performed the action.
    required String actorUid,

    /// Display name of the actor at the time of the action.
    required String actorName,

    /// Role of the actor (e.g. 'pic_project', 'finance').
    required String actorRole,

    /// The action performed (matches [ApprovalAction.value]).
    required String action,

    /// Status before the action was taken.
    required String fromStatus,

    /// Status after the action was taken.
    required String toStatus,

    /// Optional note / reason provided by the actor.
    String? note,

    /// Epoch ms of when the transition occurred (set server-side if possible).
    required int timestampMs,
  }) = _ApprovalLogModel;

  factory ApprovalLogModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalLogModelFromJson(json);

  const ApprovalLogModel._();

  /// Converts the model back to a Firestore-compatible map.
  /// Note: timestampMs is kept as an int; Cloud Functions / server-side
  /// logic should replace this with a FieldValue.serverTimestamp() before
  /// final persistence.
  Map<String, dynamic> toFirestore() => {
        'id': id,
        'module': module,
        'documentId': documentId,
        'actorUid': actorUid,
        'actorName': actorName,
        'actorRole': actorRole,
        'action': action,
        'fromStatus': fromStatus,
        'toStatus': toStatus,
        'note': note,
        'timestampMs': timestampMs,
      };

  factory ApprovalLogModel.fromFirestore(Map<String, dynamic> data) =>
      ApprovalLogModel(
        id: data['id'] as String? ?? '',
        module: data['module'] as String? ?? '',
        documentId: data['documentId'] as String? ?? '',
        actorUid: data['actorUid'] as String? ?? '',
        actorName: data['actorName'] as String? ?? '',
        actorRole: data['actorRole'] as String? ?? '',
        action: data['action'] as String? ?? '',
        fromStatus: data['fromStatus'] as String? ?? '',
        toStatus: data['toStatus'] as String? ?? '',
        note: data['note'] as String?,
        timestampMs: (data['timestampMs'] as num?)?.toInt() ??
            DateTime.now().millisecondsSinceEpoch,
      );
}
