import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../../../core/errors/exceptions.dart';

/// Maps [firebase_auth.FirebaseAuthException] codes to typed [AuthException]s.
/// Keeps all Firebase-specific error-code knowledge in the data layer.
class FirebaseAuthExceptionMapper {
  FirebaseAuthExceptionMapper._();

  static AuthException map(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const UserNotFoundException();
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-email':
        return const WrongPasswordException();
      case 'email-already-in-use':
        return const EmailAlreadyInUseException();
      case 'user-disabled':
        return AuthException(
          message: 'Your account has been disabled. Contact your administrator.',
          code: e.code,
        );
      case 'too-many-requests':
        return AuthException(
          message: 'Too many failed attempts. Please try again later.',
          code: e.code,
        );
      case 'network-request-failed':
        return AuthException(
          message: 'Network error. Please check your connection.',
          code: e.code,
        );
      case 'id-token-expired':
      case 'user-token-expired':
        return const SessionExpiredException();
      default:
        return AuthException(
          message: e.message ?? 'Authentication failed. Please try again.',
          code: e.code,
        );
    }
  }
}
