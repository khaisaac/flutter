import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/base_firestore_repository.dart';
import '../../../../core/data/firestore_error_handler.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/allowance_entity.dart';
import '../../domain/repositories/allowance_repository.dart';
import '../datasources/allowance_remote_data_source.dart';
import '../models/allowance_model.dart';

class AllowanceRepositoryImpl extends BaseFirestoreRepository
    implements AllowanceRepository {
  final AllowanceRemoteDataSource _dataSource;

  const AllowanceRepositoryImpl(this._dataSource);

  @override
  FutureEither<PaginatedResult<AllowanceEntity>> getUserSubmissions({
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
        context: 'allowance.getUserSubmissions',
      );

  @override
  FutureEither<PaginatedResult<AllowanceEntity>> getPendingApprovals({
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
        context: 'allowance.getPendingApprovals',
      );

  @override
  FutureEither<AllowanceEntity> getById(String id) =>
      guardedFetch(
        () async {
          final model = await _dataSource.getById(id);
          return model.toEntity();
        },
        context: 'allowance.getById',
      );

  @override
  StreamEither<AllowanceEntity> watchById(String id) =>
      guardedStream(
        () => _dataSource.watchById(id).map((m) => m.toEntity()),
        context: 'allowance.watchById',
      );

  @override
  StreamEither<List<AllowanceEntity>> watchUserSubmissions(String userId) =>
      guardedStream(
        () => _dataSource
            .watchUserSubmissions(userId)
            .map((list) => list.map((m) => m.toEntity()).toList()),
        context: 'allowance.watchUserSubmissions',
      );

  @override
  FutureEither<AllowanceEntity> create(AllowanceEntity entity) =>
      guardedFetch(
        () async {
          final created =
              await _dataSource.create(AllowanceModel.fromEntity(entity));
          return created.toEntity();
        },
        context: 'allowance.create',
      );

  @override
  FutureEither<AllowanceEntity> update(AllowanceEntity entity) =>
      guardedFetch(
        () async {
          final updated =
              await _dataSource.update(AllowanceModel.fromEntity(entity));
          return updated.toEntity();
        },
        context: 'allowance.update',
      );

  @override
  FutureEither<void> delete(String id) =>
      FirestoreErrorHandler.guard(
        () => _dataSource.delete(id),
        context: 'allowance.delete',
      );
}
