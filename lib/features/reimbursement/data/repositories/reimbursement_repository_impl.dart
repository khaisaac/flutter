import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/base_firestore_repository.dart';
import '../../../../core/data/firestore_error_handler.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/reimbursement_entity.dart';
import '../../domain/repositories/reimbursement_repository.dart';
import '../datasources/reimbursement_remote_data_source.dart';
import '../models/reimbursement_model.dart';

class ReimbursementRepositoryImpl extends BaseFirestoreRepository
    implements ReimbursementRepository {
  final ReimbursementRemoteDataSource _dataSource;

  const ReimbursementRepositoryImpl(this._dataSource);

  @override
  FutureEither<PaginatedResult<ReimbursementEntity>> getUserSubmissions({
    required String userId,
    int pageSize = 20,
    dynamic lastDocument,
  }) =>
      guardedFetch(
        () async {
          final models = await _dataSource.getUserSubmissions(
            userId: userId,
            pageSize: pageSize,
            lastDocument: lastDocument as DocumentSnapshot?,
          );
          return PaginatedResult(
            items: models.map((m) => m.toEntity()).toList(),
            lastDocument: null,
            hasReachedEnd: models.length < pageSize,
          );
        },
        context: 'reimbursement.getUserSubmissions',
      );

  @override
  FutureEither<PaginatedResult<ReimbursementEntity>> getPendingApprovals({
    required String approverRole,
    int pageSize = 20,
    dynamic lastDocument,
  }) =>
      guardedFetch(
        () async {
          final models = await _dataSource.getPendingApprovals(
            approverRole: approverRole,
            pageSize: pageSize,
            lastDocument: lastDocument as DocumentSnapshot?,
          );
          return PaginatedResult(
            items: models.map((m) => m.toEntity()).toList(),
            lastDocument: null,
            hasReachedEnd: models.length < pageSize,
          );
        },
        context: 'reimbursement.getPendingApprovals',
      );

  @override
  FutureEither<ReimbursementEntity> getById(String id) =>
      guardedFetch(
        () async {
          final model = await _dataSource.getById(id);
          return model.toEntity();
        },
        context: 'reimbursement.getById',
      );

  @override
  StreamEither<ReimbursementEntity> watchById(String id) =>
      guardedStream(
        () => _dataSource.watchById(id).map((m) => m.toEntity()),
        context: 'reimbursement.watchById',
      );

  @override
  StreamEither<List<ReimbursementEntity>> watchUserSubmissions(String userId) =>
      guardedStream(
        () => _dataSource
            .watchUserSubmissions(userId)
            .map((list) => list.map((m) => m.toEntity()).toList()),
        context: 'reimbursement.watchUserSubmissions',
      );

  @override
  FutureEither<ReimbursementEntity> create(ReimbursementEntity entity) =>
      guardedFetch(
        () async {
          final created = await _dataSource
              .create(ReimbursementModel.fromEntity(entity));
          return created.toEntity();
        },
        context: 'reimbursement.create',
      );

  @override
  FutureEither<ReimbursementEntity> update(ReimbursementEntity entity) =>
      guardedFetch(
        () async {
          final updated = await _dataSource
              .update(ReimbursementModel.fromEntity(entity));
          return updated.toEntity();
        },
        context: 'reimbursement.update',
      );

  @override
  FutureEither<void> delete(String id) =>
      FirestoreErrorHandler.guard(
        () => _dataSource.delete(id),
        context: 'reimbursement.delete',
      );
}
