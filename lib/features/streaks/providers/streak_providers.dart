import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/utils/timezone_utils.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/tattva_calculator.dart';
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
    this.activeHora,
    this.activeTattva,
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

  /// Current active planetary hour (Hora).
  final HoraResult? activeHora;

  /// Current active element (Tattva).
  final TattvaResult? activeTattva;
}

/// The currently selected date for the dashboard.
///
/// Defaults to today. Changed by the date picker on the Home screen.
/// When changed, the dashboardDataProvider recalculates for that date.
final selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  // Notifier requires a method (not setter) because there's no corresponding getter.
  // ignore: use_setters_to_change_properties
  void select(DateTime newDate) => state = newDate;

  void addDays(int days) => state = state.add(Duration(days: days));
}

/// Whether the selected date is today.
final isViewingTodayProvider = Provider<bool>((ref) {
  final selected = ref.watch(selectedDateProvider);
  final now = DateTime.now();
  return selected.year == now.year &&
      selected.month == now.month &&
      selected.day == now.day;
});

/// Provides all dashboard data (streak, trend, ribbon, yama accuracy, astro).
/// Auto-refreshes every 30 seconds when viewing today.
final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final repo = ref.watch(streakRepositoryProvider);
  final db = ref.watch(appDatabaseProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final isToday = ref.watch(isViewingTodayProvider);
  final now = DateTime.now();

  // Fetch last 30 days of summaries (covers both streak and trend)
  final summaries = await repo.getDailySummaries(days: 30, fromDate: now);

  // Calculate streak (always from actual today)
  final streak = StreakCalculator.calculate(summaries: summaries, today: now);

  // Calculate 30-day trend
  final trend = TrendCalculator.calculate(summaries: summaries);

  // Generate 7-day ribbon
  final ribbon = SevenDayRibbon.generate(summaries: summaries, today: now);

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

  final utcOffset = TimezoneUtils.offsetForLocation(
    latitude: lat,
    longitude: lng,
  );

  // Calculate sunrise/sunset for the selected date
  final sunResult = SunriseCalculator.calculate(
    date: selectedDate,
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

    // Active yama only when viewing today
    if (isToday) {
      activeYamaSegment = yamaResult.activeYama(now);
    }

    // Calculate Pakshi day result
    final weekday = PakshiCalculator.dartWeekdayToSunBased(
      selectedDate.weekday,
    );
    lunarPhase = LunarPhaseCalculator.phaseForDate(selectedDate);
    pakshiDay = PakshiCalculator.calculate(
      weekday: weekday,
      lunarPhase: lunarPhase,
    );

    // Get birth bird state for current/active yama
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

    // ─── Night Yama calculations ──────────────────────────────────────
    if (isToday && now.isAfter(sunResult.sunset)) {
      isNight = true;
      final tomorrow = now.add(const Duration(days: 1));
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
        activeNightYama = nightYamaResult.activeYama(now);

        pakshiNight = PakshiCalculator.calculateNight(
          weekday: weekday,
          lunarPhase: lunarPhase,
        );

        if (birthBird != null && activeNightYama != null) {
          birthBirdNightState = pakshiNight.stateTable[birthBird.index]
              [activeNightYama.index.index];
        }
      }
    } else if (isToday && now.isBefore(sunResult.sunrise)) {
      isNight = true;
      final yesterday = now.subtract(const Duration(days: 1));
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
        activeNightYama = nightYamaResult.activeYama(now);

        final yesterdayWeekday = PakshiCalculator.dartWeekdayToSunBased(
          yesterday.weekday,
        );
        final yesterdayLunarPhase = LunarPhaseCalculator.phaseForDate(
          yesterday,
        );
        pakshiNight = PakshiCalculator.calculateNight(
          weekday: yesterdayWeekday,
          lunarPhase: yesterdayLunarPhase,
        );

        if (birthBird != null && activeNightYama != null) {
          birthBirdNightState = pakshiNight.stateTable[birthBird.index]
              [activeNightYama.index.index];
        }
      }
    } else {
      // Daytime today or non-today dates: always compute night schedule
      // for display (no active yama highlighted during daytime)
      final nextDay = selectedDate.add(const Duration(days: 1));
      final nextDaySunResult = SunriseCalculator.calculate(
        date: nextDay,
        latitude: lat,
        longitude: lng,
        utcOffset: utcOffset,
      );

      if (nextDaySunResult != null) {
        nightYamaResult = YamaCalculator.calculateNight(
          sunset: sunResult.sunset,
          nextSunrise: nextDaySunResult.sunrise,
        );

        final weekdayForNight = PakshiCalculator.dartWeekdayToSunBased(
          selectedDate.weekday,
        );
        pakshiNight = PakshiCalculator.calculateNight(
          weekday: weekdayForNight,
          lunarPhase: lunarPhase,
        );
      }
    }
  }

  // ─── Hold time average for selected date ─────────────────────────────
  final dayStart = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
  );
  final dayStartMs = dayStart.millisecondsSinceEpoch;
  final dayEndMs = dayStart.add(const Duration(days: 1)).millisecondsSinceEpoch;

  final dayEntries = await (db.select(db.saraKalaiJournal)
        ..where(
          (t) =>
              t.timestamp.isBiggerOrEqualValue(dayStartMs) &
              t.timestamp.isSmallerThanValue(dayEndMs),
        ))
      .get();

  todayEntryCount = dayEntries.length;

  final holdValues = dayEntries
      .where((e) => e.holdDurationMs != null && e.holdDurationMs! > 0)
      .map((e) => e.holdDurationMs!.toDouble())
      .toList();

  if (holdValues.isNotEmpty) {
    todayAvgHoldMs = holdValues.reduce((a, b) => a + b) / holdValues.length;
  }

  // Auto-invalidate every 30 seconds when viewing today
  if (isToday) {
    final timer = Timer(const Duration(seconds: 30), () {
      ref.invalidateSelf();
    });
    ref.onDispose(timer.cancel);
  }

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
    activeHora: _computeHora(
      now: now,
      isToday: isToday,
      sunrise: sunrise,
      sunset: sunset,
      lat: lat,
      lng: lng,
      utcOffset: utcOffset,
      selectedDate: selectedDate,
    ),
    activeTattva: _computeTattva(
      now: now,
      isToday: isToday,
      activeYama: activeYamaSegment,
    ),
  );
});



/// Computes the active Hora for the current time (only when viewing today).
HoraResult? _computeHora({
  required DateTime now,
  required bool isToday,
  required DateTime? sunrise,
  required DateTime? sunset,
  required double lat,
  required double lng,
  required double utcOffset,
  required DateTime selectedDate,
}) {
  if (!isToday || sunrise == null || sunset == null) return null;

  // Need next sunrise for night hora calculation
  final tomorrow = now.add(const Duration(days: 1));
  final tomorrowSun = SunriseCalculator.calculate(
    date: tomorrow,
    latitude: lat,
    longitude: lng,
    utcOffset: utcOffset,
  );
  if (tomorrowSun == null) return null;

  final weekday = PakshiCalculator.dartWeekdayToSunBased(
    selectedDate.weekday,
  );

  return HoraCalculator.activeHora(
    time: now,
    sunrise: sunrise,
    sunset: sunset,
    nextSunrise: tomorrowSun.sunrise,
    weekday: weekday,
  );
}

/// Computes the active Tattva for the current time (only when viewing today).
TattvaResult? _computeTattva({
  required DateTime now,
  required bool isToday,
  required YamaSegment? activeYama,
}) {
  if (!isToday || activeYama == null) return null;
  return TattvaCalculator.activeTattva(time: now, yamaSegment: activeYama);
}
