import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/di/app_providers.dart';
import '../../../../shared/models/attachment_model.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/reimbursement_remote_data_source.dart';
import '../../data/repositories/reimbursement_repository_impl.dart';
import '../../domain/entities/reimbursement_entity.dart';
import '../../domain/repositories/reimbursement_repository.dart';
import '../../domain/usecases/create_reimbursement_usecase.dart';
import '../../domain/usecases/get_reimbursement_usecase.dart';
import '../../domain/usecases/submit_reimbursement_usecase.dart';

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

// ── Use-Case Providers ────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
CreateReimbursementUseCase createReimbursementUseCase(
    CreateReimbursementUseCaseRef ref) {
  return CreateReimbursementUseCase(ref.watch(reimbursementRepositoryProvider));
}

@Riverpod(keepAlive: true)
SubmitReimbursementUseCase submitReimbursementUseCase(
    SubmitReimbursementUseCaseRef ref) {
  return SubmitReimbursementUseCase(ref.watch(reimbursementRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetReimbursementUseCase getReimbursementUseCase(
    GetReimbursementUseCaseRef ref) {
  return GetReimbursementUseCase(ref.watch(reimbursementRepositoryProvider));
}

// ── Draft Item ────────────────────────────────────────────────────────────────

/// Mutable draft representation of a single expense line item.
/// Holds the raw [amountText] (not yet parsed) and the picked [receiptFile]
/// so the UI can display previews before the user saves.
class ReimbursementItemDraft {
  ReimbursementItemDraft({
    required this.id,
    this.category = ExpenseCategory.other,
    this.description = '',
    this.amountText = '',
    DateTime? receiptDate,
    this.receiptFile,
    this.uploadedAttachment,
  }) : receiptDate = receiptDate ?? DateTime.now();

  final String id;
  final ExpenseCategory category;
  final String description;
  final String amountText;
  final DateTime receiptDate;

  /// The locally-picked file (not yet uploaded).
  final XFile? receiptFile;

  /// Set after the file has been uploaded to Storage.
  final AttachmentEntity? uploadedAttachment;

  double get parsedAmount {
    final clean = amountText.replaceAll(',', '').replaceAll(' ', '');
    return double.tryParse(clean) ?? 0.0;
  }

  bool get hasReceipt => receiptFile != null || uploadedAttachment != null;

  ReimbursementItemDraft copyWith({
    ExpenseCategory? category,
    String? description,
    String? amountText,
    DateTime? receiptDate,
    Object? receiptFile = _sentinel,
    Object? uploadedAttachment = _sentinel,
  }) {
    return ReimbursementItemDraft(
      id: id,
      category: category ?? this.category,
      description: description ?? this.description,
      amountText: amountText ?? this.amountText,
      receiptDate: receiptDate ?? this.receiptDate,
      receiptFile:
          receiptFile == _sentinel ? this.receiptFile : receiptFile as XFile?,
      uploadedAttachment: uploadedAttachment == _sentinel
          ? this.uploadedAttachment
          : uploadedAttachment as AttachmentEntity?,
    );
  }

  static const Object _sentinel = Object();
}

// ── Form State ────────────────────────────────────────────────────────────────

class ReimbursementFormState {
  const ReimbursementFormState({
    this.items = const [],
    this.description = '',
    this.linkedCaId,
    this.linkedCaPurpose,
    this.savedEntity,
    this.isSaving = false,
    this.isSubmitting = false,
    this.error,
    this.isDone = false,
  });

  final List<ReimbursementItemDraft> items;
  final String description;
  final String? linkedCaId;
  final String? linkedCaPurpose;
  final ReimbursementEntity? savedEntity;
  final bool isSaving;
  final bool isSubmitting;
  final String? error;
  final bool isDone;

  double get total => items.fold(0.0, (s, i) => s + i.parsedAmount);
  bool get isIdle => !isSaving && !isSubmitting;

  ReimbursementFormState copyWith({
    List<ReimbursementItemDraft>? items,
    String? description,
    Object? linkedCaId = _sentinel,
    Object? linkedCaPurpose = _sentinel,
    Object? savedEntity = _sentinel,
    bool? isSaving,
    bool? isSubmitting,
    Object? error = _sentinel,
    bool? isDone,
  }) {
    return ReimbursementFormState(
      items: items ?? this.items,
      description: description ?? this.description,
      linkedCaId:
          linkedCaId == _sentinel ? this.linkedCaId : linkedCaId as String?,
      linkedCaPurpose: linkedCaPurpose == _sentinel
          ? this.linkedCaPurpose
          : linkedCaPurpose as String?,
      savedEntity: savedEntity == _sentinel
          ? this.savedEntity
          : savedEntity as ReimbursementEntity?,
      isSaving: isSaving ?? this.isSaving,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error == _sentinel ? this.error : error as String?,
      isDone: isDone ?? this.isDone,
    );
  }

  static const Object _sentinel = Object();
}

// ── Form Controller ───────────────────────────────────────────────────────────

@riverpod
class ReimbursementFormController extends _$ReimbursementFormController {
  static const _uuid = Uuid();

  @override
  ReimbursementFormState build() =>
      ReimbursementFormState(items: [_blankItem()]);

  ReimbursementItemDraft _blankItem() =>
      ReimbursementItemDraft(id: _uuid.v4());

  // ── Item mutations ──────────────────────────────────────────────────────────

  void addItem() =>
      state = state.copyWith(items: [...state.items, _blankItem()]);

  void removeItem(String id) {
    if (state.items.length <= 1) return;
    state =
        state.copyWith(items: state.items.where((i) => i.id != id).toList());
  }

  void updateItem(String id, ReimbursementItemDraft updated) {
    state = state.copyWith(
      items: [for (final i in state.items) i.id == id ? updated : i],
    );
  }

  void setDescription(String value) =>
      state = state.copyWith(description: value);

  void setLinkedCA(String? caId, String? caPurpose) =>
      state = state.copyWith(linkedCaId: caId, linkedCaPurpose: caPurpose);

  /// Opens the image gallery and attaches the chosen image to the item.
  Future<void> pickReceipt(String itemId) async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (xFile == null) return;
    final idx = state.items.indexWhere((i) => i.id == itemId);
    if (idx == -1) return;
    updateItem(itemId, state.items[idx].copyWith(receiptFile: xFile));
  }

  // ── Persistence ─────────────────────────────────────────────────────────────

  /// Uploads receipt files and persists a **draft** entity.
  Future<void> saveDraft({
    required String uid,
    required String name,
    required String projectId,
    required String projectName,
  }) async {
    if (!state.isIdle) return;
    state = state.copyWith(isSaving: true, error: null);

    final items = await _buildItems(uid: uid);

    final result = await ref
        .read(createReimbursementUseCaseProvider)
        .call(CreateReimbursementParams(
          submittedByUid: uid,
          submittedByName: name,
          projectId: projectId,
          projectName: projectName,
          items: items,
          description: state.description,
          linkedCashAdvanceId: state.linkedCaId,
          linkedCashAdvancePurpose: state.linkedCaPurpose,
        ));

    state = result.fold(
      (f) => state.copyWith(isSaving: false, error: f.message),
      (entity) =>
          state.copyWith(isSaving: false, savedEntity: entity, error: null),
    );
  }

  /// Ensures a draft exists, then submits it (triggers CA settlement tx).
  Future<void> submit({
    required String uid,
    required String name,
    required String projectId,
    required String projectName,
  }) async {
    if (!state.isIdle) return;

    if (state.savedEntity == null) {
      await saveDraft(
          uid: uid, name: name, projectId: projectId, projectName: projectName);
      if (state.error != null) return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    final result = await ref
        .read(submitReimbursementUseCaseProvider)
        .call(SubmitReimbursementParams(
          entity: state.savedEntity!,
          submitterUid: uid,
        ));

    state = result.fold(
      (f) => state.copyWith(isSubmitting: false, error: f.message),
      (_) => state.copyWith(isSubmitting: false, isDone: true, error: null),
    );
  }

  void reset() => state = ReimbursementFormState(items: [_blankItem()]);

  // ── Private ─────────────────────────────────────────────────────────────────

  /// Uploads pending receipt files and returns finalized [ReimbursementItem]s.
  Future<List<ReimbursementItem>> _buildItems({required String uid}) async {
    final storage = ref.read(storageServiceProvider);
    final submissionId = state.savedEntity?.id ?? _uuid.v4();
    final List<ReimbursementItem> result = [];

    for (final draft in state.items) {
      List<AttachmentEntity> receipts = [];

      if (draft.uploadedAttachment != null) {
        receipts = [draft.uploadedAttachment!];
      } else if (draft.receiptFile != null) {
        final attachment = await storage.uploadFile(
          file: File(draft.receiptFile!.path),
          module: 'reimbursement',
          userId: uid,
          submissionId: submissionId,
          itemId: draft.id,
        );
        receipts = [attachment];
        updateItem(
          draft.id,
          draft.copyWith(receiptFile: null, uploadedAttachment: attachment),
        );
      }

      result.add(ReimbursementItem(
        id: draft.id,
        category: draft.category,
        description: draft.description,
        amount: draft.parsedAmount,
        receiptDate: draft.receiptDate,
        receipts: receipts,
      ));
    }

    return result;
  }
}
