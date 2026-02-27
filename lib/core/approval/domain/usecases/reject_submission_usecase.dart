import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../approval_enums.dart';
import '../../approval_request.dart';
import '../../data/approval_service.dart';
import '../../../constants/enums.dart';
import '../../../errors/failures.dart';
import '../../../usecases/usecase.dart';
import '../../../utils/typedefs.dart';

/// Parameters required to reject a submission.
class RejectSubmissionParams extends Equatable {
  const RejectSubmissionParams({
    required this.documentId,
    required this.module,
    required this.currentStatus,
    required this.actorUid,
    required this.actorName,
    required this.actorRole,

    /// Rejection reason — strongly recommended but not enforced at the
    /// use-case layer; UI validation should enforce a non-empty note.
    this.note,
    this.extraFields,
  });

  final String documentId;
  final SubmissionModule module;
  final SubmissionStatus currentStatus;
  final String actorUid;
  final String actorName;
  final String actorRole;
  final String? note;
  final JsonMap? extraFields;

  @override
  List<Object?> get props => [documentId, module, currentStatus, actorUid];
}

/// Rejects a submission and moves it to [SubmissionStatus.rejected] (terminal).
class RejectSubmissionUseCase implements UseCase<bool, RejectSubmissionParams> {
  const RejectSubmissionUseCase(this._service);

  final ApprovalService _service;

  @override
  FutureEither<bool> call(RejectSubmissionParams params) async {
    if (params.documentId.isEmpty) {
      return Left(
        const ValidationFailure(message: 'Document ID must not be empty.'),
      );
    }

    return _service.runApproval(
      ApprovalRequest(
        documentId: params.documentId,
        module: params.module,
        currentStatus: params.currentStatus,
        action: ApprovalAction.reject,
        actorUid: params.actorUid,
        actorName: params.actorName,
        actorRole: params.actorRole,
        note: params.note,
        extraFields: params.extraFields,
      ),
    );
  }
}
