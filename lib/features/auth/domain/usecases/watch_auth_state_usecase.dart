import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Emits [UserEntity?] whenever Firebase Auth state changes.
/// Used by the router and app-level providers to react to sign-in / sign-out.
class WatchAuthStateUseCase implements StreamUseCase<UserEntity?, NoParams> {
  final AuthRepository _repository;

  const WatchAuthStateUseCase(this._repository);

  @override
  Stream<UserEntity?> call(NoParams params) {
    return _repository.watchAuthState();
  }
}
