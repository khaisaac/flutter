/// All Firestore collection / document path constants.
/// Centralised here to prevent typo-driven bugs across the codebase.
class FirebaseConstants {
  FirebaseConstants._();

  // ── Collections ───────────────────────────────────────────────────────────
  static const String usersCollection = 'users';
  static const String cashAdvancesCollection = 'cash_advances';
  static const String allowancesCollection = 'allowances';
  static const String reimbursementsCollection = 'reimbursements';
  static const String approvalsCollection = 'approvals';
  static const String notificationsCollection = 'notifications';
  static const String projectsCollection = 'projects';
  static const String settingsCollection = 'settings';

  // ── Sub-collection names ──────────────────────────────────────────────────
  static const String attachmentsSubCollection = 'attachments';
  static const String historySubCollection = 'history';

  // ── Storage Paths ─────────────────────────────────────────────────────────
  static const String storageCashAdvance = 'cash_advance';
  static const String storageAllowance = 'allowance';
  static const String storageReimbursement = 'reimbursement';
  static const String storageProfilePictures = 'profile_pictures';

  // ── Cloud Function Names ──────────────────────────────────────────────────
  static const String fnSubmitCashAdvance = 'submitCashAdvance';
  static const String fnApproveCashAdvance = 'approveCashAdvance';
  static const String fnRejectCashAdvance = 'rejectCashAdvance';

  static const String fnSubmitAllowance = 'submitAllowance';
  static const String fnApproveAllowance = 'approveAllowance';
  static const String fnRejectAllowance = 'rejectAllowance';

  static const String fnSubmitReimbursement = 'submitReimbursement';
  static const String fnApproveReimbursement = 'approveReimbursement';
  static const String fnRejectReimbursement = 'rejectReimbursement';

  // ── FCM Topics ─────────────────────────────────────────────────────────────
  static const String topicFinance = 'finance';
  static const String topicPicProject = 'pic_project';
  static const String topicAdmin = 'admin';
}
