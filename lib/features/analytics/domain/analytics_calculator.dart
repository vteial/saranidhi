import 'package:saranidhi/database/app_database.dart';

/// Weekly alignment summary for a single week.
class WeeklySummary {
  const WeeklySummary({
    required this.weekStart,
    required this.weekEnd,
    required this.totalEntries,
    required this.alignedEntries,
    required this.daysWithEntries,
  });

  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalEntries;
  final int alignedEntries;
  final int daysWithEntries;

  int get alignmentPercentage =>
      totalEntries == 0 ? 0 : (alignedEntries * 100 ~/ totalEntries);
}

/// Monthly patterns analysis result.
class MonthlyPatterns {
  const MonthlyPatterns({
    required this.bestDay,
    required this.worstDay,
    required this.mostActiveYama,
    required this.leastActiveYama,
    required this.totalEntries,
    required this.totalAligned,
    required this.avgEntriesPerDay,
    required this.activeDays,
  });

  final String? bestDay; // Day of week name with highest alignment
  final String? worstDay; // Day of week name with lowest alignment
  final String? mostActiveYama;
  final String? leastActiveYama;
  final int totalEntries;
  final int totalAligned;
  final double avgEntriesPerDay;
  final int activeDays;

  int get alignmentPercentage =>
      totalEntries == 0 ? 0 : (totalAligned * 100 ~/ totalEntries);
}

/// Extended streak insights.
class StreakInsights {
  const StreakInsights({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalPracticeDays,
    required this.totalDaysSinceFirst,
    required this.averageGapDays,
    required this.practiceConsistency,
  });

  final int currentStreak;
  final int longestStreak;
  final int totalPracticeDays;
  final int totalDaysSinceFirst;
  final double averageGapDays;
  final int practiceConsistency; // percentage (practiceDays / totalDays)
}

/// Hold time progression data point.
class HoldTimeDataPoint {
  const HoldTimeDataPoint({
    required this.date,
    required this.averageMs,
    required this.entryCount,
  });

  final DateTime date;
  final double averageMs;
  final int entryCount;
}

/// Hold time progression result.
class HoldTimeProgression {
  const HoldTimeProgression({
    required this.dailyAverages,
    required this.weeklyAverage,
    required this.monthlyAverage,
    required this.allTimeAverage,
    required this.personalBestMs,
    required this.personalBestDate,
    required this.trendDirection,
    required this.totalSessions,
  });

  final List<HoldTimeDataPoint> dailyAverages;
  final double weeklyAverage;
  final double monthlyAverage;
  final double allTimeAverage;
  final int personalBestMs;
  final DateTime? personalBestDate;
  final TrendDirection trendDirection;
  final int totalSessions;
}

/// Trend direction for hold time.
enum TrendDirection { improving, stable, declining }

/// Calculates analytics from journal entries.
class AnalyticsCalculator {
  const AnalyticsCalculator._();

  /// Calculate weekly alignment summaries for the last N weeks.
  static List<WeeklySummary> calculateWeeklySummaries({
    required List<SaraKalaiJournalData> entries,
    int weeks = 4,
  }) {
    if (entries.isEmpty) return [];

    final now = DateTime.now();
    final summaries = <WeeklySummary>[];

    for (var w = 0; w < weeks; w++) {
      final weekEnd = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: w * 7));
      final weekStart = weekEnd.subtract(const Duration(days: 6));

      final weekEntries = entries.where((e) {
        final date = DateTime.fromMillisecondsSinceEpoch(e.timestamp);
        return !date.isBefore(weekStart) &&
            date.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();

      final daysWithEntries = <int>{};
      for (final entry in weekEntries) {
        final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
        daysWithEntries.add(date.day * 100 + date.month);
      }

      summaries.add(
        WeeklySummary(
          weekStart: weekStart,
          weekEnd: weekEnd,
          totalEntries: weekEntries.length,
          alignedEntries: weekEntries.where((e) => e.isAligned).length,
          daysWithEntries: daysWithEntries.length,
        ),
      );
    }

    return summaries;
  }

  /// Calculate monthly patterns from entries.
  static MonthlyPatterns calculateMonthlyPatterns({
    required List<SaraKalaiJournalData> entries,
  }) {
    if (entries.isEmpty) {
      return const MonthlyPatterns(
        bestDay: null,
        worstDay: null,
        mostActiveYama: null,
        leastActiveYama: null,
        totalEntries: 0,
        totalAligned: 0,
        avgEntriesPerDay: 0,
        activeDays: 0,
      );
    }

    // Day-of-week analysis
    final dayAligned = <int, int>{};
    final dayTotal = <int, int>{};
    final activeDaysSet = <String>{};

    for (final entry in entries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
      final weekday = date.weekday;
      dayTotal[weekday] = (dayTotal[weekday] ?? 0) + 1;
      if (entry.isAligned) {
        dayAligned[weekday] = (dayAligned[weekday] ?? 0) + 1;
      }
      activeDaysSet.add('${date.year}-${date.month}-${date.day}');
    }

    // Find best/worst day
    String? bestDay;
    String? worstDay;
    var bestPct = -1.0;
    var worstPct = 101.0;

    for (final weekday in dayTotal.keys) {
      final total = dayTotal[weekday]!;
      final aligned = dayAligned[weekday] ?? 0;
      final pct = aligned / total;
      if (pct > bestPct) {
        bestPct = pct;
        bestDay = _weekdayName(weekday);
      }
      if (pct < worstPct) {
        worstPct = pct;
        worstDay = _weekdayName(weekday);
      }
    }

    // Yama analysis
    final yamaCounts = <String, int>{};
    for (final entry in entries) {
      if (entry.activeYama != null) {
        yamaCounts[entry.activeYama!] =
            (yamaCounts[entry.activeYama!] ?? 0) + 1;
      }
    }

    String? mostActiveYama;
    String? leastActiveYama;
    if (yamaCounts.isNotEmpty) {
      final sorted = yamaCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      mostActiveYama = sorted.first.key;
      leastActiveYama = sorted.last.key;
    }

    return MonthlyPatterns(
      bestDay: bestDay,
      worstDay: worstDay,
      mostActiveYama: mostActiveYama,
      leastActiveYama: leastActiveYama,
      totalEntries: entries.length,
      totalAligned: entries.where((e) => e.isAligned).length,
      avgEntriesPerDay: entries.length / activeDaysSet.length,
      activeDays: activeDaysSet.length,
    );
  }

  /// Calculate extended streak insights.
  static StreakInsights calculateStreakInsights({
    required List<SaraKalaiJournalData> entries,
    required int currentStreak,
    required int longestStreak,
  }) {
    if (entries.isEmpty) {
      return StreakInsights(
        currentStreak: 0,
        longestStreak: 0,
        totalPracticeDays: 0,
        totalDaysSinceFirst: 0,
        averageGapDays: 0,
        practiceConsistency: 0,
      );
    }

    // Get unique practice days
    final practiceDays = <String>{};
    for (final entry in entries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
      practiceDays.add('${date.year}-${date.month}-${date.day}');
    }

    // Days since first entry
    final timestamps = entries.map((e) => e.timestamp).toList()..sort();
    final firstEntry = DateTime.fromMillisecondsSinceEpoch(timestamps.first);
    final totalDays = DateTime.now().difference(firstEntry).inDays + 1;

    // Average gap between practice days
    final sortedDays = practiceDays.toList()..sort();
    var totalGap = 0;
    var gapCount = 0;
    for (var i = 1; i < sortedDays.length; i++) {
      final prev = _parseDate(sortedDays[i - 1]);
      final curr = _parseDate(sortedDays[i]);
      final gap = curr.difference(prev).inDays - 1;
      if (gap > 0) {
        totalGap += gap;
        gapCount++;
      }
    }

    final avgGap = gapCount > 0 ? totalGap / gapCount : 0.0;
    final consistency = totalDays > 0
        ? (practiceDays.length * 100 ~/ totalDays)
        : 0;

    return StreakInsights(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalPracticeDays: practiceDays.length,
      totalDaysSinceFirst: totalDays,
      averageGapDays: avgGap,
      practiceConsistency: consistency,
    );
  }

  /// Calculate hold time progression.
  static HoldTimeProgression calculateHoldTimeProgression({
    required List<SaraKalaiJournalData> entries,
  }) {
    final holdEntries = entries
        .where((e) => e.holdDurationMs != null && e.holdDurationMs! > 0)
        .toList();

    if (holdEntries.isEmpty) {
      return const HoldTimeProgression(
        dailyAverages: [],
        weeklyAverage: 0,
        monthlyAverage: 0,
        allTimeAverage: 0,
        personalBestMs: 0,
        personalBestDate: null,
        trendDirection: TrendDirection.stable,
        totalSessions: 0,
      );
    }

    // Group by day
    final dailyMap = <String, List<int>>{};
    var personalBestMs = 0;
    DateTime? personalBestDate;

    for (final entry in holdEntries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
      final key = '${date.year}-${date.month}-${date.day}';
      dailyMap.putIfAbsent(key, () => []).add(entry.holdDurationMs!);

      if (entry.holdDurationMs! > personalBestMs) {
        personalBestMs = entry.holdDurationMs!;
        personalBestDate = date;
      }
    }

    // Daily averages
    final dailyAverages = dailyMap.entries.map((e) {
      final avg = e.value.reduce((a, b) => a + b) / e.value.length;
      return HoldTimeDataPoint(
        date: _parseDate(e.key),
        averageMs: avg,
        entryCount: e.value.length,
      );
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    // Weekly average (last 7 days)
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final weekEntries = holdEntries.where((e) {
      final date = DateTime.fromMillisecondsSinceEpoch(e.timestamp);
      return date.isAfter(weekAgo);
    }).toList();
    final weeklyAvg = weekEntries.isEmpty
        ? 0.0
        : weekEntries.map((e) => e.holdDurationMs!).reduce((a, b) => a + b) /
            weekEntries.length;

    // Monthly average (last 30 days)
    final monthAgo = now.subtract(const Duration(days: 30));
    final monthEntries = holdEntries.where((e) {
      final date = DateTime.fromMillisecondsSinceEpoch(e.timestamp);
      return date.isAfter(monthAgo);
    }).toList();
    final monthlyAvg = monthEntries.isEmpty
        ? 0.0
        : monthEntries.map((e) => e.holdDurationMs!).reduce((a, b) => a + b) /
            monthEntries.length;

    // All-time average
    final allTimeAvg =
        holdEntries.map((e) => e.holdDurationMs!).reduce((a, b) => a + b) /
            holdEntries.length;

    // Trend direction (compare last week to previous week)
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final prevWeekEntries = holdEntries.where((e) {
      final date = DateTime.fromMillisecondsSinceEpoch(e.timestamp);
      return date.isAfter(twoWeeksAgo) && date.isBefore(weekAgo);
    }).toList();
    final prevWeekAvg = prevWeekEntries.isEmpty
        ? 0.0
        : prevWeekEntries
                .map((e) => e.holdDurationMs!)
                .reduce((a, b) => a + b) /
            prevWeekEntries.length;

    TrendDirection trend;
    if (prevWeekAvg == 0 || weeklyAvg == 0) {
      trend = TrendDirection.stable;
    } else if (weeklyAvg > prevWeekAvg * 1.1) {
      trend = TrendDirection.improving;
    } else if (weeklyAvg < prevWeekAvg * 0.9) {
      trend = TrendDirection.declining;
    } else {
      trend = TrendDirection.stable;
    }

    return HoldTimeProgression(
      dailyAverages: dailyAverages,
      weeklyAverage: weeklyAvg,
      monthlyAverage: monthlyAvg,
      allTimeAverage: allTimeAvg,
      personalBestMs: personalBestMs,
      personalBestDate: personalBestDate,
      trendDirection: trend,
      totalSessions: holdEntries.length,
    );
  }

  /// Generate CSV string from journal entries.
  static String generateCsv(List<SaraKalaiJournalData> entries) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
      'Date,Time,Expected Flow,Actual Flow,Aligned,Nostril,'
      'Inhale (ms),Hold (ms),Exhale (ms),Yama,Bird,Bird State,Element,Notes',
    );

    // Data rows
    for (final entry in entries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final timeStr =
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

      buffer.writeln(
        '$dateStr,$timeStr,${entry.expectedFlow},${entry.actualFlow},'
        '${entry.isAligned},${entry.nostril},'
        '${entry.inhaleDurationMs ?? ""},${entry.holdDurationMs ?? ""},'
        '${entry.exhaleDurationMs ?? ""},${entry.activeYama ?? ""},'
        '${entry.activeBird ?? ""},${entry.activeBirdState ?? ""},'
        '${entry.activeElement ?? ""},'
        '"${(entry.notes ?? "").replaceAll('"', '""')}"',
      );
    }

    return buffer.toString();
  }

  static String _weekdayName(int weekday) => switch (weekday) {
    1 => 'Monday',
    2 => 'Tuesday',
    3 => 'Wednesday',
    4 => 'Thursday',
    5 => 'Friday',
    6 => 'Saturday',
    7 => 'Sunday',
    _ => '',
  };

  static DateTime _parseDate(String key) {
    final parts = key.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
