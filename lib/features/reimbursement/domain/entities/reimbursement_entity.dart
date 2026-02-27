import 'package:equatable/equatable.dart';

import '../../../../core/constants/enums.dart';
import '../../../../shared/models/approval_history_model.dart';
import '../../../../shared/models/attachment_model.dart';

/// A single expense line item within a Reimbursement submission.
class ReimbursementItem extends Equatable {
  final String id;
  final ExpenseCategory category;
  final String description;
  final double amount;
  final DateTime receiptDate;
  final List<AttachmentEntity> receipts;

  const ReimbursementItem({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.receiptDate,
    this.receipts = const [],
  });

  ReimbursementItem copyWith({
    String? id,
    ExpenseCategory? category,
    String? description,
    double? amount,
    DateTime? receiptDate,
    List<AttachmentEntity>? receipts,
  }) {
    return ReimbursementItem(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      receiptDate: receiptDate ?? this.receiptDate,
      receipts: receipts ?? this.receipts,
    );
  }

  @override
  List<Object?> get props => [id, amount, category];
}

/// Domain entity for a Reimbursement submission.
class ReimbursementEntity extends Equatable {
  final String id;

  // ── Submitter ─────────────────────────────────────────────────────────────
  final String submittedByUid;
  final String submittedByName;

  // ── Project ───────────────────────────────────────────────────────────────
  final String projectId;
  final String projectName;

  // ── Financial Details ─────────────────────────────────────────────────────
  final List<ReimbursementItem> items;
  final double totalRequestedAmount; // sum of item amounts
  final double? totalApprovedAmount;
  final String currency;

  // ── Purpose ───────────────────────────────────────────────────────────────
  final String description;

  // ── Status ────────────────────────────────────────────────────────────────
  final SubmissionStatus status;

  // ── Approval Actors ───────────────────────────────────────────────────────
  final String? picUid;
  final String? financeUid;
  final String? picNote;
  final String? financeNote;
  final String? rejectionReason;

  // ── Timestamps ────────────────────────────────────────────────────────────
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? approvedByPicAt;
  final DateTime? approvedByFinanceAt;
  final DateTime? rejectedAt;
  final DateTime? paidAt;
  final DateTime? updatedAt;

  // ── Attachments & History ─────────────────────────────────────────────────
  final List<AttachmentEntity> attachments;
  final List<ApprovalHistoryEntity> history;

  const ReimbursementEntity({
    required this.id,
    required this.submittedByUid,
    required this.submittedByName,
    required this.projectId,
    required this.projectName,
    required this.items,
    required this.totalRequestedAmount,
    this.totalApprovedAmount,
    this.currency = 'IDR',
    this.description = '',
    this.status = SubmissionStatus.draft,
    this.picUid,
    this.financeUid,
    this.picNote,
    this.financeNote,
    this.rejectionReason,
    required this.createdAt,
    this.submittedAt,
    this.approvedByPicAt,
    this.approvedByFinanceAt,
    this.rejectedAt,
    this.paidAt,
    this.updatedAt,
    this.attachments = const [],
    this.history = const [],
  });

  bool get isEditable =>
      status == SubmissionStatus.draft || status == SubmissionStatus.revision;

  /// Computed total from line items (use for validation before submit).
  double get computedTotal =>
      items.fold(0.0, (sum, item) => sum + item.amount);

  ReimbursementEntity copyWith({
    String? id,
    String? submittedByUid,
    String? submittedByName,
    String? projectId,
    String? projectName,
    List<ReimbursementItem>? items,
    double? totalRequestedAmount,
    double? totalApprovedAmount,
    String? currency,
    String? description,
    SubmissionStatus? status,
    String? picUid,
    String? financeUid,
    String? picNote,
    String? financeNote,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? submittedAt,
    DateTime? approvedByPicAt,
    DateTime? approvedByFinanceAt,
    DateTime? rejectedAt,
    DateTime? paidAt,
    DateTime? updatedAt,
    List<AttachmentEntity>? attachments,
    List<ApprovalHistoryEntity>? history,
  }) {
    return ReimbursementEntity(
      id: id ?? this.id,
      submittedByUid: submittedByUid ?? this.submittedByUid,
      submittedByName: submittedByName ?? this.submittedByName,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      items: items ?? this.items,
      totalRequestedAmount: totalRequestedAmount ?? this.totalRequestedAmount,
      totalApprovedAmount: totalApprovedAmount ?? this.totalApprovedAmount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      status: status ?? this.status,
      picUid: picUid ?? this.picUid,
      financeUid: financeUid ?? this.financeUid,
      picNote: picNote ?? this.picNote,
      financeNote: financeNote ?? this.financeNote,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      approvedByPicAt: approvedByPicAt ?? this.approvedByPicAt,
      approvedByFinanceAt: approvedByFinanceAt ?? this.approvedByFinanceAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      paidAt: paidAt ?? this.paidAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachments: attachments ?? this.attachments,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props =>
      [id, status, totalRequestedAmount, submittedByUid];
}
