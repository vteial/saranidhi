import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/streaks/domain/seven_day_ribbon.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Wraps a widget in MaterialApp with localizations for isolated widget testing.
Widget testableWidget(Widget child, {List<Override> overrides = const []}) {
  final widget = MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  if (overrides.isNotEmpty) {
    return ProviderScope(overrides: overrides, child: widget);
  }
  return widget;
}

/// Creates a minimal DashboardData with sensible defaults for testing.
DashboardData createTestDashboardData({
  StreakResult? streak,
  TrendResult? trend,
  List<RibbonDay>? ribbon,
  YamaAccuracyResult? yamaAccuracy,
  PakshiBird? birthBird,
  PakshiState? birthBirdState,
  PakshiDayResult? pakshiDay,
  YamaResult? yamaResult,
  YamaSegment? activeYama,
  RahuKaalResult? rahuKaal,
  LunarPhase? lunarPhase,
  double? todayAvgHoldMs,
  int todayEntryCount = 0,
  DateTime? sunrise,
  DateTime? sunset,
  NightYamaResult? nightYamaResult,
  NightYamaSegment? activeNightYama,
  PakshiDayResult? pakshiNight,
  PakshiState? birthBirdNightState,
  bool isNight = false,
}) {
  return DashboardData(
    streak: streak ??
        const StreakResult(
          currentStreak: 3,
          longestStreak: 7,
          isActiveToday: true,
        ),
    trend: trend ??
        const TrendResult(
          alignmentPercentage: 75,
          totalDaysWithEntries: 10,
          totalAlignedDays: 8,
          periodDays: 30,
        ),
    ribbon: ribbon ?? _defaultRibbon(),
    yamaAccuracy: yamaAccuracy ??
        const YamaAccuracyResult(
          yamaEntries: {
            'yama1': 5,
            'yama2': 3,
            'yama3': 7,
            'yama4': 2,
            'yama5': 1,
          },
          totalEntries: 18,
        ),
    birthBird: birthBird,
    birthBirdState: birthBirdState,
    pakshiDay: pakshiDay,
    yamaResult: yamaResult,
    activeYama: activeYama,
    rahuKaal: rahuKaal,
    lunarPhase: lunarPhase,
    todayAvgHoldMs: todayAvgHoldMs,
    todayEntryCount: todayEntryCount,
    sunrise: sunrise,
    sunset: sunset,
    nightYamaResult: nightYamaResult,
    activeNightYama: activeNightYama,
    pakshiNight: pakshiNight,
    birthBirdNightState: birthBirdNightState,
    isNight: isNight,
  );
}

/// Creates a YamaResult with 5 yamas for a given sunrise/sunset.
YamaResult createTestYamaResult({
  DateTime? sunrise,
  DateTime? sunset,
}) {
  final sr = sunrise ?? DateTime(2026, 7, 5, 6, 0);
  final ss = sunset ?? DateTime(2026, 7, 5, 18, 30);
  return YamaCalculator.calculate(sunrise: sr, sunset: ss);
}

/// Creates a RahuKaalResult for testing.
RahuKaalResult createTestRahuKaal({
  DateTime? start,
  DateTime? end,
}) {
  return RahuKaalResult(
    start: start ?? DateTime(2026, 7, 5, 9, 0),
    end: end ?? DateTime(2026, 7, 5, 10, 30),
  );
}

List<RibbonDay> _defaultRibbon() {
  final today = DateTime.now();
  return List.generate(7, (i) {
    final date = today.subtract(Duration(days: 6 - i));
    return RibbonDay(
      date: date,
      status: i < 5 ? DayStatus.aligned : DayStatus.noEntry,
      dayLabel: ['S', 'M', 'T', 'W', 'T', 'F', 'S'][date.weekday % 7],
    );
  });
}
