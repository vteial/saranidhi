import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/router/app_router.dart';
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
class SaranidhiApp extends ConsumerWidget {
  /// Creates the root Saranidhi application widget.
  const SaranidhiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Saranidhi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(themeMode),
      routerConfig: appRouter,
    );
  }
}
