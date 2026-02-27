// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginFormControllerHash() =>
    r'b2af6e1313858f82966a6bf1dbec7c0d256cb866';

/// Manages login form interactions: sign-in action, password visibility toggle,
/// and error state. The result of authentication is broadcast via
/// [authStateStreamProvider] — this controller only handles form-level UX.
///
/// Copied from [LoginFormController].
@ProviderFor(LoginFormController)
final loginFormControllerProvider =
    AutoDisposeNotifierProvider<LoginFormController, LoginFormState>.internal(
  LoginFormController.new,
  name: r'loginFormControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loginFormControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoginFormController = AutoDisposeNotifier<LoginFormState>;
String _$authControllerHash() => r'd82376a32a668dd7467c32ffb4339813c1be4ce9';

/// Handles app-level auth actions: sign-out, token refresh.
/// Separate from [LoginFormController] so sign-out can be triggered
/// from anywhere in the app (e.g. profile page, session expiry).
///
/// Copied from [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    AutoDisposeNotifierProvider<AuthController, AsyncValue<void>>.internal(
  AuthController.new,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
