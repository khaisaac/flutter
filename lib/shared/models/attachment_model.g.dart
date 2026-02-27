// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentModelImpl _$$AttachmentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AttachmentModelImpl(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileType: json['fileType'] as String? ?? 'image',
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 0,
      uploadedAtMs: (json['uploadedAtMs'] as num).toInt(),
      uploadedByUid: json['uploadedByUid'] as String,
    );

Map<String, dynamic> _$$AttachmentModelImplToJson(
        _$AttachmentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'fileType': instance.fileType,
      'fileSizeBytes': instance.fileSizeBytes,
      'uploadedAtMs': instance.uploadedAtMs,
      'uploadedByUid': instance.uploadedByUid,
    };
