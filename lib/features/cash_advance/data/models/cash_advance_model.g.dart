// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_advance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CashAdvanceModelImpl _$$CashAdvanceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CashAdvanceModelImpl(
      id: json['id'] as String,
      submittedByUid: json['submittedByUid'] as String,
      submittedByName: json['submittedByName'] as String,
      projectId: json['projectId'] as String,
      projectName: json['projectName'] as String,
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      approvedAmount: (json['approvedAmount'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'IDR',
      purpose: json['purpose'] as String,
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'draft',
      picUid: json['picUid'] as String?,
      financeUid: json['financeUid'] as String?,
      picNote: json['picNote'] as String?,
      financeNote: json['financeNote'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      createdAtMs: (json['createdAtMs'] as num).toInt(),
      submittedAtMs: (json['submittedAtMs'] as num?)?.toInt(),
      approvedByPicAtMs: (json['approvedByPicAtMs'] as num?)?.toInt(),
      approvedByFinanceAtMs: (json['approvedByFinanceAtMs'] as num?)?.toInt(),
      rejectedAtMs: (json['rejectedAtMs'] as num?)?.toInt(),
      paidAtMs: (json['paidAtMs'] as num?)?.toInt(),
      updatedAtMs: (json['updatedAtMs'] as num?)?.toInt(),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      history: (json['history'] as List<dynamic>?)
              ?.map((e) =>
                  ApprovalHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CashAdvanceModelImplToJson(
        _$CashAdvanceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'submittedByUid': instance.submittedByUid,
      'submittedByName': instance.submittedByName,
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'requestedAmount': instance.requestedAmount,
      'approvedAmount': instance.approvedAmount,
      'currency': instance.currency,
      'purpose': instance.purpose,
      'description': instance.description,
      'status': instance.status,
      'picUid': instance.picUid,
      'financeUid': instance.financeUid,
      'picNote': instance.picNote,
      'financeNote': instance.financeNote,
      'rejectionReason': instance.rejectionReason,
      'createdAtMs': instance.createdAtMs,
      'submittedAtMs': instance.submittedAtMs,
      'approvedByPicAtMs': instance.approvedByPicAtMs,
      'approvedByFinanceAtMs': instance.approvedByFinanceAtMs,
      'rejectedAtMs': instance.rejectedAtMs,
      'paidAtMs': instance.paidAtMs,
      'updatedAtMs': instance.updatedAtMs,
      'attachments': instance.attachments,
      'history': instance.history,
    };
