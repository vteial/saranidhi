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
          currentStreak: 0,
          longestStreak: 0,
          isActiveToday: false,
        ),
        trend: const TrendResult(
          alignmentPercentage: 0,
          totalDaysWithEntries: 0,
          totalAlignedDays: 0,
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

  group('Settings Screen', () {
    testWidgets('navigates to settings and shows language section', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      // Navigate to Settings tab
      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('shows appearance section with theme brightness', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
    });

    testWidgets('shows color accent chips', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Color Accent'), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
      expect(find.text('Emerald'), findsOneWidget);
      expect(find.text('Gold'), findsOneWidget);
      expect(find.text('Purple'), findsOneWidget);
    });

    testWidgets('shows clear all data option', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Scroll to find Clear All Data
      await tester.scrollUntilVisible(
        find.text('Clear All Data'),
        200,
        scrollable: find.byType(Scrollable).last,
      );

      expect(find.text('Clear All Data'), findsOneWidget);
    });

    testWidgets('shows notifications section', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Notifications'), findsOneWidget);
    });
  });
}

class _AlwaysTrueNotifier extends OnboardingCompleteNotifier {
  @override
  bool build() => true;
}
