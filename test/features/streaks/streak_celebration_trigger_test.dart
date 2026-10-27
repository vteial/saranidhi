import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/chronobiology/domain/chronobiology_analytics.dart';
import 'package:saranidhi/features/home/presentation/today_tab.dart';
import 'package:saranidhi/features/streaks/domain/seven_day_ribbon.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/seven_day_ribbon_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/streak_celebration.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  DashboardData buildDashboardData(int streak) {
    return DashboardData(
      streak: StreakResult(
        currentStreak: streak,
        longestStreak: streak,
        isActiveToday: true,
      ),
      trend: const TrendResult(
        alignmentPercentage: 100,
        totalDaysWithEntries: 7,
        totalAlignedDays: 7,
        periodDays: 30,
      ),
      ribbon: SevenDayRibbon.generate(summaries: [], today: DateTime.now()),
      yamaAccuracy: const YamaAccuracyResult(
        yamaEntries: {},
        totalEntries: 0,
      ),
    );
  }

  setUp(() {
    resetCelebratedMilestoneCache();
  });

  group('StreakCelebration Trigger (R3 / T3)', () {
    testWidgets('fires celebration once when streak reaches milestone 7', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataProvider.overrideWith((ref) async => buildDashboardData(7)),
            latestJournalEntryProvider.overrideWith((ref) => Stream.value(null)),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: TodayTab()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Celebration dialog is shown
      expect(find.byType(StreakCelebrationOverlay), findsOneWidget);
      expect(find.text('7-Day Streak!'), findsOneWidget);

      // Verify persisted marker
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(lastCelebratedStreakMilestoneKey), equals(7));

      // Allow auto-dismiss timer to complete
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('does NOT fire when streak is not a milestone (e.g. 6)', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataProvider.overrideWith((ref) async => buildDashboardData(6)),
            latestJournalEntryProvider.overrideWith((ref) => Stream.value(null)),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: TodayTab()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StreakCelebrationOverlay), findsNothing);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(lastCelebratedStreakMilestoneKey), isNull);
    });

    testWidgets('does NOT re-fire on relaunch or rebuild at already-passed milestone', (
      tester,
    ) async {
      // Milestone 7 was already celebrated
      SharedPreferences.setMockInitialValues({
        lastCelebratedStreakMilestoneKey: 7,
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataProvider.overrideWith((ref) async => buildDashboardData(7)),
            latestJournalEntryProvider.overrideWith((ref) => Stream.value(null)),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: TodayTab()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should NOT show celebration because 7 is not > stored 7
      expect(find.byType(StreakCelebrationOverlay), findsNothing);
    });
  });
}
