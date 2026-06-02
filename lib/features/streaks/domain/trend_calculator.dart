import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';

/// Result of the 30-day trend calculation.
class TrendResult {
  const TrendResult({
    required this.alignmentPercentage,
    required this.totalDaysWithEntries,
    required this.totalAlignedDays,
    required this.periodDays,
  });

  /// Rolling alignment percentage (0–100).
  final int alignmentPercentage;

  /// Number of days in the period that have at least one entry.
  final int totalDaysWithEntries;

  /// Number of days with at least one aligned entry.
  final int totalAlignedDays;

  /// The number of days in the calculation period.
  final int periodDays;
}

/// Result of Yama-level accuracy tracking.
class YamaAccuracyResult {
  const YamaAccuracyResult({
    required this.yamaEntries,
    required this.totalEntries,
  });

  /// Count of entries per Yama (yama1–yama5).
  final Map<String, int> yamaEntries;

  /// Total entries with Yama data.
  final int totalEntries;

  /// Returns the coverage percentage (how many of 5 yamas were captured).
  int get yamaCoverage {
    final captured = yamaEntries.values.where((v) => v > 0).length;
    return totalEntries == 0 ? 0 : (captured * 100 ~/ 5);
  }

  /// Returns the most frequently captured Yama.
  String? get mostCapturedYama {
    if (yamaEntries.isEmpty) return null;
    var maxKey = '';
    var maxVal = 0;
    for (final entry in yamaEntries.entries) {
      if (entry.value > maxVal) {
        maxVal = entry.value;
        maxKey = entry.key;
      }
    }
    return maxKey.isEmpty ? null : maxKey;
  }
}

/// Calculates trend metrics from daily alignment summaries.
class TrendCalculator {
  const TrendCalculator._();

  /// Calculates the rolling alignment percentage over [periodDays].
  ///
  /// [summaries] should contain daily summaries for the period.
  /// If no entries exist, returns 0%.
  static TrendResult calculate({
    required List<DailyAlignmentSummary> summaries,
    int periodDays = 30,
  }) {
    if (summaries.isEmpty) {
      return TrendResult(
        alignmentPercentage: 0,
        totalDaysWithEntries: 0,
        totalAlignedDays: 0,
        periodDays: periodDays,
      );
    }

    final daysWithEntries = summaries.where((s) => s.totalEntries > 0).length;
    final alignedDays = summaries.where((s) => s.hasAlignedEntry).length;

    final percentage = daysWithEntries == 0
        ? 0
        : (alignedDays * 100 ~/ daysWithEntries);

    return TrendResult(
      alignmentPercentage: percentage,
      totalDaysWithEntries: daysWithEntries,
      totalAlignedDays: alignedDays,
      periodDays: periodDays,
    );
  }

  /// Calculates Yama-level accuracy from raw entry data.
  ///
  /// [yamaValues] is a list of Yama strings (e.g., 'yama1', 'yama3') from
  /// journal entries.
  static YamaAccuracyResult calculateYamaAccuracy(List<String?> yamaValues) {
    final counts = <String, int>{
      'yama1': 0,
      'yama2': 0,
      'yama3': 0,
      'yama4': 0,
      'yama5': 0,
    };

    var total = 0;
    for (final yama in yamaValues) {
      if (yama != null && counts.containsKey(yama)) {
        counts[yama] = counts[yama]! + 1;
        total++;
      }
    }

    return YamaAccuracyResult(yamaEntries: counts, totalEntries: total);
  }
}
