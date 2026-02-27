import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval_history_model.freezed.dart';
part 'approval_history_model.g.dart';

/// A single node in the approval trail.
/// Appended to Firestore whenever a submission transitions state.
class ApprovalHistoryEntity {
  final String id;
  final String actorUid;
  final String actorName;
  final String actorRole;
  final String action; // e.g. 'submitted', 'approved', 'rejected', 'revised'
  final String fromStatus;
  final String toStatus;
  final String? note;
  final DateTime timestamp;

  const ApprovalHistoryEntity({
    required this.id,
    required this.actorUid,
    required this.actorName,
    required this.actorRole,
    required this.action,
    required this.fromStatus,
    required this.toStatus,
    this.note,
    required this.timestamp,
  });
}

/// Data-layer model for [ApprovalHistoryEntity].
/// Serialised into the `history` sub-collection of each submission.
@freezed
class ApprovalHistoryModel with _$ApprovalHistoryModel {
  const factory ApprovalHistoryModel({
    required String id,
    required String actorUid,
    required String actorName,
    required String actorRole,
    required String action,
    required String fromStatus,
    required String toStatus,
    String? note,
    required int timestampMs, // millisecondsSinceEpoch
  }) = _ApprovalHistoryModel;

  factory ApprovalHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalHistoryModelFromJson(json);

  const ApprovalHistoryModel._();

  ApprovalHistoryEntity toEntity() => ApprovalHistoryEntity(
        id: id,
        actorUid: actorUid,
        actorName: actorName,
        actorRole: actorRole,
        action: action,
        fromStatus: fromStatus,
        toStatus: toStatus,
        note: note,
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMs),
      );

  factory ApprovalHistoryModel.fromEntity(ApprovalHistoryEntity e) =>
      ApprovalHistoryModel(
        id: e.id,
        actorUid: e.actorUid,
        actorName: e.actorName,
        actorRole: e.actorRole,
        action: e.action,
        fromStatus: e.fromStatus,
        toStatus: e.toStatus,
        note: e.note,
        timestampMs: e.timestamp.millisecondsSinceEpoch,
      );
}
