import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../domain/entities/reimbursement_entity.dart';
import '../providers/reimbursement_providers.dart';

/// Lists the current user's Reimbursement submissions with real-time updates.
class ReimbursementListPage extends ConsumerWidget {
  const ReimbursementListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamAsync = ref.watch(userReimbursementStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reimbursement')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.reimbursementCreate),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
      body: streamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (items) => items.isEmpty
            ? _EmptyView(
                onNewRequest: () =>
                    context.push(AppRoutes.reimbursementCreate),
              )
            : RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(userReimbursementStreamProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) =>
                      _ReimbursementCard(entity: items[i]),
                ),
              ),
      ),
    );
  }
}

// ── List Card ─────────────────────────────────────────────────────────────────

class _ReimbursementCard extends StatelessWidget {
  const _ReimbursementCard({required this.entity});

  final ReimbursementEntity entity;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final amtFmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => context.push('/reimbursement/${entity.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ───────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entity.description.isNotEmpty
                          ? entity.description
                          : entity.projectName,
                      style: tt.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(status: entity.status),
                ],
              ),
              const SizedBox(height: 6),
              // ── Amount ───────────────────────────────────────────────────
              Text(
                amtFmt.format(entity.totalRequestedAmount),
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 4),
              // ── Meta row ─────────────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.receipt_outlined,
                      size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${entity.items.length} item${entity.items.length == 1 ? '' : 's'}',
                    style: tt.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  if (entity.linkedCashAdvancePurpose != null) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.link, size: 14, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        entity.linkedCashAdvancePurpose!,
                        style: tt.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty & Error views ───────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onNewRequest});

  final VoidCallback onNewRequest;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: cs.outline),
          const SizedBox(height: 16),
          Text('No reimbursement requests yet',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onNewRequest,
            icon: const Icon(Icons.add),
            label: const Text('New Request'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Error: $message',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
