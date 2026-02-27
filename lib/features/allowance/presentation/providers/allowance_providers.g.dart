// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allowance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allowanceRemoteDataSourceHash() =>
    r'352ca46ea8b6e45f329e5ace0bf0034a133ce663';

/// See also [allowanceRemoteDataSource].
@ProviderFor(allowanceRemoteDataSource)
final allowanceRemoteDataSourceProvider =
    Provider<AllowanceRemoteDataSource>.internal(
  allowanceRemoteDataSource,
  name: r'allowanceRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allowanceRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllowanceRemoteDataSourceRef = ProviderRef<AllowanceRemoteDataSource>;
String _$allowanceRepositoryHash() =>
    r'ef09f4e3bfd814fad2e5ed47c9a6155b2906c539';

/// See also [allowanceRepository].
@ProviderFor(allowanceRepository)
final allowanceRepositoryProvider = Provider<AllowanceRepository>.internal(
  allowanceRepository,
  name: r'allowanceRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allowanceRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllowanceRepositoryRef = ProviderRef<AllowanceRepository>;
String _$userAllowanceStreamHash() =>
    r'de770090eee197ebf25aabf74dd7d3ba62e252ca';

/// Real-time list of the current user's Allowance submissions.
///
/// Copied from [userAllowanceStream].
@ProviderFor(userAllowanceStream)
final userAllowanceStreamProvider =
    AutoDisposeStreamProvider<List<AllowanceEntity>>.internal(
  userAllowanceStream,
  name: r'userAllowanceStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userAllowanceStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserAllowanceStreamRef
    = AutoDisposeStreamProviderRef<List<AllowanceEntity>>;
String _$allowanceDetailStreamHash() =>
    r'8f184ccd6228bae6917c64aae2c7c702a4a68d98';

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

/// See also [allowanceDetailStream].
@ProviderFor(allowanceDetailStream)
const allowanceDetailStreamProvider = AllowanceDetailStreamFamily();

/// See also [allowanceDetailStream].
class AllowanceDetailStreamFamily extends Family<AsyncValue<AllowanceEntity?>> {
  /// See also [allowanceDetailStream].
  const AllowanceDetailStreamFamily();

  /// See also [allowanceDetailStream].
  AllowanceDetailStreamProvider call(
    String id,
  ) {
    return AllowanceDetailStreamProvider(
      id,
    );
  }

  @override
  AllowanceDetailStreamProvider getProviderOverride(
    covariant AllowanceDetailStreamProvider provider,
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
  String? get name => r'allowanceDetailStreamProvider';
}

/// See also [allowanceDetailStream].
class AllowanceDetailStreamProvider
    extends AutoDisposeStreamProvider<AllowanceEntity?> {
  /// See also [allowanceDetailStream].
  AllowanceDetailStreamProvider(
    String id,
  ) : this._internal(
          (ref) => allowanceDetailStream(
            ref as AllowanceDetailStreamRef,
            id,
          ),
          from: allowanceDetailStreamProvider,
          name: r'allowanceDetailStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allowanceDetailStreamHash,
          dependencies: AllowanceDetailStreamFamily._dependencies,
          allTransitiveDependencies:
              AllowanceDetailStreamFamily._allTransitiveDependencies,
          id: id,
        );

  AllowanceDetailStreamProvider._internal(
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
    Stream<AllowanceEntity?> Function(AllowanceDetailStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllowanceDetailStreamProvider._internal(
        (ref) => create(ref as AllowanceDetailStreamRef),
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
  AutoDisposeStreamProviderElement<AllowanceEntity?> createElement() {
    return _AllowanceDetailStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllowanceDetailStreamProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AllowanceDetailStreamRef
    on AutoDisposeStreamProviderRef<AllowanceEntity?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _AllowanceDetailStreamProviderElement
    extends AutoDisposeStreamProviderElement<AllowanceEntity?>
    with AllowanceDetailStreamRef {
  _AllowanceDetailStreamProviderElement(super.provider);

  @override
  String get id => (origin as AllowanceDetailStreamProvider).id;
}

String _$allowanceListControllerHash() =>
    r'eb109fac85ba2184f776f009ffa09e25e8867b84';

/// See also [AllowanceListController].
@ProviderFor(AllowanceListController)
final allowanceListControllerProvider = AutoDisposeNotifierProvider<
    AllowanceListController, AllowanceListState>.internal(
  AllowanceListController.new,
  name: r'allowanceListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allowanceListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllowanceListController = AutoDisposeNotifier<AllowanceListState>;
String _$allowancePendingControllerHash() =>
    r'c9eaa0131efd240114e3f0937e025c0391bacef0';

/// See also [AllowancePendingController].
@ProviderFor(AllowancePendingController)
final allowancePendingControllerProvider = AutoDisposeNotifierProvider<
    AllowancePendingController, AllowancePendingState>.internal(
  AllowancePendingController.new,
  name: r'allowancePendingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allowancePendingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllowancePendingController
    = AutoDisposeNotifier<AllowancePendingState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
