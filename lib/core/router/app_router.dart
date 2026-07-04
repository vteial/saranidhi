import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saranidhi/core/router/shell_scaffold.dart';
import 'package:saranidhi/features/analytics/presentation/analytics_screen.dart';
import 'package:saranidhi/features/home/presentation/home_screen.dart';
import 'package:saranidhi/features/journal/presentation/journal_screen.dart';
import 'package:saranidhi/features/onboarding/presentation/onboarding_screen.dart';
import 'package:saranidhi/features/settings/presentation/settings_screen.dart';

/// Application route paths.
abstract class AppRoutes {
  /// Home/Dashboard route.
  static const home = '/';

  /// Breath Journal route.
  static const journal = '/journal';

  /// Analytics route.
  static const analytics = '/analytics';

  /// Settings route.
  static const settings = '/settings';

  /// Onboarding route.
  static const onboarding = '/onboarding';
}

// Navigator keys for each branch
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _journalNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'journal');
final _analyticsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'analytics');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

/// Custom fade-through transition for tab pages.
CustomTransitionPage<void> _fadeTransitionPage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}

/// The main router configuration using [StatefulShellRoute]
/// for persistent bottom navigation state.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) => _fadeTransitionPage(
                child: const HomeScreen(),
                state: state,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _journalNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.journal,
              pageBuilder: (context, state) => _fadeTransitionPage(
                child: const JournalScreen(),
                state: state,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              pageBuilder: (context, state) => _fadeTransitionPage(
                child: const SettingsScreen(),
                state: state,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _analyticsNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.analytics,
              pageBuilder: (context, state) => _fadeTransitionPage(
                child: const AnalyticsScreen(),
                state: state,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
