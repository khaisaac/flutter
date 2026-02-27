// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reimbursement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reimbursementRemoteDataSourceHash() =>
    r'f27b99510b0608c91f5f775fea902b0d47334105';

/// See also [reimbursementRemoteDataSource].
@ProviderFor(reimbursementRemoteDataSource)
final reimbursementRemoteDataSourceProvider =
    Provider<ReimbursementRemoteDataSource>.internal(
  reimbursementRemoteDataSource,
  name: r'reimbursementRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reimbursementRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReimbursementRemoteDataSourceRef
    = ProviderRef<ReimbursementRemoteDataSource>;
String _$reimbursementRepositoryHash() =>
    r'f6e7963e5c41433dc7a639933184e611f198eb21';

/// See also [reimbursementRepository].
@ProviderFor(reimbursementRepository)
final reimbursementRepositoryProvider =
    Provider<ReimbursementRepository>.internal(
  reimbursementRepository,
  name: r'reimbursementRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reimbursementRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReimbursementRepositoryRef = ProviderRef<ReimbursementRepository>;
String _$userReimbursementStreamHash() =>
    r'1dca5a8f17e9ed58e01dffb663e2e0f90b361db7';

/// Real-time list of the current user's Reimbursement submissions.
///
/// Copied from [userReimbursementStream].
@ProviderFor(userReimbursementStream)
final userReimbursementStreamProvider =
    AutoDisposeStreamProvider<List<ReimbursementEntity>>.internal(
  userReimbursementStream,
  name: r'userReimbursementStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userReimbursementStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserReimbursementStreamRef
    = AutoDisposeStreamProviderRef<List<ReimbursementEntity>>;
String _$reimbursementDetailStreamHash() =>
    r'f11d79dad812a871dd25723b4b4835d4a7ad832e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [reimbursementDetailStream].
@ProviderFor(reimbursementDetailStream)
const reimbursementDetailStreamProvider = ReimbursementDetailStreamFamily();

/// See also [reimbursementDetailStream].
class ReimbursementDetailStreamFamily
    extends Family<AsyncValue<ReimbursementEntity?>> {
  /// See also [reimbursementDetailStream].
  const ReimbursementDetailStreamFamily();

  /// See also [reimbursementDetailStream].
  ReimbursementDetailStreamProvider call(
    String id,
  ) {
    return ReimbursementDetailStreamProvider(
      id,
    );
  }

  @override
  ReimbursementDetailStreamProvider getProviderOverride(
    covariant ReimbursementDetailStreamProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reimbursementDetailStreamProvider';
}

/// See also [reimbursementDetailStream].
class ReimbursementDetailStreamProvider
    extends AutoDisposeStreamProvider<ReimbursementEntity?> {
  /// See also [reimbursementDetailStream].
  ReimbursementDetailStreamProvider(
    String id,
  ) : this._internal(
          (ref) => reimbursementDetailStream(
            ref as ReimbursementDetailStreamRef,
            id,
          ),
          from: reimbursementDetailStreamProvider,
          name: r'reimbursementDetailStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reimbursementDetailStreamHash,
          dependencies: ReimbursementDetailStreamFamily._dependencies,
          allTransitiveDependencies:
              ReimbursementDetailStreamFamily._allTransitiveDependencies,
          id: id,
        );

  ReimbursementDetailStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<ReimbursementEntity?> Function(ReimbursementDetailStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReimbursementDetailStreamProvider._internal(
        (ref) => create(ref as ReimbursementDetailStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ReimbursementEntity?> createElement() {
    return _ReimbursementDetailStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReimbursementDetailStreamProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReimbursementDetailStreamRef
    on AutoDisposeStreamProviderRef<ReimbursementEntity?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ReimbursementDetailStreamProviderElement
    extends AutoDisposeStreamProviderElement<ReimbursementEntity?>
    with ReimbursementDetailStreamRef {
  _ReimbursementDetailStreamProviderElement(super.provider);

  @override
  String get id => (origin as ReimbursementDetailStreamProvider).id;
}

String _$createReimbursementUseCaseHash() =>
    r'd93e8db56ed590c16492ec2a0a28ee3ebe1fd5cb';

/// See also [createReimbursementUseCase].
@ProviderFor(createReimbursementUseCase)
final createReimbursementUseCaseProvider =
    Provider<CreateReimbursementUseCase>.internal(
  createReimbursementUseCase,
  name: r'createReimbursementUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createReimbursementUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreateReimbursementUseCaseRef = ProviderRef<CreateReimbursementUseCase>;
String _$submitReimbursementUseCaseHash() =>
    r'b1a0a8a2a47fbfe5c295a15c01a88bc8cd2a8f2a';

/// See also [submitReimbursementUseCase].
@ProviderFor(submitReimbursementUseCase)
final submitReimbursementUseCaseProvider =
    Provider<SubmitReimbursementUseCase>.internal(
  submitReimbursementUseCase,
  name: r'submitReimbursementUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$submitReimbursementUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SubmitReimbursementUseCaseRef = ProviderRef<SubmitReimbursementUseCase>;
String _$getReimbursementUseCaseHash() =>
    r'ebebc8b83297ba1908f7ce4f65a05dfa04b019e4';

/// See also [getReimbursementUseCase].
@ProviderFor(getReimbursementUseCase)
final getReimbursementUseCaseProvider =
    Provider<GetReimbursementUseCase>.internal(
  getReimbursementUseCase,
  name: r'getReimbursementUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getReimbursementUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetReimbursementUseCaseRef = ProviderRef<GetReimbursementUseCase>;
String _$reimbursementListControllerHash() =>
    r'4bef22b70138e2652134af86787d68fb1eb19d8e';

/// See also [ReimbursementListController].
@ProviderFor(ReimbursementListController)
final reimbursementListControllerProvider = AutoDisposeNotifierProvider<
    ReimbursementListController, ReimbursementListState>.internal(
  ReimbursementListController.new,
  name: r'reimbursementListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reimbursementListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReimbursementListController
    = AutoDisposeNotifier<ReimbursementListState>;
String _$reimbursementPendingControllerHash() =>
    r'a05bacd385d84d48141f397aff1859269b01dafe';

/// See also [ReimbursementPendingController].
@ProviderFor(ReimbursementPendingController)
final reimbursementPendingControllerProvider = AutoDisposeNotifierProvider<
    ReimbursementPendingController, ReimbursementPendingState>.internal(
  ReimbursementPendingController.new,
  name: r'reimbursementPendingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reimbursementPendingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReimbursementPendingController
    = AutoDisposeNotifier<ReimbursementPendingState>;
String _$reimbursementFormControllerHash() =>
    r'5bff5371e35154bba7049ee04acf188021c07767';

/// See also [ReimbursementFormController].
@ProviderFor(ReimbursementFormController)
final reimbursementFormControllerProvider = AutoDisposeNotifierProvider<
    ReimbursementFormController, ReimbursementFormState>.internal(
  ReimbursementFormController.new,
  name: r'reimbursementFormControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reimbursementFormControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReimbursementFormController
    = AutoDisposeNotifier<ReimbursementFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
