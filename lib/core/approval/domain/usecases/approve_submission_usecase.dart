import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../approval_enums.dart';
import '../../approval_request.dart';
import '../../data/approval_service.dart';
import '../../../constants/enums.dart';
import '../../../errors/failures.dart';
import '../../../usecases/usecase.dart';
import '../../../utils/typedefs.dart';

/// Parameters required to approve a submission.
class ApproveSubmissionParams extends Equatable {
  const ApproveSubmissionParams({
    required this.documentId,
    required this.module,
    required this.currentStatus,
    required this.actorUid,
    required this.actorName,
    required this.actorRole,
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

/// Approves a submission, advancing it to the next pipeline step.
///
/// Delegates entirely to [ApprovalService.runApproval] — this use case adds
/// no business logic of its own; it exists to follow Clean Architecture's
/// single-responsibility principle and to make the approval domain unit-testable
/// without coupling to concrete service implementations.
class ApproveSubmissionUseCase
    implements UseCase<bool, ApproveSubmissionParams> {
  const ApproveSubmissionUseCase(this._service);

  final ApprovalService _service;

  @override
  FutureEither<bool> call(ApproveSubmissionParams params) async {
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
        action: ApprovalAction.approve,
        actorUid: params.actorUid,
        actorName: params.actorName,
        actorRole: params.actorRole,
        note: params.note,
        extraFields: params.extraFields,
      ),
    );
  }
}
