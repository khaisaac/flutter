import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/di/app_providers.dart';
import '../../../../shared/models/attachment_model.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/allowance_remote_data_source.dart';
import '../../data/repositories/allowance_repository_impl.dart';
import '../../domain/entities/allowance_entity.dart';
import '../../domain/repositories/allowance_repository.dart';
import '../../domain/usecases/create_allowance_usecase.dart';
import '../../domain/usecases/get_allowance_usecase.dart';
import '../../domain/usecases/submit_allowance_usecase.dart';

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

// ── Use-Case Providers ────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
CreateAllowanceUseCase createAllowanceUseCase(
    CreateAllowanceUseCaseRef ref) {
  return CreateAllowanceUseCase(ref.watch(allowanceRepositoryProvider));
}

@Riverpod(keepAlive: true)
SubmitAllowanceUseCase submitAllowanceUseCase(
    SubmitAllowanceUseCaseRef ref) {
  return SubmitAllowanceUseCase(ref.watch(allowanceRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetAllowanceUseCase getAllowanceUseCase(GetAllowanceUseCaseRef ref) {
  return GetAllowanceUseCase(ref.watch(allowanceRepositoryProvider));
}

// ── Per-Diem Calculator ───────────────────────────────────────────────────────

/// Lookup table for default per-diem rates in IDR.
class AllowanceCalculator {
  AllowanceCalculator._();

  static const Map<AllowanceType, double> _rates = {
    AllowanceType.transport: 200000,
    AllowanceType.meal: 150000,
    AllowanceType.accommodation: 500000,
    AllowanceType.communication: 100000,
    AllowanceType.other: 0,
  };

  /// Returns IDR per-day/night rate for the given type.
  static double rateFor(AllowanceType type) => _rates[type] ?? 0;

  /// Computes [type] rate × [days].
  static double compute(AllowanceType type, int days) =>
      rateFor(type) * days.toDouble();

  /// Human-readable label e.g. "Rp 200,000 / day".
  static String rateLabel(AllowanceType type) {
    final rate = rateFor(type);
    if (rate <= 0) return 'Manual input';
    final unit =
        type == AllowanceType.accommodation ? 'night' : 'day';
    return 'Rp ${rate.toStringAsFixed(0)} / $unit';
  }
}

// ── Form State ────────────────────────────────────────────────────────────────

class AllowanceFormState {
  AllowanceFormState({
    this.type = AllowanceType.other,
    this.amountText = '',
    this.daysCount = 1,
    DateTime? allowanceDate,
    this.description = '',
    this.projectId,
    this.projectName,
    this.pendingFiles = const [],
    this.uploadedAttachments = const [],
    this.savedEntity,
    this.isSaving = false,
    this.isSubmitting = false,
    this.error,
    this.isDone = false,
  }) : allowanceDate = allowanceDate ?? DateTime.now();

  final AllowanceType type;
  final String amountText;
  final int daysCount;
  final DateTime allowanceDate;
  final String description;
  final String? projectId;
  final String? projectName;

  /// Files picked by the user but not yet uploaded.
  final List<XFile> pendingFiles;

  /// Files already uploaded to Firebase Storage.
  final List<AttachmentEntity> uploadedAttachments;

  final AllowanceEntity? savedEntity;
  final bool isSaving;
  final bool isSubmitting;
  final String? error;
  final bool isDone;

  double get parsedAmount {
    final clean = amountText.replaceAll(',', '').replaceAll(' ', '');
    return double.tryParse(clean) ?? 0.0;
  }

  double get suggestedAmount => AllowanceCalculator.compute(type, daysCount);
  bool get isIdle => !isSaving && !isSubmitting;
  bool get hasAttachments =>
      pendingFiles.isNotEmpty || uploadedAttachments.isNotEmpty;

  AllowanceFormState copyWith({
    AllowanceType? type,
    String? amountText,
    int? daysCount,
    DateTime? allowanceDate,
    String? description,
    Object? projectId = _sentinel,
    Object? projectName = _sentinel,
    List<XFile>? pendingFiles,
    List<AttachmentEntity>? uploadedAttachments,
    Object? savedEntity = _sentinel,
    bool? isSaving,
    bool? isSubmitting,
    Object? error = _sentinel,
    bool? isDone,
  }) {
    return AllowanceFormState(
      type: type ?? this.type,
      amountText: amountText ?? this.amountText,
      daysCount: daysCount ?? this.daysCount,
      allowanceDate: allowanceDate ?? this.allowanceDate,
      description: description ?? this.description,
      projectId:
          projectId == _sentinel ? this.projectId : projectId as String?,
      projectName: projectName == _sentinel
          ? this.projectName
          : projectName as String?,
      pendingFiles: pendingFiles ?? this.pendingFiles,
      uploadedAttachments: uploadedAttachments ?? this.uploadedAttachments,
      savedEntity: savedEntity == _sentinel
          ? this.savedEntity
          : savedEntity as AllowanceEntity?,
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
class AllowanceFormController extends _$AllowanceFormController {
  static const _uuid = Uuid();

  @override
  AllowanceFormState build() => AllowanceFormState(allowanceDate: DateTime.now());

  // ── Setters ────────────────────────────────────────────────────────────────

  void setType(AllowanceType type) {
    final newSuggestion = AllowanceCalculator.compute(type, state.daysCount);
    state = state.copyWith(
      type: type,
      amountText: newSuggestion > 0
          ? newSuggestion.toStringAsFixed(0)
          : state.amountText,
    );
  }

  void setAmountText(String v) => state = state.copyWith(amountText: v);

  void setDaysCount(int days) {
    if (days < 1) return;
    final suggestion = AllowanceCalculator.compute(state.type, days);
    state = state.copyWith(
      daysCount: days,
      amountText: suggestion > 0
          ? suggestion.toStringAsFixed(0)
          : state.amountText,
    );
  }

  void setAllowanceDate(DateTime date) =>
      state = state.copyWith(allowanceDate: date);

  void setDescription(String v) => state = state.copyWith(description: v);

  // ── Attachment management ──────────────────────────────────────────────────

  Future<void> pickAttendanceFile() async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (xFile == null) return;
    state = state.copyWith(pendingFiles: [...state.pendingFiles, xFile]);
  }

  void removePendingFile(int index) {
    final updated = [...state.pendingFiles];
    updated.removeAt(index);
    state = state.copyWith(pendingFiles: updated);
  }

  void removeUploadedAttachment(String id) {
    state = state.copyWith(
      uploadedAttachments:
          state.uploadedAttachments.where((a) => a.id != id).toList(),
    );
  }

  // ── Persistence ─────────────────────────────────────────────────────────────

  Future<void> saveDraft({
    required String uid,
    required String name,
  }) async {
    if (!state.isIdle) return;
    state = state.copyWith(isSaving: true, error: null);

    final attachments = await _uploadPendingFiles(uid: uid);

    final result = await ref
        .read(createAllowanceUseCaseProvider)
        .call(CreateAllowanceParams(
          submittedByUid: uid,
          submittedByName: name,
          type: state.type,
          requestedAmount: state.parsedAmount,
          allowanceDate: state.allowanceDate,
          description: state.description,
          projectId: state.projectId,
          projectName: state.projectName,
          attendanceFiles: [...state.uploadedAttachments, ...attachments],
        ));

    state = result.fold(
      (f) => state.copyWith(isSaving: false, error: f.message),
      (entity) => state.copyWith(
        isSaving: false,
        savedEntity: entity,
        uploadedAttachments: entity.attachments,
        pendingFiles: [],
        error: null,
      ),
    );
  }

  Future<void> submit({
    required String uid,
    required String name,
  }) async {
    if (!state.isIdle) return;

    if (state.savedEntity == null) {
      await saveDraft(uid: uid, name: name);
      if (state.error != null) return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    final result = await ref
        .read(submitAllowanceUseCaseProvider)
        .call(SubmitAllowanceParams(
          entity: state.savedEntity!,
          submitterUid: uid,
        ));

    state = result.fold(
      (f) => state.copyWith(isSubmitting: false, error: f.message),
      (_) => state.copyWith(isSubmitting: false, isDone: true, error: null),
    );
  }

  void reset() => state = AllowanceFormState(allowanceDate: DateTime.now());

  // ── Private ─────────────────────────────────────────────────────────────────

  Future<List<AttachmentEntity>> _uploadPendingFiles({required String uid}) async {
    if (state.pendingFiles.isEmpty) return [];
    final storage = ref.read(storageServiceProvider);
    final submissionId = state.savedEntity?.id ?? _uuid.v4();
    final List<AttachmentEntity> result = [];
    for (final xFile in state.pendingFiles) {
      final attachment = await storage.uploadFile(
        file: File(xFile.path),
        module: 'allowance',
        userId: uid,
        submissionId: submissionId,
      );
      result.add(attachment);
    }
    return result;
  }
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
