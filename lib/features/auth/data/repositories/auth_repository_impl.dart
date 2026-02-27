import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/firebase_auth_exception_mapper.dart';

/// Concrete implementation of [AuthRepository].
/// Translates data-layer exceptions into domain [Failure] objects.
/// No Firebase-specific code reaches beyond this class.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  FutureEither<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.i('User signed in: ${userModel.uid} (role: ${userModel.role})');
      return Right(userModel.toEntity());
    } on fb.FirebaseAuthException catch (e, st) {
      AppLogger.e('FirebaseAuthException on signIn: ${e.code}', e, st);
      final exception = FirebaseAuthExceptionMapper.map(e);
      return Left(_authExceptionToFailure(exception));
    } on AuthException catch (e, st) {
      AppLogger.e('AuthException on signIn', e, st);
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e, st) {
      AppLogger.e('Unexpected error on signIn', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
  FutureEither<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
      AppLogger.i('User signed out.');
      return const Right(null);
    } on fb.FirebaseAuthException catch (e, st) {
      AppLogger.e('FirebaseAuthException on signOut: ${e.code}', e, st);
      return Left(AuthFailure(message: e.message ?? 'Sign out failed.', code: e.code));
    } catch (e, st) {
      AppLogger.e('Unexpected error on signOut', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
  FutureEither<UserEntity?> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return Right(userModel?.toEntity());
    } on fb.FirebaseAuthException catch (e, st) {
      AppLogger.e('FirebaseAuthException on getCurrentUser: ${e.code}', e, st);
      return Left(AuthFailure(message: e.message ?? 'Failed to get user.', code: e.code));
    } catch (e, st) {
      AppLogger.e('Unexpected error on getCurrentUser', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
  Stream<UserEntity?> watchAuthState() {
    return _remoteDataSource.watchAuthState().handleError((Object error, StackTrace st) {
      AppLogger.e('Auth state stream error', error, st);
    }).map((model) => model?.toEntity());
  }

  @override
  FutureEither<UserEntity> refreshUserToken() async {
    try {
      final userModel = await _remoteDataSource.refreshCurrentUser();
      AppLogger.i('Token refreshed for: ${userModel.uid}');
      return Right(userModel.toEntity());
    } on fb.FirebaseAuthException catch (e, st) {
      AppLogger.e('FirebaseAuthException on token refresh: ${e.code}', e, st);
      return Left(_authExceptionToFailure(FirebaseAuthExceptionMapper.map(e)));
    } catch (e, st) {
      AppLogger.e('Unexpected error on token refresh', e, st);
      return const Left(UnknownFailure());
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  AuthFailure _authExceptionToFailure(AuthException e) {
    if (e is UserNotFoundException) return const UserNotFoundFailure();
    if (e is WrongPasswordException) return const WrongPasswordFailure();
    if (e is EmailAlreadyInUseException) return const EmailAlreadyInUseFailure();
    if (e is SessionExpiredException) return const SessionExpiredFailure();
    return AuthFailure(message: e.message, code: e.code);
  }
}
