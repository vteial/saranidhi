import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';
import 'package:saranidhi/features/streaks/domain/seven_day_ribbon.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/main.dart';

void main() {
  final testOverrides = [
    onboardingCompleteProvider.overrideWith(_AlwaysTrueNotifier.new),
    journalEntriesProvider.overrideWith(
      (ref) => Stream.value(<SaraKalaiJournalData>[]),
    ),
    dashboardDataProvider.overrideWith((ref) async {
      return DashboardData(
        streak: const StreakResult(
          currentStreak: 2,
          longestStreak: 5,
          isActiveToday: true,
        ),
        trend: const TrendResult(
          alignmentPercentage: 50,
          totalDaysWithEntries: 10,
          totalAlignedDays: 5,
          periodDays: 30,
        ),
        ribbon: SevenDayRibbon.generate(summaries: [], today: DateTime.now()),
        yamaAccuracy: const YamaAccuracyResult(
          yamaEntries: {
            'yama1': 0,
            'yama2': 0,
            'yama3': 0,
            'yama4': 0,
            'yama5': 0,
          },
          totalEntries: 0,
        ),
      );
    }),
  ];

  group('Navigation', () {
    testWidgets('H-01: bottom nav shows Home, Journal, Settings', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Journal'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('H-02: tap Journal tab navigates to journal', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Journal'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Breath Journal'), findsOneWidget);
    });

    testWidgets('H-03: tap Settings tab navigates to settings', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Settings title appears in app bar
      expect(find.text('Settings'), findsWidgets);
    });

    testWidgets('H-05: back to Home preserves state', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      // Go to Journal
      await tester.tap(find.text('Journal'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Breath Journal'), findsOneWidget);

      // Back to Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // Dashboard data should still be visible
      expect(find.text('2 days'), findsOneWidget);
    });

    testWidgets('initial route is Home tab', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      // Home content is visible
      expect(find.text('Saranidhi'), findsOneWidget);
      expect(find.text('2 days'), findsOneWidget);
    });
  });
}

class _AlwaysTrueNotifier extends OnboardingCompleteNotifier {
  @override
  bool build() => true;
}
