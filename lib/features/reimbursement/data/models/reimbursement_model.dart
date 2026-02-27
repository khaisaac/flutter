import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/models/approval_history_model.dart';
import '../../../../shared/models/attachment_model.dart';
import '../../domain/entities/reimbursement_entity.dart';
import '../../../../core/constants/enums.dart';

part 'reimbursement_model.freezed.dart';
part 'reimbursement_model.g.dart';

/// Data model for a single expense line item.
@freezed
class ReimbursementItemModel with _$ReimbursementItemModel {
  const factory ReimbursementItemModel({
    required String id,
    @Default('other') String category,
    @Default('') String description,
    required double amount,
    required int receiptDateMs,
    @Default([]) List<AttachmentModel> receipts,
  }) = _ReimbursementItemModel;

  factory ReimbursementItemModel.fromJson(Map<String, dynamic> json) =>
      _$ReimbursementItemModelFromJson(json);

  const ReimbursementItemModel._();

  ReimbursementItem toEntity() => ReimbursementItem(
        id: id,
        category: ExpenseCategory.fromValue(category),
        description: description,
        amount: amount,
        receiptDate: DateTime.fromMillisecondsSinceEpoch(receiptDateMs),
        receipts: receipts.map((r) => r.toEntity()).toList(),
      );

  factory ReimbursementItemModel.fromEntity(ReimbursementItem e) =>
      ReimbursementItemModel(
        id: e.id,
        category: e.category.value,
        description: e.description,
        amount: e.amount,
        receiptDateMs: e.receiptDate.millisecondsSinceEpoch,
        receipts: e.receipts.map(AttachmentModel.fromEntity).toList(),
      );
}

/// Data model for a full Reimbursement submission.
@freezed
class ReimbursementModel with _$ReimbursementModel {
  const factory ReimbursementModel({
    required String id,
    required String submittedByUid,
    required String submittedByName,
    required String projectId,
    required String projectName,
    @Default([]) List<ReimbursementItemModel> items,
    required double totalRequestedAmount,
    double? totalApprovedAmount,
    @Default('IDR') String currency,
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
  }) = _ReimbursementModel;

  factory ReimbursementModel.fromJson(Map<String, dynamic> json) =>
      _$ReimbursementModelFromJson(json);

  const ReimbursementModel._();

  factory ReimbursementModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ReimbursementModel.fromJson({
      ...data,
      'id': id,
      'createdAtMs': _tsToMillis(data['createdAt']),
      'submittedAtMs': _tsToMillis(data['submittedAt']),
      'approvedByPicAtMs': _tsToMillis(data['approvedByPicAt']),
      'approvedByFinanceAtMs': _tsToMillis(data['approvedByFinanceAt']),
      'rejectedAtMs': _tsToMillis(data['rejectedAt']),
      'paidAtMs': _tsToMillis(data['paidAt']),
      'updatedAtMs': _tsToMillis(data['updatedAt']),
    });
  }

  Map<String, dynamic> toFirestore() => {
        'submittedByUid': submittedByUid,
        'submittedByName': submittedByName,
        'projectId': projectId,
        'projectName': projectName,
        'items': items.map((i) => i.toJson()).toList(),
        'totalRequestedAmount': totalRequestedAmount,
        'totalApprovedAmount': totalApprovedAmount,
        'currency': currency,
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

  ReimbursementEntity toEntity() => ReimbursementEntity(
        id: id,
        submittedByUid: submittedByUid,
        submittedByName: submittedByName,
        projectId: projectId,
        projectName: projectName,
        items: items.map((i) => i.toEntity()).toList(),
        totalRequestedAmount: totalRequestedAmount,
        totalApprovedAmount: totalApprovedAmount,
        currency: currency,
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

  factory ReimbursementModel.fromEntity(ReimbursementEntity e) =>
      ReimbursementModel(
        id: e.id,
        submittedByUid: e.submittedByUid,
        submittedByName: e.submittedByName,
        projectId: e.projectId,
        projectName: e.projectName,
        items: e.items.map(ReimbursementItemModel.fromEntity).toList(),
        totalRequestedAmount: e.totalRequestedAmount,
        totalApprovedAmount: e.totalApprovedAmount,
        currency: e.currency,
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

  static int? _tsToMillis(dynamic value) {
    if (value == null) return null;
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
