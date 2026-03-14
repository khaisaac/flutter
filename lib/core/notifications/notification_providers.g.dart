// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationServiceHash() =>
    r'6d79934546019f913d81d3c0c6b8c6a6e6a4bed0';

/// See also [notificationService].
@ProviderFor(notificationService)
final notificationServiceProvider = Provider<NotificationService>.internal(
  notificationService,
  name: r'notificationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationServiceRef = ProviderRef<NotificationService>;
String _$notificationBootstrapHash() =>
    r'f7f57489e245c625269cef7a31c1ec811316dd44';

/// See also [NotificationBootstrap].
@ProviderFor(NotificationBootstrap)
final notificationBootstrapProvider =
    AsyncNotifierProvider<NotificationBootstrap, void>.internal(
  NotificationBootstrap.new,
  name: r'notificationBootstrapProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationBootstrapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationBootstrap = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
