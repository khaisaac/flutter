import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../errors/exceptions.dart';
import '../../shared/models/attachment_model.dart';

/// Wraps Firebase Storage upload operations.
///
/// Upload path convention:
///   `{module}/{userId}/{submissionId}/{itemId?}/{uuid}_{filename}`
///
/// Example:
///   `reimbursement/uid123/reimb456/item789/a1b2-receipt.jpg`
class StorageService {
  const StorageService(this._storage);

  final FirebaseStorage _storage;

  static const _uuid = Uuid();

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Uploads [file] to Firebase Storage and returns an [AttachmentEntity].
  ///
  /// [module]       e.g. 'reimbursement', 'cash_advance'
  /// [userId]       uploader's Firebase UID
  /// [submissionId] parent document ID (or 'draft' before creation)
  /// [itemId]       optional sub-item ID (for receipt-per-line-item uploads)
  Future<AttachmentEntity> uploadFile({
    required File file,
    required String module,
    required String userId,
    required String submissionId,
    String? itemId,
  }) async {
    final fileName = file.path.split('/').last.split('\\').last;
    final ext = fileName.contains('.') ? fileName.split('.').last : 'jpg';
    final uniqueName = '${_uuid.v4()}.$ext';

    final pathSegments = [module, userId, submissionId];
    if (itemId != null) pathSegments.add(itemId);
    pathSegments.add(uniqueName);

    final storagePath = pathSegments.join('/');
    final ref = _storage.ref(storagePath);

    try {
      final fileBytes = await file.readAsBytes();
      final contentType = _mimeType(ext);
      final task = await ref.putData(
        fileBytes,
        SettableMetadata(contentType: contentType),
      );

      final downloadUrl = await task.ref.getDownloadURL();

      return AttachmentEntity(
        id: uniqueName,
        fileName: fileName,
        fileUrl: downloadUrl,
        fileType: _fileType(ext),
        fileSizeBytes: fileBytes.length,
        uploadedAt: DateTime.now(),
        uploadedByUid: userId,
      );
    } on FirebaseException catch (e) {
      throw StorageException(
        message: e.message ?? 'Upload failed.',
        code: e.code,
      );
    }
  }

  /// Deletes a file from Firebase Storage by its full download URL.
  Future<void> deleteByUrl(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      // Swallow not-found errors (already deleted or never existed).
      if (e.code != 'object-not-found') {
        throw StorageException(message: e.message ?? 'Delete failed.', code: e.code);
      }
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  String _mimeType(String ext) => switch (ext.toLowerCase()) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'gif' => 'image/gif',
        'webp' => 'image/webp',
        'pdf' => 'application/pdf',
        _ => 'application/octet-stream',
      };

  String _fileType(String ext) => switch (ext.toLowerCase()) {
        'pdf' => 'pdf',
        _ => 'image',
      };
}
