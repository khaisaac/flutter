/// Base class for all application-level exceptions.
/// These are caught at the data layer and converted into [Failure] objects.
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

// ── Firebase Auth ─────────────────────────────────────────────────────────────

class AuthException extends AppException {
  const AuthException({required super.message, super.code});
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException()
      : super(message: 'User not found.', code: 'user-not-found');
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException()
      : super(message: 'Incorrect password.', code: 'wrong-password');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException()
      : super(
          message: 'Email already in use.',
          code: 'email-already-in-use',
        );
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException()
      : super(message: 'Unauthorized access.', code: 'unauthorized');
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException()
      : super(message: 'Session expired. Please log in again.', code: 'session-expired');
}

// ── Firestore / Storage ───────────────────────────────────────────────────────

class FirestoreException extends AppException {
  const FirestoreException({required super.message, super.code});
}

class StorageException extends AppException {
  const StorageException({required super.message, super.code});
}

class DocumentNotFoundException extends FirestoreException {
  const DocumentNotFoundException({required String docPath})
      : super(
          message: 'Document not found: $docPath',
          code: 'document-not-found',
        );
}

// ── Network ───────────────────────────────────────────────────────────────────

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'no-internet',
  });
}

// ── Server / Cloud Function ───────────────────────────────────────────────────

class ServerException extends AppException {
  const ServerException({required super.message, super.code = 'server-error'});
}

class CloudFunctionException extends AppException {
  const CloudFunctionException({required super.message, super.code});
}

// ── Validation ────────────────────────────────────────────────────────────────

class ValidationException extends AppException {
  const ValidationException({required super.message, super.code = 'validation-error'});
}

// ── Cache ─────────────────────────────────────────────────────────────────────

class CacheException extends AppException {
  const CacheException({required super.message, super.code = 'cache-error'});
}
