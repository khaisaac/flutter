/// Shared enums used across all financial modules.
/// Kept in core so both domain and data layers can reference them
/// without creating circular imports.
library;

/// Lifecycle status for all submission types
/// (Cash Advance, Allowance, Reimbursement).
enum SubmissionStatus {
  draft('draft', 'Draft'),
  pendingPic('pending_pic', 'Pending PIC'),
  pendingFinance('pending_finance', 'Pending Finance'),
  approved('approved', 'Approved'),
  rejected('rejected', 'Rejected'),
  revision('revision', 'Needs Revision'),
  paid('paid', 'Paid');

  const SubmissionStatus(this.value, this.label);

  /// Firestore-stored string value.
  final String value;

  /// Human-readable display label.
  final String label;

  /// Parses a raw Firestore string into a [SubmissionStatus].
  /// Falls back to [SubmissionStatus.draft] on unknown values.
  static SubmissionStatus fromValue(String? value) {
    return SubmissionStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => SubmissionStatus.draft,
    );
  }

  /// True when the submission is in a terminal state (no further transitions).
  bool get isTerminal =>
      this == approved || this == rejected || this == paid;

  /// True when the submission is awaiting any approval action.
  bool get isPending =>
      this == pendingPic || this == pendingFinance;
}

/// Allowance type categories.
enum AllowanceType {
  transport('transport', 'Transport'),
  meal('meal', 'Meal'),
  accommodation('accommodation', 'Accommodation'),
  communication('communication', 'Communication'),
  other('other', 'Other');

  const AllowanceType(this.value, this.label);
  final String value;
  final String label;

  static AllowanceType fromValue(String? value) {
    return AllowanceType.values.firstWhere(
      (t) => t.value == value,
      orElse: () => AllowanceType.other,
    );
  }
}

/// Reimbursement expense categories.
enum ExpenseCategory {
  transport('transport', 'Transport'),
  accommodation('accommodation', 'Accommodation'),
  meal('meal', 'Meal & Entertainment'),
  medical('medical', 'Medical'),
  officeSuppply('office_supply', 'Office Supply'),
  communication('communication', 'Communication'),
  other('other', 'Other');

  const ExpenseCategory(this.value, this.label);
  final String value;
  final String label;

  static ExpenseCategory fromValue(String? value) {
    return ExpenseCategory.values.firstWhere(
      (c) => c.value == value,
      orElse: () => ExpenseCategory.other,
    );
  }
}
