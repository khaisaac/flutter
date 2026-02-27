// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reimbursement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReimbursementItemModelImpl _$$ReimbursementItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReimbursementItemModelImpl(
      id: json['id'] as String,
      category: json['category'] as String? ?? 'other',
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      receiptDateMs: (json['receiptDateMs'] as num).toInt(),
      receipts: (json['receipts'] as List<dynamic>?)
              ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ReimbursementItemModelImplToJson(
        _$ReimbursementItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'description': instance.description,
      'amount': instance.amount,
      'receiptDateMs': instance.receiptDateMs,
      'receipts': instance.receipts,
    };

_$ReimbursementModelImpl _$$ReimbursementModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReimbursementModelImpl(
      id: json['id'] as String,
      submittedByUid: json['submittedByUid'] as String,
      submittedByName: json['submittedByName'] as String,
      projectId: json['projectId'] as String,
      projectName: json['projectName'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) =>
                  ReimbursementItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalRequestedAmount: (json['totalRequestedAmount'] as num).toDouble(),
      totalApprovedAmount: (json['totalApprovedAmount'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'IDR',
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

Map<String, dynamic> _$$ReimbursementModelImplToJson(
        _$ReimbursementModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'submittedByUid': instance.submittedByUid,
      'submittedByName': instance.submittedByName,
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'items': instance.items,
      'totalRequestedAmount': instance.totalRequestedAmount,
      'totalApprovedAmount': instance.totalApprovedAmount,
      'currency': instance.currency,
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
