import 'package:logger/logger.dart';

/// Application-wide logger.
/// Usage: `AppLogger.instance.d('debug message')`
class AppLogger {
  AppLogger._();

  static final Logger instance = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: Level.debug,
  );

  /// Log debug
  static void d(String message, [Object? error, StackTrace? stackTrace]) =>
      instance.d(message, error: error, stackTrace: stackTrace);

  /// Log info
  static void i(String message, [Object? error, StackTrace? stackTrace]) =>
      instance.i(message, error: error, stackTrace: stackTrace);

  /// Log warning
  static void w(String message, [Object? error, StackTrace? stackTrace]) =>
      instance.w(message, error: error, stackTrace: stackTrace);

  /// Log error
  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      instance.e(message, error: error, stackTrace: stackTrace);

  /// Log fatal
  static void f(String message, [Object? error, StackTrace? stackTrace]) =>
      instance.f(message, error: error, stackTrace: stackTrace);
}
