import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

/// The five birds of Panja Pakshi Shastra.
enum PakshiBird {
  vulture,
  owl,
  crow,
  rooster,
  peacock;

  /// Display name with first letter capitalized.
  String get displayName => name[0].toUpperCase() + name.substring(1);
}

/// The five activity states a bird can be in during a Yama.
enum PakshiState {
  ruling,
  eating,
  walking,
  sleeping,
  dying;

  /// Display name with first letter capitalized.
  String get displayName => name[0].toUpperCase() + name.substring(1);
}

/// Represents the lunar phase relevant to Pakshi calculation.
enum LunarPhase { waxing, waning }

/// Result of the Pakshi calculation for a specific Yama.
class PakshiResult {
  const PakshiResult({
    required this.bird,
    required this.state,
    required this.yama,
  });

  /// The active (ruling) bird for this Yama.
  final PakshiBird bird;

  /// The activity state of the ruling bird (always `PakshiState.ruling`).
  final PakshiState state;

  /// Which Yama this result applies to.
  final YamaIndex yama;
}

/// Full day Pakshi result with all 5 Yama assignments.
///
/// The authentic Panja Pakshi system assigns **all 5 birds** a state in each
/// Yama. This class provides access to both the ruling bird per Yama and the
/// state of any specific bird at any Yama.
class PakshiDayResult {
  const PakshiDayResult({
    required this.entries,
    required this.stateTable,
  });

  /// The ruling bird for each of the 5 Yamas (backward-compatible).
  final List<PakshiResult> entries;

  /// Full 2D state table: `stateTable[birdIndex][yamaIndex]` → PakshiState.
  /// Bird order: vulture=0, owl=1, crow=2, rooster=3, peacock=4.
  final List<List<PakshiState>> stateTable;

  /// Get the ruling bird result for a specific Yama.
  PakshiResult forYama(YamaIndex yama) {
    return entries.firstWhere((e) => e.yama == yama);
  }

  /// Get the state of a specific [bird] during a specific [yama].
  PakshiState stateForBird(PakshiBird bird, YamaIndex yama) {
    return stateTable[bird.index][yama.index];
  }
}

/// Calculates Panja Pakshi bird states based on weekday and lunar phase.
///
/// Uses authentic 2D lookup tables from the traditional Panja Pakshi system
/// (source: Prof. Dr. U.S. Pulippani, "Biorhythms of Natal Moon — Mysteries
/// of Pancha Pakshi").
///
/// The system groups weekdays into day-groups:
/// - **Bright half (Shukla Paksha):** Group A (Sun/Tue), Group B (Mon/Wed/Sat),
///   Group C (Thu), Group D (Fri)
/// - **Dark half (Krishna Paksha):** Group A (Sun/Tue), Group B (Mon/Sat),
///   Group C (Wed), Group D (Thu), Group E (Fri)
///
/// Each table assigns all 5 birds their own independent state per Yama.
class PakshiCalculator {
  const PakshiCalculator._();

  // ─── Abbreviations for readability ──────────────────────────────────
  static const _r = PakshiState.ruling;
  static const _e = PakshiState.eating;
  static const _w = PakshiState.walking;
  static const _s = PakshiState.sleeping;
  static const _d = PakshiState.dying;

  // ═══════════════════════════════════════════════════════════════════════
  // BRIGHT HALF (Shukla Paksha) — Daytime Tables
  // ═══════════════════════════════════════════════════════════════════════
  //
  // Each table is a 5×5 matrix: [bird][yama] → state.
  // Bird order: Vulture, Owl, Crow, Cock(Rooster), Peacock.
  // Yama order: Yama1, Yama2, Yama3, Yama4, Yama5.

  /// Group A: Sunday & Tuesday (Bright Half, Daytime)
  static const List<List<PakshiState>> _brightGroupA = [
    // Vulture:  Eating,  Walking, Ruling,  Sleeping, Dying
    [_e, _w, _r, _s, _d],
    // Owl:      Ruling,  Dying,   Eating,  Walking,  Sleeping
    [_r, _d, _e, _w, _s],
    // Crow:     Walking, Sleeping, Dying,  Ruling,   Eating
    [_w, _s, _d, _r, _e],
    // Cock:     Dying,   Ruling,  Sleeping, Eating,  Walking
    [_d, _r, _s, _e, _w],
    // Peacock:  Sleeping, Eating, Walking,  Dying,   Ruling
    [_s, _e, _w, _d, _r],
  ];

  /// Group B: Monday, Wednesday & Saturday (Bright Half, Daytime)
  static const List<List<PakshiState>> _brightGroupB = [
    // Vulture:  Dying,   Ruling,  Sleeping, Eating,  Walking
    [_d, _r, _s, _e, _w],
    // Owl:      Eating,  Walking, Ruling,   Sleeping, Dying
    [_e, _w, _r, _s, _d],
    // Crow:     Sleeping, Eating, Walking,  Dying,   Ruling
    [_s, _e, _w, _d, _r],
    // Cock:     Walking, Sleeping, Dying,   Ruling,  Eating
    [_w, _s, _d, _r, _e],
    // Peacock:  Ruling,  Dying,   Eating,   Walking, Sleeping
    [_r, _d, _e, _w, _s],
  ];

  /// Group C: Thursday (Bright Half, Daytime)
  static const List<List<PakshiState>> _brightGroupC = [
    // Vulture:  Sleeping, Eating,  Walking, Dying,   Ruling
    [_s, _e, _w, _d, _r],
    // Owl:      Walking,  Sleeping, Dying,  Ruling,  Eating
    [_w, _s, _d, _r, _e],
    // Crow:     Eating,   Walking, Ruling,  Sleeping, Dying
    [_e, _w, _r, _s, _d],
    // Cock:     Ruling,   Dying,   Eating,  Walking, Sleeping
    [_r, _d, _e, _w, _s],
    // Peacock:  Dying,    Ruling,  Sleeping, Eating, Walking
    [_d, _r, _s, _e, _w],
  ];

  /// Group D: Friday (Bright Half, Daytime)
  static const List<List<PakshiState>> _brightGroupD = [
    // Vulture:  Walking, Sleeping, Dying,   Ruling,  Eating
    [_w, _s, _d, _r, _e],
    // Owl:      Dying,   Ruling,   Sleeping, Eating, Walking
    [_d, _r, _s, _e, _w],
    // Crow:     Ruling,  Dying,    Eating,  Walking, Sleeping
    [_r, _d, _e, _w, _s],
    // Cock:     Eating,  Walking,  Ruling,  Sleeping, Dying
    [_e, _w, _r, _s, _d],
    // Peacock:  Sleeping, Eating,  Walking, Dying,   Ruling
    [_s, _e, _w, _d, _r],
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // DARK HALF (Krishna Paksha) — Daytime Tables
  // ═══════════════════════════════════════════════════════════════════════

  /// Group A: Sunday & Tuesday (Dark Half, Daytime)
  static const List<List<PakshiState>> _darkGroupA = [
    // Vulture:  Walking, Ruling,  Eating,  Dying,   Sleeping
    [_w, _r, _e, _d, _s],
    // Owl:      Dying,   Sleeping, Ruling, Walking, Eating
    [_d, _s, _r, _w, _e],
    // Crow:     Eating,  Dying,   Sleeping, Ruling, Walking
    [_e, _d, _s, _r, _w],
    // Cock:     Ruling,  Eating,  Walking, Sleeping, Dying
    [_r, _e, _w, _s, _d],
    // Peacock:  Sleeping, Walking, Dying,  Eating,  Ruling
    [_s, _w, _d, _e, _r],
  ];

  /// Group B: Monday & Saturday (Dark Half, Daytime)
  static const List<List<PakshiState>> _darkGroupB = [
    // Vulture:  Sleeping, Walking, Dying,  Eating,  Ruling
    [_s, _w, _d, _e, _r],
    // Owl:      Eating,   Dying,   Walking, Ruling, Sleeping
    [_e, _d, _w, _r, _s],
    // Crow:     Walking,  Ruling,  Eating, Sleeping, Dying
    [_w, _r, _e, _s, _d],
    // Cock:     Dying,    Sleeping, Ruling, Walking, Eating
    [_d, _s, _r, _w, _e],
    // Peacock:  Ruling,   Eating,  Sleeping, Dying, Walking
    [_r, _e, _s, _d, _w],
  ];

  /// Group C: Wednesday (Dark Half, Daytime)
  static const List<List<PakshiState>> _darkGroupC = [
    // Vulture:  Dying,   Sleeping, Walking, Ruling,  Eating
    [_d, _s, _w, _r, _e],
    // Owl:      Ruling,  Eating,   Dying,   Sleeping, Walking
    [_r, _e, _d, _s, _w],
    // Crow:     Sleeping, Walking, Ruling,  Eating,  Dying
    [_s, _w, _r, _e, _d],
    // Cock:     Eating,  Ruling,   Sleeping, Dying, Walking
    [_e, _r, _s, _d, _w],
    // Peacock:  Walking, Dying,    Eating,  Walking, Ruling
    [_w, _d, _e, _w, _r],
  ];

  /// Group D: Thursday (Dark Half, Daytime)
  static const List<List<PakshiState>> _darkGroupD = [
    // Vulture:  Ruling,  Eating,  Sleeping, Walking, Dying
    [_r, _e, _s, _w, _d],
    // Owl:      Sleeping, Walking, Eating,  Dying,   Ruling
    [_s, _w, _e, _d, _r],
    // Crow:     Dying,   Ruling,  Walking,  Eating,  Sleeping
    [_d, _r, _w, _e, _s],
    // Cock:     Walking, Dying,   Ruling,   Sleeping, Eating
    [_w, _d, _r, _s, _e],
    // Peacock:  Eating,  Sleeping, Dying,   Ruling,  Walking
    [_e, _s, _d, _r, _w],
  ];

  /// Group E: Friday (Dark Half, Daytime)
  static const List<List<PakshiState>> _darkGroupE = [
    // Vulture:  Eating,  Dying,   Ruling,  Sleeping, Walking
    [_e, _d, _r, _s, _w],
    // Owl:      Walking, Ruling,  Sleeping, Eating,  Dying
    [_w, _r, _s, _e, _d],
    // Crow:     Ruling,  Sleeping, Dying,   Walking, Eating
    [_r, _s, _d, _w, _e],
    // Cock:     Sleeping, Eating,  Walking, Dying,   Ruling
    [_s, _e, _w, _d, _r],
    // Peacock:  Dying,   Walking,  Eating,  Ruling,  Sleeping
    [_d, _w, _e, _r, _s],
  ];

  /// Returns the correct daytime state table for the given [weekday]
  /// and [lunarPhase].
  static List<List<PakshiState>> _getStateTable({
    required int weekday,
    required LunarPhase lunarPhase,
  }) {
    if (lunarPhase == LunarPhase.waxing) {
      // Bright half day groups:
      // Group A: Sunday(0), Tuesday(2)
      // Group B: Monday(1), Wednesday(3), Saturday(6)
      // Group C: Thursday(4)
      // Group D: Friday(5)
      return switch (weekday) {
        0 || 2 => _brightGroupA,
        1 || 3 || 6 => _brightGroupB,
        4 => _brightGroupC,
        5 => _brightGroupD,
        _ => _brightGroupA, // unreachable
      };
    } else {
      // Dark half day groups:
      // Group A: Sunday(0), Tuesday(2)
      // Group B: Monday(1), Saturday(6)
      // Group C: Wednesday(3)
      // Group D: Thursday(4)
      // Group E: Friday(5)
      return switch (weekday) {
        0 || 2 => _darkGroupA,
        1 || 6 => _darkGroupB,
        3 => _darkGroupC,
        4 => _darkGroupD,
        5 => _darkGroupE,
        _ => _darkGroupA, // unreachable
      };
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // BRIGHT HALF (Shukla Paksha) — Nighttime Tables
  // ═══════════════════════════════════════════════════════════════════════

  /// Group A: Sunday & Tuesday (Bright Half, Nighttime)
  static const List<List<PakshiState>> _brightNightGroupA = [
    // Vulture:  Dying, Ruling, Sleeping, Eating, Walking
    [_d, _r, _s, _e, _w],
    // Owl:      Sleeping, Eating, Walking, Dying, Ruling
    [_s, _e, _w, _d, _r],
    // Crow:     Eating, Walking, Ruling, Sleeping, Dying
    [_e, _w, _r, _s, _d],
    // Cock:     Walking, Sleeping, Dying, Ruling, Eating
    [_w, _s, _d, _r, _e],
    // Peacock:  Ruling, Dying, Eating, Walking, Sleeping
    [_r, _d, _e, _w, _s],
  ];

  /// Group B: Monday, Wednesday & Saturday (Bright Half, Nighttime)
  static const List<List<PakshiState>> _brightNightGroupB = [
    // Vulture:  Walking, Sleeping, Dying, Ruling, Eating
    [_w, _s, _d, _r, _e],
    // Owl:      Dying, Ruling, Sleeping, Eating, Walking
    [_d, _r, _s, _e, _w],
    // Crow:     Ruling, Dying, Eating, Walking, Sleeping
    [_r, _d, _e, _w, _s],
    // Cock:     Eating, Walking, Ruling, Sleeping, Dying
    [_e, _w, _r, _s, _d],
    // Peacock:  Sleeping, Eating, Walking, Dying, Ruling
    [_s, _e, _w, _d, _r],
  ];

  /// Group C: Thursday (Bright Half, Nighttime)
  static const List<List<PakshiState>> _brightNightGroupC = [
    // Vulture:  Ruling, Dying, Eating, Walking, Sleeping
    [_r, _d, _e, _w, _s],
    // Owl:      Eating, Walking, Ruling, Sleeping, Dying
    [_e, _w, _r, _s, _d],
    // Crow:     Dying, Ruling, Sleeping, Eating, Walking
    [_d, _r, _s, _e, _w],
    // Cock:     Sleeping, Eating, Walking, Dying, Ruling
    [_s, _e, _w, _d, _r],
    // Peacock:  Walking, Sleeping, Dying, Ruling, Eating
    [_w, _s, _d, _r, _e],
  ];

  /// Group D: Friday (Bright Half, Nighttime)
  static const List<List<PakshiState>> _brightNightGroupD = [
    // Vulture:  Eating, Walking, Ruling, Sleeping, Dying
    [_e, _w, _r, _s, _d],
    // Owl:      Walking, Sleeping, Dying, Ruling, Eating
    [_w, _s, _d, _r, _e],
    // Crow:     Sleeping, Eating, Walking, Dying, Ruling
    [_s, _e, _w, _d, _r],
    // Cock:     Dying, Ruling, Sleeping, Eating, Walking
    [_d, _r, _s, _e, _w],
    // Peacock:  Ruling, Dying, Eating, Walking, Sleeping
    [_r, _d, _e, _w, _s],
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // DARK HALF (Krishna Paksha) — Nighttime Tables
  // ═══════════════════════════════════════════════════════════════════════

  /// Group A: Sunday & Tuesday (Dark Half, Nighttime)
  static const List<List<PakshiState>> _darkNightGroupA = [
    // Vulture:  Sleeping, Walking, Dying, Eating, Ruling
    [_s, _w, _d, _e, _r],
    // Owl:      Eating, Dying, Walking, Ruling, Sleeping
    [_e, _d, _w, _r, _s],
    // Crow:     Walking, Ruling, Eating, Sleeping, Dying
    [_w, _r, _e, _s, _d],
    // Cock:     Dying, Sleeping, Ruling, Dying, Eating
    [_d, _s, _r, _d, _e],
    // Peacock:  Ruling, Eating, Sleeping, Walking, Walking
    [_r, _e, _s, _w, _w],
  ];

  /// Group B: Monday & Saturday (Dark Half, Nighttime)
  static const List<List<PakshiState>> _darkNightGroupB = [
    // Vulture:  Ruling, Eating, Sleeping, Walking, Dying
    [_r, _e, _s, _w, _d],
    // Owl:      Sleeping, Walking, Dying, Eating, Ruling
    [_s, _w, _d, _e, _r],
    // Crow:     Dying, Sleeping, Ruling, Dying, Eating
    [_d, _s, _r, _d, _e],
    // Cock:     Eating, Ruling, Walking, Sleeping, Walking
    [_e, _r, _w, _s, _w],
    // Peacock:  Walking, Dying, Eating, Ruling, Sleeping
    [_w, _d, _e, _r, _s],
  ];

  /// Group C: Wednesday (Dark Half, Nighttime)
  static const List<List<PakshiState>> _darkNightGroupC = [
    // Vulture:  Eating, Ruling, Sleeping, Dying, Walking
    [_e, _r, _s, _d, _w],
    // Owl:      Walking, Dying, Eating, Ruling, Sleeping
    [_w, _d, _e, _r, _s],
    // Crow:     Dying, Eating, Walking, Sleeping, Ruling
    [_d, _e, _w, _s, _r],
    // Cock:     Ruling, Sleeping, Dying, Walking, Eating
    [_r, _s, _d, _w, _e],
    // Peacock:  Sleeping, Walking, Ruling, Eating, Dying
    [_s, _w, _r, _e, _d],
  ];

  /// Group D: Thursday (Dark Half, Nighttime)
  static const List<List<PakshiState>> _darkNightGroupD = [
    // Vulture:  Dying, Walking, Ruling, Eating, Sleeping
    [_d, _w, _r, _e, _s],
    // Owl:      Ruling, Eating, Sleeping, Walking, Dying
    [_r, _e, _s, _w, _d],
    // Crow:     Sleeping, Dying, Eating, Ruling, Walking
    [_s, _d, _e, _r, _w],
    // Cock:     Eating, Ruling, Walking, Dying, Ruling
    [_e, _r, _w, _d, _r],
    // Peacock:  Walking, Sleeping, Dying, Sleeping, Eating
    [_w, _s, _d, _s, _e],
  ];

  /// Group E: Friday (Dark Half, Nighttime)
  static const List<List<PakshiState>> _darkNightGroupE = [
    // Vulture:  Walking, Sleeping, Dying, Ruling, Eating
    [_w, _s, _d, _r, _e],
    // Owl:      Dying, Eating, Ruling, Sleeping, Walking
    [_d, _e, _r, _s, _w],
    // Crow:     Eating, Walking, Sleeping, Dying, Ruling
    [_e, _w, _s, _d, _r],
    // Cock:     Ruling, Dying, Eating, Walking, Sleeping
    [_r, _d, _e, _w, _s],
    // Peacock:  Sleeping, Ruling, Walking, Eating, Dying
    [_s, _r, _w, _e, _d],
  ];

  /// Returns the correct NIGHTTIME state table for the given [weekday]
  /// and [lunarPhase].
  static List<List<PakshiState>> _getNightStateTable({
    required int weekday,
    required LunarPhase lunarPhase,
  }) {
    if (lunarPhase == LunarPhase.waxing) {
      return switch (weekday) {
        0 || 2 => _brightNightGroupA,
        1 || 3 || 6 => _brightNightGroupB,
        4 => _brightNightGroupC,
        5 => _brightNightGroupD,
        _ => _brightNightGroupA, // unreachable
      };
    } else {
      return switch (weekday) {
        0 || 2 => _darkNightGroupA,
        1 || 6 => _darkNightGroupB,
        3 => _darkNightGroupC,
        4 => _darkNightGroupD,
        5 => _darkNightGroupE,
        _ => _darkNightGroupA, // unreachable
      };
    }
  }

  /// Calculates the night Pakshi assignment for a given [weekday]
  /// and [lunarPhase].
  ///
  /// [weekday] is 0=Sunday through 6=Saturday (use [dartWeekdayToSunBased]
  /// to convert from Dart's DateTime.weekday).
  ///
  /// Returns a [PakshiDayResult] containing:
  /// - `entries`: The ruling bird for each night Yama.
  /// - `stateTable`: Full 2D table of all birds' states per night Yama.
  static PakshiDayResult calculateNight({
    required int weekday,
    required LunarPhase lunarPhase,
  }) {
    if (weekday < 0 || weekday > 6) {
      throw ArgumentError.value(
        weekday,
        'weekday',
        'Must be 0 (Sunday) through 6 (Saturday)',
      );
    }

    final stateTable = _getNightStateTable(
      weekday: weekday,
      lunarPhase: lunarPhase,
    );

    // Build entries: for each Yama, find the bird whose state is Ruling.
    final entries = <PakshiResult>[];
    for (var yamaIdx = 0; yamaIdx < 5; yamaIdx++) {
      PakshiBird? rulingBird;
      for (var birdIdx = 0; birdIdx < 5; birdIdx++) {
        if (stateTable[birdIdx][yamaIdx] == PakshiState.ruling) {
          rulingBird = PakshiBird.values[birdIdx];
          break;
        }
      }
      entries.add(
        PakshiResult(
          bird: rulingBird ?? PakshiBird.vulture,
          state: PakshiState.ruling,
          yama: YamaIndex.values[yamaIdx],
        ),
      );
    }

    return PakshiDayResult(entries: entries, stateTable: stateTable);
  }

  /// Calculates the full-day Pakshi assignment for a given [weekday]
  /// and [lunarPhase].
  ///
  /// [weekday] is 0=Sunday through 6=Saturday (use [dartWeekdayToSunBased]
  /// to convert from Dart's DateTime.weekday).
  ///
  /// Returns a [PakshiDayResult] containing:
  /// - `entries`: The ruling bird for each Yama (backward-compatible).
  /// - `stateTable`: Full 2D table of all birds' states per Yama.
  static PakshiDayResult calculate({
    required int weekday,
    required LunarPhase lunarPhase,
  }) {
    if (weekday < 0 || weekday > 6) {
      throw ArgumentError.value(
        weekday,
        'weekday',
        'Must be 0 (Sunday) through 6 (Saturday)',
      );
    }

    final stateTable = _getStateTable(
      weekday: weekday,
      lunarPhase: lunarPhase,
    );

    // Build entries: for each Yama, find the bird whose state is Ruling.
    final entries = <PakshiResult>[];
    for (var yamaIdx = 0; yamaIdx < 5; yamaIdx++) {
      PakshiBird? rulingBird;
      for (var birdIdx = 0; birdIdx < 5; birdIdx++) {
        if (stateTable[birdIdx][yamaIdx] == PakshiState.ruling) {
          rulingBird = PakshiBird.values[birdIdx];
          break;
        }
      }
      entries.add(
        PakshiResult(
          bird: rulingBird ?? PakshiBird.vulture,
          state: PakshiState.ruling,
          yama: YamaIndex.values[yamaIdx],
        ),
      );
    }

    return PakshiDayResult(entries: entries, stateTable: stateTable);
  }

  /// Convenience method: converts Dart's [DateTime.weekday] (1=Mon..7=Sun)
  /// to our 0=Sunday..6=Saturday format.
  static int dartWeekdayToSunBased(int dartWeekday) {
    return dartWeekday % 7; // 7(Sun)->0, 1(Mon)->1, ..., 6(Sat)->6
  }

  /// Maps a birth nakshatra to its corresponding Pakshi bird.
  /// Returns null if the nakshatra is not recognized.
  ///
  /// Uses the BRIGHT HALF (Shukla) table as default for backward
  /// compatibility when birth Paksha is unknown.
  /// For correct derivation, use [birthBirdFromNakshatraAndPaksha].
  static PakshiBird? birthBirdFromNakshatraSafe(String nakshatra) {
    final lower = nakshatra.toLowerCase().trim();
    return _lookupBrightHalf(lower);
  }

  /// Maps a birth nakshatra to its corresponding Pakshi bird.
  ///
  /// Uses the BRIGHT HALF (Shukla) table as default.
  /// For correct derivation, use [birthBirdFromNakshatraAndPaksha].
  static PakshiBird birthBirdFromNakshatra(String nakshatra) {
    final lower = nakshatra.toLowerCase().trim();
    final bird = _lookupBrightHalf(lower);
    if (bird == null) {
      throw ArgumentError.value(
        nakshatra,
        'nakshatra',
        'Unknown nakshatra name',
      );
    }
    return bird;
  }

  /// Correctly derives the permanent birth bird using BOTH the nakshatra
  /// AND the birth Paksha (lunar phase at the time of birth).
  ///
  /// This is the authoritative derivation per Prof. Pulippani's
  /// *Biorhythms of Natal Moon* (Tables 1 & 2).
  ///
  /// - Born during Shukla Paksha (waxing) → use Bright Half table
  /// - Born during Krishna Paksha (waning) → use Dark Half table
  ///
  /// The resulting bird is PERMANENT — it never changes with the
  /// current lunar phase.
  static PakshiBird? birthBirdFromNakshatraAndPaksha(
    String nakshatra,
    LunarPhase birthPaksha,
  ) {
    final lower = nakshatra.toLowerCase().trim();
    return switch (birthPaksha) {
      LunarPhase.waxing => _lookupBrightHalf(lower),
      LunarPhase.waning => _lookupDarkHalf(lower),
    };
  }

  /// Determines the birth Paksha (Shukla or Krishna) from the date of birth.
  ///
  /// Uses [LunarPhaseCalculator] to determine if the moon was waxing or
  /// waning at the time of birth. This is used alongside the nakshatra
  /// to derive the correct permanent birth bird.
  static LunarPhase birthPakshaFromDOB(DateTime dateOfBirth) {
    return LunarPhaseCalculator.phaseForDate(dateOfBirth);
  }

  static PakshiBird? _lookupBrightHalf(String lower) {
    if (_brightVultureNakshatras.contains(lower)) return PakshiBird.vulture;
    if (_brightOwlNakshatras.contains(lower)) return PakshiBird.owl;
    if (_brightCrowNakshatras.contains(lower)) return PakshiBird.crow;
    if (_brightRoosterNakshatras.contains(lower)) return PakshiBird.rooster;
    if (_brightPeacockNakshatras.contains(lower)) return PakshiBird.peacock;
    return null;
  }

  static PakshiBird? _lookupDarkHalf(String lower) {
    if (_darkVultureNakshatras.contains(lower)) return PakshiBird.vulture;
    if (_darkOwlNakshatras.contains(lower)) return PakshiBird.owl;
    if (_darkCrowNakshatras.contains(lower)) return PakshiBird.crow;
    if (_darkRoosterNakshatras.contains(lower)) return PakshiBird.rooster;
    if (_darkPeacockNakshatras.contains(lower)) return PakshiBird.peacock;
    return null;
  }

  // ─── Nakshatra-to-bird mappings ────────────────────────────────────────

  // BRIGHT HALF (Shukla Paksha) — used when user was born during waxing moon.
  // Source: Prof. Pulippani, Table 1 — "Biorhythms of Natal Moon"
  static const Set<String> _brightVultureNakshatras = {
    'ashwini',
    'bharani',
    'krittika',
    'rohini',
    'mrigashira',
  };

  static const Set<String> _brightOwlNakshatras = {
    'ardra',
    'punarvasu',
    'pushya',
    'ashlesha',
    'magha',
  };

  static const Set<String> _brightCrowNakshatras = {
    'purva phalguni',
    'uttara phalguni',
    'hasta',
    'chitra',
    'swati',
  };

  static const Set<String> _brightRoosterNakshatras = {
    'vishakha',
    'anuradha',
    'jyeshtha',
    'mula',
    'purva ashadha',
  };

  static const Set<String> _brightPeacockNakshatras = {
    'uttara ashadha',
    'shravana',
    'dhanishta',
    'shatabhisha',
    'purva bhadrapada',
    'uttara bhadrapada',
    'revati',
  };

  // DARK HALF (Krishna Paksha) — used when user was born during waning moon.
  // Source: Prof. Pulippani, Table 2 — "Biorhythms of Natal Moon"
  // Nakshatras are assigned in reverse order from Revati.
  static const Set<String> _darkVultureNakshatras = {
    'revati',
    'uttara bhadrapada',
    'purva bhadrapada',
    'shatabhisha',
    'dhanishta',
  };

  static const Set<String> _darkOwlNakshatras = {
    'shravana',
    'uttara ashadha',
    'purva ashadha',
    'mula',
    'jyeshtha',
  };

  static const Set<String> _darkCrowNakshatras = {
    'anuradha',
    'vishakha',
    'swati',
    'chitra',
    'hasta',
  };

  static const Set<String> _darkRoosterNakshatras = {
    'uttara phalguni',
    'purva phalguni',
    'magha',
    'ashlesha',
    'pushya',
  };

  static const Set<String> _darkPeacockNakshatras = {
    'punarvasu',
    'ardra',
    'mrigashira',
    'rohini',
    'krittika',
    'bharani',
    'ashwini',
  };

  /// @deprecated Use [birthBirdFromNakshatraAndPaksha] instead.
  /// Birth bird is PERMANENT — it does NOT swap with current lunar phase.
  /// This method is kept temporarily for backward compatibility but always
  /// returns the natal bird unchanged.
  ///
  /// The previous swap logic (Sprint 27.5) was based on an incorrect
  /// interpretation. The correct system uses dual lookup tables at birth
  /// time, not monthly swapping.
  static PakshiBird birthBirdForPhase(
    PakshiBird natalBird,
    LunarPhase phase,
  ) {
    // Birth bird is permanent — no swap.
    return natalBird;
  }
}
