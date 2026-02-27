import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/auth_providers.dart';

/// Splash screen shown during the initial Firebase Auth state check.
/// It does NOT contain navigation logic — routing is handled entirely
/// by [AppRouter]'s redirect guard which watches [authStateStreamProvider].
/// This page is displayed only while [authStateStreamProvider] is loading.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateStreamProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: authAsync.when(
          loading: () => _buildLoading(colorScheme),
          data: (_) => _buildLoading(colorScheme), // Router will redirect.
          error: (e, _) => _buildError(context, colorScheme, e),
        ),
      ),
    );
  }

  Widget _buildLoading(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.receipt_long_rounded,
            size: 44,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildError(
    BuildContext context,
    ColorScheme colorScheme,
    Object error,
  ) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to initialise. Please restart the app.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.error, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
