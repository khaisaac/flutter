import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../approval_enums.dart';
import '../../approval_request.dart';
import '../../data/approval_service.dart';
import '../../../constants/enums.dart';
import '../../../errors/failures.dart';
import '../../../usecases/usecase.dart';
import '../../../utils/typedefs.dart';

/// Parameters required to mark a submission as paid.
class MarkPaidParams extends Equatable {
  const MarkPaidParams({
    required this.documentId,
    required this.module,
    required this.actorUid,
    required this.actorName,
    this.note,
    this.extraFields,
  });

  final String documentId;
  final SubmissionModule module;
  final String actorUid;
  final String actorName;
  final String? note;
  final JsonMap? extraFields;

  @override
  List<Object?> get props => [documentId, module, actorUid];
}

/// Marks an approved submission as paid (Finance-only, terminal state).
///
/// The submission must already be in [SubmissionStatus.approved]; this use
/// case enforces that by passing [SubmissionStatus.approved] as the
/// [currentStatus] so the service's stale-status guard will catch any
/// out-of-sequence call.
class MarkPaidUseCase implements UseCase<bool, MarkPaidParams> {
  const MarkPaidUseCase(this._service);

  final ApprovalService _service;

  @override
  FutureEither<bool> call(MarkPaidParams params) async {
    if (params.documentId.isEmpty) {
      return Left(
        const ValidationFailure(message: 'Document ID must not be empty.'),
      );
    }

    return _service.runApproval(
      ApprovalRequest(
        documentId: params.documentId,
        module: params.module,
        currentStatus: SubmissionStatus.approved,
        action: ApprovalAction.markPaid,
        actorUid: params.actorUid,
        actorName: params.actorName,
        actorRole: 'finance',
        note: params.note,
        extraFields: params.extraFields,
      ),
    );
  }
}
