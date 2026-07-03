import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// Provider that fetches which days in a given month have journal entries.
///
/// Returns a Set of day-of-month integers (1-31) that have at least one entry.
final monthEntryDaysProvider =
    FutureProvider.family<Set<int>, DateTime>((ref, month) async {
  final db = ref.watch(appDatabaseProvider);

  final startOfMonth = DateTime(month.year, month.month);
  final endOfMonth = DateTime(month.year, month.month + 1);

  final entries = await (db.select(db.saraKalaiJournal)
        ..where(
          (t) =>
              t.timestamp.isBiggerOrEqualValue(
                startOfMonth.millisecondsSinceEpoch,
              ) &
              t.timestamp.isSmallerThanValue(
                endOfMonth.millisecondsSinceEpoch,
              ),
        ))
      .get();

  final days = <int>{};
  for (final entry in entries) {
    final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
    days.add(date.day);
  }
  return days;
});

/// A compact calendar month view showing which days have journal entries.
///
/// Tapping a day navigates the date selector to that date.
/// Days with entries show a colored dot indicator.
/// The selected date is highlighted.
class CalendarMonthView extends ConsumerStatefulWidget {
  const CalendarMonthView({super.key});

  @override
  ConsumerState<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends ConsumerState<CalendarMonthView> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final entryDaysAsync = ref.watch(
      monthEntryDaysProvider(
        DateTime(_displayedMonth.year, _displayedMonth.month),
      ),
    );
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month header with navigation
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: _previousMonth,
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat('MMMM yyyy').format(_displayedMonth),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: _nextMonth,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map(
                    (d) => SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(
                          d,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 4),

            // Calendar grid
            entryDaysAsync.when(
              data: (entryDays) => _buildCalendarGrid(
                theme: theme,
                selectedDate: selectedDate,
                entryDays: entryDays,
              ),
              loading: () => const SizedBox(height: 180),
              error: (_, __) => const SizedBox(height: 180),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid({
    required ThemeData theme,
    required DateTime selectedDate,
    required Set<int> entryDays,
  }) {
    final firstDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;

    // Sunday = 0 start (DateTime.sunday = 7, so we convert)
    final startWeekday = firstDayOfMonth.weekday % 7;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final rows = <Widget>[];
    var dayCounter = 1;
    var weekStarted = false;

    for (var week = 0; week < 6; week++) {
      if (dayCounter > daysInMonth) break;

      final cells = <Widget>[];
      for (var weekday = 0; weekday < 7; weekday++) {
        if (!weekStarted && weekday < startWeekday) {
          cells.add(const SizedBox(width: 32, height: 36));
          continue;
        }
        weekStarted = true;

        if (dayCounter > daysInMonth) {
          cells.add(const SizedBox(width: 32, height: 36));
          continue;
        }

        final day = dayCounter;
        final date = DateTime(
          _displayedMonth.year,
          _displayedMonth.month,
          day,
        );
        final isSelected = date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;
        final isToday = date == today;
        final hasEntry = entryDays.contains(day);
        final isFuture = date.isAfter(today);

        cells.add(
          _DayCell(
            day: day,
            isSelected: isSelected,
            isToday: isToday,
            hasEntry: hasEntry,
            isFuture: isFuture,
            theme: theme,
            onTap: () {
              ref.read(selectedDateProvider.notifier).state = date;
            },
          ),
        );
        dayCounter++;
      }

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: cells,
        ),
      );
    }

    return Column(children: rows);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.hasEntry,
    required this.isFuture,
    required this.theme,
    required this.onTap,
  });

  final int day;
  final bool isSelected;
  final bool isToday;
  final bool hasEntry;
  final bool isFuture;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? theme.colorScheme.primary
        : isToday
            ? theme.colorScheme.primaryContainer
            : null;

    final textColor = isSelected
        ? theme.colorScheme.onPrimary
        : isFuture
            ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
            : theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: bgColor != null
                  ? BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Center(
                child: Text(
                  '$day',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            // Entry indicator dot
            if (hasEntry)
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
