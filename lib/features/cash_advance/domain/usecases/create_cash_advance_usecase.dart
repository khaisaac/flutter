import '../../../../core/constants/enums.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/cash_advance_entity.dart';
import '../repositories/cash_advance_repository.dart';

/// Parameters for creating a new Cash Advance draft.
class CreateCashAdvanceParams {
  const CreateCashAdvanceParams({
    required this.submittedByUid,
    required this.submittedByName,
    required this.projectId,
    required this.projectName,
    required this.requestedAmount,
    this.currency = 'IDR',
    required this.purpose,
    this.description = '',
  });

  final String submittedByUid;
  final String submittedByName;
  final String projectId;
  final String projectName;
  final double requestedAmount;
  final String currency;
  final String purpose;
  final String description;
}

/// Creates a new Cash Advance submission in [SubmissionStatus.draft] state.
/// Returns the saved entity with the server-assigned document ID.
class CreateCashAdvanceUseCase {
  const CreateCashAdvanceUseCase(this._repo);

  final CashAdvanceRepository _repo;

  FutureEither<CashAdvanceEntity> call(CreateCashAdvanceParams params) {
    final entity = CashAdvanceEntity(
      id: '',
      submittedByUid: params.submittedByUid,
      submittedByName: params.submittedByName,
      projectId: params.projectId,
      projectName: params.projectName,
      requestedAmount: params.requestedAmount,
      currency: params.currency,
      purpose: params.purpose,
      description: params.description,
      status: SubmissionStatus.draft,
      createdAt: DateTime.now(),
    );
    return _repo.create(entity);
  }
}
