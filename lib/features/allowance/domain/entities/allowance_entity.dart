import 'package:equatable/equatable.dart';

import '../../../../core/constants/enums.dart';
import '../../../../shared/models/approval_history_model.dart';
import '../../../../shared/models/attachment_model.dart';

/// Domain entity for an Allowance submission.
class AllowanceEntity extends Equatable {
  final String id;

  // ── Submitter ─────────────────────────────────────────────────────────────
  final String submittedByUid;
  final String submittedByName;

  // ── Project (optional for allowances) ─────────────────────────────────────
  final String? projectId;
  final String? projectName;

  // ── Allowance Details ─────────────────────────────────────────────────────
  final AllowanceType type;
  final double requestedAmount;
  final double? approvedAmount;
  final String currency;
  final DateTime allowanceDate;
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

  const AllowanceEntity({
    required this.id,
    required this.submittedByUid,
    required this.submittedByName,
    this.projectId,
    this.projectName,
    required this.type,
    required this.requestedAmount,
    this.approvedAmount,
    this.currency = 'IDR',
    required this.allowanceDate,
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

  AllowanceEntity copyWith({
    String? id,
    String? submittedByUid,
    String? submittedByName,
    String? projectId,
    String? projectName,
    AllowanceType? type,
    double? requestedAmount,
    double? approvedAmount,
    String? currency,
    DateTime? allowanceDate,
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
    return AllowanceEntity(
      id: id ?? this.id,
      submittedByUid: submittedByUid ?? this.submittedByUid,
      submittedByName: submittedByName ?? this.submittedByName,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      type: type ?? this.type,
      requestedAmount: requestedAmount ?? this.requestedAmount,
      approvedAmount: approvedAmount ?? this.approvedAmount,
      currency: currency ?? this.currency,
      allowanceDate: allowanceDate ?? this.allowanceDate,
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
  List<Object?> get props => [id, status, requestedAmount, submittedByUid];
}
