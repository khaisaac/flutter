/// All named route paths used with go_router.
/// Import this file wherever route strings are needed.
class AppRoutes {
  AppRoutes._();

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String login = '/login';

  // ── Dashboard ─────────────────────────────────────────────────────────────
  static const String dashboard = '/dashboard';

  // ── Cash Advance ──────────────────────────────────────────────────────────
  static const String cashAdvanceList = '/cash-advance';
  static const String cashAdvanceCreate = '/cash-advance/create';
  static const String cashAdvanceDetail = '/cash-advance/:id';
  static const String cashAdvanceApprove = '/cash-advance/:id/approve';

  // ── Allowance ─────────────────────────────────────────────────────────────
  static const String allowanceList = '/allowance';
  static const String allowanceCreate = '/allowance/create';
  static const String allowanceDetail = '/allowance/:id';
  static const String allowanceApprove = '/allowance/:id/approve';

  // ── Reimbursement ─────────────────────────────────────────────────────────
  static const String reimbursementList = '/reimbursement';
  static const String reimbursementCreate = '/reimbursement/create';
  static const String reimbursementDetail = '/reimbursement/:id';
  static const String reimbursementApprove = '/reimbursement/:id/approve';

  // ── Profile ───────────────────────────────────────────────────────────────
  static const String profile = '/profile';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notifications = '/notifications';

  // ── Error ─────────────────────────────────────────────────────────────────
  static const String error = '/error';
}
