import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';

/// Status for a single day in the 7-day ribbon.
enum DayStatus {
  /// Day has at least one aligned entry.
  aligned,

  /// Day has entries but none aligned.
  unaligned,

  /// Day has no entries.
  noEntry,

  /// Day is in the future.
  future,
}

/// Represents one day in the 7-day ribbon.
class RibbonDay {
  const RibbonDay({
    required this.date,
    required this.status,
    required this.dayLabel,
  });

  final DateTime date;
  final DayStatus status;
  final String dayLabel;
}

/// Builds the 7-day ribbon data from daily summaries.
class SevenDayRibbon {
  const SevenDayRibbon._();

  static const _dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  /// Generates 7 days of ribbon data ending at [today].
  ///
  /// [summaries] should cover at least the last 7 days.
  static List<RibbonDay> generate({
    required List<DailyAlignmentSummary> summaries,
    required DateTime today,
  }) {
    final todayDate = DateTime(today.year, today.month, today.day);
    final summaryMap = <String, DailyAlignmentSummary>{};

    for (final s in summaries) {
      final key = _dateKey(s.date);
      summaryMap[key] = s;
    }

    final ribbon = <RibbonDay>[];
    for (var i = 6; i >= 0; i--) {
      final date = todayDate.subtract(Duration(days: i));
      final key = _dateKey(date);
      final summary = summaryMap[key];

      DayStatus status;
      if (date.isAfter(todayDate)) {
        status = DayStatus.future;
      } else if (summary == null || summary.totalEntries == 0) {
        status = DayStatus.noEntry;
      } else if (summary.hasAlignedEntry) {
        status = DayStatus.aligned;
      } else {
        status = DayStatus.unaligned;
      }

      // Weekday: Dart uses 1=Mon..7=Sun, we need 0=Sun index
      final weekdayIndex = date.weekday % 7;

      ribbon.add(
        RibbonDay(
          date: date,
          status: status,
          dayLabel: _dayLabels[weekdayIndex],
        ),
      );
    }

    return ribbon;
  }

  static String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
