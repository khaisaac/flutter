// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApprovalHistoryModelImpl _$$ApprovalHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalHistoryModelImpl(
      id: json['id'] as String,
      actorUid: json['actorUid'] as String,
      actorName: json['actorName'] as String,
      actorRole: json['actorRole'] as String,
      action: json['action'] as String,
      fromStatus: json['fromStatus'] as String,
      toStatus: json['toStatus'] as String,
      note: json['note'] as String?,
      timestampMs: (json['timestampMs'] as num).toInt(),
    );

Map<String, dynamic> _$$ApprovalHistoryModelImplToJson(
        _$ApprovalHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actorUid': instance.actorUid,
      'actorName': instance.actorName,
      'actorRole': instance.actorRole,
      'action': instance.action,
      'fromStatus': instance.fromStatus,
      'toStatus': instance.toStatus,
      'note': instance.note,
      'timestampMs': instance.timestampMs,
    };
