import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/cash_advance_providers.dart';

/// Form page for creating a new Cash Advance submission.
///
/// Provides two actions:
/// - **Save Draft** — persists the form data without submitting for approval.
/// - **Submit Request** — validates the outstanding guard, then transitions
///   status to [SubmissionStatus.pendingPic].
class CashAdvanceCreatePage extends ConsumerStatefulWidget {
  const CashAdvanceCreatePage({super.key});

  @override
  ConsumerState<CashAdvanceCreatePage> createState() =>
      _CashAdvanceCreatePageState();
}

class _CashAdvanceCreatePageState
    extends ConsumerState<CashAdvanceCreatePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _projectNameCtrl;
  late final TextEditingController _projectIdCtrl;
  late final TextEditingController _purposeCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _amountCtrl;

  @override
  void initState() {
    super.initState();
    _projectNameCtrl = TextEditingController();
    _projectIdCtrl = TextEditingController();
    _purposeCtrl = TextEditingController();
    _descriptionCtrl = TextEditingController();
    _amountCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _projectIdCtrl.dispose();
    _purposeCtrl.dispose();
    _descriptionCtrl.dispose();
    _amountCtrl.dispose();
    // Reset form controller state so next open starts fresh.
    ref.invalidate(cashAdvanceFormControllerProvider);
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  double get _parsedAmount =>
      double.tryParse(_amountCtrl.text.replaceAll(',', '').trim()) ?? 0.0;

  String? _notEmpty(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required.' : null;

  String? _validateAmount(String? v) {
    if (v == null || v.trim().isEmpty) return 'Amount is required.';
    final amount = double.tryParse(v.replaceAll(',', ''));
    if (amount == null || amount <= 0) return 'Enter a valid amount greater than 0.';
    return null;
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _onSaveDraft() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    await ref.read(cashAdvanceFormControllerProvider.notifier).saveDraft(
          projectName: _projectNameCtrl.text.trim(),
          projectId: _projectIdCtrl.text.trim(),
          purpose: _purposeCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
          amount: _parsedAmount,
          currency: 'IDR',
          userUid: user.uid,
          userName: user.displayName,
        );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authStateStreamProvider).valueOrNull;
    if (user == null) return;

    await ref.read(cashAdvanceFormControllerProvider.notifier).submit(
          projectName: _projectNameCtrl.text.trim(),
          projectId: _projectIdCtrl.text.trim(),
          purpose: _purposeCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
          amount: _parsedAmount,
          currency: 'IDR',
          userUid: user.uid,
          userName: user.displayName,
        );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(cashAdvanceFormControllerProvider);

    // ── Side effects: navigate on success, show snackbar on save/error ──────
    ref.listen<CashAdvanceFormState>(cashAdvanceFormControllerProvider,
        (prev, next) {
      if (next.isDone) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cash Advance submitted successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.cashAdvanceList);
        return;
      }

      // Draft saved
      if (!next.isSaving &&
          prev?.isSaving == true &&
          next.savedEntity != null &&
          next.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft saved.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Error
      if (next.errorMessage != null &&
          prev?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Cash Advance'),
        actions: [
          // Quick "Save Draft" from AppBar
          if (!formState.isLoading)
            TextButton(
              onPressed: _onSaveDraft,
              child: const Text('Save Draft'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
          children: [
            const _SectionHeader(label: 'Project Information'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _projectNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Project Name *',
                hintText: 'e.g. Mobile App Development',
              ),
              validator: _notEmpty,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _projectIdCtrl,
              decoration: const InputDecoration(
                labelText: 'Project Code',
                hintText: 'e.g. PROJ-001 (optional)',
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 24),
            const _SectionHeader(label: 'Request Details'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _purposeCtrl,
              decoration: const InputDecoration(
                labelText: 'Purpose *',
                hintText: 'Brief reason for the advance',
              ),
              validator: _notEmpty,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Additional details (optional)',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountCtrl,
              decoration: const InputDecoration(
                labelText: 'Requested Amount (IDR) *',
                prefixText: 'Rp ',
                hintText: '0',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: _validateAmount,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
      // ── Fixed bottom action bar ─────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (formState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    formState.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: formState.isLoading ? null : _onSaveDraft,
                      child: formState.isSaving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: formState.isLoading ? null : _onSubmit,
                      child: formState.isSubmitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Submit Request'),
                    ),
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

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.8,
          ),
    );
  }
}
