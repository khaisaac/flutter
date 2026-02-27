import '../../../../core/data/base_firestore_repository.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/reimbursement_entity.dart';

abstract class ReimbursementRepository {
  FutureEither<PaginatedResult<ReimbursementEntity>> getUserSubmissions({
    required String userId,
    int pageSize = 20,
    dynamic lastDocument,
  });

  FutureEither<PaginatedResult<ReimbursementEntity>> getPendingApprovals({
    required String approverRole,
    int pageSize = 20,
    dynamic lastDocument,
  });

  FutureEither<ReimbursementEntity> getById(String id);

  StreamEither<ReimbursementEntity> watchById(String id);

  StreamEither<List<ReimbursementEntity>> watchUserSubmissions(String userId);

  FutureEither<ReimbursementEntity> create(ReimbursementEntity entity);

  FutureEither<ReimbursementEntity> update(ReimbursementEntity entity);

  FutureEither<void> delete(String id);
}
