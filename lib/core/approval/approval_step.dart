import 'package:equatable/equatable.dart';

import '../constants/enums.dart';
import '../constants/app_constants.dart';
import 'approval_enums.dart';

/// A single node in an approval pipeline.
///
/// Describes which role must act at this step, what [ApprovalAction]s are
/// permitted, and which [SubmissionStatus] the submission transitions into
/// when that action is taken.
class ApprovalStep extends Equatable {
  const ApprovalStep({
    required this.stepIndex,
    required this.requiredRole,
    required this.allowedActions,
    required this.onApprove,
    required this.onReject,
    this.onRevise,
    this.label = '',
  });

  /// Zero-based position in the pipeline (used for logging and cursoring).
  final int stepIndex;

  /// The role that is authorised to act on this step.
  /// One of [AppConstants.roleEmployee], [AppConstants.rolePicProject],
  /// [AppConstants.roleFinance].
  final String requiredRole;

  /// Which [ApprovalAction]s are valid at this step.
  final List<ApprovalAction> allowedActions;

  /// The [SubmissionStatus] to set when an [ApprovalAction.approve] action
  /// is taken at this step.
  final SubmissionStatus onApprove;

  /// The [SubmissionStatus] to set on [ApprovalAction.reject].
  final SubmissionStatus onReject;

  /// The [SubmissionStatus] to set on [ApprovalAction.revise].
  /// Null if revision is not available at this step.
  final SubmissionStatus? onRevise;

  /// Human-readable label for this step (used in UI and logs).
  final String label;

  bool canActWith(ApprovalAction action) => allowedActions.contains(action);

  bool isAuthorised(String actorRole) => actorRole == requiredRole;

  @override
  List<Object?> get props => [stepIndex, requiredRole];

  @override
  String toString() =>
      'ApprovalStep(step: $stepIndex, role: $requiredRole, label: $label)';
}

/// Defines the full multi-step approval pipeline for a submission module.
///
/// Each financial module has an identical two-step pipeline (PIC → Finance),
/// with Finance having the additional ability to mark payment as disbursed.
///
/// Usage:
/// ```dart
/// final step = ApprovalPipeline.forModule(SubmissionModule.cashAdvance)
///     .stepForStatus(SubmissionStatus.pendingPic);
/// ```
class ApprovalPipeline {
  const ApprovalPipeline._(this.steps);

  final List<ApprovalStep> steps;

  // ── Pipeline factory ──────────────────────────────────────────────────────

  /// Returns the canonical approval pipeline for [module].
  /// All three modules share identical pipeline logic.
  factory ApprovalPipeline.forModule(SubmissionModule module) =>
      const ApprovalPipeline._(_sharedSteps);

  // ── Shared two-step pipeline: PIC Project → Finance ───────────────────────

  static const List<ApprovalStep> _sharedSteps = [
    // Step 0 — PIC Project review
    ApprovalStep(
      stepIndex: 0,
      requiredRole: AppConstants.rolePicProject,
      allowedActions: [
        ApprovalAction.approve,
        ApprovalAction.reject,
        ApprovalAction.revise,
      ],
      onApprove: SubmissionStatus.pendingFinance,
      onReject: SubmissionStatus.rejected,
      onRevise: SubmissionStatus.revision,
      label: 'PIC Project Review',
    ),
    // Step 1 — Finance processing
    ApprovalStep(
      stepIndex: 1,
      requiredRole: AppConstants.roleFinance,
      allowedActions: [
        ApprovalAction.approve,
        ApprovalAction.reject,
        ApprovalAction.revise,
        ApprovalAction.markPaid,
      ],
      onApprove: SubmissionStatus.approved,
      onReject: SubmissionStatus.rejected,
      onRevise: SubmissionStatus.revision,
      label: 'Finance Processing',
    ),
  ];

  // ── Lookup helpers ────────────────────────────────────────────────────────

  /// Returns the [ApprovalStep] whose [requiredRole] matches the approver's
  /// current role, or null if there is no active step for that role.
  ApprovalStep? stepForRole(String role) {
    try {
      return steps.firstWhere((s) => s.requiredRole == role);
    } catch (_) {
      return null;
    }
  }

  /// Returns the [ApprovalStep] that governs the given [SubmissionStatus],
  /// i.e., the step that is *waiting* on an actor while in this status.
  ApprovalStep? stepForStatus(SubmissionStatus status) => switch (status) {
        SubmissionStatus.pendingPic =>
          steps.firstWhere((s) => s.stepIndex == 0),
        SubmissionStatus.pendingFinance =>
          steps.firstWhere((s) => s.stepIndex == 1),
        _ => null,
      };

  /// True when [status] is a step that may receive any approval action.
  bool isActionableStatus(SubmissionStatus status) =>
      stepForStatus(status) != null;
}
