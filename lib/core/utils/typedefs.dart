/// Central type aliases used across all layers.
/// Keeps import chains short and intent explicit.
library;

import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Standard return type for all repository methods and use cases.
/// [L] is always a [Failure]; [R] is the success value.
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Stream-based Either, used for real-time Firestore subscriptions.
typedef StreamEither<T> = Stream<Either<Failure, T>>;

/// JSON map, widely used in serialization.
typedef JsonMap = Map<String, dynamic>;
