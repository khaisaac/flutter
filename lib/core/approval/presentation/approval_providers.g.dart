// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationWriterHash() =>
    r'95ee4c8f0d6bc85d8c6a03ba0dd5ca2566e8051d';

/// See also [notificationWriter].
@ProviderFor(notificationWriter)
final notificationWriterProvider = Provider<NotificationWriter>.internal(
  notificationWriter,
  name: r'notificationWriterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationWriterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationWriterRef = ProviderRef<NotificationWriter>;
String _$approvalServiceHash() => r'30e0f8634e9dfe0b6f4ed4777b8172a80e53cfa4';

/// See also [approvalService].
@ProviderFor(approvalService)
final approvalServiceProvider = Provider<ApprovalService>.internal(
  approvalService,
  name: r'approvalServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$approvalServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApprovalServiceRef = ProviderRef<ApprovalService>;
String _$approveSubmissionUseCaseHash() =>
    r'c00753f658aed8d6f0e6db4c08b9f6538dbeec43';

/// See also [approveSubmissionUseCase].
@ProviderFor(approveSubmissionUseCase)
final approveSubmissionUseCaseProvider =
    Provider<ApproveSubmissionUseCase>.internal(
  approveSubmissionUseCase,
  name: r'approveSubmissionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$approveSubmissionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApproveSubmissionUseCaseRef = ProviderRef<ApproveSubmissionUseCase>;
String _$rejectSubmissionUseCaseHash() =>
    r'ad446040f78cf9a591442ee25dad827600127d9b';

/// See also [rejectSubmissionUseCase].
@ProviderFor(rejectSubmissionUseCase)
final rejectSubmissionUseCaseProvider =
    Provider<RejectSubmissionUseCase>.internal(
  rejectSubmissionUseCase,
  name: r'rejectSubmissionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rejectSubmissionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RejectSubmissionUseCaseRef = ProviderRef<RejectSubmissionUseCase>;
String _$requestRevisionUseCaseHash() =>
    r'87caea83eae5a6ca483fc7b8ad199f08ca7516ae';

/// See also [requestRevisionUseCase].
@ProviderFor(requestRevisionUseCase)
final requestRevisionUseCaseProvider =
    Provider<RequestRevisionUseCase>.internal(
  requestRevisionUseCase,
  name: r'requestRevisionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$requestRevisionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RequestRevisionUseCaseRef = ProviderRef<RequestRevisionUseCase>;
String _$markPaidUseCaseHash() => r'4075eb628348dc7526cc347ad44b75845770679f';

/// See also [markPaidUseCase].
@ProviderFor(markPaidUseCase)
final markPaidUseCaseProvider = Provider<MarkPaidUseCase>.internal(
  markPaidUseCase,
  name: r'markPaidUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$markPaidUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MarkPaidUseCaseRef = ProviderRef<MarkPaidUseCase>;
String _$approvalActionControllerHash() =>
    r'1e66cea36932d047fea93378611680ebb49df395';

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

abstract class _$ApprovalActionController
    extends BuildlessAutoDisposeNotifier<ApprovalActionState> {
  late final String key;

  ApprovalActionState build(
    String key,
  );
}

/// Drives UI for any approval action (approve / reject / revise / markPaid).
///
/// Create one per approval screen using `family`:
/// ```dart
/// ref.watch(approvalActionControllerProvider('docId_moduleValue'))
/// ```
///
/// Copied from [ApprovalActionController].
@ProviderFor(ApprovalActionController)
const approvalActionControllerProvider = ApprovalActionControllerFamily();

/// Drives UI for any approval action (approve / reject / revise / markPaid).
///
/// Create one per approval screen using `family`:
/// ```dart
/// ref.watch(approvalActionControllerProvider('docId_moduleValue'))
/// ```
///
/// Copied from [ApprovalActionController].
class ApprovalActionControllerFamily extends Family<ApprovalActionState> {
  /// Drives UI for any approval action (approve / reject / revise / markPaid).
  ///
  /// Create one per approval screen using `family`:
  /// ```dart
  /// ref.watch(approvalActionControllerProvider('docId_moduleValue'))
  /// ```
  ///
  /// Copied from [ApprovalActionController].
  const ApprovalActionControllerFamily();

  /// Drives UI for any approval action (approve / reject / revise / markPaid).
  ///
  /// Create one per approval screen using `family`:
  /// ```dart
  /// ref.watch(approvalActionControllerProvider('docId_moduleValue'))
  /// ```
  ///
  /// Copied from [ApprovalActionController].
  ApprovalActionControllerProvider call(
    String key,
  ) {
    return ApprovalActionControllerProvider(
      key,
    );
  }

  @override
  ApprovalActionControllerProvider getProviderOverride(
    covariant ApprovalActionControllerProvider provider,
  ) {
    return call(
      provider.key,
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
  String? get name => r'approvalActionControllerProvider';
}

/// Drives UI for any approval action (approve / reject / revise / markPaid).
///
/// Create one per approval screen using `family`:
/// ```dart
/// ref.watch(approvalActionControllerProvider('docId_moduleValue'))
/// ```
///
/// Copied from [ApprovalActionController].
class ApprovalActionControllerProvider extends AutoDisposeNotifierProviderImpl<
    ApprovalActionController, ApprovalActionState> {
  /// Drives UI for any approval action (approve / reject / revise / markPaid).
  ///
  /// Create one per approval screen using `family`:
  /// ```dart
  /// ref.watch(approvalActionControllerProvider('docId_moduleValue'))
  /// ```
  ///
  /// Copied from [ApprovalActionController].
  ApprovalActionControllerProvider(
    String key,
  ) : this._internal(
          () => ApprovalActionController()..key = key,
          from: approvalActionControllerProvider,
          name: r'approvalActionControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$approvalActionControllerHash,
          dependencies: ApprovalActionControllerFamily._dependencies,
          allTransitiveDependencies:
              ApprovalActionControllerFamily._allTransitiveDependencies,
          key: key,
        );

  ApprovalActionControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  ApprovalActionState runNotifierBuild(
    covariant ApprovalActionController notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(ApprovalActionController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ApprovalActionControllerProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ApprovalActionController,
      ApprovalActionState> createElement() {
    return _ApprovalActionControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApprovalActionControllerProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ApprovalActionControllerRef
    on AutoDisposeNotifierProviderRef<ApprovalActionState> {
  /// The parameter `key` of this provider.
  String get key;
}

class _ApprovalActionControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ApprovalActionController,
        ApprovalActionState> with ApprovalActionControllerRef {
  _ApprovalActionControllerProviderElement(super.provider);

  @override
  String get key => (origin as ApprovalActionControllerProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
