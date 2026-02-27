import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/models/approval_history_model.dart';
import '../../../../shared/models/attachment_model.dart';
import '../../domain/entities/cash_advance_entity.dart';
import '../../../../core/constants/enums.dart';

part 'cash_advance_model.freezed.dart';
part 'cash_advance_model.g.dart';

/// Data-layer model for [CashAdvanceEntity].
/// All timestamps are stored as [int] (millisecondsSinceEpoch) to remain
/// compatible with [json_serializable] without a custom Timestamp converter.
///
/// Firestore write path:  [CashAdvanceModel] → [toFirestore()] → Firestore
/// Firestore read path:   Firestore → [CashAdvanceModel.fromFirestore()] → [toEntity()]
@freezed
class CashAdvanceModel with _$CashAdvanceModel {
  const factory CashAdvanceModel({
    required String id,
    required String submittedByUid,
    required String submittedByName,
    required String projectId,
    required String projectName,
    required double requestedAmount,
    double? approvedAmount,
    @Default('IDR') String currency,
    required String purpose,
    @Default('') String description,
    @Default('draft') String status,
    String? picUid,
    String? financeUid,
    String? picNote,
    String? financeNote,
    String? rejectionReason,
    required int createdAtMs,
    int? submittedAtMs,
    int? approvedByPicAtMs,
    int? approvedByFinanceAtMs,
    int? rejectedAtMs,
    int? paidAtMs,
    int? updatedAtMs,
    @Default([]) List<AttachmentModel> attachments,
    @Default([]) List<ApprovalHistoryModel> history,
  }) = _CashAdvanceModel;

  factory CashAdvanceModel.fromJson(Map<String, dynamic> json) =>
      _$CashAdvanceModelFromJson(json);

  const CashAdvanceModel._();

  // ── Firestore I/O ─────────────────────────────────────────────────────────

  /// Deserialises from a Firestore document snapshot.
  factory CashAdvanceModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CashAdvanceModel.fromJson({
      ...data,
      'id': id,
      // Firestore timestamps arrive as Timestamp objects; normalise to millis.
      'createdAtMs': _tsToMillis(data['createdAt']),
      'submittedAtMs': _tsToMillis(data['submittedAt']),
      'approvedByPicAtMs': _tsToMillis(data['approvedByPicAt']),
      'approvedByFinanceAtMs': _tsToMillis(data['approvedByFinanceAt']),
      'rejectedAtMs': _tsToMillis(data['rejectedAt']),
      'paidAtMs': _tsToMillis(data['paidAt']),
      'updatedAtMs': _tsToMillis(data['updatedAt']),
    });
  }

  /// Serialises to a Firestore-writable map.
  /// Timestamps are written as integers; server timestamps are handled
  /// separately via [FieldValue.serverTimestamp()] in the data source.
  Map<String, dynamic> toFirestore() => {
        'submittedByUid': submittedByUid,
        'submittedByName': submittedByName,
        'projectId': projectId,
        'projectName': projectName,
        'requestedAmount': requestedAmount,
        'approvedAmount': approvedAmount,
        'currency': currency,
        'purpose': purpose,
        'description': description,
        'status': status,
        'picUid': picUid,
        'financeUid': financeUid,
        'picNote': picNote,
        'financeNote': financeNote,
        'rejectionReason': rejectionReason,
        'createdAt': createdAtMs,
        'submittedAt': submittedAtMs,
        'approvedByPicAt': approvedByPicAtMs,
        'approvedByFinanceAt': approvedByFinanceAtMs,
        'rejectedAt': rejectedAtMs,
        'paidAt': paidAtMs,
        'updatedAt': updatedAtMs,
      };

  // ── Domain Mapping ────────────────────────────────────────────────────────

  CashAdvanceEntity toEntity() => CashAdvanceEntity(
        id: id,
        submittedByUid: submittedByUid,
        submittedByName: submittedByName,
        projectId: projectId,
        projectName: projectName,
        requestedAmount: requestedAmount,
        approvedAmount: approvedAmount,
        currency: currency,
        purpose: purpose,
        description: description,
        status: SubmissionStatus.fromValue(status),
        picUid: picUid,
        financeUid: financeUid,
        picNote: picNote,
        financeNote: financeNote,
        rejectionReason: rejectionReason,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
        submittedAt: submittedAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(submittedAtMs!)
            : null,
        approvedByPicAt: approvedByPicAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(approvedByPicAtMs!)
            : null,
        approvedByFinanceAt: approvedByFinanceAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(approvedByFinanceAtMs!)
            : null,
        rejectedAt: rejectedAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(rejectedAtMs!)
            : null,
        paidAt: paidAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(paidAtMs!)
            : null,
        updatedAt: updatedAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(updatedAtMs!)
            : null,
        attachments: attachments.map((a) => a.toEntity()).toList(),
        history: history.map((h) => h.toEntity()).toList(),
      );

  factory CashAdvanceModel.fromEntity(CashAdvanceEntity e) => CashAdvanceModel(
        id: e.id,
        submittedByUid: e.submittedByUid,
        submittedByName: e.submittedByName,
        projectId: e.projectId,
        projectName: e.projectName,
        requestedAmount: e.requestedAmount,
        approvedAmount: e.approvedAmount,
        currency: e.currency,
        purpose: e.purpose,
        description: e.description,
        status: e.status.value,
        picUid: e.picUid,
        financeUid: e.financeUid,
        picNote: e.picNote,
        financeNote: e.financeNote,
        rejectionReason: e.rejectionReason,
        createdAtMs: e.createdAt.millisecondsSinceEpoch,
        submittedAtMs: e.submittedAt?.millisecondsSinceEpoch,
        approvedByPicAtMs: e.approvedByPicAt?.millisecondsSinceEpoch,
        approvedByFinanceAtMs: e.approvedByFinanceAt?.millisecondsSinceEpoch,
        rejectedAtMs: e.rejectedAt?.millisecondsSinceEpoch,
        paidAtMs: e.paidAt?.millisecondsSinceEpoch,
        updatedAtMs: e.updatedAt?.millisecondsSinceEpoch,
        attachments: e.attachments.map(AttachmentModel.fromEntity).toList(),
        history: e.history.map(ApprovalHistoryModel.fromEntity).toList(),
      );

  // ── Private Helpers ───────────────────────────────────────────────────────

  static int? _tsToMillis(dynamic value) {
    if (value == null) return null;
    // Firestore Timestamp (duck-typed since we avoid importing Timestamp here)
    try {
      // ignore: avoid_dynamic_calls
      return (value.millisecondsSinceEpoch as int?) ??
          (value.toDate() as DateTime).millisecondsSinceEpoch;
    } catch (_) {}
    if (value is int) return value;
    if (value is String) return DateTime.tryParse(value)?.millisecondsSinceEpoch;
    return null;
  }
}
