import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/data/base_firestore_repository.dart';
import '../models/cash_advance_model.dart';

/// Contract for the Cash Advance Firestore data source.
abstract class CashAdvanceRemoteDataSource {
  Future<List<CashAdvanceModel>> getUserSubmissions({
    required String userId,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  });

  Future<List<CashAdvanceModel>> getPendingApprovals({
    required String approverRole,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  });

  Future<CashAdvanceModel> getById(String id);

  Stream<CashAdvanceModel> watchById(String id);

  Stream<List<CashAdvanceModel>> watchUserSubmissions(String userId);

  Future<CashAdvanceModel> create(CashAdvanceModel model);

  Future<CashAdvanceModel> update(CashAdvanceModel model);

  Future<void> delete(String id);

  /// Returns [true] when the user has any active in-flight submission.
  Future<bool> hasOutstanding(String userId);
}

// ── Implementation ─────────────────────────────────────────────────────────

class CashAdvanceRemoteDataSourceImpl
    extends BaseFirestoreRepository
    implements CashAdvanceRemoteDataSource {
  final FirebaseFirestore _firestore;

  const CashAdvanceRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirebaseConstants.cashAdvancesCollection);

  @override
  Future<List<CashAdvanceModel>> getUserSubmissions({
    required String userId,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  }) async {
    Query<Map<String, dynamic>> query = _col
        .where('submittedByUid', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snap = await query.get();
    return snap.docs
        .map((d) => CashAdvanceModel.fromFirestore(d.data(), d.id))
        .toList();
  }

  @override
  Future<List<CashAdvanceModel>> getPendingApprovals({
    required String approverRole,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  }) async {
    final pendingStatus = approverRole == 'pic_project'
        ? 'pending_pic'
        : 'pending_finance';

    Query<Map<String, dynamic>> query = _col
        .where('status', isEqualTo: pendingStatus)
        .orderBy('submittedAt', descending: false)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snap = await query.get();
    return snap.docs
        .map((d) => CashAdvanceModel.fromFirestore(d.data(), d.id))
        .toList();
  }

  @override
  Future<CashAdvanceModel> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists || doc.data() == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'Cash advance $id not found.',
      );
    }
    return CashAdvanceModel.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Stream<CashAdvanceModel> watchById(String id) {
    return _col.doc(id).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'not-found',
        );
      }
      return CashAdvanceModel.fromFirestore(snap.data()!, snap.id);
    });
  }

  @override
  Stream<List<CashAdvanceModel>> watchUserSubmissions(String userId) {
    return _col
        .where('submittedByUid', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => CashAdvanceModel.fromFirestore(d.data(), d.id))
            .toList());
  }

  @override
  Future<CashAdvanceModel> create(CashAdvanceModel model) async {
    final data = {
      ...model.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final ref = await _col.add(data);
    return model.copyWith(id: ref.id);
  }

  @override
  Future<CashAdvanceModel> update(CashAdvanceModel model) async {
    final data = {
      ...model.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _col.doc(model.id).update(data);
    return model;
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  @override
  Future<bool> hasOutstanding(String userId) async {
    final snap = await _col
        .where('submittedByUid', isEqualTo: userId)
        .where('status', whereIn: [
          'pending_pic',
          'pending_finance',
          'approved',
        ])
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }
}
