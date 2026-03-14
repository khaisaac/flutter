import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/notifications/notification_providers.dart';
import 'core/notifications/notification_service.dart';
import 'core/router/app_router.dart';
import 'shared/theme/app_theme.dart';

/// Root application widget.
/// Consumes the [appRouterProvider] from Riverpod so the router
/// can react to auth state changes without rebuilding the entire widget tree.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    ref.watch(notificationBootstrapProvider);

    return MaterialApp.router(
      title: 'Reimbursement Hexa',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationService.scaffoldMessengerKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
