import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/models/approval_history_model.dart';
import '../../../../shared/models/attachment_model.dart';
import '../../domain/entities/allowance_entity.dart';
import '../../../../core/constants/enums.dart';

part 'allowance_model.freezed.dart';
part 'allowance_model.g.dart';

@freezed
class AllowanceModel with _$AllowanceModel {
  const factory AllowanceModel({
    required String id,
    required String submittedByUid,
    required String submittedByName,
    String? projectId,
    String? projectName,
    @Default('other') String type,
    required double requestedAmount,
    double? approvedAmount,
    @Default('IDR') String currency,
    required int allowanceDateMs,
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
  }) = _AllowanceModel;

  factory AllowanceModel.fromJson(Map<String, dynamic> json) =>
      _$AllowanceModelFromJson(json);

  const AllowanceModel._();

  factory AllowanceModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AllowanceModel.fromJson({
      ...data,
      'id': id,
      'createdAtMs': _tsToMillis(data['createdAt']),
      'allowanceDateMs': _tsToMillis(data['allowanceDate']),
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
        'type': type,
        'requestedAmount': requestedAmount,
        'approvedAmount': approvedAmount,
        'currency': currency,
        'allowanceDate': allowanceDateMs,
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

  AllowanceEntity toEntity() => AllowanceEntity(
        id: id,
        submittedByUid: submittedByUid,
        submittedByName: submittedByName,
        projectId: projectId,
        projectName: projectName,
        type: AllowanceType.fromValue(type),
        requestedAmount: requestedAmount,
        approvedAmount: approvedAmount,
        currency: currency,
        allowanceDate: DateTime.fromMillisecondsSinceEpoch(allowanceDateMs),
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

  factory AllowanceModel.fromEntity(AllowanceEntity e) => AllowanceModel(
        id: e.id,
        submittedByUid: e.submittedByUid,
        submittedByName: e.submittedByName,
        projectId: e.projectId,
        projectName: e.projectName,
        type: e.type.value,
        requestedAmount: e.requestedAmount,
        approvedAmount: e.approvedAmount,
        currency: e.currency,
        allowanceDateMs: e.allowanceDate.millisecondsSinceEpoch,
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
