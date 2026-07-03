import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:saranidhi/core/utils/bird_emoji.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// Provider that fetches journal entries for the currently selected date.
final historicalEntriesProvider =
    FutureProvider<List<SaraKalaiJournalData>>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getEntriesForDate(selectedDate);
});

/// Card showing journal entries for the selected historical date.
///
/// Displays a compact list of breath entries with timestamp, flow,
/// alignment status, and hold time (if recorded).
/// Only visible when viewing a non-today date with entries.
class HistoricalEntriesCard extends ConsumerWidget {
  const HistoricalEntriesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(historicalEntriesProvider);
    final isToday = ref.watch(isViewingTodayProvider);
    final theme = Theme.of(context);

    // Don't show on today view (journal tab handles that)
    if (isToday) return const SizedBox.shrink();

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.event_note_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'No entries on this day',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Journal Entries (${entries.length})',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...entries.map(
                  (entry) => _EntryRow(entry: entry, theme: theme),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry, required this.theme});

  final SaraKalaiJournalData entry;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final time = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
    final timeStr = DateFormat('HH:mm').format(time);

    final flowIcon = switch (entry.actualFlow) {
      'solar' => '\u2600\uFE0F', // ☀️
      'lunar' => '\uD83C\uDF19', // 🌙
      _ => '\u2728', // ✨ (sushumna)
    };

    final alignIcon = entry.isAligned ? '✓' : '✗';
    final alignColor = entry.isAligned
        ? theme.colorScheme.primary
        : theme.colorScheme.error;

    // Bird state if available
    final birdInfo = entry.activeBird != null
        ? BirdEmoji.forBirdName(entry.activeBird!)
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 44,
            child: Text(
              timeStr,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Flow
          Text(flowIcon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          // Alignment
          Text(
            alignIcon,
            style: TextStyle(
              color: alignColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          // Bird state
          if (birdInfo.isNotEmpty)
            Text(birdInfo, style: const TextStyle(fontSize: 12)),
          if (entry.activeBirdState != null) ...[
            const SizedBox(width: 4),
            Text(
              entry.activeBirdState!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const Spacer(),
          // Hold time
          if (entry.holdDurationMs != null && entry.holdDurationMs! > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(entry.holdDurationMs! / 1000).toStringAsFixed(1)}s',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
