import '../../../../core/utils/typedefs.dart';
import '../entities/cash_advance_entity.dart';
import '../repositories/cash_advance_repository.dart';

/// One-shot fetch of a single Cash Advance submission by document [id].
class GetCashAdvanceUseCase {
  const GetCashAdvanceUseCase(this._repo);

  final CashAdvanceRepository _repo;

  FutureEither<CashAdvanceEntity> call(String id) => _repo.getById(id);
}
