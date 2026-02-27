// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRemoteDataSourceHash() =>
    r'a2c360911dfb0025aadeae2df69c86e76b78cac2';

/// See also [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>.internal(
  authRemoteDataSource,
  name: r'authRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRemoteDataSourceRef = ProviderRef<AuthRemoteDataSource>;
String _$authRepositoryHash() => r'3a186f8116a3be371350708c0d3b088545a1a39e';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$signInUseCaseHash() => r'2ac57d8f88f91a394f0e6f32b41ea61373054694';

/// See also [signInUseCase].
@ProviderFor(signInUseCase)
final signInUseCaseProvider = Provider<SignInUseCase>.internal(
  signInUseCase,
  name: r'signInUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignInUseCaseRef = ProviderRef<SignInUseCase>;
String _$signOutUseCaseHash() => r'a05ddecbd0452f13ff5e56daceeba4567d673c5f';

/// See also [signOutUseCase].
@ProviderFor(signOutUseCase)
final signOutUseCaseProvider = Provider<SignOutUseCase>.internal(
  signOutUseCase,
  name: r'signOutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignOutUseCaseRef = ProviderRef<SignOutUseCase>;
String _$getCurrentUserUseCaseHash() =>
    r'6652a4477b86f808f3ca18b34516b225d889a4c5';

/// See also [getCurrentUserUseCase].
@ProviderFor(getCurrentUserUseCase)
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>.internal(
  getCurrentUserUseCase,
  name: r'getCurrentUserUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCurrentUserUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetCurrentUserUseCaseRef = ProviderRef<GetCurrentUserUseCase>;
String _$watchAuthStateUseCaseHash() =>
    r'e678f4523d16c35514e661af1e67bc0a90f1e73d';

/// See also [watchAuthStateUseCase].
@ProviderFor(watchAuthStateUseCase)
final watchAuthStateUseCaseProvider = Provider<WatchAuthStateUseCase>.internal(
  watchAuthStateUseCase,
  name: r'watchAuthStateUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchAuthStateUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchAuthStateUseCaseRef = ProviderRef<WatchAuthStateUseCase>;
String _$authStateStreamHash() => r'cfebfdb09a46c6d9f46df4c21abb179a9a9c5d88';

/// Real-time auth state. UI and router depend on this provider.
/// - [AsyncLoading]: initial Firebase check in progress
/// - [AsyncData(UserEntity)]: user authenticated
/// - [AsyncData(null)]: user is not authenticated
///
/// Copied from [authStateStream].
@ProviderFor(authStateStream)
final authStateStreamProvider = StreamProvider<UserEntity?>.internal(
  authStateStream,
  name: r'authStateStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateStreamRef = StreamProviderRef<UserEntity?>;
String _$firebaseAuthStateStreamHash() =>
    r'd4a7cc05d7aaded7de8eec4fc13136d7da9c9c03';

/// Exposes the raw Firebase [User?] stream when the data layer needs it.
///
/// Copied from [firebaseAuthStateStream].
@ProviderFor(firebaseAuthStateStream)
final firebaseAuthStateStreamProvider = StreamProvider<User?>.internal(
  firebaseAuthStateStream,
  name: r'firebaseAuthStateStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthStateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseAuthStateStreamRef = StreamProviderRef<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
