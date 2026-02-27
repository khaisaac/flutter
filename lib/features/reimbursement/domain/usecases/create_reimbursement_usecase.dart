import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/reimbursement_entity.dart';
import '../repositories/reimbursement_repository.dart';

class CreateReimbursementParams extends Equatable {
  const CreateReimbursementParams({
    required this.submittedByUid,
    required this.submittedByName,
    required this.projectId,
    required this.projectName,
    required this.items,
    required this.description,
    this.linkedCashAdvanceId,
    this.linkedCashAdvancePurpose,
    this.currency = 'IDR',
  });

  final String submittedByUid;
  final String submittedByName;
  final String projectId;
  final String projectName;
  final List<ReimbursementItem> items;
  final String description;
  final String? linkedCashAdvanceId;
  final String? linkedCashAdvancePurpose;
  final String currency;

  @override
  List<Object?> get props =>
      [submittedByUid, projectId, items, linkedCashAdvanceId];
}

/// Builds a [ReimbursementEntity] draft and persists it to Firestore.
///
/// This use case only creates the draft — it does NOT transition status
/// or touch the linked Cash Advance. Call [SubmitReimbursementUseCase]
/// to submit and settle simultaneously.
class CreateReimbursementUseCase
    implements UseCase<ReimbursementEntity, CreateReimbursementParams> {
  const CreateReimbursementUseCase(this._repo);

  final ReimbursementRepository _repo;

  static const _uuid = Uuid();

  @override
  FutureEither<ReimbursementEntity> call(
      CreateReimbursementParams params) async {
    if (params.items.isEmpty) {
      return Left(
        const ValidationFailure(
          message: 'At least one expense item is required.',
        ),
      );
    }

    final total = params.items.fold(0.0, (s, i) => s + i.amount);
    if (total <= 0) {
      return Left(
        const ValidationFailure(message: 'Total amount must be greater than 0.'),
      );
    }

    final entity = ReimbursementEntity(
      id: _uuid.v4(), // Replaced with server ID on create
      submittedByUid: params.submittedByUid,
      submittedByName: params.submittedByName,
      projectId: params.projectId,
      projectName: params.projectName,
      items: params.items,
      totalRequestedAmount: total,
      currency: params.currency,
      description: params.description,
      linkedCashAdvanceId: params.linkedCashAdvanceId,
      linkedCashAdvancePurpose: params.linkedCashAdvancePurpose,
      status: SubmissionStatus.draft,
      createdAt: DateTime.now(),
    );

    return _repo.create(entity);
  }
}
