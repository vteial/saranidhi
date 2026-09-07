import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';
import 'package:saranidhi/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Shell E2E', () {
    testWidgets('App launches and shows onboarding on first run', (
      tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: SaranidhiApp()));
      // Stream-based providers never quiesce, so pumpAndSettle would time out.
      // Pump once to build, then advance a frame for async init to surface.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // First launch should show intro screen (pre-onboarding)
      expect(find.text('The Treasure House of Breath'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('App shows dashboard when onboarding complete', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith(_AlwaysTrueNotifier.new),
          ],
          child: const SaranidhiApp(),
        ),
      );
      // Only onboardingCompleteProvider is overridden here, so the real
      // dashboardDataProvider runs against an empty DB. Use pump() (not
      // pumpAndSettle) and assert only on stable, always-present shell UI —
      // never on async-loaded card content like the 7-day ribbon.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Saranidhi'), findsOneWidget); // l10n.dashboardTitle
      expect(find.text('Today'), findsOneWidget); // l10n.todayTab
      expect(find.text('Explore'), findsOneWidget); // l10n.exploreTab
    });

    // Sprint 36 (Task 36.1): un-skipped after fixing the stream-settling issue.
    // Uses pump() + pump(Duration(seconds:1)) for every navigation step (never
    // pumpAndSettle, which times out on the app's active stream providers) and
    // asserts on stable shell/screen titles rather than async card content.
    testWidgets('Navigation between all tabs works', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith(_AlwaysTrueNotifier.new),
          ],
          child: const SaranidhiApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Navigate to Journal
      await tester.tap(find.text('Journal'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Breath Journal'), findsOneWidget); // l10n.breathJournalTitle

      // Navigate to Settings via gear icon
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Settings'), findsOneWidget); // l10n.settingsTitle

      // Go back from Settings
      await tester.tap(find.byType(BackButton).first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Navigate back to Home and assert on the stable app bar title.
      await tester.tap(find.text('Home'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Saranidhi'), findsOneWidget); // l10n.dashboardTitle
    });
  });
}

class _AlwaysTrueNotifier extends OnboardingCompleteNotifier {
  @override
  bool build() => true;
}
