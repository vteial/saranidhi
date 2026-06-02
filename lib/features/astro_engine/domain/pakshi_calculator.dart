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

  /// The active bird for this Yama.
  final PakshiBird bird;

  /// The activity state of the bird.
  final PakshiState state;

  /// Which Yama this result applies to.
  final YamaIndex yama;
}

/// Full day Pakshi result with all 5 Yama assignments.
class PakshiDayResult {
  const PakshiDayResult({required this.entries});

  /// All 5 Yama assignments for the day.
  final List<PakshiResult> entries;

  /// Get the Pakshi result for a specific Yama.
  PakshiResult forYama(YamaIndex yama) {
    return entries.firstWhere((e) => e.yama == yama);
  }
}

/// Calculates Panja Pakshi bird states based on weekday and lunar phase.
///
/// The Panja Pakshi system assigns one of 5 birds to each of the 5 Yamas
/// (time segments) of the day. The bird sequence rotates based on:
/// - The day of the week (0=Sunday through 6=Saturday)
/// - The lunar phase (waxing or waning moon)
///
/// Each bird cycles through 5 states: Ruling → Eating → Walking →
/// Sleeping → Dying across the 5 Yamas.
class PakshiCalculator {
  const PakshiCalculator._();

  /// Bird sequence for each weekday during WAXING moon.
  ///
  /// Each row is a weekday (0=Sunday..6=Saturday).
  /// The 5 values are the birds assigned to Yama 1–5.
  /// The first bird in the sequence is in "Ruling" state.
  static const List<List<PakshiBird>> _waxingSequences = [
    // Sunday
    [
      PakshiBird.vulture,
      PakshiBird.owl,
      PakshiBird.crow,
      PakshiBird.rooster,
      PakshiBird.peacock,
    ],
    // Monday
    [
      PakshiBird.owl,
      PakshiBird.crow,
      PakshiBird.rooster,
      PakshiBird.peacock,
      PakshiBird.vulture,
    ],
    // Tuesday
    [
      PakshiBird.crow,
      PakshiBird.rooster,
      PakshiBird.peacock,
      PakshiBird.vulture,
      PakshiBird.owl,
    ],
    // Wednesday
    [
      PakshiBird.rooster,
      PakshiBird.peacock,
      PakshiBird.vulture,
      PakshiBird.owl,
      PakshiBird.crow,
    ],
    // Thursday
    [
      PakshiBird.peacock,
      PakshiBird.vulture,
      PakshiBird.owl,
      PakshiBird.crow,
      PakshiBird.rooster,
    ],
    // Friday
    [
      PakshiBird.vulture,
      PakshiBird.owl,
      PakshiBird.crow,
      PakshiBird.rooster,
      PakshiBird.peacock,
    ],
    // Saturday
    [
      PakshiBird.owl,
      PakshiBird.crow,
      PakshiBird.rooster,
      PakshiBird.peacock,
      PakshiBird.vulture,
    ],
  ];

  /// Bird sequence for each weekday during WANING moon.
  ///
  /// The waning sequence is shifted from waxing — each day starts
  /// with a different bird compared to waxing.
  static const List<List<PakshiBird>> _waningSequences = [
    // Sunday
    [
      PakshiBird.crow,
      PakshiBird.rooster,
      PakshiBird.peacock,
      PakshiBird.vulture,
      PakshiBird.owl,
    ],
    // Monday
    [
      PakshiBird.rooster,
      PakshiBird.peacock,
      PakshiBird.vulture,
      PakshiBird.owl,
      PakshiBird.crow,
    ],
    // Tuesday
    [
      PakshiBird.peacock,
      PakshiBird.vulture,
      PakshiBird.owl,
      PakshiBird.crow,
      PakshiBird.rooster,
    ],
    // Wednesday
    [
      PakshiBird.vulture,
      PakshiBird.owl,
      PakshiBird.crow,
      PakshiBird.rooster,
      PakshiBird.peacock,
    ],
    // Thursday
    [
      PakshiBird.owl,
      PakshiBird.crow,
      PakshiBird.rooster,
      PakshiBird.peacock,
      PakshiBird.vulture,
    ],
    // Friday
    [
      PakshiBird.crow,
      PakshiBird.rooster,
      PakshiBird.peacock,
      PakshiBird.vulture,
      PakshiBird.owl,
    ],
    // Saturday
    [
      PakshiBird.rooster,
      PakshiBird.peacock,
      PakshiBird.vulture,
      PakshiBird.owl,
      PakshiBird.crow,
    ],
  ];

  /// The fixed state order: the bird at position 0 is Ruling,
  /// position 1 is Eating, etc.
  static const List<PakshiState> _stateOrder = [
    PakshiState.ruling,
    PakshiState.eating,
    PakshiState.walking,
    PakshiState.sleeping,
    PakshiState.dying,
  ];

  /// Calculates the full-day Pakshi assignment for a given [weekday]
  /// and [lunarPhase].
  ///
  /// [weekday] is 0=Sunday through 6=Saturday (use `DateTime.weekday % 7`
  /// since Dart's DateTime.weekday is 1=Monday..7=Sunday).
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

    final sequences = lunarPhase == LunarPhase.waxing
        ? _waxingSequences
        : _waningSequences;

    final dayBirds = sequences[weekday];

    final entries = <PakshiResult>[];
    for (var i = 0; i < 5; i++) {
      entries.add(
        PakshiResult(
          bird: dayBirds[i],
          state: _stateOrder[i],
          yama: YamaIndex.values[i],
        ),
      );
    }

    return PakshiDayResult(entries: entries);
  }

  /// Convenience method: converts Dart's [DateTime.weekday] (1=Mon..7=Sun)
  /// to our 0=Sunday..6=Saturday format.
  static int dartWeekdayToSunBased(int dartWeekday) {
    return dartWeekday % 7; // 7(Sun)->0, 1(Mon)->1, ..., 6(Sat)->6
  }

  /// Maps a birth nakshatra to its corresponding Pakshi bird.
  /// Returns null if the nakshatra is not recognized.
  static PakshiBird? birthBirdFromNakshatraSafe(String nakshatra) {
    final lower = nakshatra.toLowerCase().trim();
    if (_vultureNakshatras.contains(lower)) return PakshiBird.vulture;
    if (_owlNakshatras.contains(lower)) return PakshiBird.owl;
    if (_crowNakshatras.contains(lower)) return PakshiBird.crow;
    if (_roosterNakshatras.contains(lower)) return PakshiBird.rooster;
    if (_peacockNakshatras.contains(lower)) return PakshiBird.peacock;
    return null;
  }

  /// Maps a birth nakshatra to its corresponding Pakshi bird.
  ///
  /// The 27 nakshatras are grouped into 5 sets of ~5-6 each.
  static PakshiBird birthBirdFromNakshatra(String nakshatra) {
    final lower = nakshatra.toLowerCase().trim();
    if (_vultureNakshatras.contains(lower)) return PakshiBird.vulture;
    if (_owlNakshatras.contains(lower)) return PakshiBird.owl;
    if (_crowNakshatras.contains(lower)) return PakshiBird.crow;
    if (_roosterNakshatras.contains(lower)) return PakshiBird.rooster;
    if (_peacockNakshatras.contains(lower)) return PakshiBird.peacock;
    throw ArgumentError.value(nakshatra, 'nakshatra', 'Unknown nakshatra name');
  }

  // Nakshatra-to-bird mappings (traditional grouping)
  static const Set<String> _vultureNakshatras = {
    'ashwini',
    'bharani',
    'krittika',
    'rohini',
    'mrigashira',
    'ardra',
  };

  static const Set<String> _owlNakshatras = {
    'punarvasu',
    'pushya',
    'ashlesha',
    'magha',
    'purva phalguni',
    'uttara phalguni',
  };

  static const Set<String> _crowNakshatras = {
    'hasta',
    'chitra',
    'swati',
    'vishakha',
    'anuradha',
  };

  static const Set<String> _roosterNakshatras = {
    'jyeshtha',
    'mula',
    'purva ashadha',
    'uttara ashadha',
    'shravana',
    'dhanishta',
  };

  static const Set<String> _peacockNakshatras = {
    'shatabhisha',
    'purva bhadrapada',
    'uttara bhadrapada',
    'revati',
  };
}
