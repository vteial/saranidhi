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
    onboardingCompleteProvider.overrideWith(() => _AlwaysTrueNotifier()),
    journalEntriesProvider.overrideWith(
      (ref) => Stream.value(<SaraKalaiJournalData>[]),
    ),
    dashboardDataProvider.overrideWith((ref) async {
      return DashboardData(
        streak: const StreakResult(
          currentStreak: 3,
          longestStreak: 5,
          isActiveToday: true,
        ),
        trend: const TrendResult(
          alignmentPercentage: 75,
          totalDaysWithEntries: 8,
          totalAlignedDays: 6,
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

  testWidgets('App renders with bottom navigation and dashboard', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
    );
    await tester.pumpAndSettle();

    // Verify bottom navigation tabs are present (Home, Journal, Analytics)
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Journal'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);

    // Verify Settings gear icon is in app bar (top-right)
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // Verify home screen shows dashboard title
    expect(find.text('Saranidhi'), findsOneWidget);

    // Verify Today sub-tab is visible (default tab)
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);

    // Verify Today tab shows streak and ribbon (cards on Today tab)
    expect(find.text('3 days'), findsOneWidget); // streak
    expect(find.text('Last 7 Days'), findsOneWidget); // ribbon header
  });

  testWidgets('Navigation between tabs works', (tester) async {
    await tester.pumpWidget(
      ProviderScope(overrides: testOverrides, child: const SaranidhiApp()),
    );
    await tester.pumpAndSettle();

    // Navigate to Journal tab
    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();
    expect(find.text('Breath Journal'), findsOneWidget);

    // Navigate to Settings via gear icon
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    // Go back from Settings
    await tester.tap(find.byType(BackButton).first);
    await tester.pumpAndSettle();

    // Navigate to Home tab
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    // Verify Today tab content is still visible
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('3 days'), findsOneWidget);
  });
}

class _AlwaysTrueNotifier extends OnboardingCompleteNotifier {
  @override
  bool build() => true;
}
