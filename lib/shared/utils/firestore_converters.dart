import 'package:cloud_firestore/cloud_firestore.dart';

// ── Firestore Timestamp Helpers ───────────────────────────────────────────────
// Shared JSON conversion helpers used by all Freezed models.
// Attached as static methods to keep generated code clean.

/// Converts a Firestore [Timestamp] or [int] (millis) field to [DateTime].
DateTime? dateTimeFromFirestore(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) return DateTime.tryParse(value);
  return null;
}

/// Converts a non-nullable [DateTime] from Firestore.
DateTime dateTimeFromFirestoreNonNull(dynamic value) {
  return dateTimeFromFirestore(value) ?? DateTime.now();
}

/// Stores [DateTime] as millisecondsSinceEpoch [int] for JSON serialization.
int? dateTimeToMillis(DateTime? dt) => dt?.millisecondsSinceEpoch;

/// Stores non-nullable [DateTime] as millisecondsSinceEpoch.
int dateTimeToMillisNonNull(DateTime dt) => dt.millisecondsSinceEpoch;
