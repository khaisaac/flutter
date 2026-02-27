import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../approval_enums.dart';
import '../../approval_request.dart';
import '../../data/approval_service.dart';
import '../../../constants/enums.dart';
import '../../../errors/failures.dart';
import '../../../usecases/usecase.dart';
import '../../../utils/typedefs.dart';

/// Parameters required to request a revision on a submission.
class RequestRevisionParams extends Equatable {
  const RequestRevisionParams({
    required this.documentId,
    required this.module,
    required this.currentStatus,
    required this.actorUid,
    required this.actorName,
    required this.actorRole,

    /// Revision instructions — shown to the submitter in their detail view.
    /// Strongly recommended; UI should enforce a non-empty value.
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

/// Sends a submission back to the submitter for revision
/// ([SubmissionStatus.revision]).
class RequestRevisionUseCase
    implements UseCase<bool, RequestRevisionParams> {
  const RequestRevisionUseCase(this._service);

  final ApprovalService _service;

  @override
  FutureEither<bool> call(RequestRevisionParams params) async {
    if (params.documentId.isEmpty) {
      return Left(
        const ValidationFailure(message: 'Document ID must not be empty.'),
      );
    }

    if (params.note == null || params.note!.trim().isEmpty) {
      return Left(
        const ValidationFailure(
          message: 'A revision note is required so the submitter knows what to fix.',
        ),
      );
    }

    return _service.runApproval(
      ApprovalRequest(
        documentId: params.documentId,
        module: params.module,
        currentStatus: params.currentStatus,
        action: ApprovalAction.revise,
        actorUid: params.actorUid,
        actorName: params.actorName,
        actorRole: params.actorRole,
        note: params.note,
        extraFields: params.extraFields,
      ),
    );
  }
}
