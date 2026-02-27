import '../../../../core/data/base_firestore_repository.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/allowance_entity.dart';

abstract class AllowanceRepository {
  FutureEither<PaginatedResult<AllowanceEntity>> getUserSubmissions({
    required String userId,
    int pageSize = 20,
    dynamic lastDocument,
  });

  FutureEither<PaginatedResult<AllowanceEntity>> getPendingApprovals({
    required String approverRole,
    int pageSize = 20,
    dynamic lastDocument,
  });

  FutureEither<AllowanceEntity> getById(String id);

  StreamEither<AllowanceEntity> watchById(String id);

  StreamEither<List<AllowanceEntity>> watchUserSubmissions(String userId);

  FutureEither<AllowanceEntity> create(AllowanceEntity entity);

  FutureEither<AllowanceEntity> update(AllowanceEntity entity);

  FutureEither<void> delete(String id);
}
