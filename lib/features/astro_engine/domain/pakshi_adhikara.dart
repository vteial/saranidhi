import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// Operating status of a bird on a specific day/night period.
///
/// Grounded in Kottumozhi Sathya (*"பஞ்ச பட்சி ஆருடம்"*, pp. 14, 17, 18, 22)
/// and the 2025 Workshop Day 2 (CONF-PP-007):
/// - [adhikara]: Bird is in its ruling-power block (sovereign authority).
/// - [padu]: Bird is in its complete downtime day (leave / inactivity).
/// - [normal]: Standard operating day without special status.
enum AdhikaraStatus { adhikara, padu, normal }

/// Pure, data-driven helper for Panja Pakshi Adhikara and Padu-Pakshi day rules.
///
/// **Doctrinal Provenance (CONF-PP-007):**
/// - Kottumozhi Sathya, *"பஞ்ச பட்சி ஆருடம்"*, pp. 14, 17, 18, 22
/// - 2025 Panja Pakshi Workshop Day 2 (`pp-class-02.md` @ 02:41–23:45)
///
/// Weekdays are 0-indexed with 0=Sunday through 6=Saturday (matching
/// [PakshiCalculator] Sun-based indexing).
class PakshiAdhikara {
  const PakshiAdhikara._();

  /// Shukla (Valarpirai / Waxing) Adhikara day/night blocks (p. 22).
  ///
  /// Entries are `(weekday, isNight)`:
  /// - Vulture: Sun-day, Tue-day, Fri-night
  /// - Owl: Mon-day, Wed-day, Sat-night
  /// - Crow: Thu-day, Sun-night, Tue-night
  /// - Rooster: Fri-day, Mon-night, Wed-night
  /// - Peacock: Sat-day, Thu-night
  static const Map<PakshiBird, List<(int, bool)>> _shuklaAdhikara = {
    PakshiBird.vulture: [(0, false), (2, false), (5, true)],
    PakshiBird.owl: [(1, false), (3, false), (6, true)],
    PakshiBird.crow: [(4, false), (0, true), (2, true)],
    PakshiBird.rooster: [(5, false), (1, true), (3, true)],
    PakshiBird.peacock: [(6, false), (4, true)],
  };

  /// Krishna (Theipirai / Waning) Adhikara day/night blocks (p. 17).
  ///
  /// Entries are `(weekday, isNight)`:
  /// - Vulture: Fri-day, Sun-night
  /// - Owl: Thu-day, Wed-night
  /// - Crow: Wed-day, Thu-night
  /// - Rooster: Sun-day, Tue-day, Mon-night
  /// - Peacock: Mon-day, Sat-day
  static const Map<PakshiBird, List<(int, bool)>> _krishnaAdhikara = {
    PakshiBird.vulture: [(5, false), (0, true)],
    PakshiBird.owl: [(4, false), (3, true)],
    PakshiBird.crow: [(3, false), (4, true)],
    PakshiBird.rooster: [(0, false), (2, false), (1, true)],
    PakshiBird.peacock: [(1, false), (6, false)],
  };

  /// Shukla (Valarpirai / Waxing) Padu-Pakshi downtime days (p. 18).
  ///
  /// Downtime applies to both day and night:
  /// - Vulture: Thursday (4), Saturday (6)
  /// - Owl: Sunday (0), Friday (5)
  /// - Crow: Monday (1)
  /// - Rooster: Tuesday (2)
  /// - Peacock: Wednesday (3)
  static const Map<PakshiBird, Set<int>> _shuklaPadu = {
    PakshiBird.vulture: {4, 6},
    PakshiBird.owl: {0, 5},
    PakshiBird.crow: {1},
    PakshiBird.rooster: {2},
    PakshiBird.peacock: {3},
  };

  /// Krishna (Theipirai / Waning) Padu-Pakshi downtime days (p. 18).
  ///
  /// Downtime applies to both day and night:
  /// - Vulture: Tuesday (2)
  /// - Owl: Monday (1)
  /// - Crow: Sunday (0), Thursday (4)
  /// - Rooster: Saturday (6)
  /// - Peacock: Wednesday (3), Friday (5) [Peacock is Padu on Wed in both pakshas]
  static const Map<PakshiBird, Set<int>> _krishnaPadu = {
    PakshiBird.vulture: {2},
    PakshiBird.owl: {1},
    PakshiBird.crow: {0, 4},
    PakshiBird.rooster: {6},
    PakshiBird.peacock: {3, 5},
  };

  /// Checks whether [bird] is in its Adhikara (ruling authority) block.
  static bool isAdhikara({
    required PakshiBird bird,
    required int weekday,
    required LunarPhase paksha,
    required bool isNight,
  }) {
    final blocks = paksha == LunarPhase.waxing
        ? _shuklaAdhikara[bird]
        : _krishnaAdhikara[bird];
    if (blocks == null) return false;
    return blocks.any((b) => b.$1 == weekday && b.$2 == isNight);
  }

  /// Checks whether [bird] is in a Padu-Pakshi (complete downtime) day.
  static bool isPadu({
    required PakshiBird bird,
    required int weekday,
    required LunarPhase paksha,
  }) {
    final days = paksha == LunarPhase.waxing
        ? _shuklaPadu[bird]
        : _krishnaPadu[bird];
    if (days == null) return false;
    return days.contains(weekday);
  }

  /// Returns the overall [AdhikaraStatus] for [bird] at the given timing.
  ///
  /// Grounded in CONF-PP-007 / Kottumozhi Sathya pp. 14, 17, 18, 22.
  /// When a specific night block is designated as Adhikara (such as Crow on
  /// Thursday night in Krishna paksha), that specific Adhikara block takes
  /// precedence over the general weekday downtime.
  static AdhikaraStatus statusFor({
    required PakshiBird bird,
    required int weekday,
    required LunarPhase paksha,
    required bool isNight,
  }) {
    if (isAdhikara(
      bird: bird,
      weekday: weekday,
      paksha: paksha,
      isNight: isNight,
    )) {
      return AdhikaraStatus.adhikara;
    }
    if (isPadu(bird: bird, weekday: weekday, paksha: paksha)) {
      return AdhikaraStatus.padu;
    }
    return AdhikaraStatus.normal;
  }

  /// Multiplier modifier for composite scoring:
  /// - [AdhikaraStatus.adhikara] -> 1.15 boost
  /// - [AdhikaraStatus.padu] -> 0.5 adverse reduction
  /// - [AdhikaraStatus.normal] -> 1.0 neutral
  static double scoreModifier(AdhikaraStatus status) {
    return switch (status) {
      AdhikaraStatus.adhikara => 1.15,
      AdhikaraStatus.padu => 0.5,
      AdhikaraStatus.normal => 1.0,
    };
  }

  /// Derives the Adhikara / Padu-Pakshi multiplier for [bird] at [queryTime].
  ///
  /// Returns `1.0` (neutral no-op) if [bird], [sunrise], or [sunset] is `null`
  /// (R1.2 / R2.2 null-bird invariant).
  ///
  /// Grounded in CONF-PP-007 / Kottumozhi Sathya pp. 14, 17, 18, 22:
  /// - [AdhikaraStatus.adhikara] -> 1.15 boost
  /// - [AdhikaraStatus.padu] -> 0.5 adverse reduction
  /// - [AdhikaraStatus.normal] -> 1.0 neutral
  static double multiplierFor({
    required int weekday,
    required DateTime queryTime,
    PakshiBird? bird,
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    if (bird == null || sunrise == null || sunset == null) {
      return 1;
    }
    final isNight = queryTime.isBefore(sunrise) || !queryTime.isBefore(sunset);
    final anchoredSunrise = queryTime.isBefore(sunrise)
        ? sunrise.subtract(const Duration(days: 1))
        : sunrise;
    final paksha = LunarPhaseCalculator.phaseForDate(anchoredSunrise);
    final status = statusFor(
      bird: bird,
      weekday: weekday,
      paksha: paksha,
      isNight: isNight,
    );
    return scoreModifier(status);
  }
}
