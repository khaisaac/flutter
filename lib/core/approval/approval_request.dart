import '../constants/enums.dart';
import '../utils/typedefs.dart';
import 'approval_enums.dart';

/// The aggregate passed into [ApprovalService.runApproval].
///
/// Carries everything needed to validate, execute, and log a single
/// transition within an approval pipeline — without tying the service to
/// any specific financial module's entity.
class ApprovalRequest {
  const ApprovalRequest({
    required this.documentId,
    required this.module,
    required this.currentStatus,
    required this.action,
    required this.actorUid,
    required this.actorName,
    required this.actorRole,
    this.note,
    this.extraFields,
  });

  /// Firestore document ID of the submission being acted on.
  final String documentId;

  /// Which financial module owns this submission.
  final SubmissionModule module;

  /// The submission's status at the moment the actor initiates the action.
  /// Used to validate that the pipeline has not moved since the actor loaded
  /// the screen (optimistic-lock guard).
  final SubmissionStatus currentStatus;

  /// The action the actor wants to perform.
  final ApprovalAction action;

  /// Firebase UID of the actor.
  final String actorUid;

  /// Display name of the actor (written directly into the history log,
  /// so the log is readable even if the user record is later modified).
  final String actorName;

  /// Role of the actor (e.g. [AppConstants.rolePicProject]).
  final String actorRole;

  /// Optional note / comment attached to this decision.
  final String? note;

  /// Any additional key-value pairs to merge into the parent document
  /// during the same transaction (e.g. revisionNote, rejectionReason).
  final JsonMap? extraFields;

  @override
  String toString() =>
      'ApprovalRequest(doc: $documentId, module: ${module.value}, '
      'action: ${action.value}, actor: $actorUid)';
}
