import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/data/base_firestore_repository.dart';
import '../models/reimbursement_model.dart';

abstract class ReimbursementRemoteDataSource {
  Future<List<ReimbursementModel>> getUserSubmissions({
    required String userId,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  });

  Future<List<ReimbursementModel>> getPendingApprovals({
    required String approverRole,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  });

  Future<ReimbursementModel> getById(String id);

  Stream<ReimbursementModel> watchById(String id);

  Stream<List<ReimbursementModel>> watchUserSubmissions(String userId);

  Future<ReimbursementModel> create(ReimbursementModel model);

  Future<ReimbursementModel> update(ReimbursementModel model);

  Future<void> delete(String id);
}

class ReimbursementRemoteDataSourceImpl extends BaseFirestoreRepository
    implements ReimbursementRemoteDataSource {
  final FirebaseFirestore _firestore;

  const ReimbursementRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirebaseConstants.reimbursementsCollection);

  @override
  Future<List<ReimbursementModel>> getUserSubmissions({
    required String userId,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  }) async {
    Query<Map<String, dynamic>> q = _col
        .where('submittedByUid', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(pageSize);
    if (lastDocument != null) q = q.startAfterDocument(lastDocument);
    final snap = await q.get();
    return snap.docs
        .map((d) => ReimbursementModel.fromFirestore(d.data(), d.id))
        .toList();
  }

  @override
  Future<List<ReimbursementModel>> getPendingApprovals({
    required String approverRole,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  }) async {
    final pendingStatus =
        approverRole == 'pic_project' ? 'pending_pic' : 'pending_finance';
    Query<Map<String, dynamic>> q = _col
        .where('status', isEqualTo: pendingStatus)
        .orderBy('submittedAt', descending: false)
        .limit(pageSize);
    if (lastDocument != null) q = q.startAfterDocument(lastDocument);
    final snap = await q.get();
    return snap.docs
        .map((d) => ReimbursementModel.fromFirestore(d.data(), d.id))
        .toList();
  }

  @override
  Future<ReimbursementModel> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists || doc.data() == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'Reimbursement $id not found.',
      );
    }
    return ReimbursementModel.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Stream<ReimbursementModel> watchById(String id) {
    return _col.doc(id).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) {
        throw FirebaseException(plugin: 'cloud_firestore', code: 'not-found');
      }
      return ReimbursementModel.fromFirestore(snap.data()!, snap.id);
    });
  }

  @override
  Stream<List<ReimbursementModel>> watchUserSubmissions(String userId) {
    return _col
        .where('submittedByUid', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ReimbursementModel.fromFirestore(d.data(), d.id))
            .toList());
  }

  @override
  Future<ReimbursementModel> create(ReimbursementModel model) async {
    final data = {
      ...model.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final ref = await _col.add(data);
    return model.copyWith(id: ref.id);
  }

  @override
  Future<ReimbursementModel> update(ReimbursementModel model) async {
    await _col.doc(model.id).update({
      ...model.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return model;
  }

  @override
  Future<void> delete(String id) => _col.doc(id).delete();
}
