import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
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
    this.birthBird,
    this.birthBirdState,
    this.pakshiDay,
    this.yamaResult,
    this.activeYama,
    this.rahuKaal,
    this.lunarPhase,
    this.todayAvgHoldMs,
    this.todayEntryCount = 0,
    this.sunrise,
    this.sunset,
    this.nightYamaResult,
    this.activeNightYama,
    this.pakshiNight,
    this.birthBirdNightState,
    this.isNight = false,
  });

  final StreakResult streak;
  final TrendResult trend;
  final List<RibbonDay> ribbon;
  final YamaAccuracyResult yamaAccuracy;

  /// User's birth bird from profile.
  final PakshiBird? birthBird;

  /// Current state of user's birth bird.
  final PakshiState? birthBirdState;

  /// Full day Pakshi result.
  final PakshiDayResult? pakshiDay;

  /// All 5 yamas for today.
  final YamaResult? yamaResult;

  /// Current active yama.
  final YamaSegment? activeYama;

  /// Rahu Kaal window.
  final RahuKaalResult? rahuKaal;

  /// Current lunar phase.
  final LunarPhase? lunarPhase;

  /// Today's average hold duration (ms).
  final double? todayAvgHoldMs;

  /// Number of entries today.
  final int todayEntryCount;

  /// Today's sunrise time.
  final DateTime? sunrise;

  /// Today's sunset time.
  final DateTime? sunset;

  /// Night yama calculation result (sunset to next sunrise).
  final NightYamaResult? nightYamaResult;

  /// Current active night yama (if currently nighttime).
  final NightYamaSegment? activeNightYama;

  /// Night Pakshi result (bird states for nighttime).
  final PakshiDayResult? pakshiNight;

  /// Birth bird state for current night yama.
  final PakshiState? birthBirdNightState;

  /// Whether current time is after sunset (nighttime).
  final bool isNight;
}

/// Provides all dashboard data (streak, trend, ribbon, yama accuracy, astro).
/// Auto-refreshes every 30 seconds.
final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final repo = ref.watch(streakRepositoryProvider);
  final db = ref.watch(appDatabaseProvider);
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

  // ─── Astro calculations ─────────────────────────────────────────────
  PakshiBird? birthBird;
  PakshiState? birthBirdState;
  PakshiDayResult? pakshiDay;
  YamaResult? yamaResult;
  YamaSegment? activeYamaSegment;
  RahuKaalResult? rahuKaal;
  LunarPhase? lunarPhase;
  double? todayAvgHoldMs;
  var todayEntryCount = 0;
  DateTime? sunrise;
  DateTime? sunset;
  NightYamaResult? nightYamaResult;
  NightYamaSegment? activeNightYama;
  PakshiDayResult? pakshiNight;
  PakshiState? birthBirdNightState;
  var isNight = false;

  // Read profile for birth bird and location
  var lat = 13.08; // Default: Chennai
  var lng = 80.27;
  const utcOffset = 5.5;

  final profiles = await db.select(db.profiles).get();
  if (profiles.isNotEmpty) {
    final profile = profiles.first;
    if (profile.birthBird != null) {
      birthBird = PakshiBird.values.where(
        (b) => b.name == profile.birthBird,
      ).firstOrNull;
    }
    if (profile.locationLat != null) lat = profile.locationLat!;
    if (profile.locationLng != null) lng = profile.locationLng!;
  }

  // Calculate sunrise/sunset
  final sunResult = SunriseCalculator.calculate(
    date: today,
    latitude: lat,
    longitude: lng,
    utcOffset: utcOffset,
  );

  if (sunResult != null) {
    sunrise = sunResult.sunrise;
    sunset = sunResult.sunset;

    // Calculate yamas
    yamaResult = YamaCalculator.calculate(
      sunrise: sunResult.sunrise,
      sunset: sunResult.sunset,
    );
    activeYamaSegment = yamaResult.activeYama(today);

    // Calculate Pakshi day result
    final weekday = PakshiCalculator.dartWeekdayToSunBased(today.weekday);
    lunarPhase = LunarPhaseCalculator.phaseForDate(today);
    pakshiDay = PakshiCalculator.calculate(
      weekday: weekday,
      lunarPhase: lunarPhase,
    );

    // Get birth bird state for current yama
    if (birthBird != null && activeYamaSegment != null) {
      birthBirdState = pakshiDay.stateForBird(
        birthBird,
        activeYamaSegment.index,
      );
    }

    // Calculate Rahu Kaal
    rahuKaal = RahuKaalCalculator.calculate(
      sunrise: sunResult.sunrise,
      sunset: sunResult.sunset,
      weekday: weekday,
    );

    // ─── Night Yama calculations ────────────────────────────────────────
    if (today.isAfter(sunResult.sunset)) {
      isNight = true;
      // Calculate next sunrise (tomorrow)
      final tomorrow = today.add(const Duration(days: 1));
      final tomorrowSunResult = SunriseCalculator.calculate(
        date: tomorrow,
        latitude: lat,
        longitude: lng,
        utcOffset: utcOffset,
      );

      if (tomorrowSunResult != null) {
        nightYamaResult = YamaCalculator.calculateNight(
          sunset: sunResult.sunset,
          nextSunrise: tomorrowSunResult.sunrise,
        );
        activeNightYama = nightYamaResult!.activeYama(today);

        // Calculate night Pakshi
        pakshiNight = PakshiCalculator.calculateNight(
          weekday: weekday,
          lunarPhase: lunarPhase,
        );

        // Get birth bird night state for current night yama
        if (birthBird != null && activeNightYama != null) {
          birthBirdNightState = pakshiNight!.stateTable[birthBird.index]
              [activeNightYama!.index.index];
        }
      }
    } else if (today.isBefore(sunResult.sunrise)) {
      // Before sunrise — still nighttime from previous day's sunset
      isNight = true;
      final yesterday = today.subtract(const Duration(days: 1));
      final yesterdaySunResult = SunriseCalculator.calculate(
        date: yesterday,
        latitude: lat,
        longitude: lng,
        utcOffset: utcOffset,
      );

      if (yesterdaySunResult != null) {
        nightYamaResult = YamaCalculator.calculateNight(
          sunset: yesterdaySunResult.sunset,
          nextSunrise: sunResult.sunrise,
        );
        activeNightYama = nightYamaResult!.activeYama(today);

        // Use yesterday's weekday for night Pakshi
        final yesterdayWeekday = PakshiCalculator.dartWeekdayToSunBased(
          yesterday.weekday,
        );
        final yesterdayLunarPhase = LunarPhaseCalculator.phaseForDate(yesterday);
        pakshiNight = PakshiCalculator.calculateNight(
          weekday: yesterdayWeekday,
          lunarPhase: yesterdayLunarPhase,
        );

        if (birthBird != null && activeNightYama != null) {
          birthBirdNightState = pakshiNight!.stateTable[birthBird.index]
              [activeNightYama!.index.index];
        }
      }
    }
  }

  // ─── Today's hold time average ──────────────────────────────────────
  final todayStart = DateTime(today.year, today.month, today.day);
  final todayStartMs = todayStart.millisecondsSinceEpoch;

  final todayEntries = await (db.select(db.saraKalaiJournal)
        ..where((t) => t.timestamp.isBiggerOrEqualValue(todayStartMs)))
      .get();

  todayEntryCount = todayEntries.length;

  final holdValues = todayEntries
      .where((e) => e.holdDurationMs != null && e.holdDurationMs! > 0)
      .map((e) => e.holdDurationMs!.toDouble())
      .toList();

  if (holdValues.isNotEmpty) {
    todayAvgHoldMs = holdValues.reduce((a, b) => a + b) / holdValues.length;
  }

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
    birthBird: birthBird,
    birthBirdState: birthBirdState,
    pakshiDay: pakshiDay,
    yamaResult: yamaResult,
    activeYama: activeYamaSegment,
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
});
