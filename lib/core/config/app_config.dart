/// Environment / build-time configuration.
/// Values here are set once at startup and remain immutable.
class AppConfig {
  AppConfig._();

  /// True when running in debug/profile mode.
  static const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: true);

  /// Firebase project ID (mirrors firebase_options.dart — kept for reference).
  static const String firebaseProjectId = 'reimbursement-hexa';

  /// Firestore region (for callable Cloud Functions).
  static const String functionsRegion = 'asia-southeast1';
}
