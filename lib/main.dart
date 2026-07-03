import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/l10n/locale_provider.dart';
import 'package:saranidhi/core/router/app_router.dart';
import 'package:saranidhi/core/router/onboarding_guard.dart';
import 'package:saranidhi/core/theme/app_theme.dart';
import 'package:saranidhi/core/theme/theme_provider.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/sync_on_open_widget.dart';
import 'package:saranidhi/features/notifications/data/notification_service.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  runApp(const ProviderScope(child: SaranidhiApp()));
}

/// Root application widget.
///
/// Wraps the app in a [ProviderScope] for Riverpod and uses
/// GoRouter for declarative routing with Material 3 theming.
/// [OnboardingGuard] ensures first-time users complete setup.
class SaranidhiApp extends ConsumerWidget {
  const SaranidhiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final appLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Saranidhi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(themeState.accent),
      darkTheme: AppTheme.darkTheme(themeState.accent),
      themeMode: themeState.brightness.flutterMode,
      locale: appLocale.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      builder: (context, child) {
        return SyncOnOpenWidget(
          child: OnboardingGuard(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
