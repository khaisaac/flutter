import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../di/app_providers.dart';
import '../../errors/failures.dart';
import '../approval_enums.dart';
import '../data/approval_service.dart';
import '../data/notification_writer.dart';
import '../domain/usecases/approve_submission_usecase.dart';
import '../domain/usecases/mark_paid_usecase.dart';
import '../domain/usecases/reject_submission_usecase.dart';
import '../domain/usecases/request_revision_usecase.dart';

part 'approval_providers.g.dart';

// ── Infrastructure providers ───────────────────────────────────────────────

@Riverpod(keepAlive: true)
NotificationWriter notificationWriter(Ref ref) =>
    NotificationWriter(ref.watch(firestoreProvider));

@Riverpod(keepAlive: true)
ApprovalService approvalService(Ref ref) => ApprovalService(
      firestore: ref.watch(firestoreProvider),
      notificationWriter: ref.watch(notificationWriterProvider),
    );

// ── Use-case providers ─────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
ApproveSubmissionUseCase approveSubmissionUseCase(Ref ref) =>
    ApproveSubmissionUseCase(ref.watch(approvalServiceProvider));

@Riverpod(keepAlive: true)
RejectSubmissionUseCase rejectSubmissionUseCase(Ref ref) =>
    RejectSubmissionUseCase(ref.watch(approvalServiceProvider));

@Riverpod(keepAlive: true)
RequestRevisionUseCase requestRevisionUseCase(Ref ref) =>
    RequestRevisionUseCase(ref.watch(approvalServiceProvider));

@Riverpod(keepAlive: true)
MarkPaidUseCase markPaidUseCase(Ref ref) =>
    MarkPaidUseCase(ref.watch(approvalServiceProvider));

// ── ApprovalActionState ────────────────────────────────────────────────────

/// Ephemeral state for the approval action UI (approve / reject / revise).
class ApprovalActionState {
  const ApprovalActionState({
    this.isLoading = false,
    this.isDone = false,
    this.errorMessage,
    this.completedAction,
  });

  final bool isLoading;
  final bool isDone;
  final String? errorMessage;
  final ApprovalAction? completedAction;

  bool get hasError => errorMessage != null;

  ApprovalActionState copyWith({
    bool? isLoading,
    bool? isDone,
    String? errorMessage,
    ApprovalAction? completedAction,
    bool clearError = false,
  }) =>
      ApprovalActionState(
        isLoading: isLoading ?? this.isLoading,
        isDone: isDone ?? this.isDone,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        completedAction: completedAction ?? this.completedAction,
      );
}

// ── ApprovalActionController ───────────────────────────────────────────────

/// Drives UI for any approval action (approve / reject / revise / markPaid).
///
/// Create one per approval screen using `family`:
/// ```dart
/// ref.watch(approvalActionControllerProvider('docId_moduleValue'))
/// ```
@riverpod
class ApprovalActionController extends _$ApprovalActionController {
  @override
  ApprovalActionState build(String key) => const ApprovalActionState();

  /// Approve the submission described by the parameters.
  Future<void> approve(ApproveSubmissionParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(approveSubmissionUseCaseProvider)(params);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: _failureMessage(failure),
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        isDone: true,
        completedAction: ApprovalAction.approve,
      ),
    );
  }

  /// Reject the submission described by the parameters.
  Future<void> reject(RejectSubmissionParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(rejectSubmissionUseCaseProvider)(params);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: _failureMessage(failure),
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        isDone: true,
        completedAction: ApprovalAction.reject,
      ),
    );
  }

  /// Request revisions on the submission.
  Future<void> requestRevision(RequestRevisionParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(requestRevisionUseCaseProvider)(params);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: _failureMessage(failure),
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        isDone: true,
        completedAction: ApprovalAction.revise,
      ),
    );
  }

  /// Mark an approved submission as paid (Finance only).
  Future<void> markPaid(MarkPaidParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(markPaidUseCaseProvider)(params);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: _failureMessage(failure),
      ),
      (_) => state = state.copyWith(
        isLoading: false,
        isDone: true,
        completedAction: ApprovalAction.markPaid,
      ),
    );
  }

  void reset() => state = const ApprovalActionState();

  String _failureMessage(Failure failure) => failure.message;
}
