// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_advance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cashAdvanceRemoteDataSourceHash() =>
    r'81ea74000097e16853ed0522214ec970470f205c';

/// See also [cashAdvanceRemoteDataSource].
@ProviderFor(cashAdvanceRemoteDataSource)
final cashAdvanceRemoteDataSourceProvider =
    Provider<CashAdvanceRemoteDataSource>.internal(
  cashAdvanceRemoteDataSource,
  name: r'cashAdvanceRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cashAdvanceRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CashAdvanceRemoteDataSourceRef
    = ProviderRef<CashAdvanceRemoteDataSource>;
String _$cashAdvanceRepositoryHash() =>
    r'60a81bddb85f4ef83587a9d2b1378a653265b2b6';

/// See also [cashAdvanceRepository].
@ProviderFor(cashAdvanceRepository)
final cashAdvanceRepositoryProvider = Provider<CashAdvanceRepository>.internal(
  cashAdvanceRepository,
  name: r'cashAdvanceRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cashAdvanceRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CashAdvanceRepositoryRef = ProviderRef<CashAdvanceRepository>;
String _$userCashAdvanceStreamHash() =>
    r'8c1d78f00e11892c74b66b812d96af31ae7625a9';

/// Real-time list of the current user's Cash Advance submissions.
///
/// Copied from [userCashAdvanceStream].
@ProviderFor(userCashAdvanceStream)
final userCashAdvanceStreamProvider =
    AutoDisposeStreamProvider<List<CashAdvanceEntity>>.internal(
  userCashAdvanceStream,
  name: r'userCashAdvanceStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userCashAdvanceStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserCashAdvanceStreamRef
    = AutoDisposeStreamProviderRef<List<CashAdvanceEntity>>;
String _$cashAdvanceDetailStreamHash() =>
    r'e859c30011a4863e2b84572fd980499953b8f5fa';

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

/// Real-time stream for a single Cash Advance document.
///
/// Copied from [cashAdvanceDetailStream].
@ProviderFor(cashAdvanceDetailStream)
const cashAdvanceDetailStreamProvider = CashAdvanceDetailStreamFamily();

/// Real-time stream for a single Cash Advance document.
///
/// Copied from [cashAdvanceDetailStream].
class CashAdvanceDetailStreamFamily
    extends Family<AsyncValue<CashAdvanceEntity?>> {
  /// Real-time stream for a single Cash Advance document.
  ///
  /// Copied from [cashAdvanceDetailStream].
  const CashAdvanceDetailStreamFamily();

  /// Real-time stream for a single Cash Advance document.
  ///
  /// Copied from [cashAdvanceDetailStream].
  CashAdvanceDetailStreamProvider call(
    String id,
  ) {
    return CashAdvanceDetailStreamProvider(
      id,
    );
  }

  @override
  CashAdvanceDetailStreamProvider getProviderOverride(
    covariant CashAdvanceDetailStreamProvider provider,
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
  String? get name => r'cashAdvanceDetailStreamProvider';
}

/// Real-time stream for a single Cash Advance document.
///
/// Copied from [cashAdvanceDetailStream].
class CashAdvanceDetailStreamProvider
    extends AutoDisposeStreamProvider<CashAdvanceEntity?> {
  /// Real-time stream for a single Cash Advance document.
  ///
  /// Copied from [cashAdvanceDetailStream].
  CashAdvanceDetailStreamProvider(
    String id,
  ) : this._internal(
          (ref) => cashAdvanceDetailStream(
            ref as CashAdvanceDetailStreamRef,
            id,
          ),
          from: cashAdvanceDetailStreamProvider,
          name: r'cashAdvanceDetailStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashAdvanceDetailStreamHash,
          dependencies: CashAdvanceDetailStreamFamily._dependencies,
          allTransitiveDependencies:
              CashAdvanceDetailStreamFamily._allTransitiveDependencies,
          id: id,
        );

  CashAdvanceDetailStreamProvider._internal(
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
    Stream<CashAdvanceEntity?> Function(CashAdvanceDetailStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CashAdvanceDetailStreamProvider._internal(
        (ref) => create(ref as CashAdvanceDetailStreamRef),
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
  AutoDisposeStreamProviderElement<CashAdvanceEntity?> createElement() {
    return _CashAdvanceDetailStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashAdvanceDetailStreamProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CashAdvanceDetailStreamRef
    on AutoDisposeStreamProviderRef<CashAdvanceEntity?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CashAdvanceDetailStreamProviderElement
    extends AutoDisposeStreamProviderElement<CashAdvanceEntity?>
    with CashAdvanceDetailStreamRef {
  _CashAdvanceDetailStreamProviderElement(super.provider);

  @override
  String get id => (origin as CashAdvanceDetailStreamProvider).id;
}

String _$createCashAdvanceUseCaseHash() =>
    r'bf5951288006dd8aaf8f1000482b4ca31b8eda7b';

/// See also [createCashAdvanceUseCase].
@ProviderFor(createCashAdvanceUseCase)
final createCashAdvanceUseCaseProvider =
    AutoDisposeProvider<CreateCashAdvanceUseCase>.internal(
  createCashAdvanceUseCase,
  name: r'createCashAdvanceUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createCashAdvanceUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreateCashAdvanceUseCaseRef
    = AutoDisposeProviderRef<CreateCashAdvanceUseCase>;
String _$submitCashAdvanceUseCaseHash() =>
    r'614944198304165ea97999ee50269cd7d97c0dbc';

/// See also [submitCashAdvanceUseCase].
@ProviderFor(submitCashAdvanceUseCase)
final submitCashAdvanceUseCaseProvider =
    AutoDisposeProvider<SubmitCashAdvanceUseCase>.internal(
  submitCashAdvanceUseCase,
  name: r'submitCashAdvanceUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$submitCashAdvanceUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SubmitCashAdvanceUseCaseRef
    = AutoDisposeProviderRef<SubmitCashAdvanceUseCase>;
String _$getCashAdvanceUseCaseHash() =>
    r'4f7278fccc48575671ea9cc54f56b65579db0b17';

/// See also [getCashAdvanceUseCase].
@ProviderFor(getCashAdvanceUseCase)
final getCashAdvanceUseCaseProvider =
    AutoDisposeProvider<GetCashAdvanceUseCase>.internal(
  getCashAdvanceUseCase,
  name: r'getCashAdvanceUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCashAdvanceUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetCashAdvanceUseCaseRef
    = AutoDisposeProviderRef<GetCashAdvanceUseCase>;
String _$cashAdvanceListControllerHash() =>
    r'180ab17f1131399cacc0e32babeb79ebcaa0a35e';

/// Paginated submissions list controller for Employee list view.
///
/// Copied from [CashAdvanceListController].
@ProviderFor(CashAdvanceListController)
final cashAdvanceListControllerProvider = AutoDisposeNotifierProvider<
    CashAdvanceListController, CashAdvanceListState>.internal(
  CashAdvanceListController.new,
  name: r'cashAdvanceListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cashAdvanceListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CashAdvanceListController = AutoDisposeNotifier<CashAdvanceListState>;
String _$cashAdvancePendingControllerHash() =>
    r'2d37aad228604537c29b7db28e1a3b6f5c89b322';

/// See also [CashAdvancePendingController].
@ProviderFor(CashAdvancePendingController)
final cashAdvancePendingControllerProvider = AutoDisposeNotifierProvider<
    CashAdvancePendingController, PendingApprovalState>.internal(
  CashAdvancePendingController.new,
  name: r'cashAdvancePendingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cashAdvancePendingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CashAdvancePendingController
    = AutoDisposeNotifier<PendingApprovalState>;
String _$cashAdvanceFormControllerHash() =>
    r'96924e9d0f0fb936d4fa55ccf36d5865aa5fb392';

/// Manages state and business actions for the Cash Advance create form.
///
/// - [saveDraft] persists as draft (creates if new; updates if previously saved).
/// - [submit] validates outstanding, then upserts with [pendingPic] status.
/// - [reset] clears state (call on page dispose or post-navigation).
///
/// Copied from [CashAdvanceFormController].
@ProviderFor(CashAdvanceFormController)
final cashAdvanceFormControllerProvider = AutoDisposeNotifierProvider<
    CashAdvanceFormController, CashAdvanceFormState>.internal(
  CashAdvanceFormController.new,
  name: r'cashAdvanceFormControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cashAdvanceFormControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CashAdvanceFormController = AutoDisposeNotifier<CashAdvanceFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
