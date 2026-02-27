import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/app_providers.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/watch_auth_state_usecase.dart';

part 'auth_providers.g.dart';

// ── Data Layer Providers ──────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSourceImpl(ref.watch(firebaseAuthProvider));
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
}

// ── Use Case Providers ────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
SignInUseCase signInUseCase(SignInUseCaseRef ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
SignOutUseCase signOutUseCase(SignOutUseCaseRef ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetCurrentUserUseCase getCurrentUserUseCase(GetCurrentUserUseCaseRef ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
WatchAuthStateUseCase watchAuthStateUseCase(WatchAuthStateUseCaseRef ref) {
  return WatchAuthStateUseCase(ref.watch(authRepositoryProvider));
}

// ── Auth State Stream Provider ────────────────────────────────────────────────

/// Real-time auth state. UI and router depend on this provider.
/// - [AsyncLoading]: initial Firebase check in progress
/// - [AsyncData(UserEntity)]: user authenticated
/// - [AsyncData(null)]: user is not authenticated
@Riverpod(keepAlive: true)
Stream<UserEntity?> authStateStream(AuthStateStreamRef ref) {
  return ref.watch(watchAuthStateUseCaseProvider).call(const NoParams());
}

// ── Firebase Auth Raw Stream (for internal data-layer use) ───────────────────

/// Exposes the raw Firebase [User?] stream when the data layer needs it.
@Riverpod(keepAlive: true)
Stream<User?> firebaseAuthStateStream(FirebaseAuthStateStreamRef ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}
