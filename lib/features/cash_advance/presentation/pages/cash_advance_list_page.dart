import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../domain/entities/cash_advance_entity.dart';
import '../providers/cash_advance_providers.dart';

/// Displays the current user's Cash Advance submissions as a real-time list.
/// Tapping a card navigates to the detail page.
/// FAB navigates to the create form.
class CashAdvanceListPage extends ConsumerWidget {
  const CashAdvanceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamAsync = ref.watch(userCashAdvanceStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cash Advance')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.cashAdvanceCreate),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
      body: streamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (items) => items.isEmpty
            ? _EmptyView(
                onNewRequest: () => context.push(AppRoutes.cashAdvanceCreate),
              )
            : RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(userCashAdvanceStreamProvider),
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _CashAdvanceCard(entity: items[index]),
                ),
              ),
      ),
    );
  }
}

// ── List Card ─────────────────────────────────────────────────────────────────

class _CashAdvanceCard extends StatelessWidget {
  const _CashAdvanceCard({required this.entity});

  final CashAdvanceEntity entity;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final amtFmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFmt = DateFormat('dd MMM yyyy');

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => context.push('/cash-advance/${entity.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entity.projectName,
                      style: tt.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(status: entity.status),
                ],
              ),
              const SizedBox(height: 6),
              // ── Purpose ────────────────────────────────────────────────
              Text(
                entity.purpose,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // ── Amount + date row ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    amtFmt.format(entity.requestedAmount),
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                  Text(
                    dateFmt.format(entity.createdAt),
                    style:
                        tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

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
          Icon(
            Icons.receipt_long_outlined,
            size: 72,
            color: cs.onSurfaceVariant.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No Cash Advances yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to submit your first request.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
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

// ── Error View ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

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
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
