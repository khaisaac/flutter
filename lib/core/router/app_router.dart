import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

// ── Router Notifier ───────────────────────────────────────────────────────────

/// [ChangeNotifier] bridge between Riverpod's [authStateStreamProvider]
/// and GoRouter's [refreshListenable].
///
/// When auth state changes (sign-in / sign-out / role update),
/// [notifyListeners] triggers GoRouter to re-evaluate the redirect guard.
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<UserEntity?>>(
      authStateStreamProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;

  /// GoRouter redirect hook. Returns the target path or null (stay put).
  String? redirect(BuildContext context, GoRouterState state) {
    final authAsync = _ref.read(authStateStreamProvider);
    final location = state.matchedLocation;

    // ── Still loading initial auth state ─────────────────────────────────────
    if (authAsync.isLoading || authAsync.hasError) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    final user = authAsync.valueOrNull;
    final isAuthenticated = user != null;

    // ── Unauthenticated ───────────────────────────────────────────────────────
    if (!isAuthenticated) {
      if (location == AppRoutes.login || location == AppRoutes.splash) {
        return null;
      }
      return AppRoutes.login;
    }

    // ── Authenticated: redirect away from auth pages ──────────────────────────
    if (location == AppRoutes.login || location == AppRoutes.splash) {
      return _homeRouteForUser(user);
    }

    return null;
  }

  /// Returns the post-login landing route.
  /// Will branch by role in the Dashboard step.
  String _homeRouteForUser(UserEntity user) => AppRoutes.dashboard;
}

// ── Providers ─────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
RouterNotifier routerNotifier(RouterNotifierRef ref) => RouterNotifier(ref);

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
    routes: _buildRoutes(),
  );
}

// ── Route Definitions ─────────────────────────────────────────────────────────

List<RouteBase> _buildRoutes() => [
      // ── Public ──────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (_, __) => const LoginPage(),
      ),

      // ── Protected ────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (_, __) => const _DashboardPlaceholder(),
      ),

      // ── Cash Advance (Step 4) ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.cashAdvanceList,
        name: 'cash-advance-list',
        builder: (_, __) => const _PlaceholderPage(title: 'Cash Advance'),
        routes: [
          GoRoute(
            path: 'create',
            name: 'cash-advance-create',
            builder: (_, __) =>
                const _PlaceholderPage(title: 'New Cash Advance'),
          ),
          GoRoute(
            path: ':id',
            name: 'cash-advance-detail',
            builder: (_, state) => _PlaceholderPage(
              title: 'Cash Advance #${state.pathParameters['id']}',
            ),
          ),
        ],
      ),

      // ── Allowance (Step 5) ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.allowanceList,
        name: 'allowance-list',
        builder: (_, __) => const _PlaceholderPage(title: 'Allowance'),
        routes: [
          GoRoute(
            path: 'create',
            name: 'allowance-create',
            builder: (_, __) =>
                const _PlaceholderPage(title: 'New Allowance'),
          ),
          GoRoute(
            path: ':id',
            name: 'allowance-detail',
            builder: (_, state) => _PlaceholderPage(
              title: 'Allowance #${state.pathParameters['id']}',
            ),
          ),
        ],
      ),

      // ── Reimbursement (Step 6) ────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.reimbursementList,
        name: 'reimbursement-list',
        builder: (_, __) => const _PlaceholderPage(title: 'Reimbursement'),
        routes: [
          GoRoute(
            path: 'create',
            name: 'reimbursement-create',
            builder: (_, __) =>
                const _PlaceholderPage(title: 'New Reimbursement'),
          ),
          GoRoute(
            path: ':id',
            name: 'reimbursement-detail',
            builder: (_, state) => _PlaceholderPage(
              title: 'Reimbursement #${state.pathParameters['id']}',
            ),
          ),
        ],
      ),

      // ── Profile & Notifications ───────────────────────────────────────────
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (_, __) => const _PlaceholderPage(title: 'Profile'),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (_, __) => const _PlaceholderPage(title: 'Notifications'),
      ),
    ];

// ── Placeholder Pages (replaced in feature steps) ────────────────────────────

class _DashboardPlaceholder extends ConsumerWidget {
  const _DashboardPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateStreamProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_rounded, size: 64, color: colorScheme.primary),
            const SizedBox(height: 16),
            if (user != null) ...[
              Text(
                'Welcome, ${user.displayName}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Chip(label: Text('Role: ${user.role}')),
            ],
            const SizedBox(height: 24),
            const Text(
              'Dashboard — populated in Step 3',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  final Exception? error;
  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text(error?.toString() ?? 'Unknown navigation error.'),
      ),
    );
  }
}
