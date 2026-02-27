import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/reimbursement_entity.dart';
import '../repositories/reimbursement_repository.dart';

class SubmitReimbursementParams extends Equatable {
  const SubmitReimbursementParams({
    required this.entity,
    required this.submitterUid,
  });

  /// The draft entity to submit (must have status == draft or revision).
  final ReimbursementEntity entity;
  final String submitterUid;

  @override
  List<Object?> get props => [entity.id, submitterUid];
}

/// Submits a reimbursement draft (status: draft → pending_pic) and atomically
/// settles the linked Cash Advance inside a single Firestore transaction.
///
/// Settlement rules:
///  - If [entity.linkedCashAdvanceId] is null: standard submit, no CA update.
///  - If linked: CA's `outstandingAmount` is decremented by
///    [entity.totalRequestedAmount]. If the new outstanding ≤ 0, the CA is
///    marked `isFullySettled = true`.
///
/// The transaction ensures no race condition between concurrent submissions.
class SubmitReimbursementUseCase
    implements UseCase<ReimbursementEntity, SubmitReimbursementParams> {
  const SubmitReimbursementUseCase(this._repo);

  final ReimbursementRepository _repo;

  @override
  FutureEither<ReimbursementEntity> call(
      SubmitReimbursementParams params) async {
    final entity = params.entity;

    if (entity.id.isEmpty) {
      return Left(
        const ValidationFailure(
          message: 'Cannot submit an unsaved draft. Save first.',
        ),
      );
    }

    if (!entity.isEditable) {
      return Left(
        ValidationFailure(
          message: 'Cannot submit a submission with status "${entity.status.label}".',
        ),
      );
    }

    if (entity.items.isEmpty) {
      return Left(
        const ValidationFailure(
          message: 'Cannot submit without at least one expense item.',
        ),
      );
    }

    if (entity.computedTotal <= 0) {
      return Left(
        const ValidationFailure(
          message: 'Total amount must be greater than 0.',
        ),
      );
    }

    return _repo.submitWithSettlement(
      entity: entity,
      linkedCaId: entity.linkedCashAdvanceId,
    );
  }
}
