import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../utils/logger.dart';

/// Centralised strategy for converting [FirebaseException]s to [Failure]s.
/// Used by all data-layer repository implementations.
/// Keeps Firestore-specific error-code knowledge out of business logic.
class FirestoreErrorHandler {
  FirestoreErrorHandler._();

  /// Wraps a Firestore async operation and returns [Either<Failure, T>].
  /// Any [FirebaseException] or unexpected error is caught and mapped.
  static Future<Either<Failure, T>> guard<T>(
    Future<T> Function() operation, {
    String context = '',
  }) async {
    try {
      final result = await operation();
      return Right(result);
    } on FirebaseException catch (e, st) {
      AppLogger.e('FirebaseException [$context]: ${e.code}', e, st);
      return Left(_mapFirebaseException(e));
    } on FirestoreException catch (e, st) {
      AppLogger.e('FirestoreException [$context]: ${e.message}', e, st);
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } catch (e, st) {
      AppLogger.e('Unexpected error [$context]', e, st);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Converts Firestore [FirebaseException] to domain [Failure].
  static Failure _mapFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const UnauthorizedFailure();
      case 'not-found':
        return FirestoreFailure(
          message: 'Document not found.',
          code: e.code,
        );
      case 'already-exists':
        return FirestoreFailure(
          message: 'Document already exists.',
          code: e.code,
        );
      case 'resource-exhausted':
        return const ServerFailure(message: 'Quota exceeded. Try again later.');
      case 'unavailable':
        return const NetworkFailure(
          message: 'Service temporarily unavailable. Please retry.',
        );
      case 'deadline-exceeded':
        return const NetworkFailure(
          message: 'Request timed out. Please check your connection.',
        );
      case 'unauthenticated':
        return const SessionExpiredFailure();
      default:
        return ServerFailure(
          message: e.message ?? 'Firestore operation failed.',
          code: e.code,
        );
    }
  }
}
