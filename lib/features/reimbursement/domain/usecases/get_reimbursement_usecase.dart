import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/reimbursement_entity.dart';
import '../repositories/reimbursement_repository.dart';

class GetReimbursementParams extends Equatable {
  const GetReimbursementParams(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

/// One-shot fetch of a single [ReimbursementEntity] by Firestore document ID.
class GetReimbursementUseCase
    implements UseCase<ReimbursementEntity, GetReimbursementParams> {
  const GetReimbursementUseCase(this._repo);

  final ReimbursementRepository _repo;

  @override
  FutureEither<ReimbursementEntity> call(GetReimbursementParams params) =>
      _repo.getById(params.id);
}
