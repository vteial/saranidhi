import 'package:flutter/material.dart';
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
          currentStreak: 7,
          longestStreak: 14,
          isActiveToday: true,
        ),
        trend: const TrendResult(
          alignmentPercentage: 85,
          totalDaysWithEntries: 20,
          totalAlignedDays: 17,
          periodDays: 30,
        ),
        ribbon: SevenDayRibbon.generate(summaries: [], today: DateTime.now()),
        yamaAccuracy: const YamaAccuracyResult(
          yamaEntries: {
            'yama1': 5,
            'yama2': 3,
            'yama3': 4,
            'yama4': 2,
            'yama5': 1,
          },
          totalEntries: 15,
        ),
      );
    }),
  ];

  group('Home Screen', () {
    testWidgets('displays streak data', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('7 days'), findsOneWidget);
    });

    testWidgets('displays 30-day trend section', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('30-Day Trend'), findsOneWidget);
    });

    testWidgets('displays 7-day ribbon section', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Last 7 Days'), findsOneWidget);
    });

    testWidgets('dashboard content is scrollable', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      // Dashboard uses SingleChildScrollView wrapped in RefreshIndicator
      // Verify scrollable content exists
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('pull-to-refresh indicator exists', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      // The RefreshIndicator should be in the widget tree
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}

class _AlwaysTrueNotifier extends OnboardingCompleteNotifier {
  @override
  bool build() => true;
}
