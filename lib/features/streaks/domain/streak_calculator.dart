/// Represents a daily alignment summary used for streak calculation.
class DailyAlignmentSummary {
  const DailyAlignmentSummary({
    required this.date,
    required this.hasAlignedEntry,
    required this.totalEntries,
    required this.alignedEntries,
  });

  /// The date this summary represents (date only, no time).
  final DateTime date;

  /// Whether at least one aligned entry exists for this day.
  final bool hasAlignedEntry;

  /// Total number of entries logged this day.
  final int totalEntries;

  /// Number of aligned entries this day.
  final int alignedEntries;
}

/// Result of a streak calculation.
class StreakResult {
  const StreakResult({
    required this.currentStreak,
    required this.longestStreak,
    required this.isActiveToday,
  });

  /// Consecutive days with aligned entries counting back from today/yesterday.
  final int currentStreak;

  /// The longest streak ever recorded.
  final int longestStreak;

  /// Whether today already has an aligned entry (streak includes today).
  final bool isActiveToday;
}

/// Calculates streaks from daily alignment summaries.
///
/// A streak is defined as consecutive days where the day has an aligned entry.
/// The current streak counts backwards from today (or yesterday if today
/// has no entry yet).
class StreakCalculator {
  const StreakCalculator._();

  /// Calculates the current and longest streak from a list of daily summaries.
  ///
  /// [summaries] should be ordered by date descending (newest first).
  /// [today] is the reference date for "current" streak calculation.
  static StreakResult calculate({
    required List<DailyAlignmentSummary> summaries,
    required DateTime today,
  }) {
    if (summaries.isEmpty) {
      return const StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        isActiveToday: false,
      );
    }

    final todayDate = _dateOnly(today);

    // Sort by date descending
    final sorted = List<DailyAlignmentSummary>.from(summaries)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Calculate current streak
    var currentStreak = 0;
    var isActiveToday = false;
    var expectedDate = todayDate;

    for (final summary in sorted) {
      final summaryDate = _dateOnly(summary.date);

      // If today has no entry, start from yesterday
      if (currentStreak == 0 &&
          summaryDate != todayDate &&
          summaryDate == todayDate.subtract(const Duration(days: 1))) {
        expectedDate = summaryDate;
      }

      if (summaryDate == expectedDate) {
        if (summary.hasAlignedEntry) {
          currentStreak++;
          if (summaryDate == todayDate) isActiveToday = true;
          expectedDate = expectedDate.subtract(const Duration(days: 1));
        } else {
          break; // Day exists but no alignment — streak broken
        }
      } else if (summaryDate.isBefore(expectedDate)) {
        // Missed day(s) — streak broken
        break;
      }
      // Skip if summaryDate is after expectedDate (shouldn't happen with sort)
    }

    // Calculate longest streak
    final longestStreak = _calculateLongest(sorted);

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak: longestStreak > currentStreak
          ? longestStreak
          : currentStreak,
      isActiveToday: isActiveToday,
    );
  }

  static int _calculateLongest(List<DailyAlignmentSummary> sortedDesc) {
    if (sortedDesc.isEmpty) return 0;

    // Reverse to chronological order for longest calculation
    final chronological = sortedDesc.reversed.toList();
    var longest = 0;
    var current = 0;

    for (var i = 0; i < chronological.length; i++) {
      if (chronological[i].hasAlignedEntry) {
        if (current == 0) {
          current = 1;
        } else {
          // Check if consecutive with previous
          final prevDate = _dateOnly(chronological[i - 1].date);
          final thisDate = _dateOnly(chronological[i].date);
          final diff = thisDate.difference(prevDate).inDays;
          if (diff == 1) {
            current++;
          } else {
            current = 1; // Gap — restart
          }
        }
        if (current > longest) longest = current;
      } else {
        current = 0;
      }
    }

    return longest;
  }

  static DateTime _dateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }
}
