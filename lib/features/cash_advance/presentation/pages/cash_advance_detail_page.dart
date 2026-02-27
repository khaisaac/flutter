import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/cash_advance_entity.dart';
import '../../domain/usecases/submit_cash_advance_usecase.dart';
import '../providers/cash_advance_providers.dart';

/// Shows the full details of a single Cash Advance submission.
///
/// Watches a real-time stream for the document.
/// If the entity is still in [draft] or [revision] state, shows a
/// "Submit Request" button (the only submission action in this step).
class CashAdvanceDetailPage extends ConsumerStatefulWidget {
  const CashAdvanceDetailPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<CashAdvanceDetailPage> createState() =>
      _CashAdvanceDetailPageState();
}

class _CashAdvanceDetailPageState
    extends ConsumerState<CashAdvanceDetailPage> {
  bool _isSubmitting = false;
  String? _submitError;

  // ── Submit action ─────────────────────────────────────────────────────────

  Future<void> _submit(CashAdvanceEntity entity) async {
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final result = await ref.read(submitCashAdvanceUseCaseProvider).call(
          SubmitCashAdvanceParams(
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
            content: Text('Cash Advance submitted for approval.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.cashAdvanceList);
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final streamAsync = ref.watch(cashAdvanceDetailStreamProvider(widget.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Cash Advance Detail')),
      body: streamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(message: e.toString()),
        data: (entity) {
          if (entity == null) {
            return const _ErrorBody(message: 'Submission not found.');
          }
          return _DetailBody(
            entity: entity,
            isSubmitting: _isSubmitting,
            submitError: _submitError,
            onSubmit: () => _submit(entity),
          );
        },
      ),
    );
  }
}

// ── Detail body ───────────────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.entity,
    required this.isSubmitting,
    required this.submitError,
    required this.onSubmit,
  });

  final CashAdvanceEntity entity;
  final bool isSubmitting;
  final String? submitError;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFmt = DateFormat('dd MMM yyyy, HH:mm');
    final canSubmit = entity.isDraft || entity.status.value == 'revision';

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Status header card ──────────────────────────────────────
              _StatusHeaderCard(entity: entity, amtFmt: amtFmt),
              const SizedBox(height: 16),

              // ── Project info ────────────────────────────────────────────
              _InfoCard(
                title: 'Project',
                rows: [
                  _InfoRow(label: 'Project Name', value: entity.projectName),
                  _InfoRow(label: 'Project Code', value: entity.projectId),
                ],
              ),
              const SizedBox(height: 12),

              // ── Request details ─────────────────────────────────────────
              _InfoCard(
                title: 'Request Details',
                rows: [
                  _InfoRow(label: 'Purpose', value: entity.purpose),
                  if (entity.description.isNotEmpty)
                    _InfoRow(
                      label: 'Description',
                      value: entity.description,
                    ),
                  _InfoRow(
                    label: 'Amount',
                    value: amtFmt.format(entity.requestedAmount),
                    valueStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  _InfoRow(label: 'Currency', value: entity.currency),
                ],
              ),
              const SizedBox(height: 12),

              // ── Timeline ────────────────────────────────────────────────
              _InfoCard(
                title: 'Timeline',
                rows: [
                  _InfoRow(
                    label: 'Created',
                    value: dateFmt.format(entity.createdAt),
                  ),
                  if (entity.submittedAt != null)
                    _InfoRow(
                      label: 'Submitted',
                      value: dateFmt.format(entity.submittedAt!),
                    ),
                  if (entity.approvedByPicAt != null)
                    _InfoRow(
                      label: 'Approved by PIC',
                      value: dateFmt.format(entity.approvedByPicAt!),
                    ),
                  if (entity.approvedByFinanceAt != null)
                    _InfoRow(
                      label: 'Approved by Finance',
                      value: dateFmt.format(entity.approvedByFinanceAt!),
                    ),
                  if (entity.rejectedAt != null)
                    _InfoRow(
                      label: 'Rejected',
                      value: dateFmt.format(entity.rejectedAt!),
                    ),
                ],
              ),

              // ── Notes ───────────────────────────────────────────────────
              if (entity.rejectionReason != null ||
                  entity.picNote != null ||
                  entity.financeNote != null) ...[
                const SizedBox(height: 12),
                _InfoCard(
                  title: 'Notes',
                  rows: [
                    if (entity.rejectionReason != null)
                      _InfoRow(
                        label: 'Rejection Reason',
                        value: entity.rejectionReason!,
                      ),
                    if (entity.picNote != null)
                      _InfoRow(label: 'PIC Note', value: entity.picNote!),
                    if (entity.financeNote != null)
                      _InfoRow(
                        label: 'Finance Note',
                        value: entity.financeNote!,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // ── Action bar ─────────────────────────────────────────────────────
        if (canSubmit)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (submitError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        submitError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  FilledButton(
                    onPressed: isSubmitting ? null : onSubmit,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            entity.isDraft
                                ? 'Submit Request'
                                : 'Resubmit Request',
                          ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Status header card ────────────────────────────────────────────────────────

class _StatusHeaderCard extends StatelessWidget {
  const _StatusHeaderCard({required this.entity, required this.amtFmt});

  final CashAdvanceEntity entity;
  final NumberFormat amtFmt;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      color: cs.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    entity.projectName,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimaryContainer,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusChip(status: entity.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amtFmt.format(entity.requestedAmount),
              style: tt.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Requested by ${entity.submittedByName}',
              style:
                  tt.bodySmall?.copyWith(color: cs.onPrimaryContainer.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info card + rows ──────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0.8,
                  ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: (valueStyle ?? tt.bodyMedium)?.copyWith(
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error body ────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
