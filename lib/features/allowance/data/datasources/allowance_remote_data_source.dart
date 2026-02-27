import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/data/base_firestore_repository.dart';
import '../models/allowance_model.dart';

abstract class AllowanceRemoteDataSource {
  Future<List<AllowanceModel>> getUserSubmissions({
    required String userId,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  });

  Future<List<AllowanceModel>> getPendingApprovals({
    required String approverRole,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  });

  Future<AllowanceModel> getById(String id);

  Stream<AllowanceModel> watchById(String id);

  Stream<List<AllowanceModel>> watchUserSubmissions(String userId);

  Future<AllowanceModel> create(AllowanceModel model);

  Future<AllowanceModel> update(AllowanceModel model);

  Future<void> delete(String id);
}

class AllowanceRemoteDataSourceImpl extends BaseFirestoreRepository
    implements AllowanceRemoteDataSource {
  final FirebaseFirestore _firestore;

  const AllowanceRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirebaseConstants.allowancesCollection);

  @override
  Future<List<AllowanceModel>> getUserSubmissions({
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
        .map((d) => AllowanceModel.fromFirestore(d.data(), d.id))
        .toList();
  }

  @override
  Future<List<AllowanceModel>> getPendingApprovals({
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
        .map((d) => AllowanceModel.fromFirestore(d.data(), d.id))
        .toList();
  }

  @override
  Future<AllowanceModel> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists || doc.data() == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'Allowance $id not found.',
      );
    }
    return AllowanceModel.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Stream<AllowanceModel> watchById(String id) {
    return _col.doc(id).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) {
        throw FirebaseException(plugin: 'cloud_firestore', code: 'not-found');
      }
      return AllowanceModel.fromFirestore(snap.data()!, snap.id);
    });
  }

  @override
  Stream<List<AllowanceModel>> watchUserSubmissions(String userId) {
    return _col
        .where('submittedByUid', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => AllowanceModel.fromFirestore(d.data(), d.id))
            .toList());
  }

  @override
  Future<AllowanceModel> create(AllowanceModel model) async {
    final data = {
      ...model.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final ref = await _col.add(data);
    return model.copyWith(id: ref.id);
  }

  @override
  Future<AllowanceModel> update(AllowanceModel model) async {
    await _col.doc(model.id).update({
      ...model.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return model;
  }

  @override
  Future<void> delete(String id) => _col.doc(id).delete();
}
