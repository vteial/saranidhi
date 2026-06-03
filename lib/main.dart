import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/l10n/locale_provider.dart';
import 'package:saranidhi/core/router/app_router.dart';
import 'package:saranidhi/core/router/onboarding_guard.dart';
import 'package:saranidhi/core/theme/app_theme.dart';
import 'package:saranidhi/core/theme/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        return OnboardingGuard(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
