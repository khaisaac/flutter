import 'package:dartz/dartz.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/allowance_entity.dart';
import '../repositories/allowance_repository.dart';

/// Parameters for submitting an Allowance for approval.
class SubmitAllowanceParams {
  const SubmitAllowanceParams({
    required this.entity,
    required this.submitterUid,
  });

  /// The draft entity to submit. If [entity.id] is empty the impl will
  /// create it first; otherwise it updates the existing draft.
  final AllowanceEntity entity;
  final String submitterUid;
}

/// Submits an Allowance draft → `pending_pic`.
///
/// Business rules:
///  1. Amount must be > 0.
///  2. Entity status must be `draft` or `revision`.
///  3. Transitions: draft | revision → pending_pic.
///  4. Upserts: creates when [entity.id] is empty, updates otherwise.
class SubmitAllowanceUseCase {
  const SubmitAllowanceUseCase(this._repo);

  final AllowanceRepository _repo;

  FutureEither<AllowanceEntity> call(SubmitAllowanceParams params) async {
    final entity = params.entity;

    if (entity.requestedAmount <= 0) {
      return const Left(
        ValidationFailure(message: 'Requested amount must be greater than 0.'),
      );
    }

    if (!entity.isEditable) {
      return Left(
        ValidationFailure(
          message:
              'Cannot submit an allowance with status "${entity.status.label}".',
        ),
      );
    }

    final now = DateTime.now();
    final submitted = entity.copyWith(
      status: SubmissionStatus.pendingPic,
      submittedAt: now,
      updatedAt: now,
    );

    if (entity.id.isEmpty) {
      return _repo.create(submitted);
    }
    return _repo.update(submitted);
  }
}
