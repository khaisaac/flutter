// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApprovalLogModelImpl _$$ApprovalLogModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalLogModelImpl(
      id: json['id'] as String,
      module: json['module'] as String,
      documentId: json['documentId'] as String,
      actorUid: json['actorUid'] as String,
      actorName: json['actorName'] as String,
      actorRole: json['actorRole'] as String,
      action: json['action'] as String,
      fromStatus: json['fromStatus'] as String,
      toStatus: json['toStatus'] as String,
      note: json['note'] as String?,
      timestampMs: (json['timestampMs'] as num).toInt(),
    );

Map<String, dynamic> _$$ApprovalLogModelImplToJson(
        _$ApprovalLogModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'module': instance.module,
      'documentId': instance.documentId,
      'actorUid': instance.actorUid,
      'actorName': instance.actorName,
      'actorRole': instance.actorRole,
      'action': instance.action,
      'fromStatus': instance.fromStatus,
      'toStatus': instance.toStatus,
      'note': instance.note,
      'timestampMs': instance.timestampMs,
    };
