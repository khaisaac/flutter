import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/approval/approval_enums.dart';
import '../../../../core/approval/domain/usecases/approve_submission_usecase.dart';
import '../../../../core/approval/domain/usecases/mark_paid_usecase.dart';
import '../../../../core/approval/domain/usecases/reject_submission_usecase.dart';
import '../../../../core/approval/domain/usecases/request_revision_usecase.dart';
import '../../../../core/approval/presentation/approval_providers.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/allowance_entity.dart';
import '../../domain/usecases/submit_allowance_usecase.dart';
import '../providers/allowance_providers.dart';

/// Full detail view for a single Allowance submission.
///
/// - Real-time stream via [allowanceDetailStreamProvider].
/// - Shows type, amount, date, attachments, approval history.
/// - Submit button for submitter in draft/revision state.
/// - Approval action panel for PIC (pending_pic) and Finance (pending_finance / approved).
class AllowanceDetailPage extends ConsumerStatefulWidget {
  const AllowanceDetailPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<AllowanceDetailPage> createState() =>
      _AllowanceDetailPageState();
}

class _AllowanceDetailPageState extends ConsumerState<AllowanceDetailPage> {
  bool _isSubmitting = false;
  String? _submitError;

  final _noteCtrl = TextEditingController();

  static final _currFmt =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  static final _dateFmt = DateFormat('dd MMM yyyy, HH:mm');
  static final _shortDateFmt = DateFormat('dd MMM yyyy');

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _submitForApproval(AllowanceEntity entity) async {
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final result = await ref.read(submitAllowanceUseCaseProvider).call(
          SubmitAllowanceParams(
            entity: entity,
            submitterUid: user.uid,
          ),
        );

    if (!mounted) return;

    result.fold(
      (f) => setState(() {
        _isSubmitting = false;
        _submitError = f.message;
      }),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Allowance submitted for approval.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.allowanceList);
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final stream = ref.watch(allowanceDetailStreamProvider(widget.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Allowance Detail')),
      body: stream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(message: e.toString()),
        data: (entity) => entity == null
            ? const _ErrorBody(message: 'Submission not found.')
            : _buildBody(context, entity),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AllowanceEntity entity) {
    final user = ref.watch(authStateStreamProvider).valueOrNull;
    final isSubmitter = user?.uid == entity.submittedByUid;
    final isPic = user?.role == 'pic_project';
    final isFinance = user?.role == 'finance';
    final approvalKey = '${widget.id}_allowance';
    final approvalCtrl = ref.watch(approvalActionControllerProvider(approvalKey));

    final showPicPanel = isPic && entity.status == SubmissionStatus.pendingPic;
    final showFinancePanel =
        isFinance && entity.status == SubmissionStatus.pendingFinance;
    final showMarkPaid =
        isFinance && entity.status == SubmissionStatus.approved;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // ── Status Card ──────────────────────────────────────────────────
        _StatusCard(entity: entity, currFmt: _currFmt, dateFmt: _shortDateFmt),
        const SizedBox(height: 16),

        // ── Rejection Banner ─────────────────────────────────────────────
        if (entity.rejectionReason != null) ...[
          _InfoBanner(
            label: 'Rejection Reason',
            text: entity.rejectionReason!,
            isError: true,
          ),
          const SizedBox(height: 12),
        ],

        // ── Notes (PIC / Finance) ────────────────────────────────────────
        if (entity.picNote != null || entity.financeNote != null) ...[
          _NotesCard(entity: entity),
          const SizedBox(height: 16),
        ],

        // ── Attachments ──────────────────────────────────────────────────
        if (entity.attachments.isNotEmpty) ...[
          Text('Attendance Proof',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...entity.attachments.map(
            (a) => _AttachmentTile(
              name: a.fileName,
              url: a.fileUrl,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── Submit Error ─────────────────────────────────────────────────
        if (_submitError != null) ...[
          _InfoBanner(label: 'Error', text: _submitError!, isError: true),
          const SizedBox(height: 8),
        ],

        // ── Submit Button (submitter in draft/revision) ──────────────────
        if (isSubmitter && entity.isEditable) ...[
          _SubmitButton(
            isSubmitting: _isSubmitting,
            onPressed: () => _submitForApproval(entity),
          ),
          const SizedBox(height: 20),
        ],

        // ── Approval Panel ───────────────────────────────────────────────
        if (showPicPanel || showFinancePanel || showMarkPaid) ...[
          _ApprovalPanel(
            entity: entity,
            noteCtrl: _noteCtrl,
            approvalKey: approvalKey,
            approvalState: approvalCtrl,
            showMarkPaid: showMarkPaid,
            actorRole: isPic ? 'pic_project' : 'finance',
            onActionDone: () => context.go(AppRoutes.allowanceList),
          ),
          const SizedBox(height: 20),
        ],

        // ── Approval History ─────────────────────────────────────────────
        if (entity.history.isNotEmpty) ...[
          Text('Approval History',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...entity.history.map(
            (h) => _HistoryTile(
              actorName: h.actorName,
              action: ApprovalAction.fromValue(h.action),
              timestamp: h.timestamp,
              note: h.note,
              dateFmt: _dateFmt,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Status Card ───────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.entity,
    required this.currFmt,
    required this.dateFmt,
  });

  final AllowanceEntity entity;
  final NumberFormat currFmt;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(entity.type.label,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSecondaryContainer)),
                  backgroundColor: cs.secondaryContainer,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                StatusChip(status: entity.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              currFmt.format(entity.requestedAmount),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (entity.approvedAmount != null) ...[
              const SizedBox(height: 4),
              Text(
                'Approved: ${currFmt.format(entity.approvedAmount!)}',
                style: TextStyle(color: cs.primary),
              ),
            ],
            const Divider(height: 20),
            _Row(
              icon: Icons.calendar_today_outlined,
              label: 'Allowance Date',
              value: dateFmt.format(entity.allowanceDate),
            ),
            const SizedBox(height: 6),
            _Row(
              icon: Icons.person_outline,
              label: 'Submitted by',
              value: entity.submittedByName,
            ),
            if (entity.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              _Row(
                icon: Icons.notes_outlined,
                label: 'Description',
                value: entity.description,
              ),
            ],
            if (entity.projectName != null) ...[
              const SizedBox(height: 6),
              _Row(
                icon: Icons.folder_outlined,
                label: 'Project',
                value: entity.projectName!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: cs.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                    text: '$label: ',
                    style: TextStyle(color: cs.onSurfaceVariant)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Notes Card ────────────────────────────────────────────────────────────────

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.entity});

  final AllowanceEntity entity;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      color: cs.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reviewer Notes',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            if (entity.picNote != null)
              _NoteRow(label: 'PIC', note: entity.picNote!),
            if (entity.financeNote != null)
              _NoteRow(label: 'Finance', note: entity.financeNote!),
          ],
        ),
      ),
    );
  }
}

class _NoteRow extends StatelessWidget {
  const _NoteRow({required this.label, required this.note});

  final String label;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: note),
        ]),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

// ── Info Banner ───────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  const _InfoBanner(
      {required this.label, required this.text, this.isError = false});

  final String label;
  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? cs.errorContainer : cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isError ? Icons.error_outline : Icons.info_outline,
              size: 18,
              color:
                  isError ? cs.onErrorContainer : cs.onTertiaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isError
                          ? cs.onErrorContainer
                          : cs.onTertiaryContainer),
                ),
                TextSpan(text: text),
              ]),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isError
                        ? cs.onErrorContainer
                        : cs.onTertiaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Attachment Tile ───────────────────────────────────────────────────────────

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({required this.name, required this.url});

  final String name;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.image_outlined),
        title: Text(name,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 18),
          tooltip: 'Copy URL',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: url));
          },
        ),
      ),
    );
  }
}

// ── Submit Button ─────────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  const _SubmitButton(
      {required this.isSubmitting, required this.onPressed});

  final bool isSubmitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isSubmitting ? null : onPressed,
        icon: isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.send_outlined),
        label: const Text('Submit for Approval'),
      ),
    );
  }
}

// ── Approval Panel ────────────────────────────────────────────────────────────

class _ApprovalPanel extends ConsumerWidget {
  const _ApprovalPanel({
    required this.entity,
    required this.noteCtrl,
    required this.approvalKey,
    required this.approvalState,
    required this.showMarkPaid,
    required this.actorRole,
    required this.onActionDone,
  });

  final AllowanceEntity entity;
  final TextEditingController noteCtrl;
  final String approvalKey;
  final ApprovalActionState approvalState;
  final bool showMarkPaid;
  final String actorRole;
  final VoidCallback onActionDone;

  void _handleDone(WidgetRef ref, BuildContext context) {
    if (!approvalState.isDone) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Action "${approvalState.completedAction?.label ?? 'done'}" completed.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    ref
        .read(approvalActionControllerProvider(approvalKey).notifier)
        .reset();
    onActionDone();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // React when action completes
    ref.listen(approvalActionControllerProvider(approvalKey), (_, next) {
      if (next.isDone) _handleDone(ref, context);
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Unknown error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final isLoading = approvalState.isLoading;
    final cs = Theme.of(context).colorScheme;
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return const SizedBox.shrink();

    return Card(
      color: cs.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Approval Action',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            // Note field (used for approval note / revision instructions)
            TextFormField(
              controller: noteCtrl,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'Add a comment or revision instruction',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            // Mark Paid (Finance, status == approved)
            if (showMarkPaid) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => ref
                              .read(approvalActionControllerProvider(approvalKey)
                                  .notifier)
                              .markPaid(
                                MarkPaidParams(
                                  documentId: entity.id,
                                  module: SubmissionModule.allowance,
                                  actorUid: user.uid,
                                  actorName: user.displayName,
                                  note: noteCtrl.text.trim().isEmpty
                                      ? null
                                      : noteCtrl.text.trim(),
                                ),
                              ),
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.payments_outlined),
                  label: const Text('Mark as Paid'),
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700),
                ),
              ),
            ],

            // Approve / Reject / Revision (PIC or Finance)
            if (!showMarkPaid) ...[
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: isLoading
                          ? null
                          : () => ref
                                  .read(approvalActionControllerProvider(
                                          approvalKey)
                                      .notifier)
                                  .approve(
                                    ApproveSubmissionParams(
                                      documentId: entity.id,
                                      module: SubmissionModule.allowance,
                                      currentStatus: entity.status,
                                      actorUid: user.uid,
                                      actorName: user.displayName,
                                      actorRole: actorRole,
                                      note: noteCtrl.text.trim().isEmpty
                                          ? null
                                          : noteCtrl.text.trim(),
                                    ),
                                  ),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Approve'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () => ref
                                .read(approvalActionControllerProvider(
                                        approvalKey)
                                    .notifier)
                                .requestRevision(
                                  RequestRevisionParams(
                                    documentId: entity.id,
                                    module: SubmissionModule.allowance,
                                    currentStatus: entity.status,
                                    actorUid: user.uid,
                                    actorName: user.displayName,
                                    actorRole: actorRole,
                                    note: noteCtrl.text.trim().isEmpty
                                        ? null
                                        : noteCtrl.text.trim(),
                                  ),
                                ),
                    child: const Text('Revise'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () => ref
                              .read(approvalActionControllerProvider(
                                      approvalKey)
                                  .notifier)
                              .reject(
                                RejectSubmissionParams(
                                  documentId: entity.id,
                                  module: SubmissionModule.allowance,
                                  currentStatus: entity.status,
                                  actorUid: user.uid,
                                  actorName: user.displayName,
                                  actorRole: actorRole,
                                  note: noteCtrl.text.trim().isEmpty
                                      ? null
                                      : noteCtrl.text.trim(),
                                ),
                              ),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: cs.error,
                      side: BorderSide(color: cs.error)),
                  child: const Text('Reject'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Approval History Tile ─────────────────────────────────────────────────────

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.actorName,
    required this.action,
    required this.timestamp,
    required this.note,
    required this.dateFmt,
  });

  final String actorName;
  final ApprovalAction action;
  final DateTime timestamp;
  final String? note;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final color = switch (action) {
      ApprovalAction.approve => Colors.green,
      ApprovalAction.reject => cs.error,
      ApprovalAction.revise => Colors.orange,
      ApprovalAction.markPaid => Colors.blue,
      ApprovalAction.submit => cs.primary,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(height: 4),
            CircleAvatar(
                radius: 8, backgroundColor: color),
            Container(
                width: 2,
                height: 36,
                color: cs.outlineVariant),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${action.label} by $actorName',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(dateFmt.format(timestamp),
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            )),
                if (note != null && note!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(note!,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Error Body ────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center),
      ),
    );
  }
}
