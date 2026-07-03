import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// A date selector row at the top of the Home dashboard.
///
/// Shows: [◀ Yesterday] [Today's date] [Tomorrow ▶]
/// Tapping the date opens a date picker dialog.
/// Tapping arrows navigates day-by-day.
/// A "Today" chip appears when viewing a non-today date for quick return.
class DateSelector extends ConsumerWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final isToday = ref.watch(isViewingTodayProvider);
    final theme = Theme.of(context);

    final dateFormat = DateFormat('EEE, MMM d');
    final dateLabel = isToday ? 'Today' : dateFormat.format(selectedDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Previous day
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeDate(ref, -1),
            tooltip: 'Previous day',
            visualDensity: VisualDensity.compact,
          ),

          // Date label (tappable for picker)
          Expanded(
            child: GestureDetector(
              onTap: () => _showDatePicker(context, ref, selectedDate),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isToday
                      ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        )
                      : theme.colorScheme.tertiaryContainer.withValues(
                          alpha: 0.3,
                        ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    dateLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isToday
                          ? theme.colorScheme.primary
                          : theme.colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Next day
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeDate(ref, 1),
            tooltip: 'Next day',
            visualDensity: VisualDensity.compact,
          ),

          // Quick buttons for non-today views
          if (isToday)
            TextButton.icon(
              onPressed: () => _changeDate(ref, 1),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('Tomorrow'),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),

          // "Today" reset button (only when not viewing today)
          if (!isToday)
            TextButton.icon(
              onPressed: () => _goToToday(ref),
              icon: const Icon(Icons.today, size: 16),
              label: const Text('Today'),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
        ],
      ),
    );
  }

  void _changeDate(WidgetRef ref, int days) {
    final current = ref.read(selectedDateProvider);
    ref.read(selectedDateProvider.notifier).select(
      current.add(Duration(days: days)),
    );
  }

  void _goToToday(WidgetRef ref) {
    ref.read(selectedDateProvider.notifier).select(DateTime.now());
  }

  Future<void> _showDatePicker(
    BuildContext context,
    WidgetRef ref,
    DateTime current,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      helpText: 'Select a date to view schedule',
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).select(picked);
    }
  }
}
