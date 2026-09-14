import 'package:flutter/foundation.dart';

import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// The expected swara (nostril) on the 1-hour / 24-cycle clock (CONF-014),
/// seeded at astronomical sunrise by the Weekday Udhaya rule (CONF-013 / CONF-001).
class SwaraClock {
  const SwaraClock._();

  /// Expected flow at [time] for a civil day whose dawn is [sunrise].
  ///
  /// [sunrise] is the astronomical sunrise of the civil day that CONTAINS [time]
  /// (sunrise-to-sunrise reckoning — see [anchorSunrise] / [anchorSunriseForLocation]).
  /// [paksha] is the lunar phase at that sunrise (only consulted for Thursday).
  ///
  /// Returns [BreathFlow.solar] (Right) or [BreathFlow.lunar] (Left).
  /// Never returns Sushumna (Sushumna is the ≤5-min transition, not a scheduled hour — CONF-014/026).
  static BreathFlow expectedFlowAt({
    required DateTime time,
    required DateTime sunrise,
    required LunarPhase paksha,
  }) {
    return blockAt(time: time, sunrise: sunrise, paksha: paksha).flow;
  }

  /// Converts Dart's [DateTime.weekday] (1=Mon … 7=Sun)
  /// to sun-based 1=Sun … 7=Sat convention (CONF-013).
  static int dartWeekdayToSunBased(int dartWeekday) => (dartWeekday % 7) + 1;

  /// The seed for the given civil day: the dawn nostril + Udhaya inception
  /// duration (1h or 2h) per CONF-013. Exposed for dashboard card + tests.
  ///
  /// [sunBasedWeekday] uses 1=Sun … 7=Sat (CONF-013 table).
  /// [paksha] is evaluated at astronomical sunrise (CONF-001).
  static SwaraSeed seedFor({
    required int sunBasedWeekday,
    required LunarPhase paksha,
  }) {
    return switch (sunBasedWeekday) {
      1 => const SwaraSeed(
        dawnFlow: BreathFlow.solar,
        inceptionHours: 1,
      ), // Sun: Right, 1h
      2 => const SwaraSeed(
        dawnFlow: BreathFlow.lunar,
        inceptionHours: 1,
      ), // Mon: Left, 1h
      3 => const SwaraSeed(
        dawnFlow: BreathFlow.solar,
        inceptionHours: 2,
      ), // Tue: Right, 2h
      4 => const SwaraSeed(
        dawnFlow: BreathFlow.lunar,
        inceptionHours: 2,
      ), // Wed: Left, 2h
      5 =>
        paksha == LunarPhase.waxing
            ? const SwaraSeed(
                dawnFlow: BreathFlow.lunar,
                inceptionHours: 1,
              ) // Thu Shukla: Left, 1h
            : const SwaraSeed(
                dawnFlow: BreathFlow.solar,
                inceptionHours: 2,
              ), // Thu Krishna: Right, 2h
      6 => const SwaraSeed(
        dawnFlow: BreathFlow.lunar,
        inceptionHours: 2,
      ), // Fri: Left, 2h
      7 => const SwaraSeed(
        dawnFlow: BreathFlow.solar,
        inceptionHours: 1,
      ), // Sat: Right, 1h (video governed)
      _ => const SwaraSeed(dawnFlow: BreathFlow.solar, inceptionHours: 1),
    };
  }

  /// Start of the current ~1h swara block that contains [time], and the next
  /// switch instant — powers the "next switch in N min" countdown on the card.
  static SwaraBlock blockAt({
    required DateTime time,
    required DateTime sunrise,
    required LunarPhase paksha,
  }) {
    final sunBasedWeekday = dartWeekdayToSunBased(sunrise.weekday);
    final seed = seedFor(sunBasedWeekday: sunBasedWeekday, paksha: paksha);
    final h = seed.inceptionHours;
    final inceptionEnd = sunrise.add(Duration(hours: h));

    if (time.isBefore(inceptionEnd)) {
      return SwaraBlock(flow: seed.dawnFlow, start: sunrise, end: inceptionEnd);
    }

    final elapsedSeconds = time.difference(sunrise).inSeconds;
    final elapsedHours = elapsedSeconds ~/ 3600;
    final blockStart = sunrise.add(Duration(hours: elapsedHours));
    final blockEnd = sunrise.add(Duration(hours: elapsedHours + 1));

    final n = elapsedHours - h;
    final oppositeFlow = seed.dawnFlow == BreathFlow.solar
        ? BreathFlow.lunar
        : BreathFlow.solar;
    final flow = n.isEven ? oppositeFlow : seed.dawnFlow;

    return SwaraBlock(flow: flow, start: blockStart, end: blockEnd);
  }

  /// Resolves the astronomical sunrise of the civil day containing [time].
  ///
  /// Under sunrise-to-sunrise civil day reckoning (CONF-001):
  /// - If [time] is at or after sunrise on its date, that sunrise anchors the day.
  /// - If [time] is before sunrise on its date (pre-dawn, post-midnight),
  ///   the governing day began at yesterday's sunrise.
  static DateTime anchorSunrise({
    required DateTime time,
    required DateTime Function(DateTime date) sunriseForDate,
  }) {
    final candidate = sunriseForDate(time);
    if (time.isBefore(candidate)) {
      return sunriseForDate(time.subtract(const Duration(days: 1)));
    }
    return candidate;
  }

  /// Convenience helper to anchor sunrise using geographic coordinates.
  ///
  /// Returns `null` if polar day/night prevents sunrise calculation.
  static DateTime? anchorSunriseForLocation({
    required DateTime time,
    required double latitude,
    required double longitude,
    required double utcOffset,
  }) {
    final sunResult = SunriseCalculator.calculate(
      date: time,
      latitude: latitude,
      longitude: longitude,
      utcOffset: utcOffset,
    );
    if (sunResult == null) return null;
    if (time.isBefore(sunResult.sunrise)) {
      final yesterdayResult = SunriseCalculator.calculate(
        date: time.subtract(const Duration(days: 1)),
        latitude: latitude,
        longitude: longitude,
        utcOffset: utcOffset,
      );
      return yesterdayResult?.sunrise;
    }
    return sunResult.sunrise;
  }
}

/// The seed for the civil day: the dawn nostril + Udhaya inception duration.
@immutable
class SwaraSeed {
  const SwaraSeed({required this.dawnFlow, required this.inceptionHours});

  /// Dawn flow at astronomical sunrise (Solar / Right or Lunar / Left).
  final BreathFlow dawnFlow;

  /// Udhaya inception duration in hours (1 or 2).
  final int inceptionHours;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwaraSeed &&
          runtimeType == other.runtimeType &&
          dawnFlow == other.dawnFlow &&
          inceptionHours == other.inceptionHours;

  @override
  int get hashCode => Object.hash(dawnFlow, inceptionHours);

  @override
  String toString() =>
      'SwaraSeed(dawnFlow: $dawnFlow, inceptionHours: ${inceptionHours}h)';
}

/// A swara block on the 1-hour / 24-cycle clock (or 2-hour Udhaya inception block).
@immutable
class SwaraBlock {
  const SwaraBlock({
    required this.flow,
    required this.start,
    required this.end,
  });

  /// The expected flow during this block.
  final BreathFlow flow;

  /// Start timestamp of this block.
  final DateTime start;

  /// End timestamp of this block (next switch instant).
  final DateTime end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwaraBlock &&
          runtimeType == other.runtimeType &&
          flow == other.flow &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => Object.hash(flow, start, end);

  @override
  String toString() => 'SwaraBlock(flow: $flow, start: $start, end: $end)';
}
