import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/reimbursement_entity.dart';
import '../../domain/usecases/submit_reimbursement_usecase.dart';
import '../providers/reimbursement_providers.dart';

/// Full detail view for a single Reimbursement submission.
///
/// - Real-time stream via [reimbursementDetailStreamProvider].
/// - Shows status, items, settlement info, approval history.
/// - Provides a Submit button when the entity is in draft/revision state.
class ReimbursementDetailPage extends ConsumerStatefulWidget {
  const ReimbursementDetailPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ReimbursementDetailPage> createState() =>
      _ReimbursementDetailPageState();
}

class _ReimbursementDetailPageState
    extends ConsumerState<ReimbursementDetailPage> {
  bool _isSubmitting = false;
  String? _submitError;

  static final _currFmt = NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  static final _dateFmt = DateFormat('dd MMM yyyy, HH:mm');
  static final _shortDateFmt = DateFormat('dd MMM yyyy');

  // ── Submit action ──────────────────────────────────────────────────────────

  Future<void> _submit(ReimbursementEntity entity) async {
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final result = await ref.read(submitReimbursementUseCaseProvider).call(
          SubmitReimbursementParams(
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
            content: Text('Reimbursement submitted for approval.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.reimbursementList);
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final streamAsync =
        ref.watch(reimbursementDetailStreamProvider(widget.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Reimbursement Detail')),
      body: streamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(message: e.toString()),
        data: (entity) => entity == null
            ? const _ErrorBody(message: 'Submission not found.')
            : _Body(
                entity: entity,
                currFmt: _currFmt,
                dateFmt: _dateFmt,
                shortDateFmt: _shortDateFmt,
                isSubmitting: _isSubmitting,
                submitError: _submitError,
                onSubmit: () => _submit(entity),
              ),
      ),
    );
  }
}

// ── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({
    required this.entity,
    required this.currFmt,
    required this.dateFmt,
    required this.shortDateFmt,
    required this.isSubmitting,
    required this.submitError,
    required this.onSubmit,
  });

  final ReimbursementEntity entity;
  final NumberFormat currFmt;
  final DateFormat dateFmt;
  final DateFormat shortDateFmt;
  final bool isSubmitting;
  final String? submitError;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // ── Status Card ──────────────────────────────────────────────────
        _StatusCard(
          entity: entity,
          dateFmt: dateFmt,
        ),
        const SizedBox(height: 12),

        // ── Linked CA Card ───────────────────────────────────────────────
        if (entity.linkedCashAdvancePurpose != null)
          _LinkedCaCard(entity: entity, currFmt: currFmt),
        if (entity.linkedCashAdvancePurpose != null)
          const SizedBox(height: 12),

        // ── Items ────────────────────────────────────────────────────────
        Text('Expense Items',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...entity.items.map(
          (item) => _ItemTile(
            item: item,
            currFmt: currFmt,
            dateFmt: shortDateFmt,
          ),
        ),
        const SizedBox(height: 12),

        // ── Total ────────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: Theme.of(context).textTheme.titleMedium),
              Text(
                currFmt.format(entity.totalRequestedAmount),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimaryContainer,
                    ),
              ),
            ],
          ),
        ),

        // ── Rejection Reason ─────────────────────────────────────────────
        if (entity.rejectionReason != null) ...[
          const SizedBox(height: 12),
          Card(
            color: cs.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rejection Reason',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: cs.onErrorContainer,
                          )),
                  const SizedBox(height: 6),
                  Text(entity.rejectionReason!,
                      style: TextStyle(color: cs.onErrorContainer)),
                ],
              ),
            ),
          ),
        ],

        // ── Notes ────────────────────────────────────────────────────────
        if (entity.picNote != null || entity.financeNote != null) ...[
          const SizedBox(height: 12),
          _NotesCard(entity: entity),
        ],

        // ── Approval History ─────────────────────────────────────────────
        if (entity.history.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Approval History',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...entity.history.map(
            (h) => _ApprovalHistoryTile(
              actorName: h.actorName,
              action: h.action,
              timestamp: h.timestamp,
              note: h.note,
              dateFmt: dateFmt,
            ),
          ),
        ],

        // ── Submit button (only for draft/revision) ──────────────────────
        if (entity.isEditable) ...[
          const SizedBox(height: 24),
          if (submitError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                submitError!,
                style: TextStyle(color: cs.error),
                textAlign: TextAlign.center,
              ),
            ),
          FilledButton(
            onPressed: isSubmitting ? null : onSubmit,
            child: isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Submit for Approval'),
          ),
        ],
      ],
    );
  }
}

// ── Status Card ───────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.entity, required this.dateFmt});

  final ReimbursementEntity entity;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entity.description.isNotEmpty
                        ? entity.description
                        : entity.projectName,
                    style:
                        tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                StatusChip(status: entity.status),
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.person_outline,
              label: entity.submittedByName,
              cs: cs,
            ),
            _InfoRow(
              icon: Icons.folder_outlined,
              label: entity.projectName,
              cs: cs,
            ),
            if (entity.submittedAt != null)
              _InfoRow(
                icon: Icons.schedule_outlined,
                label: 'Submitted ${dateFmt.format(entity.submittedAt!)}',
                cs: cs,
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.label, required this.cs});

  final IconData icon;
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}

// ── Linked CA Card ────────────────────────────────────────────────────────────

class _LinkedCaCard extends StatelessWidget {
  const _LinkedCaCard({required this.entity, required this.currFmt});

  final ReimbursementEntity entity;
  final NumberFormat currFmt;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      color: cs.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.link, size: 16, color: cs.onSecondaryContainer),
                const SizedBox(width: 6),
                Text(
                  'Linked Cash Advance',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: cs.onSecondaryContainer),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              entity.linkedCashAdvancePurpose ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Settlement: ${currFmt.format(entity.totalRequestedAmount)} deducted from CA outstanding',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSecondaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Item Tile ─────────────────────────────────────────────────────────────────

class _ItemTile extends StatelessWidget {
  const _ItemTile(
      {required this.item,
      required this.currFmt,
      required this.dateFmt});

  final ReimbursementItem item;
  final NumberFormat currFmt;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category icon chip
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _categoryIcon(item.category.value),
                size: 20,
                color: cs.onTertiaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.description,
                      style: tt.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(item.category.label,
                      style: tt.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                  Text(dateFmt.format(item.receiptDate),
                      style: tt.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                  if (item.receipts.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.image_outlined,
                              size: 12, color: cs.primary),
                          const SizedBox(width: 4),
                          Text(
                            '${item.receipts.length} receipt${item.receipts.length > 1 ? 's' : ''}',
                            style: tt.bodySmall
                                ?.copyWith(color: cs.primary),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Text(
              currFmt.format(item.amount),
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _categoryIcon(String value) => switch (value) {
        'transport' => Icons.directions_car_outlined,
        'accommodation' => Icons.hotel_outlined,
        'meal' => Icons.restaurant_outlined,
        'medical' => Icons.medical_services_outlined,
        'office_supply' => Icons.inventory_2_outlined,
        'communication' => Icons.phone_outlined,
        _ => Icons.receipt_outlined,
      };
}

// ── Notes Card ────────────────────────────────────────────────────────────────

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.entity});

  final ReimbursementEntity entity;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes',
                style: Theme.of(context).textTheme.labelLarge),
            if (entity.picNote != null) ...[
              const SizedBox(height: 6),
              Text('PIC: ${entity.picNote!}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      )),
            ],
            if (entity.financeNote != null) ...[
              const SizedBox(height: 4),
              Text('Finance: ${entity.financeNote!}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      )),
            ],
          ],
        ),
      ),
    );
  }
}

// ── History Tile ──────────────────────────────────────────────────────────────

class _ApprovalHistoryTile extends StatelessWidget {
  const _ApprovalHistoryTile(
      {required this.actorName,
      required this.action,
      required this.timestamp,
      required this.note,
      required this.dateFmt});

  final String actorName;
  final String action;
  final DateTime timestamp;
  final String? note;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary,
              ),
            ),
            Container(
                width: 2, height: 40, color: cs.outlineVariant),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$actorName  •  $action',
                  style: tt.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(dateFmt.format(timestamp),
                  style: tt.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              if (note != null)
                Text(note!,
                    style: tt.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 12),
            ],
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
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
