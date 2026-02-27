import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Signs in a user with email and password.
/// Validates inputs before delegating to the repository.
class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  @override
  FutureEither<UserEntity> call(SignInParams params) {
    return _repository.signInWithEmailAndPassword(
      email: params.email.trim(),
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
