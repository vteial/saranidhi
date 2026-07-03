import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/full_day_schedule.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

import '../../../helpers/pump_app.dart';

void main() {
  final now = DateTime.now();
  final baseData = DashboardData(
    streak: const StreakResult(currentStreak: 0, longestStreak: 0, isActiveToday: false),
    trend: const TrendResult(alignmentPercentage: 0, totalDaysWithEntries: 0, totalAlignedDays: 0, periodDays: 30),
    ribbon: [],
    yamaAccuracy: const YamaAccuracyResult(yamaEntries: {}, totalEntries: 0),
  );

  group('FullDaySchedule', () {
    testWidgets('renders daytime yama rows', (tester) async {
      final yamaResult = YamaCalculator.calculate(
        sunrise: now.subtract(const Duration(hours: 6)),
        sunset: now.add(const Duration(hours: 6)),
      );
      final pakshiDay = PakshiCalculator.calculate(weekday: 0, lunarPhase: LunarPhase.waxing);

      final data = baseData.copyWith(
        birthBird: PakshiBird.vulture,
        pakshiDay: pakshiDay,
        yamaResult: yamaResult,
        activeYama: yamaResult.yamas[2],
      );

      await tester.pumpApp(FullDaySchedule(data: data));

      expect(find.textContaining('Y1'), findsOneWidget);
      expect(find.textContaining('Y5'), findsOneWidget);
      expect(find.textContaining('NOW'), findsOneWidget);
    });

    testWidgets('renders nighttime yama rows when provided', (tester) async {
      final yamaResult = YamaCalculator.calculate(
        sunrise: now.subtract(const Duration(hours: 6)),
        sunset: now.add(const Duration(hours: 6)),
      );
      final nightYamaResult = YamaCalculator.calculateNight(
        sunset: now.add(const Duration(hours: 6)),
        nextSunrise: now.add(const Duration(hours: 18)),
      );
      final pakshiDay = PakshiCalculator.calculate(weekday: 0, lunarPhase: LunarPhase.waxing);
      final pakshiNight = PakshiCalculator.calculateNight(weekday: 0, lunarPhase: LunarPhase.waxing);

      final data = baseData.copyWith(
        birthBird: PakshiBird.vulture,
        pakshiDay: pakshiDay,
        yamaResult: yamaResult,
        nightYamaResult: nightYamaResult,
        pakshiNight: pakshiNight,
      );

      await tester.pumpApp(FullDaySchedule(data: data));

      expect(find.textContaining('Y6'), findsOneWidget);
      expect(find.textContaining('Y10'), findsOneWidget);
      expect(find.textContaining('Night Yamas'), findsOneWidget);
    });
  });
}

extension on DashboardData {
  DashboardData copyWith({
    PakshiBird? birthBird,
    PakshiDayResult? pakshiDay,
    YamaResult? yamaResult,
    YamaSegment? activeYama,
    NightYamaResult? nightYamaResult,
    PakshiDayResult? pakshiNight,
  }) {
    return DashboardData(
      streak: streak,
      trend: trend,
      ribbon: ribbon,
      yamaAccuracy: yamaAccuracy,
      birthBird: birthBird ?? this.birthBird,
      pakshiDay: pakshiDay ?? this.pakshiDay,
      yamaResult: yamaResult ?? this.yamaResult,
      activeYama: activeYama ?? this.activeYama,
      nightYamaResult: nightYamaResult ?? this.nightYamaResult,
      pakshiNight: pakshiNight ?? this.pakshiNight,
    );
  }
}
