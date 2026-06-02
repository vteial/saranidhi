import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saranidhi/core/router/shell_scaffold.dart';
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

  /// Settings route.
  static const settings = '/settings';

  /// Onboarding route.
  static const onboarding = '/onboarding';
}

// Navigator keys for each branch
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _journalNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'journal');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

/// The main router configuration using [StatefulShellRoute]
/// for persistent bottom navigation state.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
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
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _journalNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.journal,
              builder: (context, state) => const JournalScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
