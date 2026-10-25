import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/router/onboarding_guard.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';
import 'package:saranidhi/features/whats_new/presentation/whats_new_screen.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CompleteOnboardingNotifier extends OnboardingCompleteNotifier {
  @override
  bool build() => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WhatsNew Startup Gate (R1 / T5)', () {
    testWidgets('presents WhatsNewScreen once post-onboarding, dismiss reveals main app and persists marker', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'onboarding_complete': true,
        // No whats_new_last_seen_version stored yet
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith(() => _CompleteOnboardingNotifier()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: OnboardingGuard(child: Text('MainAppReady')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // WhatsNewScreen is presented
      expect(find.byType(WhatsNewScreen), findsOneWidget);
      expect(find.text("What's New"), findsOneWidget);
      expect(find.text('MainAppReady'), findsNothing);

      // Tap 'Got it!' dismiss button
      await tester.tap(find.text('Got it!'));
      await tester.pumpAndSettle();

      // Main app content is revealed
      expect(find.byType(WhatsNewScreen), findsNothing);
      expect(find.text('MainAppReady'), findsOneWidget);

      // Verify SharedPreferences has the current version stored
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('whats_new_last_seen_version'), equals('1.2.0'));
    });

    testWidgets('does not show WhatsNewScreen if already marked seen for current version', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'onboarding_complete': true,
        'whats_new_last_seen_version': '1.2.0',
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith(() => _CompleteOnboardingNotifier()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: OnboardingGuard(child: Text('MainAppReady')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Directly shows main app content
      expect(find.byType(WhatsNewScreen), findsNothing);
      expect(find.text('MainAppReady'), findsOneWidget);
    });
  });
}
