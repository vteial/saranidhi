import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/streaks/data/streak_repository.dart';
import 'package:saranidhi/features/streaks/domain/seven_day_ribbon.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';

/// Provides the [StreakRepository] instance.
final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return StreakRepository(db);
});

/// Combined dashboard data for the Home screen.
class DashboardData {
  const DashboardData({
    required this.streak,
    required this.trend,
    required this.ribbon,
    required this.yamaAccuracy,
  });

  final StreakResult streak;
  final TrendResult trend;
  final List<RibbonDay> ribbon;
  final YamaAccuracyResult yamaAccuracy;
}

/// Provides all dashboard data (streak, trend, ribbon, yama accuracy).
/// Auto-refreshes every 30 seconds.
final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final repo = ref.watch(streakRepositoryProvider);
  final today = DateTime.now();

  // Fetch last 30 days of summaries (covers both streak and trend)
  final summaries = await repo.getDailySummaries(days: 30, fromDate: today);

  // Calculate streak
  final streak = StreakCalculator.calculate(summaries: summaries, today: today);

  // Calculate 30-day trend
  final trend = TrendCalculator.calculate(summaries: summaries);

  // Generate 7-day ribbon
  final ribbon = SevenDayRibbon.generate(summaries: summaries, today: today);

  // Calculate Yama accuracy
  final yamaValues = await repo.getYamaValues(days: 30);
  final yamaAccuracy = TrendCalculator.calculateYamaAccuracy(yamaValues);

  // Auto-invalidate every 30 seconds for freshness
  final timer = Timer(const Duration(seconds: 30), () {
    ref.invalidateSelf();
  });
  ref.onDispose(timer.cancel);

  return DashboardData(
    streak: streak,
    trend: trend,
    ribbon: ribbon,
    yamaAccuracy: yamaAccuracy,
  );
});
