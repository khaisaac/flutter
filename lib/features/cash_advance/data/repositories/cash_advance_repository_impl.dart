import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/base_firestore_repository.dart';
import '../../../../core/data/firestore_error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/cash_advance_entity.dart';
import '../../domain/repositories/cash_advance_repository.dart';
import '../datasources/cash_advance_remote_data_source.dart';
import '../models/cash_advance_model.dart';

class CashAdvanceRepositoryImpl extends BaseFirestoreRepository
    implements CashAdvanceRepository {
  final CashAdvanceRemoteDataSource _dataSource;

  const CashAdvanceRepositoryImpl(this._dataSource);

  @override
  FutureEither<PaginatedResult<CashAdvanceEntity>> getUserSubmissions({
    required String userId,
    int pageSize = 20,
    dynamic lastDocument,
  }) {
    return guardedFetch(
      () async {
        final models = await _dataSource.getUserSubmissions(
          userId: userId,
          pageSize: pageSize,
          lastDocument: lastDocument as DocumentSnapshot?,
        );
        final entities = models.map((m) => m.toEntity()).toList();
        return PaginatedResult<CashAdvanceEntity>(
          items: entities,
          hasReachedEnd: entities.length < pageSize,
        );
      },
      context: 'CashAdvance.getUserSubmissions',
    );
  }

  @override
  FutureEither<PaginatedResult<CashAdvanceEntity>> getPendingApprovals({
    required String approverRole,
    int pageSize = 20,
    dynamic lastDocument,
  }) {
    return guardedFetch(
      () async {
        final models = await _dataSource.getPendingApprovals(
          approverRole: approverRole,
          pageSize: pageSize,
          lastDocument: lastDocument as DocumentSnapshot?,
        );
        final entities = models.map((m) => m.toEntity()).toList();
        return PaginatedResult<CashAdvanceEntity>(
          items: entities,
          hasReachedEnd: entities.length < pageSize,
        );
      },
      context: 'CashAdvance.getPendingApprovals',
    );
  }

  @override
  FutureEither<CashAdvanceEntity> getById(String id) {
    return guardedFetch(
      () async {
        final model = await _dataSource.getById(id);
        return model.toEntity();
      },
      context: 'CashAdvance.getById($id)',
    );
  }

  @override
  StreamEither<CashAdvanceEntity> watchById(String id) {
    return guardedStream(
      () => _dataSource.watchById(id).map((m) => m.toEntity()),
      context: 'CashAdvance.watchById($id)',
    );
  }

  @override
  StreamEither<List<CashAdvanceEntity>> watchUserSubmissions(String userId) {
    return guardedStream(
      () => _dataSource
          .watchUserSubmissions(userId)
          .map((list) => list.map((m) => m.toEntity()).toList()),
      context: 'CashAdvance.watchUserSubmissions',
    );
  }

  @override
  FutureEither<CashAdvanceEntity> create(CashAdvanceEntity entity) {
    return guardedFetch(
      () async {
        final model = CashAdvanceModel.fromEntity(entity);
        final saved = await _dataSource.create(model);
        AppLogger.i('CashAdvance created: ${saved.id}');
        return saved.toEntity();
      },
      context: 'CashAdvance.create',
    );
  }

  @override
  FutureEither<CashAdvanceEntity> update(CashAdvanceEntity entity) {
    return guardedFetch(
      () async {
        if (entity.id.isEmpty) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'invalid-argument',
            message: 'Cannot update entity with empty ID.',
          );
        }
        final model = CashAdvanceModel.fromEntity(entity);
        final saved = await _dataSource.update(model);
        AppLogger.i('CashAdvance updated: ${saved.id}');
        return saved.toEntity();
      },
      context: 'CashAdvance.update',
    );
  }

  @override
  FutureEither<void> delete(String id) async {
    final result = await FirestoreErrorHandler.guard(
      () => _dataSource.delete(id),
      context: 'CashAdvance.delete($id)',
    );
    return result.fold(
      (f) => Left<Failure, void>(f),
      (_) {
        AppLogger.i('CashAdvance deleted: $id');
        return const Right<Failure, void>(null);
      },
    );
  }

  @override
  FutureEither<bool> hasOutstanding(String userId) =>
      guardedFetch(
        () => _dataSource.hasOutstanding(userId),
        context: 'CashAdvance.hasOutstanding',
      );

  @override
  FutureEither<List<CashAdvanceEntity>> getApprovedCashAdvances(
      String userId) =>
      guardedFetch(
        () async {
          final models =
              await _dataSource.getApprovedCashAdvances(userId);
          return models.map((m) => m.toEntity()).toList();
        },
        context: 'CashAdvance.getApprovedCashAdvances',
      );
}
