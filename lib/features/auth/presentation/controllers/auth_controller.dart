import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../providers/auth_providers.dart';

part 'auth_controller.g.dart';

// ── Login Form State ──────────────────────────────────────────────────────────

/// Immutable state for the login screen form.
class LoginFormState {
  final bool isLoading;
  final bool isPasswordObscured;
  final String? errorMessage;

  const LoginFormState({
    this.isLoading = false,
    this.isPasswordObscured = true,
    this.errorMessage,
  });

  LoginFormState copyWith({
    bool? isLoading,
    bool? isPasswordObscured,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginFormState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ── Login Form Controller ─────────────────────────────────────────────────────

/// Manages login form interactions: sign-in action, password visibility toggle,
/// and error state. The result of authentication is broadcast via
/// [authStateStreamProvider] — this controller only handles form-level UX.
@riverpod
class LoginFormController extends _$LoginFormController {
  @override
  LoginFormState build() => const LoginFormState();

  /// Attempts to sign the user in with [email] and [password].
  /// On failure, sets [LoginFormState.errorMessage].
  /// On success, [authStateStreamProvider] emits the authenticated user,
  /// triggering the router to redirect automatically.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref.read(signInUseCaseProvider).call(
          SignInParams(email: email, password: password),
        );

    result.fold(
      (failure) {
        AppLogger.w('Sign-in failure: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (UserEntity user) {
        AppLogger.i('Sign-in success: ${user.uid}');
        // Auth stream emits the user — router handles redirect.
        state = state.copyWith(isLoading: false, clearError: true);
      },
    );
  }

  /// Toggles password field visibility.
  void togglePasswordVisibility() {
    state = state.copyWith(
      isPasswordObscured: !state.isPasswordObscured,
    );
  }

  /// Clears any displayed error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// ── Auth Action Controller ────────────────────────────────────────────────────

/// Handles app-level auth actions: sign-out, token refresh.
/// Separate from [LoginFormController] so sign-out can be triggered
/// from anywhere in the app (e.g. profile page, session expiry).
@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signOut() async {
    state = const AsyncLoading();

    final result = await ref
        .read(signOutUseCaseProvider)
        .call(const NoParams());

    state = result.fold(
      (failure) {
        AppLogger.e('Sign-out failure: ${failure.message}');
        return AsyncError(failure, StackTrace.current);
      },
      (_) {
        AppLogger.i('Sign-out successful.');
        return const AsyncData(null);
      },
    );
  }
}
