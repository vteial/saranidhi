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
      await tester.pumpAndSettle();

      // First launch should show onboarding
      expect(find.text('Welcome to Saranidhi'), findsOneWidget);
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
      await tester.pumpAndSettle();

      expect(find.text('Saranidhi'), findsOneWidget);
      expect(find.text('Last 7 Days'), findsOneWidget);
      expect(find.text('30-Day Trend'), findsOneWidget);
    });

    testWidgets('Navigation between all tabs works', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith(_AlwaysTrueNotifier.new),
          ],
          child: const SaranidhiApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Journal
      await tester.tap(find.text('Journal'));
      await tester.pumpAndSettle();
      expect(find.text('Breath Journal'), findsOneWidget);

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsWidgets);

      // Navigate back to Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Saranidhi'), findsOneWidget);
    });
  });
}

class _AlwaysTrueNotifier extends OnboardingCompleteNotifier {
  @override
  bool build() => true;
}
