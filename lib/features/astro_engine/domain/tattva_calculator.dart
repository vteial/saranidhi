import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

/// The five elements (Tattvas) that cycle within each Yama.
enum Tattva {
  earth,
  water,
  fire,
  air,
  ether;

  /// Display name with first letter capitalized.
  String get displayName => name[0].toUpperCase() + name.substring(1);

  /// Traditional Sanskrit name.
  String get sanskritName => switch (this) {
    Tattva.earth => 'Prithvi',
    Tattva.water => 'Apas',
    Tattva.fire => 'Tejas',
    Tattva.air => 'Vayu',
    Tattva.ether => 'Akasha',
  };
}

/// Result of a Tattva calculation for a specific time.
class TattvaResult {
  const TattvaResult({
    required this.tattva,
    required this.index,
    required this.start,
    required this.end,
    required this.yama,
  });

  /// The active element.
  final Tattva tattva;

  /// 0-based index of this tattva within the yama cycle (0–4).
  final int index;

  /// Start time of this tattva period.
  final DateTime start;

  /// End time of this tattva period.
  final DateTime end;

  /// The yama this tattva belongs to.
  final YamaIndex yama;

  /// Duration of this tattva period.
  Duration get duration => end.difference(start);

  /// Whether the given [time] falls within this tattva period.
  bool contains(DateTime time) {
    return !time.isBefore(start) && time.isBefore(end);
  }
}

/// Calculates the Tattva (element) cycle within each Yama.
///
/// Within each Yama, the 5 elements cycle in fixed order:
/// Earth → Water → Fire → Air → Ether
///
/// Each element lasts for an equal sub-division of the Yama duration.
/// For a typical 12-hour day (144-minute Yamas), each Tattva lasts
/// approximately 28.8 minutes.
class TattvaCalculator {
  const TattvaCalculator._();

  /// Fixed cycle order of tattvas within each Yama.
  static const List<Tattva> cycleOrder = [
    Tattva.earth,
    Tattva.water,
    Tattva.fire,
    Tattva.air,
    Tattva.ether,
  ];

  /// Calculates all 5 tattva periods within a given [yamaSegment].
  static List<TattvaResult> calculateForYama(YamaSegment yamaSegment) {
    final totalMs = yamaSegment.duration.inMilliseconds;
    final tattvaDurationMs = totalMs ~/ 5;

    return List.generate(5, (i) {
      final start = yamaSegment.start.add(
        Duration(milliseconds: tattvaDurationMs * i),
      );
      final end = (i == 4)
          ? yamaSegment.end
          : yamaSegment.start.add(
              Duration(milliseconds: tattvaDurationMs * (i + 1)),
            );

      return TattvaResult(
        tattva: cycleOrder[i],
        index: i,
        start: start,
        end: end,
        yama: yamaSegment.index,
      );
    });
  }

  /// Returns the active [TattvaResult] for a given [time] within a
  /// [yamaSegment], or `null` if time is outside the yama.
  static TattvaResult? activeTattva({
    required DateTime time,
    required YamaSegment yamaSegment,
  }) {
    if (!yamaSegment.contains(time)) return null;

    final tattvas = calculateForYama(yamaSegment);
    for (final tattva in tattvas) {
      if (tattva.contains(time)) return tattva;
    }
    return null;
  }
}
