import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_model.freezed.dart';
part 'attachment_model.g.dart';

/// Domain entity for a file attachment on any submission.
class AttachmentEntity {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType; // 'image' | 'pdf'
  final int fileSizeBytes;
  final DateTime uploadedAt;
  final String uploadedByUid;

  const AttachmentEntity({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSizeBytes,
    required this.uploadedAt,
    required this.uploadedByUid,
  });
}

/// Data-layer model for [AttachmentEntity].
/// Serialised to / from Firestore sub-collection documents.
@freezed
class AttachmentModel with _$AttachmentModel {
  const factory AttachmentModel({
    required String id,
    required String fileName,
    required String fileUrl,
    @Default('image') String fileType,
    @Default(0) int fileSizeBytes,
    required int uploadedAtMs, // stored as millisecondsSinceEpoch
    required String uploadedByUid,
  }) = _AttachmentModel;

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentModelFromJson(json);

  const AttachmentModel._();

  AttachmentEntity toEntity() => AttachmentEntity(
        id: id,
        fileName: fileName,
        fileUrl: fileUrl,
        fileType: fileType,
        fileSizeBytes: fileSizeBytes,
        uploadedAt: DateTime.fromMillisecondsSinceEpoch(uploadedAtMs),
        uploadedByUid: uploadedByUid,
      );

  factory AttachmentModel.fromEntity(AttachmentEntity e) => AttachmentModel(
        id: e.id,
        fileName: e.fileName,
        fileUrl: e.fileUrl,
        fileType: e.fileType,
        fileSizeBytes: e.fileSizeBytes,
        uploadedAtMs: e.uploadedAt.millisecondsSinceEpoch,
        uploadedByUid: e.uploadedByUid,
      );
}
