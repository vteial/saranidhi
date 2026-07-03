import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// The displayed month for the calendar view.
final calendarMonthProvider =
    NotifierProvider<CalendarMonthNotifier, DateTime>(
      CalendarMonthNotifier.new,
    );

class CalendarMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void setMonth(DateTime month) => state = month;

  void changeMonth(int offset) {
    state = DateTime(state.year, state.month + offset);
  }
}

/// Provider that fetches which days in the displayed month have journal entries.
///
/// Returns a Set of day-of-month integers (1-31) that have at least one entry.
final monthEntryDaysProvider = FutureProvider<Set<int>>((ref) async {
  final month = ref.watch(calendarMonthProvider);
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
class CalendarMonthView extends ConsumerWidget {
  const CalendarMonthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final displayedMonth = ref.watch(calendarMonthProvider);
    final entryDaysAsync = ref.watch(monthEntryDaysProvider);
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
                  onPressed: () => _changeMonth(ref, -1),
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat('MMMM yyyy').format(displayedMonth),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: () => _changeMonth(ref, 1),
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
                ref: ref,
                theme: theme,
                selectedDate: selectedDate,
                displayedMonth: displayedMonth,
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

  void _changeMonth(WidgetRef ref, int offset) {
    ref.read(calendarMonthProvider.notifier).changeMonth(offset);
  }

  Widget _buildCalendarGrid({
    required WidgetRef ref,
    required ThemeData theme,
    required DateTime selectedDate,
    required DateTime displayedMonth,
    required Set<int> entryDays,
  }) {
    final firstDayOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month,
    );
    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;

    // Sunday = 0 start
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
          displayedMonth.year,
          displayedMonth.month,
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
              ref.read(selectedDateProvider.notifier).setDate(date);
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
