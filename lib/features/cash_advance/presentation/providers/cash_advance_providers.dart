import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/di/app_providers.dart';
import '../../../../core/utils/typedefs.dart';
import '../../data/datasources/cash_advance_remote_data_source.dart';
import '../../data/repositories/cash_advance_repository_impl.dart';
import '../../domain/entities/cash_advance_entity.dart';
import '../../domain/repositories/cash_advance_repository.dart';
import '../../domain/usecases/create_cash_advance_usecase.dart';
import '../../domain/usecases/get_cash_advance_usecase.dart';
import '../../domain/usecases/submit_cash_advance_usecase.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

part 'cash_advance_providers.g.dart';

// ── DI Wiring ─────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
CashAdvanceRemoteDataSource cashAdvanceRemoteDataSource(
    CashAdvanceRemoteDataSourceRef ref,) {
  return CashAdvanceRemoteDataSourceImpl(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
CashAdvanceRepository cashAdvanceRepository(CashAdvanceRepositoryRef ref) {
  return CashAdvanceRepositoryImpl(
    ref.watch(cashAdvanceRemoteDataSourceProvider),
  );
}

// ── User's Submission Stream ──────────────────────────────────────────────────

/// Real-time list of the current user's Cash Advance submissions.
@riverpod
Stream<List<CashAdvanceEntity>> userCashAdvanceStream(
    UserCashAdvanceStreamRef ref,) {
  final authAsync = ref.watch(authStateStreamProvider);
  final user = authAsync.valueOrNull;
  if (user == null) return const Stream.empty();

  return ref
      .watch(cashAdvanceRepositoryProvider)
      .watchUserSubmissions(user.uid)
      .map((either) => either.getOrElse(() => []));
}

/// One-shot fetch of approved/paid CAs that are not fully settled.
/// Used to populate the "Linked Cash Advance" dropdown on the
/// Reimbursement create form.
@riverpod
Future<List<CashAdvanceEntity>> approvedCashAdvances(
    ApprovedCashAdvancesRef ref) async {
  final user = ref.watch(authStateStreamProvider).valueOrNull;
  if (user == null) return [];
  final result = await ref
      .watch(cashAdvanceRepositoryProvider)
      .getApprovedCashAdvances(user.uid);
  return result.getOrElse(() => []);
}

// ── Paginated List State ──────────────────────────────────────────────────────

class CashAdvanceListState {
  final List<CashAdvanceEntity> items;
  final bool isLoading;
  final bool hasReachedEnd;
  final String? errorMessage;

  const CashAdvanceListState({
    this.items = const [],
    this.isLoading = false,
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  CashAdvanceListState copyWith({
    List<CashAdvanceEntity>? items,
    bool? isLoading,
    bool? hasReachedEnd,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CashAdvanceListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Paginated submissions list controller for Employee list view.
@riverpod
class CashAdvanceListController extends _$CashAdvanceListController {
  static const int _pageSize = 20;

  @override
  CashAdvanceListState build() {
    // Kick off first page load.
    Future.microtask(loadFirstPage);
    return const CashAdvanceListState(isLoading: true);
  }

  Future<void> loadFirstPage() async {
    final authAsync = ref.read(authStateStreamProvider);
    final user = authAsync.valueOrNull;
    if (user == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref.read(cashAdvanceRepositoryProvider).getUserSubmissions(
          userId: user.uid,
          pageSize: _pageSize,
        );

    state = result.fold(
      (f) => state.copyWith(isLoading: false, errorMessage: f.message),
      (page) => CashAdvanceListState(
        items: page.items,
        isLoading: false,
        hasReachedEnd: page.hasReachedEnd,
      ),
    );
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.hasReachedEnd) return;

    final authAsync = ref.read(authStateStreamProvider);
    final user = authAsync.valueOrNull;
    if (user == null) return;

    state = state.copyWith(isLoading: true);

    final result = await ref.read(cashAdvanceRepositoryProvider).getUserSubmissions(
          userId: user.uid,
          pageSize: _pageSize,
        );

    state = result.fold(
      (f) => state.copyWith(isLoading: false, errorMessage: f.message),
      (page) => state.copyWith(
        items: [...state.items, ...page.items],
        isLoading: false,
        hasReachedEnd: page.hasReachedEnd,
      ),
    );
  }

  Future<void> refresh() => loadFirstPage();
}

// ── Detail Provider ───────────────────────────────────────────────────────────

/// Real-time stream for a single Cash Advance document.
@riverpod
Stream<CashAdvanceEntity?> cashAdvanceDetailStream(
  CashAdvanceDetailStreamRef ref,
  String id,
) {
  return ref
      .watch(cashAdvanceRepositoryProvider)
      .watchById(id)
      .map((either) => either.getOrElse(() => throw either.fold((f) => f, (e) => e)));
}

// ── Pending Approvals (PIC / Finance) ────────────────────────────────────────

class PendingApprovalState {
  final List<CashAdvanceEntity> items;
  final bool isLoading;
  final bool hasReachedEnd;
  final String? errorMessage;

  const PendingApprovalState({
    this.items = const [],
    this.isLoading = true,
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  PendingApprovalState copyWith({
    List<CashAdvanceEntity>? items,
    bool? isLoading,
    bool? hasReachedEnd,
    String? errorMessage,
  }) {
    return PendingApprovalState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class CashAdvancePendingController extends _$CashAdvancePendingController {
  @override
  PendingApprovalState build() {
    Future.microtask(loadFirstPage);
    return const PendingApprovalState();
  }

  Future<void> loadFirstPage() async {
    final authAsync = ref.read(authStateStreamProvider);
    final user = authAsync.valueOrNull;
    if (user == null) return;

    state = state.copyWith(isLoading: true);

    final result = await ref
        .read(cashAdvanceRepositoryProvider)
        .getPendingApprovals(approverRole: user.role);

    state = result.fold(
      (f) => state.copyWith(isLoading: false, errorMessage: f.message),
      (page) => PendingApprovalState(
        items: page.items,
        isLoading: false,
        hasReachedEnd: page.hasReachedEnd,
      ),
    );
  }

  Future<void> refresh() => loadFirstPage();
}
// ── Use Case Providers ────────────────────────────────────────────────────────

@riverpod
CreateCashAdvanceUseCase createCashAdvanceUseCase(
  CreateCashAdvanceUseCaseRef ref,
) =>
    CreateCashAdvanceUseCase(ref.watch(cashAdvanceRepositoryProvider));

@riverpod
SubmitCashAdvanceUseCase submitCashAdvanceUseCase(
  SubmitCashAdvanceUseCaseRef ref,
) =>
    SubmitCashAdvanceUseCase(ref.watch(cashAdvanceRepositoryProvider));

@riverpod
GetCashAdvanceUseCase getCashAdvanceUseCase(
  GetCashAdvanceUseCaseRef ref,
) =>
    GetCashAdvanceUseCase(ref.watch(cashAdvanceRepositoryProvider));

// ── Form State + Controller ───────────────────────────────────────────────────

/// Immutable state for the Cash Advance create/edit form.
class CashAdvanceFormState {
  const CashAdvanceFormState({
    this.isSaving = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.savedEntity,
    this.isDone = false,
  });

  final bool isSaving;
  final bool isSubmitting;
  final String? errorMessage;

  /// Set after a successful draft save or submission.
  final CashAdvanceEntity? savedEntity;

  /// True after a successful submission — triggers navigation upstream.
  final bool isDone;

  bool get isLoading => isSaving || isSubmitting;

  CashAdvanceFormState copyWith({
    bool? isSaving,
    bool? isSubmitting,
    String? errorMessage,
    CashAdvanceEntity? savedEntity,
    bool? isDone,
    bool clearError = false,
  }) =>
      CashAdvanceFormState(
        isSaving: isSaving ?? this.isSaving,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        savedEntity: savedEntity ?? this.savedEntity,
        isDone: isDone ?? this.isDone,
      );
}

/// Manages state and business actions for the Cash Advance create form.
///
/// - [saveDraft] persists as draft (creates if new; updates if previously saved).
/// - [submit] validates outstanding, then upserts with [pendingPic] status.
/// - [reset] clears state (call on page dispose or post-navigation).
@riverpod
class CashAdvanceFormController extends _$CashAdvanceFormController {
  @override
  CashAdvanceFormState build() => const CashAdvanceFormState();

  Future<void> saveDraft({
    required String projectName,
    required String projectId,
    required String purpose,
    required String description,
    required double amount,
    required String currency,
    required String userUid,
    required String userName,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final FutureEither<CashAdvanceEntity> action;
    final existing = state.savedEntity;

    if (existing != null) {
      // Update the already-persisted draft with the latest field values.
      action = ref.read(cashAdvanceRepositoryProvider).update(
            existing.copyWith(
              projectId: projectId,
              projectName: projectName,
              purpose: purpose,
              description: description,
              requestedAmount: amount,
              currency: currency,
              updatedAt: DateTime.now(),
            ),
          );
    } else {
      action = ref.read(createCashAdvanceUseCaseProvider).call(
            CreateCashAdvanceParams(
              submittedByUid: userUid,
              submittedByName: userName,
              projectId: projectId,
              projectName: projectName,
              requestedAmount: amount,
              currency: currency,
              purpose: purpose,
              description: description,
            ),
          );
    }

    final result = await action;
    state = result.fold(
      (f) => state.copyWith(isSaving: false, errorMessage: f.message),
      (entity) => state.copyWith(isSaving: false, savedEntity: entity),
    );
  }

  Future<void> submit({
    required String projectName,
    required String projectId,
    required String purpose,
    required String description,
    required double amount,
    required String currency,
    required String userUid,
    required String userName,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    final existing = state.savedEntity;
    final CashAdvanceEntity entityToSubmit;

    if (existing != null) {
      entityToSubmit = existing.copyWith(
        projectId: projectId,
        projectName: projectName,
        purpose: purpose,
        description: description,
        requestedAmount: amount,
        currency: currency,
        updatedAt: DateTime.now(),
      );
    } else {
      entityToSubmit = CashAdvanceEntity(
        id: '',
        submittedByUid: userUid,
        submittedByName: userName,
        projectId: projectId,
        projectName: projectName,
        requestedAmount: amount,
        currency: currency,
        purpose: purpose,
        description: description,
        status: SubmissionStatus.draft,
        createdAt: DateTime.now(),
      );
    }

    final result = await ref.read(submitCashAdvanceUseCaseProvider).call(
          SubmitCashAdvanceParams(
            entity: entityToSubmit,
            submitterUid: userUid,
          ),
        );

    state = result.fold(
      (f) => state.copyWith(isSubmitting: false, errorMessage: f.message),
      (entity) =>
          state.copyWith(isSubmitting: false, savedEntity: entity, isDone: true),
    );
  }

  void reset() => state = const CashAdvanceFormState();
}