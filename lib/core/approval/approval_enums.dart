/// All possible actions an actor can take during an approval workflow.
/// Used in approval log entries and to describe what triggered a transition.
enum ApprovalAction {
  /// Submission: employee sends draft for review.
  submit('submit', 'Submitted'),

  /// Approver accepts and forwards to the next step (or completes).
  approve('approve', 'Approved'),

  /// Approver rejects; submission enters terminal [SubmissionStatus.rejected].
  reject('reject', 'Rejected'),

  /// Approver requests changes; submission returns to [SubmissionStatus.revision].
  revise('revise', 'Returned for Revision'),

  /// Finance marks payment as disbursed; terminal [SubmissionStatus.paid].
  markPaid('mark_paid', 'Marked as Paid');

  const ApprovalAction(this.value, this.label);

  final String value;
  final String label;

  static ApprovalAction fromValue(String? value) =>
      ApprovalAction.values.firstWhere(
        (a) => a.value == value,
        orElse: () => ApprovalAction.submit,
      );
}

/// Which broad category of financial module this approval belongs to.
/// Drives collection routing in Firestore and analytic grouping.
enum SubmissionModule {
  cashAdvance('cash_advance', 'Cash Advance'),
  allowance('allowance', 'Allowance'),
  reimbursement('reimbursement', 'Reimbursement');

  const SubmissionModule(this.value, this.label);

  final String value;
  final String label;

  static SubmissionModule fromValue(String? value) =>
      SubmissionModule.values.firstWhere(
        (m) => m.value == value,
        orElse: () => SubmissionModule.cashAdvance,
      );

  /// Returns the Firestore collection name for this module's submissions.
  String get collection => switch (this) {
        SubmissionModule.cashAdvance => 'cash_advances',
        SubmissionModule.allowance => 'allowances',
        SubmissionModule.reimbursement => 'reimbursements',
      };
}
