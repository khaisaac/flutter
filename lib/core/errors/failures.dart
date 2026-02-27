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

// ── Approval Engine Failures ──────────────────────────────────────────────────

/// Base class for all approval-workflow failures.
class ApprovalFailure extends Failure {
  const ApprovalFailure({required super.message, super.code = 'approval-error'});
}

/// Thrown when the submission is not in a state that accepts any action.
class InvalidApprovalStateFailure extends ApprovalFailure {
  const InvalidApprovalStateFailure({required String status})
      : super(
          message: 'Cannot act on a submission with status "$status".',
          code: 'invalid-approval-state',
        );
}

/// Thrown when the actor's role does not match the step's required role.
class UnauthorizedApprovalFailure extends ApprovalFailure {
  const UnauthorizedApprovalFailure({required String requiredRole, required String actorRole})
      : super(
          message:
              'Action requires role "$requiredRole", but actor has role "$actorRole".',
          code: 'unauthorized-approval',
        );
}

/// Thrown when the actor's requested action is not in the step's allowed list.
class DisallowedActionFailure extends ApprovalFailure {
  const DisallowedActionFailure({required String action, required String step})
      : super(
          message: 'Action "$action" is not allowed at step "$step".',
          code: 'disallowed-action',
        );
}

/// Thrown when the document status changed between the actor loading the UI
/// and submitting the approval (concurrent modification guard).
class StaleStatusFailure extends ApprovalFailure {
  const StaleStatusFailure({required String expected, required String actual})
      : super(
          message:
              'Submission status changed since you opened it. '
              'Expected "$expected" but found "$actual".',
          code: 'stale-status',
        );
}
