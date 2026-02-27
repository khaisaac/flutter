import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../cash_advance/presentation/providers/cash_advance_providers.dart';
import '../providers/reimbursement_providers.dart';

/// Form for creating a Reimbursement submission.
///
/// Supports:
/// - Free-text description
/// - Optional linkage to an approved Cash Advance (dropdown)
/// - Multiple expense line items (category, description, amount, date, receipt)
/// - Live total + settlement preview
/// - Save Draft and Submit actions
class ReimbursementCreatePage extends ConsumerStatefulWidget {
  const ReimbursementCreatePage({super.key});

  @override
  ConsumerState<ReimbursementCreatePage> createState() =>
      _ReimbursementCreatePageState();
}

class _ReimbursementCreatePageState
    extends ConsumerState<ReimbursementCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();

  /// Text controllers for each item, keyed by draft item ID.
  final Map<String, TextEditingController> _amountCtrls = {};
  final Map<String, TextEditingController> _itemDescCtrls = {};

  static final _currFmt = NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Create controllers for the initial blank item.
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureControllers());
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    for (final c in _amountCtrls.values) c.dispose();
    for (final c in _itemDescCtrls.values) c.dispose();
    ref.invalidate(reimbursementFormControllerProvider);
    super.dispose();
  }

  // ── Controller helpers ─────────────────────────────────────────────────────

  void _ensureControllers() {
    final items = ref.read(reimbursementFormControllerProvider).items;
    for (final item in items) {
      _amountCtrls.putIfAbsent(
          item.id, () => TextEditingController(text: item.amountText));
      _itemDescCtrls.putIfAbsent(
          item.id, () => TextEditingController(text: item.description));
    }
    if (mounted) setState(() {});
  }

  /// Pushes text-field values into the form controller before saving.
  void _syncText() {
    final notifier =
        ref.read(reimbursementFormControllerProvider.notifier);
    final items = ref.read(reimbursementFormControllerProvider).items;
    notifier.setDescription(_descCtrl.text.trim());
    for (final item in items) {
      notifier.updateItem(
        item.id,
        item.copyWith(
          amountText: _amountCtrls[item.id]?.text ?? item.amountText,
          description: _itemDescCtrls[item.id]?.text ?? item.description,
        ),
      );
    }
  }

  void _addItem() {
    ref.read(reimbursementFormControllerProvider.notifier).addItem();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _ensureControllers());
  }

  void _removeItem(String id) {
    ref.read(reimbursementFormControllerProvider.notifier).removeItem(id);
    _amountCtrls.remove(id)?.dispose();
    _itemDescCtrls.remove(id)?.dispose();
    setState(() {});
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _saveDraft() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _syncText();

    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    await ref.read(reimbursementFormControllerProvider.notifier).saveDraft(
          uid: user.uid,
          name: user.displayName,
          projectId: 'default',
          projectName: 'General',
        );

    if (!mounted) return;
    final error =
        ref.read(reimbursementFormControllerProvider).error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error),
            backgroundColor: Theme.of(context).colorScheme.error),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Draft saved.'),
            behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _syncText();

    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    await ref.read(reimbursementFormControllerProvider.notifier).submit(
          uid: user.uid,
          name: user.displayName,
          projectId: 'default',
          projectName: 'General',
        );

    if (!mounted) return;
    final formState = ref.read(reimbursementFormControllerProvider);
    if (formState.isDone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Reimbursement submitted for approval.'),
            behavior: SnackBarBehavior.floating),
      );
      context.go(AppRoutes.reimbursementList);
    } else if (formState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(formState.error!),
            backgroundColor: Theme.of(context).colorScheme.error),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(reimbursementFormControllerProvider);
    final caAsync = ref.watch(approvedCashAdvancesProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('New Reimbursement')),
      bottomNavigationBar: _BottomBar(
        isSaving: formState.isSaving,
        isSubmitting: formState.isSubmitting,
        onSaveDraft: _saveDraft,
        onSubmit: _submit,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // ── Description ───────────────────────────────────────────────
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'e.g. Business trip to client office',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // ── Linked Cash Advance ───────────────────────────────────────
            caAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
              data: (caList) => caList.isEmpty
                  ? const SizedBox.shrink()
                  : DropdownButtonFormField<String?>(
                      value: formState.linkedCaId,
                      decoration: const InputDecoration(
                        labelText: 'Linked Cash Advance (optional)',
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('— None —'),
                        ),
                        ...caList.map(
                          (ca) => DropdownMenuItem<String?>(
                            value: ca.id,
                            child: Text(
                              '${ca.purpose}  •  ${_currFmt.format(ca.effectiveOutstanding)} outstanding',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (id) {
                        final ca = caList
                            .where((c) => c.id == id)
                            .firstOrNull;
                        ref
                            .read(reimbursementFormControllerProvider.notifier)
                            .setLinkedCA(id, ca?.purpose);
                      },
                    ),
            ),
            const SizedBox(height: 24),

            // ── Expense Items ─────────────────────────────────────────────
            Text('Expense Items',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...formState.items.asMap().entries.map((entry) {
              final idx = entry.key;
              final draft = entry.value;
              _amountCtrls.putIfAbsent(
                  draft.id, () => TextEditingController(text: draft.amountText));
              _itemDescCtrls.putIfAbsent(
                  draft.id, () => TextEditingController(text: draft.description));
              return _ItemCard(
                key: ValueKey(draft.id),
                index: idx,
                draft: draft,
                amountCtrl: _amountCtrls[draft.id]!,
                descCtrl: _itemDescCtrls[draft.id]!,
                onCategoryChanged: (cat) => ref
                    .read(reimbursementFormControllerProvider.notifier)
                    .updateItem(draft.id, draft.copyWith(category: cat)),
                onDatePick: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: draft.receiptDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    ref
                        .read(reimbursementFormControllerProvider.notifier)
                        .updateItem(
                            draft.id, draft.copyWith(receiptDate: picked));
                  }
                },
                onPickReceipt: () => ref
                    .read(reimbursementFormControllerProvider.notifier)
                    .pickReceipt(draft.id),
                onRemove: formState.items.length > 1
                    ? () => _removeItem(draft.id)
                    : null,
              );
            }),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
            const SizedBox(height: 24),

            // ── Total ─────────────────────────────────────────────────────
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
                    _currFmt.format(formState.total),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),

            // ── Settlement Preview ────────────────────────────────────────
            if (formState.linkedCaId != null)
              caAsync.whenData((caList) {
                final ca = caList
                    .where((c) => c.id == formState.linkedCaId)
                    .firstOrNull;
                if (ca == null) return const SizedBox.shrink();
                final newOutstanding =
                    ca.effectiveOutstanding - formState.total;
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Card(
                    color: cs.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Settlement Preview',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color: cs.onSecondaryContainer)),
                          const SizedBox(height: 8),
                          _SettlementRow(
                            label: 'CA Outstanding',
                            value: ca.effectiveOutstanding,
                            fmt: _currFmt,
                          ),
                          _SettlementRow(
                            label: 'This Request',
                            value: -formState.total,
                            fmt: _currFmt,
                            isNegative: true,
                          ),
                          const Divider(height: 12),
                          _SettlementRow(
                            label: 'Remaining',
                            value: newOutstanding < 0 ? 0 : newOutstanding,
                            fmt: _currFmt,
                            isBold: true,
                          ),
                          if (newOutstanding <= 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 14,
                                      color: cs.onSecondaryContainer),
                                  const SizedBox(width: 6),
                                  Text(
                                    'CA will be fully settled',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: cs.onSecondaryContainer),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).value ??
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

// ── Item Card ─────────────────────────────────────────────────────────────────

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    super.key,
    required this.index,
    required this.draft,
    required this.amountCtrl,
    required this.descCtrl,
    required this.onCategoryChanged,
    required this.onDatePick,
    required this.onPickReceipt,
    this.onRemove,
  });

  final int index;
  final ReimbursementItemDraft draft;
  final TextEditingController amountCtrl;
  final TextEditingController descCtrl;
  final ValueChanged<ExpenseCategory> onCategoryChanged;
  final VoidCallback onDatePick;
  final VoidCallback onPickReceipt;
  final VoidCallback? onRemove;

  static final _dateFmt = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card header ────────────────────────────────────────────
            Row(
              children: [
                Text('Item ${index + 1}',
                    style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                if (onRemove != null)
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 20,
                    color: cs.error,
                    tooltip: 'Remove item',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Category ──────────────────────────────────────────────
            DropdownButtonFormField<ExpenseCategory>(
              value: draft.category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: ExpenseCategory.values
                  .map((c) => DropdownMenuItem(
                      value: c, child: Text(c.label)))
                  .toList(),
              onChanged: (c) {
                if (c != null) onCategoryChanged(c);
              },
              validator: (_) => null,
            ),
            const SizedBox(height: 12),

            // ── Item Description ──────────────────────────────────────
            TextFormField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            // ── Amount ────────────────────────────────────────────────
            TextFormField(
              controller: amountCtrl,
              decoration: const InputDecoration(
                labelText: 'Amount (IDR)',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (v) {
                final parsed = double.tryParse(
                        v?.replaceAll(',', '').replaceAll(' ', '') ?? '') ??
                    0;
                if (parsed <= 0) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ── Receipt Date ──────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDatePick,
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(_dateFmt.format(draft.receiptDate)),
                  ),
                ),
                const SizedBox(width: 8),
                // ── Receipt Upload ──────────────────────────────────
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPickReceipt,
                    icon: Icon(
                      draft.hasReceipt
                          ? Icons.image_outlined
                          : Icons.upload_outlined,
                      size: 16,
                      color: draft.hasReceipt ? cs.primary : null,
                    ),
                    label: Text(
                      draft.hasReceipt ? 'Receipt ✓' : 'Upload Receipt',
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: draft.hasReceipt
                        ? OutlinedButton.styleFrom(
                            foregroundColor: cs.primary)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Settlement Row ────────────────────────────────────────────────────────────

class _SettlementRow extends StatelessWidget {
  const _SettlementRow({
    required this.label,
    required this.value,
    required this.fmt,
    this.isNegative = false,
    this.isBold = false,
  });

  final String label;
  final double value;
  final NumberFormat fmt;
  final bool isNegative;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: isBold ? FontWeight.bold : null,
          color: cs.onSecondaryContainer,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            '${isNegative ? '− ' : ''}${fmt.format(value.abs())}',
            style: style,
          ),
        ],
      ),
    );
  }
}

// ── Bottom Action Bar ─────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isSaving,
    required this.isSubmitting,
    required this.onSaveDraft,
    required this.onSubmit,
  });

  final bool isSaving;
  final bool isSubmitting;
  final VoidCallback onSaveDraft;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Save Draft
            Expanded(
              child: OutlinedButton(
                onPressed: isSaving || isSubmitting ? null : onSaveDraft,
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save Draft'),
              ),
            ),
            const SizedBox(width: 12),
            // Submit
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: isSaving || isSubmitting ? null : onSubmit,
                style:
                    FilledButton.styleFrom(backgroundColor: cs.primary),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
