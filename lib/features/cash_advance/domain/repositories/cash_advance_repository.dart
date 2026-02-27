import '../../../../core/data/base_firestore_repository.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/cash_advance_entity.dart';

/// Abstract contract for Cash Advance data operations.
/// Implemented by [CashAdvanceRepositoryImpl] in the data layer.
abstract class CashAdvanceRepository {
  // ── Queries ───────────────────────────────────────────────────────────────

  /// Returns a paginated list of the current user's submissions.
  FutureEither<PaginatedResult<CashAdvanceEntity>> getUserSubmissions({
    required String userId,
    int pageSize = 20,
    dynamic lastDocument,
  });

  /// Returns all submissions pending the given approver's action.
  /// [approverRole] is one of 'pic_project' or 'finance'.
  FutureEither<PaginatedResult<CashAdvanceEntity>> getPendingApprovals({
    required String approverRole,
    int pageSize = 20,
    dynamic lastDocument,
  });

  /// Fetches a single submission by ID (one-shot).
  FutureEither<CashAdvanceEntity> getById(String id);

  /// Real-time stream for a single submission document.
  StreamEither<CashAdvanceEntity> watchById(String id);

  /// Real-time stream for the current user's submission list.
  StreamEither<List<CashAdvanceEntity>> watchUserSubmissions(String userId);

  // ── Mutations ─────────────────────────────────────────────────────────────

  /// Creates a new draft submission. Returns the saved entity with server ID.
  FutureEither<CashAdvanceEntity> create(CashAdvanceEntity entity);

  /// Updates mutable fields of a draft or revision-status submission.
  FutureEither<CashAdvanceEntity> update(CashAdvanceEntity entity);

  /// Deletes a draft submission permanently.
  FutureEither<void> delete(String id);

  /// Returns [true] when the [userId] already has at least one submission
  /// in an active (in-flight) state: pending_pic, pending_finance, or
  /// approved-but-unpaid.  Used to block duplicate submissions.
  FutureEither<bool> hasOutstanding(String userId);

  /// Returns approved / paid cash advances for [userId] that have not yet
  /// been fully settled.  Used for the reimbursement linked-CA dropdown.
  FutureEither<List<CashAdvanceEntity>> getApprovedCashAdvances(String userId);
}
