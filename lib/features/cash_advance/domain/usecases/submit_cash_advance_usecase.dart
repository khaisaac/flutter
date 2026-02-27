import 'package:dartz/dartz.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/cash_advance_entity.dart';
import '../repositories/cash_advance_repository.dart';

/// Parameters for submitting a Cash Advance for approval.
class SubmitCashAdvanceParams {
  const SubmitCashAdvanceParams({
    required this.entity,
    required this.submitterUid,
  });

  /// The entity to submit. May have an empty [id] (new) or a real id (draft).
  final CashAdvanceEntity entity;

  /// UID of the person triggering submission (for outstanding check).
  final String submitterUid;
}

/// Submits a Cash Advance for PIC Project approval.
///
/// Business rules enforced:
/// 1. The user must not already have an active in-flight submission
///    (status in [pending_pic, pending_finance, approved]).
/// 2. Status transitions: draft → pending_pic  (or revision → pending_pic).
/// 3. Upserts the entity: creates if [entity.id] is empty, otherwise updates.
class SubmitCashAdvanceUseCase {
  const SubmitCashAdvanceUseCase(this._repo);

  final CashAdvanceRepository _repo;

  FutureEither<CashAdvanceEntity> call(SubmitCashAdvanceParams params) async {
    // ── 1. Outstanding guard ───────────────────────────────────────────────
    final checkResult = await _repo.hasOutstanding(params.submitterUid);

    // Propagate any Firestore-level failure from the check itself.
    final checkFailure = checkResult.fold<Failure?>((f) => f, (_) => null);
    if (checkFailure != null) return Left(checkFailure);

    final hasOutstanding = checkResult.getOrElse(() => false);
    if (hasOutstanding) {
      return const Left(
        ValidationFailure(
          message:
              'You already have an active Cash Advance request. '
              'Submit new requests only after your current one is fully settled.',
          code: 'outstanding-exists',
        ),
      );
    }

    // ── 2. Transition to pending_pic ───────────────────────────────────────
    final now = DateTime.now();
    final submitted = params.entity.copyWith(
      status: SubmissionStatus.pendingPic,
      submittedAt: now,
      updatedAt: now,
    );

    // ── 3. Upsert ──────────────────────────────────────────────────────────
    if (params.entity.id.isEmpty) {
      return _repo.create(submitted);
    }
    return _repo.update(submitted);
  }
}
