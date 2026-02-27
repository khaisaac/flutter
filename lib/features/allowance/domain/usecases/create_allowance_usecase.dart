import '../../../../core/constants/enums.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../../shared/models/attachment_model.dart';
import '../entities/allowance_entity.dart';
import '../repositories/allowance_repository.dart';

/// Parameters for creating a new Allowance draft.
class CreateAllowanceParams {
  const CreateAllowanceParams({
    required this.submittedByUid,
    required this.submittedByName,
    required this.type,
    required this.requestedAmount,
    required this.allowanceDate,
    this.description = '',
    this.currency = 'IDR',
    this.projectId,
    this.projectName,
    this.attendanceFiles = const [],
  });

  final String submittedByUid;
  final String submittedByName;
  final AllowanceType type;
  final double requestedAmount;
  final DateTime allowanceDate;
  final String description;
  final String currency;
  final String? projectId;
  final String? projectName;

  /// Attendance proof files already uploaded to Firebase Storage.
  final List<AttachmentEntity> attendanceFiles;
}

/// Creates a new Allowance submission in [SubmissionStatus.draft] state.
/// Returns the saved entity with the server-assigned document ID.
class CreateAllowanceUseCase {
  const CreateAllowanceUseCase(this._repo);

  final AllowanceRepository _repo;

  FutureEither<AllowanceEntity> call(CreateAllowanceParams params) {
    final entity = AllowanceEntity(
      id: '',
      submittedByUid: params.submittedByUid,
      submittedByName: params.submittedByName,
      projectId: params.projectId,
      projectName: params.projectName,
      type: params.type,
      requestedAmount: params.requestedAmount,
      currency: params.currency,
      allowanceDate: params.allowanceDate,
      description: params.description,
      status: SubmissionStatus.draft,
      createdAt: DateTime.now(),
      attachments: params.attendanceFiles,
    );
    return _repo.create(entity);
  }
}
