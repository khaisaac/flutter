import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Retrieves the currently authenticated user (one-shot).
/// Returns null inside [Right] if no user is signed in.
class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  @override
  FutureEither<UserEntity?> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
