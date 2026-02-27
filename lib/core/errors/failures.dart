import 'package:equatable/equatable.dart';

/// Domain-layer error representation.
/// Returned via [Either<Failure, T>] from repositories and use cases.
/// The presentation layer maps failures to human-readable messages.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

// ── Auth Failures ─────────────────────────────────────────────────────────────

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure()
      : super(message: 'User not found.', code: 'user-not-found');
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure()
      : super(message: 'Incorrect password.', code: 'wrong-password');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure()
      : super(message: 'Email already in use.', code: 'email-already-in-use');
}

class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure()
      : super(message: 'You are not authorized.', code: 'unauthorized');
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure()
      : super(
          message: 'Your session has expired. Please log in again.',
          code: 'session-expired',
        );
}

// ── Network Failures ──────────────────────────────────────────────────────────

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection.',
    super.code = 'no-internet',
  });
}

// ── Server Failures ───────────────────────────────────────────────────────────

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code = 'server-error'});
}

class CloudFunctionFailure extends Failure {
  const CloudFunctionFailure({required super.message, super.code});
}

// ── Firestore / Storage Failures ──────────────────────────────────────────────

class FirestoreFailure extends Failure {
  const FirestoreFailure({required super.message, super.code});
}

class DocumentNotFoundFailure extends FirestoreFailure {
  const DocumentNotFoundFailure({required String docPath})
      : super(
          message: 'Document not found: $docPath',
          code: 'document-not-found',
        );
}

class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code});
}

// ── Validation Failures ───────────────────────────────────────────────────────

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code = 'validation-error'});
}

// ── Cache Failures ────────────────────────────────────────────────────────────

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code = 'cache-error'});
}

// ── Unknown Failures ──────────────────────────────────────────────────────────

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.code = 'unknown',
  });
}
