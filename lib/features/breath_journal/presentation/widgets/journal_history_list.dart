import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';

/// Displays the journal history grouped by date, chronologically descending.
/// Supports delete via long-press or trailing icon.
class JournalHistoryList extends ConsumerWidget {
  const JournalHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesProvider);

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return const _EmptyHistory();
        }
        return _HistoryContent(entries: entries);
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('Error loading history: $error'),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No entries yet',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select your breath flow above to log your first entry',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({required this.entries});

  final List<SaraKalaiJournalData> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Group by date
    final grouped = <String, List<SaraKalaiJournalData>>{};
    for (final entry in entries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(entry);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'History (${entries.length} entries)',
            style: theme.textTheme.titleSmall,
          ),
        ),
        ...sortedKeys.map((dateKey) {
          final dayEntries = grouped[dateKey]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  _formatDateLabel(dateKey),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              ...dayEntries.map((entry) => _EntryTile(entry: entry)),
              const SizedBox(height: 8),
            ],
          );
        }),
      ],
    );
  }

  String _formatDateLabel(String dateKey) {
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    if (dateKey == todayKey) return 'Today';

    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayKey =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    if (dateKey == yesterdayKey) return 'Yesterday';

    return dateKey;
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({required this.entry});

  final SaraKalaiJournalData entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final time = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';

    final hasTimingData =
        (entry.inhaleDurationMs != null && entry.inhaleDurationMs! > 0) ||
        (entry.holdDurationMs != null && entry.holdDurationMs! > 0) ||
        (entry.exhaleDurationMs != null && entry.exhaleDurationMs! > 0);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: Icon(
              entry.isAligned ? Icons.check_circle : Icons.cancel_outlined,
              color: entry.isAligned
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
              size: 20,
            ),
            title: Text(
              '${_capitalize(entry.actualFlow)} flow',
              style: theme.textTheme.bodyMedium,
            ),
            subtitle: Text(
              'Expected: ${_capitalize(entry.expectedFlow)}',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: theme.colorScheme.error.withValues(alpha: 0.7),
                  ),
                  onPressed: () => _confirmDelete(context, ref),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                ),
              ],
            ),
          ),
          // Show timing data if present
          if (hasTimingData)
            Padding(
              padding: const EdgeInsets.only(left: 56, right: 16, bottom: 8),
              child: Row(
                children: [
                  if (entry.inhaleDurationMs != null &&
                      entry.inhaleDurationMs! > 0)
                    _TimingChip(
                      label: 'In',
                      ms: entry.inhaleDurationMs!,
                      theme: theme,
                    ),
                  if (entry.holdDurationMs != null &&
                      entry.holdDurationMs! > 0) ...[
                    const SizedBox(width: 8),
                    _TimingChip(
                      label: 'Hold',
                      ms: entry.holdDurationMs!,
                      theme: theme,
                      highlight: true,
                    ),
                  ],
                  if (entry.exhaleDurationMs != null &&
                      entry.exhaleDurationMs! > 0) ...[
                    const SizedBox(width: 8),
                    _TimingChip(
                      label: 'Out',
                      ms: entry.exhaleDurationMs!,
                      theme: theme,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('This will permanently remove this breath entry.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(journalRepositoryProvider).deleteEntry(entry.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}

class _TimingChip extends StatelessWidget {
  const _TimingChip({
    required this.label,
    required this.ms,
    required this.theme,
    this.highlight = false,
  });

  final String label;
  final int ms;
  final ThemeData theme;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final seconds = (ms / 1000).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: highlight
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: highlight ? Border.all(color: theme.colorScheme.primary) : null,
      ),
      child: Text(
        '$label: ${seconds}s',
        style: highlight
            ? theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              )
            : theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
      ),
    );
  }
}
