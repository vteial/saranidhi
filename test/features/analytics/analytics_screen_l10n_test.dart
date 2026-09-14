import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/analytics/domain/analytics_calculator.dart';
import 'package:saranidhi/features/analytics/presentation/analytics_screen.dart';
import 'package:saranidhi/features/analytics/providers/analytics_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

import '../../helpers/widget_test_helpers.dart';

Widget testableScreen(
  Widget child, {
  dynamic overrides,
  Locale locale = const Locale('en'),
}) {
  final widget = MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: child,
  );

  if (overrides != null) {
    return ProviderScope(
      overrides: overrides is List<dynamic> ? overrides.cast() : [overrides],
      child: widget,
    );
  }

  return ProviderScope(child: widget);
}

void main() {
  final sampleWeekly = <WeeklySummary>[
    WeeklySummary(
      weekStart: DateTime(2026, 9, 7),
      weekEnd: DateTime(2026, 9, 13),
      totalEntries: 10,
      alignedEntries: 8,
      daysWithEntries: 5,
    ),
  ];

  const sampleMonthly = MonthlyPatterns(
    bestDayWeekday: 7,
    worstDayWeekday: 2,
    mostActiveYama: 'yama1',
    leastActiveYama: 'yama5',
    totalEntries: 20,
    totalAligned: 15,
    avgEntriesPerDay: 2.5,
    activeDays: 8,
  );

  const sampleStreak = StreakInsights(
    currentStreak: 5,
    longestStreak: 12,
    totalPracticeDays: 20,
    totalDaysSinceFirst: 30,
    averageGapDays: 0.5,
    practiceConsistency: 85,
  );

  final sampleYama = {'yama1': 5, 'yama2': 3};

  final sampleHold = HoldTimeProgression(
    dailyAverages: const [],
    weeklyAverage: 12000,
    monthlyAverage: 11000,
    allTimeAverage: 10000,
    personalBestMs: 15000,
    personalBestDate: DateTime(2026, 9, 10),
    trendDirection: TrendDirection.improving,
    totalSessions: 15,
  );

  List<dynamic> createOverrides() => [
    weeklyAnalyticsProvider.overrideWith((ref) async => sampleWeekly),
    monthlyPatternsProvider.overrideWith((ref) async => sampleMonthly),
    streakInsightsProvider.overrideWith((ref) async => sampleStreak),
    yamaPerformanceProvider.overrideWith((ref) async => sampleYama),
    holdTimeProgressionProvider.overrideWith((ref) async => sampleHold),
  ];

  group('AnalyticsScreen Localization', () {
    testWidgets('renders English prefix "Y" and unit suffixes in en locale', (
      tester,
    ) async {
      await tester.pumpWidget(
        testableScreen(
          const AnalyticsScreen(),
          locale: const Locale('en'),
          overrides: createOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Monthly patterns weekday localization in en locale
      expect(find.text('Sunday'), findsOneWidget);
      expect(find.text('Tuesday'), findsOneWidget);

      // Yama performance renders 'Y1' and 'Y2'
      expect(find.text('Y1'), findsOneWidget);
      expect(find.text('Y2'), findsOneWidget);

      // Streak insights unit suffix 'd'
      expect(find.text('5d'), findsOneWidget);
      expect(find.text('12d'), findsOneWidget);

      // Hold time progression unit suffix 's'
      expect(find.text('12.0s'), findsOneWidget);
      expect(find.text('11.0s'), findsOneWidget);
      expect(find.text('15.0s'), findsOneWidget);

      // Verify ExportCard is NOT present
      expect(find.text('Export as CSV'), findsNothing);
      expect(find.text('Export Data'), findsNothing);
    });

    testWidgets(
      'renders Tamil prefix "யா" and Tamil unit suffixes in ta locale',
      (tester) async {
        await tester.pumpWidget(
          testableScreen(
            const AnalyticsScreen(),
            locale: const Locale('ta'),
            overrides: createOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        // Monthly patterns weekday localization in ta locale (Tamil script)
        expect(find.text('ஞாயிறு'), findsOneWidget);
        expect(find.text('செவ்வாய்'), findsOneWidget);
        expect(find.text('Sunday'), findsNothing);
        expect(find.text('Tuesday'), findsNothing);

        // Yama performance renders 'யா1' and 'யா2' without bare English 'Y1'/'Y2'
        expect(find.text('யா1'), findsOneWidget);
        expect(find.text('யா2'), findsOneWidget);
        expect(find.text('Y1'), findsNothing);
        expect(find.text('Y2'), findsNothing);

        // Streak insights unit suffix 'நா'
        expect(find.text('5நா'), findsOneWidget);
        expect(find.text('12நா'), findsOneWidget);

        // Hold time progression unit suffix 'வி'
        expect(find.text('12.0வி'), findsOneWidget);
        expect(find.text('11.0வி'), findsOneWidget);
        expect(find.text('15.0வி'), findsOneWidget);

        // Verify ExportCard is NOT present
        expect(find.text('CSV ஆக ஏற்றுமதி'), findsNothing);
        expect(find.text('தரவு ஏற்றுமதி'), findsNothing);
      },
    );
  });
}
