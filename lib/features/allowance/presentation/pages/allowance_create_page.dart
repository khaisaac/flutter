import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/allowance_providers.dart';

/// Form page for creating / editing an Allowance submission.
///
/// Features:
/// - Allowance type dropdown with per-diem rate hint
/// - Day-count stepper → auto-fills the amount field
/// - Amount field (overridable)
/// - Allowance date picker
/// - Description field
/// - Attendance proof upload (gallery)
/// - Save Draft and Submit buttons
class AllowanceCreatePage extends ConsumerStatefulWidget {
  const AllowanceCreatePage({super.key});

  @override
  ConsumerState<AllowanceCreatePage> createState() =>
      _AllowanceCreatePageState();
}

class _AllowanceCreatePageState extends ConsumerState<AllowanceCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  static final _currFmt = NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  static final _dateFmt = DateFormat('dd MMM yyyy');

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    ref.invalidate(allowanceFormControllerProvider);
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _syncText() {
    final notifier = ref.read(allowanceFormControllerProvider.notifier);
    notifier.setAmountText(_amountCtrl.text.trim());
    notifier.setDescription(_descCtrl.text.trim());
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _saveDraft() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _syncText();
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    await ref
        .read(allowanceFormControllerProvider.notifier)
        .saveDraft(uid: user.uid, name: user.displayName);

    if (!mounted) return;
    final error = ref.read(allowanceFormControllerProvider).error;
    if (error != null) {
      _showError(error);
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

    await ref
        .read(allowanceFormControllerProvider.notifier)
        .submit(uid: user.uid, name: user.displayName);

    if (!mounted) return;
    final formState = ref.read(allowanceFormControllerProvider);
    if (formState.isDone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Allowance submitted for approval.'),
            behavior: SnackBarBehavior.floating),
      );
      context.go(AppRoutes.allowanceList);
    } else if (formState.error != null) {
      _showError(formState.error!);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).colorScheme.error),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(allowanceFormControllerProvider);
    final notifier = ref.read(allowanceFormControllerProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    // Keep amount field in sync when type/days auto-fills amount
    final suggestion = formState.suggestedAmount;
    if (suggestion > 0 && _amountCtrl.text.isEmpty) {
      _amountCtrl.text = suggestion.toStringAsFixed(0);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('New Allowance')),
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
            // ── Allowance Type ────────────────────────────────────────────
            DropdownButtonFormField<AllowanceType>(
              value: formState.type,
              decoration: InputDecoration(
                labelText: 'Allowance Type',
                border: const OutlineInputBorder(),
                helperText:
                    AllowanceCalculator.rateLabel(formState.type),
              ),
              isExpanded: true,
              items: AllowanceType.values
                  .map((t) => DropdownMenuItem(
                      value: t, child: Text(t.label)))
                  .toList(),
              onChanged: (t) {
                if (t == null) return;
                notifier.setType(t);
                // Sync amount field with new auto-suggestion
                final s = AllowanceCalculator.compute(t, formState.daysCount);
                if (s > 0) _amountCtrl.text = s.toStringAsFixed(0);
              },
            ),
            const SizedBox(height: 16),

            // ── Days Stepper ──────────────────────────────────────────────
            _DaysStepper(
              value: formState.daysCount,
              label: formState.type == AllowanceType.accommodation
                  ? 'Nights'
                  : 'Days',
              onChanged: (days) {
                notifier.setDaysCount(days);
                final s = AllowanceCalculator.compute(formState.type, days);
                if (s > 0) _amountCtrl.text = s.toStringAsFixed(0);
              },
            ),
            const SizedBox(height: 16),

            // ── Amount ────────────────────────────────────────────────────
            TextFormField(
              controller: _amountCtrl,
              decoration: InputDecoration(
                labelText: 'Amount (IDR)',
                prefixText: 'Rp ',
                border: const OutlineInputBorder(),
                helperText: suggestion > 0
                    ? 'Suggested: ${_currFmt.format(suggestion)}'
                    : null,
                suffixIcon: suggestion > 0
                    ? Tooltip(
                        message: 'Use suggested amount',
                        child: IconButton(
                          icon: const Icon(Icons.auto_fix_high),
                          onPressed: () {
                            _amountCtrl.text =
                                suggestion.toStringAsFixed(0);
                            notifier
                                .setAmountText(suggestion.toStringAsFixed(0));
                          },
                        ),
                      )
                    : null,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                final amt = double.tryParse(
                        v?.replaceAll(',', '').trim() ?? '') ??
                    0;
                if (amt <= 0) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Allowance Date ────────────────────────────────────────────
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: formState.allowanceDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) notifier.setAllowanceDate(picked);
              },
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(
                'Allowance Date: ${_dateFmt.format(formState.allowanceDate)}',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 16),

            // ── Description ───────────────────────────────────────────────
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'e.g. Team offsite in Bandung',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // ── Attendance Proof ──────────────────────────────────────────
            Row(
              children: [
                Text('Attendance Proof',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                TextButton.icon(
                  onPressed: notifier.pickAttendanceFile,
                  icon: const Icon(Icons.upload_outlined, size: 18),
                  label: const Text('Upload'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Uploaded attachments
            ...formState.uploadedAttachments.asMap().entries.map(
              (e) => _AttachmentTile(
                name: 'Attendance ${e.key + 1}',
                subtitle: e.value.fileName,
                uploaded: true,
                onRemove: () =>
                    notifier.removeUploadedAttachment(e.value.id),
              ),
            ),

            // Pending (not yet uploaded) files
            ...formState.pendingFiles.asMap().entries.map(
              (e) => _AttachmentTile(
                name: e.value.name,
                subtitle: 'Pending upload',
                uploaded: false,
                onRemove: () => notifier.removePendingFile(e.key),
              ),
            ),

            if (!formState.hasAttachments)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: cs.outline.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Attach attendance sheet or proof document.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // ── Summary ───────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: formState.type.label,
                    value:
                        '${formState.daysCount} ${formState.type == AllowanceType.accommodation ? 'night(s)' : 'day(s)'}',
                  ),
                  const Divider(height: 16),
                  _SummaryRow(
                    label: 'Total',
                    value: _currFmt.format(formState.parsedAmount),
                    isBold: true,
                    color: cs.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Days Stepper ─────────────────────────────────────────────────────────────

class _DaysStepper extends StatelessWidget {
  const _DaysStepper({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final int value;
  final String label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
            iconSize: 20,
            color: cs.primary,
          ),
          Expanded(
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add),
            iconSize: 20,
            color: cs.primary,
          ),
        ],
      ),
    );
  }
}

// ── Attachment Tile ───────────────────────────────────────────────────────────

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.name,
    required this.subtitle,
    required this.uploaded,
    required this.onRemove,
  });

  final String name;
  final String subtitle;
  final bool uploaded;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        leading: Icon(
          uploaded ? Icons.image_outlined : Icons.schedule_outlined,
          color: uploaded ? cs.primary : cs.onSurfaceVariant,
        ),
        title: Text(name,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(subtitle,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.onSurfaceVariant)),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          iconSize: 18,
          onPressed: onRemove,
          color: cs.error,
        ),
      ),
    );
  }
}

// ── Summary Row ───────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.color,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: isBold ? FontWeight.bold : null,
          color: color,
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

// ── Bottom Bar ────────────────────────────────────────────────────────────────

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
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: isSaving || isSubmitting ? null : onSubmit,
                style: FilledButton.styleFrom(backgroundColor: cs.primary),
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
