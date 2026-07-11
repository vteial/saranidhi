import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          // Decorative breath icon with ring
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.air_rounded,
              size: 40,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.journalEmptyTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.journalEmptySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Subtle guidance arrow pointing up toward the entry widget
          Icon(
            Icons.keyboard_arrow_up_rounded,
            size: 28,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          Text(
            l10n.journalEmptyHint,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HistoryContent extends StatefulWidget {
  const _HistoryContent({required this.entries});

  final List<SaraKalaiJournalData> entries;

  @override
  State<_HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<_HistoryContent> {
  final Set<String> _expandedDates = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // Group by date
    final grouped = <String, List<SaraKalaiJournalData>>{};
    for (final entry in widget.entries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(entry);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    // Today's key
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            l10n.historyCount(widget.entries.length),
            style: theme.textTheme.titleSmall,
          ),
        ),
        ...sortedKeys.map((dateKey) {
          final dayEntries = grouped[dateKey]!;
          final isToday = dateKey == todayKey;
          final isExpanded = isToday || _expandedDates.contains(dateKey);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header — tappable for older dates
              InkWell(
                onTap: isToday
                    ? null
                    : () {
                        setState(() {
                          if (_expandedDates.contains(dateKey)) {
                            _expandedDates.remove(dateKey);
                          } else {
                            _expandedDates.add(dateKey);
                          }
                        });
                      },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        _formatDateLabel(dateKey, l10n),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (!isToday) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(${dayEntries.length})',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Entries — always visible for today, expandable for older
              if (isExpanded)
                ...dayEntries.map((entry) => _EntryTile(entry: entry)),
              const SizedBox(height: 8),
            ],
          );
        }),
      ],
    );
  }

  String _formatDateLabel(String dateKey, AppLocalizations l10n) {
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    if (dateKey == todayKey) return l10n.today;

    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayKey =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    if (dateKey == yesterdayKey) return l10n.yesterday;

    return dateKey;
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({required this.entry});

  final SaraKalaiJournalData entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
              l10n.flowLabel(_localizedFlowName(entry.actualFlow, l10n)),
              style: theme.textTheme.bodyMedium,
            ),
            subtitle: Text(
              '${l10n.expected}: ${_localizedFlowName(entry.expectedFlow, l10n)}',
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
                      label: l10n.timerIn,
                      ms: entry.inhaleDurationMs!,
                      theme: theme,
                    ),
                  if (entry.holdDurationMs != null &&
                      entry.holdDurationMs! > 0) ...[
                    const SizedBox(width: 8),
                    _TimingChip(
                      label: l10n.hold,
                      ms: entry.holdDurationMs!,
                      theme: theme,
                      highlight: true,
                    ),
                  ],
                  if (entry.exhaleDurationMs != null &&
                      entry.exhaleDurationMs! > 0) ...[
                    const SizedBox(width: 8),
                    _TimingChip(
                      label: l10n.timerOut,
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
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEntry),
        content: Text(l10n.deleteEntryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(journalRepositoryProvider).deleteEntry(entry.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  String _localizedFlowName(String flowStr, AppLocalizations l10n) {
    final flow = BreathFlow.values.where((f) => f.name == flowStr).firstOrNull;
    if (flow == null) return _capitalize(flowStr);
    return switch (flow) {
      BreathFlow.solar => l10n.solar,
      BreathFlow.lunar => l10n.lunar,
      BreathFlow.sushumna => l10n.sushumna,
    };
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
