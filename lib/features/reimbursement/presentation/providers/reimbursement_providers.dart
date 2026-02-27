import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/app_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/reimbursement_remote_data_source.dart';
import '../../data/repositories/reimbursement_repository_impl.dart';
import '../../domain/entities/reimbursement_entity.dart';
import '../../domain/repositories/reimbursement_repository.dart';

part 'reimbursement_providers.g.dart';

// ── DI Wiring ─────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
ReimbursementRemoteDataSource reimbursementRemoteDataSource(
    ReimbursementRemoteDataSourceRef ref) {
  return ReimbursementRemoteDataSourceImpl(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
ReimbursementRepository reimbursementRepository(
    ReimbursementRepositoryRef ref) {
  return ReimbursementRepositoryImpl(
      ref.watch(reimbursementRemoteDataSourceProvider));
}

// ── User's Submission Stream ──────────────────────────────────────────────────

/// Real-time list of the current user's Reimbursement submissions.
@riverpod
Stream<List<ReimbursementEntity>> userReimbursementStream(
    UserReimbursementStreamRef ref) {
  final user = ref.watch(authStateStreamProvider).valueOrNull;
  if (user == null) return const Stream.empty();

  return ref
      .watch(reimbursementRepositoryProvider)
      .watchUserSubmissions(user.uid)
      .map((either) => either.getOrElse(() => []));
}

// ── Paginated List State ──────────────────────────────────────────────────────

class ReimbursementListState {
  final List<ReimbursementEntity> items;
  final bool isLoading;
  final bool hasReachedEnd;
  final String? errorMessage;

  const ReimbursementListState({
    this.items = const [],
    this.isLoading = false,
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  ReimbursementListState copyWith({
    List<ReimbursementEntity>? items,
    bool? isLoading,
    bool? hasReachedEnd,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReimbursementListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class ReimbursementListController extends _$ReimbursementListController {
  static const int _pageSize = 20;

  @override
  ReimbursementListState build() {
    Future.microtask(loadFirstPage);
    return const ReimbursementListState(isLoading: true);
  }

  Future<void> loadFirstPage() async {
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref
        .read(reimbursementRepositoryProvider)
        .getUserSubmissions(userId: user.uid, pageSize: _pageSize);

    state = result.fold(
      (f) => state.copyWith(isLoading: false, errorMessage: f.message),
      (page) => ReimbursementListState(
        items: page.items,
        isLoading: false,
        hasReachedEnd: page.hasReachedEnd,
      ),
    );
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.hasReachedEnd) return;

    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    state = state.copyWith(isLoading: true);

    final result = await ref
        .read(reimbursementRepositoryProvider)
        .getUserSubmissions(userId: user.uid, pageSize: _pageSize);

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

@riverpod
Stream<ReimbursementEntity?> reimbursementDetailStream(
  ReimbursementDetailStreamRef ref,
  String id,
) {
  return ref
      .watch(reimbursementRepositoryProvider)
      .watchById(id)
      .map((either) => either.fold((f) => null, (e) => e));
}

// ── Pending Approvals (PIC / Finance) ─────────────────────────────────────────

class ReimbursementPendingState {
  final List<ReimbursementEntity> items;
  final bool isLoading;
  final bool hasReachedEnd;
  final String? errorMessage;

  const ReimbursementPendingState({
    this.items = const [],
    this.isLoading = true,
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  ReimbursementPendingState copyWith({
    List<ReimbursementEntity>? items,
    bool? isLoading,
    bool? hasReachedEnd,
    String? errorMessage,
  }) {
    return ReimbursementPendingState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class ReimbursementPendingController extends _$ReimbursementPendingController {
  @override
  ReimbursementPendingState build() {
    Future.microtask(loadFirstPage);
    return const ReimbursementPendingState();
  }

  Future<void> loadFirstPage() async {
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    state = state.copyWith(isLoading: true);

    final result = await ref
        .read(reimbursementRepositoryProvider)
        .getPendingApprovals(approverRole: user.role);

    state = result.fold(
      (f) => state.copyWith(isLoading: false, errorMessage: f.message),
      (page) => ReimbursementPendingState(
        items: page.items,
        isLoading: false,
        hasReachedEnd: page.hasReachedEnd,
      ),
    );
  }

  Future<void> refresh() => loadFirstPage();
}
