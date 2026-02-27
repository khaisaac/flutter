import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../errors/failures.dart';
import '../utils/logger.dart';
import 'firestore_error_handler.dart';

/// Paginated result wrapper for list queries.
class PaginatedResult<T> {
  final List<T> items;

  /// The last [DocumentSnapshot] for cursor-based pagination.
  /// Pass into the next query's [startAfterDocument] parameter.
  final DocumentSnapshot? lastDocument;

  /// True when there are no further pages.
  final bool hasReachedEnd;

  const PaginatedResult({
    required this.items,
    this.lastDocument,
    required this.hasReachedEnd,
  });
}

/// Abstract base class for all Firestore repository implementations.
///
/// Provides:
/// - [guardedFetch] — wraps Future ops with error handling
/// - [guardedStream] — wraps Stream ops with error handling
/// - [timestampFromDateTime] / [dateTimeFromTimestamp] — safe conversions
/// - [paginatedQuery] — cursor-based pagination helper
abstract class BaseFirestoreRepository {
  const BaseFirestoreRepository();

  // ── Guarded Operations ────────────────────────────────────────────────────

  /// Wraps a Firestore [Future] operation with standard error handling.
  Future<Either<Failure, T>> guardedFetch<T>(
    Future<T> Function() operation, {
    required String context,
  }) {
    return FirestoreErrorHandler.guard(operation, context: context);
  }

  /// Wraps a Firestore [Stream] into a safe [Stream<Either<Failure, T>>].
  Stream<Either<Failure, T>> guardedStream<T>(
    Stream<T> Function() streamBuilder, {
    required String context,
  }) {
    try {
      return streamBuilder().handleError((Object error, StackTrace st) {
        AppLogger.e('Stream error [$context]', error, st);
      }).map<Either<Failure, T>>((data) => Right(data));
    } catch (e, st) {
      AppLogger.e('Stream init error [$context]', e, st);
      return Stream.value(Left(UnknownFailure(message: e.toString())));
    }
  }

  // ── Timestamp Helpers ─────────────────────────────────────────────────────

  /// Converts a [DateTime] to a Firestore [Timestamp].
  Timestamp timestampFromDateTime(DateTime dt) => Timestamp.fromDate(dt);

  /// Safely extracts [DateTime] from a Firestore field which may be a
  /// [Timestamp], an [int] (millis), or a [String] (ISO8601).
  DateTime? dateTimeFromField(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  // ── Pagination ────────────────────────────────────────────────────────────

  /// Executes a paginated [Query] and maps results using [fromDoc].
  Future<Either<Failure, PaginatedResult<T>>> paginatedQuery<T>({
    required Query<Map<String, dynamic>> query,
    required int pageSize,
    required T Function(DocumentSnapshot<Map<String, dynamic>>) fromDoc,
    DocumentSnapshot? startAfter,
    required String context,
  }) {
    return FirestoreErrorHandler.guard(() async {
      Query<Map<String, dynamic>> q = query.limit(pageSize);
      if (startAfter != null) {
        q = q.startAfterDocument(startAfter);
      }

      final snapshot = await q.get();
      final docs = snapshot.docs;

      final items = docs.map((doc) => fromDoc(doc)).toList();

      return PaginatedResult<T>(
        items: items,
        lastDocument: docs.isNotEmpty ? docs.last : null,
        hasReachedEnd: docs.length < pageSize,
      );
    }, context: context);
  }

  // ── Convenience Wrappers ──────────────────────────────────────────────────

  /// Alias for Firestore [FieldValue.serverTimestamp].
  FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  /// Alias for Firestore [FieldValue.delete()].
  FieldValue get fieldDelete => FieldValue.delete();
}
