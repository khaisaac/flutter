import 'package:equatable/equatable.dart';

import '../utils/typedefs.dart';

/// Generic base class for synchronous-result use cases.
/// [Type] is the success return type; [Params] is the input parameter type.
abstract class UseCase<Type, Params> {
  const UseCase();
  FutureEither<Type> call(Params params);
}

/// Base class for stream-based use cases (real-time listeners).
abstract class StreamUseCase<Type, Params> {
  const StreamUseCase();
  Stream<Type> call(Params params);
}

/// Placeholder for use cases that require no parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
