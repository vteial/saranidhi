import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';

/// Displays the journal history grouped by date, chronologically descending.
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

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});

  final SaraKalaiJournalData entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
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
        trailing: Text(
          timeStr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}
