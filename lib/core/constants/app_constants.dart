/// Application-wide non-Firebase constants.
class AppConstants {
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────────────────────
  static const String appName = 'Reimbursement Hexa';
  static const String appVersion = '1.0.0';

  // ── User Roles ─────────────────────────────────────────────────────────────
  static const String roleEmployee = 'employee';
  static const String roleAdmin = 'admin';
  static const String rolePicProject = 'pic_project';
  static const String roleFinance = 'finance';

  static const List<String> allRoles = [
    roleEmployee,
    roleAdmin,
    rolePicProject,
    roleFinance,
  ];

  // ── Submission Status ─────────────────────────────────────────────────────
  static const String statusDraft = 'draft';
  static const String statusPendingPic = 'pending_pic';
  static const String statusPendingFinance = 'pending_finance';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';
  static const String statusRevision = 'revision';
  static const String statusPaid = 'paid';

  // ── Module Types ──────────────────────────────────────────────────────────
  static const String moduleCashAdvance = 'cash_advance';
  static const String moduleAllowance = 'allowance';
  static const String moduleReimbursement = 'reimbursement';

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int pageSize = 20;

  // ── File Upload ───────────────────────────────────────────────────────────
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedFileExtensions = ['jpg', 'jpeg', 'png', 'pdf'];

  // ── Timeouts ──────────────────────────────────────────────────────────────
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheExpiry = Duration(hours: 1);

  // ── Secure Storage Keys ───────────────────────────────────────────────────
  static const String keyUserRole = 'user_role';
  static const String keyFcmToken = 'fcm_token';
}
