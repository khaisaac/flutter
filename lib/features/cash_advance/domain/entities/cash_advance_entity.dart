import 'package:equatable/equatable.dart';

import '../../../../core/constants/enums.dart';
import '../../../../shared/models/approval_history_model.dart';
import '../../../../shared/models/attachment_model.dart';

/// Domain entity for a Cash Advance submission.
/// Pure Dart — zero external package dependencies except [Equatable].
class CashAdvanceEntity extends Equatable {
  final String id;

  // ── Submitter ─────────────────────────────────────────────────────────────
  final String submittedByUid;
  final String submittedByName;

  // ── Project ───────────────────────────────────────────────────────────────
  final String projectId;
  final String projectName;

  // ── Financial Details ─────────────────────────────────────────────────────
  final double requestedAmount;
  final double? approvedAmount; // set by Finance on approval
  final String currency;

  // ── Purpose ───────────────────────────────────────────────────────────────
  final String purpose;
  final String description;

  // ── Status ────────────────────────────────────────────────────────────────
  final SubmissionStatus status;

  // ── Approval Actors ───────────────────────────────────────────────────────
  final String? picUid;   // PIC Project who approved / rejected
  final String? financeUid; // Finance who processed

  // ── Notes ─────────────────────────────────────────────────────────────────
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

  // ── Settlement Tracking ───────────────────────────────────────────────────
  /// Remaining amount still to be reimbursed against this advance.
  /// Null until the first reimbursement is submitted against this CA;
  /// thereafter decremented per submitted reimbursement.
  final double? outstandingAmount;

  /// True when [outstandingAmount] has reached zero (fully settled).
  final bool isFullySettled;

  /// The effective outstanding amount, defaulting to [approvedAmount] when
  /// no reimbursement has been submitted yet.
  double get effectiveOutstanding =>
      outstandingAmount ?? approvedAmount ?? requestedAmount;

  const CashAdvanceEntity({
    required this.id,
    required this.submittedByUid,
    required this.submittedByName,
    required this.projectId,
    required this.projectName,
    required this.requestedAmount,
    this.approvedAmount,
    this.currency = 'IDR',
    required this.purpose,
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
    this.outstandingAmount,
    this.isFullySettled = false,
  });

  bool get isDraft => status == SubmissionStatus.draft;
  bool get isPendingPic => status == SubmissionStatus.pendingPic;
  bool get isPendingFinance => status == SubmissionStatus.pendingFinance;
  bool get isApproved => status == SubmissionStatus.approved;
  bool get isRejected => status == SubmissionStatus.rejected;
  bool get isPaid => status == SubmissionStatus.paid;
  bool get isEditable => status == SubmissionStatus.draft || status == SubmissionStatus.revision;

  CashAdvanceEntity copyWith({
    String? id,
    String? submittedByUid,
    String? submittedByName,
    String? projectId,
    String? projectName,
    double? requestedAmount,
    double? approvedAmount,
    String? currency,
    String? purpose,
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
    double? outstandingAmount,
    bool? isFullySettled,
  }) {
    return CashAdvanceEntity(
      id: id ?? this.id,
      submittedByUid: submittedByUid ?? this.submittedByUid,
      submittedByName: submittedByName ?? this.submittedByName,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      requestedAmount: requestedAmount ?? this.requestedAmount,
      approvedAmount: approvedAmount ?? this.approvedAmount,
      currency: currency ?? this.currency,
      purpose: purpose ?? this.purpose,
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
      outstandingAmount: outstandingAmount ?? this.outstandingAmount,
      isFullySettled: isFullySettled ?? this.isFullySettled,
    );
  }

  @override
  List<Object?> get props => [id, status, requestedAmount, submittedByUid];

  @override
  String toString() =>
      'CashAdvanceEntity(id: $id, status: ${status.value}, amount: $requestedAmount)';
}
