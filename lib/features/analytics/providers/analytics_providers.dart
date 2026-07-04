import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/analytics/domain/analytics_calculator.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// Provides weekly alignment summaries (last 4 weeks).
final weeklyAnalyticsProvider =
    FutureProvider<List<WeeklySummary>>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  final entries = await repo.getAllEntries();
  return AnalyticsCalculator.calculateWeeklySummaries(entries: entries);
});

/// Provides monthly patterns analysis.
final monthlyPatternsProvider = FutureProvider<MonthlyPatterns>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  final now = DateTime.now();
  final thirtyDaysAgo = now.subtract(const Duration(days: 30));

  final allEntries = await repo.getAllEntries();
  final recentEntries = allEntries.where((e) {
    final date = DateTime.fromMillisecondsSinceEpoch(e.timestamp);
    return date.isAfter(thirtyDaysAgo);
  }).toList();

  return AnalyticsCalculator.calculateMonthlyPatterns(entries: recentEntries);
});

/// Provides extended streak insights.
final streakInsightsProvider = FutureProvider<StreakInsights>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  final dashData = await ref.watch(dashboardDataProvider.future);

  final entries = await repo.getAllEntries();
  return AnalyticsCalculator.calculateStreakInsights(
    entries: entries,
    currentStreak: dashData.streak.currentStreak,
    longestStreak: dashData.streak.longestStreak,
  );
});

/// Provides hold time progression data.
final holdTimeProgressionProvider =
    FutureProvider<HoldTimeProgression>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  final entries = await repo.getAllEntries();
  return AnalyticsCalculator.calculateHoldTimeProgression(entries: entries);
});

/// Provides CSV export string.
final csvExportProvider = FutureProvider<String>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  final entries = await repo.getAllEntries();
  return AnalyticsCalculator.generateCsv(entries);
});

/// Provides yama performance breakdown (sorted by count).
final yamaPerformanceProvider =
    FutureProvider<Map<String, int>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final entries = await db.select(db.saraKalaiJournal).get();

  final counts = <String, int>{
    'yama1': 0,
    'yama2': 0,
    'yama3': 0,
    'yama4': 0,
    'yama5': 0,
  };

  for (final entry in entries) {
    if (entry.activeYama != null && counts.containsKey(entry.activeYama)) {
      counts[entry.activeYama!] = counts[entry.activeYama!]! + 1;
    }
  }

  return counts;
});
