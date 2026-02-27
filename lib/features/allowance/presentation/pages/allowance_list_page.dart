import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../domain/entities/allowance_entity.dart';
import '../providers/allowance_providers.dart';

/// Lists the current user's Allowance submissions with real-time updates.
class AllowanceListPage extends ConsumerWidget {
  const AllowanceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamAsync = ref.watch(userAllowanceStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Allowance')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.allowanceCreate),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
      body: streamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (items) => items.isEmpty
            ? _EmptyView(
                onNewRequest: () => context.push(AppRoutes.allowanceCreate),
              )
            : RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(userAllowanceStreamProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _AllowanceCard(entity: items[i]),
                ),
              ),
      ),
    );
  }
}

// ── List Card ─────────────────────────────────────────────────────────────────

class _AllowanceCard extends StatelessWidget {
  const _AllowanceCard({required this.entity});

  final AllowanceEntity entity;

  static final _amtFmt = NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  static final _dateFmt = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => context.push('/allowance/${entity.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entity.type.label,
                      style: tt.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(status: entity.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _amtFmt.format(entity.requestedAmount),
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    _dateFmt.format(entity.allowanceDate),
                    style: tt.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  if (entity.description.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        entity.description,
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
          Icon(Icons.payments_outlined, size: 72, color: cs.outline),
          const SizedBox(height: 16),
          Text(
            'No allowance requests yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: cs.onSurfaceVariant),
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
