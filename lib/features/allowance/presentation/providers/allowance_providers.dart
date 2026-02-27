import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/app_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/allowance_remote_data_source.dart';
import '../../data/repositories/allowance_repository_impl.dart';
import '../../domain/entities/allowance_entity.dart';
import '../../domain/repositories/allowance_repository.dart';

part 'allowance_providers.g.dart';

// ── DI Wiring ─────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
AllowanceRemoteDataSource allowanceRemoteDataSource(
    AllowanceRemoteDataSourceRef ref) {
  return AllowanceRemoteDataSourceImpl(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
AllowanceRepository allowanceRepository(AllowanceRepositoryRef ref) {
  return AllowanceRepositoryImpl(ref.watch(allowanceRemoteDataSourceProvider));
}

// ── User's Submission Stream ──────────────────────────────────────────────────

/// Real-time list of the current user's Allowance submissions.
@riverpod
Stream<List<AllowanceEntity>> userAllowanceStream(
    UserAllowanceStreamRef ref) {
  final user = ref.watch(authStateStreamProvider).valueOrNull;
  if (user == null) return const Stream.empty();

  return ref
      .watch(allowanceRepositoryProvider)
      .watchUserSubmissions(user.uid)
      .map((either) => either.getOrElse(() => []));
}

// ── Paginated List State ──────────────────────────────────────────────────────

class AllowanceListState {
  final List<AllowanceEntity> items;
  final bool isLoading;
  final bool hasReachedEnd;
  final String? errorMessage;

  const AllowanceListState({
    this.items = const [],
    this.isLoading = false,
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  AllowanceListState copyWith({
    List<AllowanceEntity>? items,
    bool? isLoading,
    bool? hasReachedEnd,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AllowanceListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class AllowanceListController extends _$AllowanceListController {
  static const int _pageSize = 20;

  @override
  AllowanceListState build() {
    Future.microtask(loadFirstPage);
    return const AllowanceListState(isLoading: true);
  }

  Future<void> loadFirstPage() async {
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref
        .read(allowanceRepositoryProvider)
        .getUserSubmissions(userId: user.uid, pageSize: _pageSize);

    state = result.fold(
      (f) => state.copyWith(isLoading: false, errorMessage: f.message),
      (page) => AllowanceListState(
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
        .read(allowanceRepositoryProvider)
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
Stream<AllowanceEntity?> allowanceDetailStream(
  AllowanceDetailStreamRef ref,
  String id,
) {
  return ref
      .watch(allowanceRepositoryProvider)
      .watchById(id)
      .map((either) => either.fold((f) => null, (e) => e));
}

// ── Pending Approvals (PIC / Finance) ─────────────────────────────────────────

class AllowancePendingState {
  final List<AllowanceEntity> items;
  final bool isLoading;
  final bool hasReachedEnd;
  final String? errorMessage;

  const AllowancePendingState({
    this.items = const [],
    this.isLoading = true,
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  AllowancePendingState copyWith({
    List<AllowanceEntity>? items,
    bool? isLoading,
    bool? hasReachedEnd,
    String? errorMessage,
  }) {
    return AllowancePendingState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class AllowancePendingController extends _$AllowancePendingController {
  @override
  AllowancePendingState build() {
    Future.microtask(loadFirstPage);
    return const AllowancePendingState();
  }

  Future<void> loadFirstPage() async {
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    state = state.copyWith(isLoading: true);

    final result = await ref
        .read(allowanceRepositoryProvider)
        .getPendingApprovals(approverRole: user.role);

    state = result.fold(
      (f) => state.copyWith(isLoading: false, errorMessage: f.message),
      (page) => AllowancePendingState(
        items: page.items,
        isLoading: false,
        hasReachedEnd: page.hasReachedEnd,
      ),
    );
  }

  Future<void> refresh() => loadFirstPage();
}
