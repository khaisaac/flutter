import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/app_providers.dart';
import '../../data/datasources/cash_advance_remote_data_source.dart';
import '../../data/repositories/cash_advance_repository_impl.dart';
import '../../domain/entities/cash_advance_entity.dart';
import '../../domain/repositories/cash_advance_repository.dart';
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
