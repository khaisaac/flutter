import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/auth_repository.dart';

/// Clears the current authentication session.
class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;

  const SignOutUseCase(this._repository);

  @override
  FutureEither<void> call(NoParams params) {
    return _repository.signOut();
  }
}
