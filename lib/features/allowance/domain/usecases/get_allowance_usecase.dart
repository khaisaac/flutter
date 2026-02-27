import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/allowance_entity.dart';
import '../repositories/allowance_repository.dart';

class GetAllowanceParams extends Equatable {
  const GetAllowanceParams(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// One-shot fetch of a single [AllowanceEntity] by ID.
class GetAllowanceUseCase
    implements UseCase<AllowanceEntity, GetAllowanceParams> {
  const GetAllowanceUseCase(this._repo);

  final AllowanceRepository _repo;

  @override
  FutureEither<AllowanceEntity> call(GetAllowanceParams params) =>
      _repo.getById(params.id);
}
