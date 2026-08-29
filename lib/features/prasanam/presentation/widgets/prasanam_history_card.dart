import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/astro_engine/domain/oracle_engine.dart';
import 'package:saranidhi/features/prasanam/presentation/widgets/outcome_notes_dialog.dart';
import 'package:saranidhi/features/prasanam/providers/prasanam_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays a chronological timeline of past Prasanam Oracle queries.
///
/// Shown on the Explore tab below the existing content.
class PrasanamHistoryCard extends ConsumerWidget {
  const PrasanamHistoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(prasanamHistoryProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return historyAsync.when(
      data: (queries) {
        if (queries.isEmpty) return const SizedBox.shrink();

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.prasanamHistoryTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                // Show last 5 queries
                ...queries.take(5).map(
                  (query) => _PrasanamHistoryTile(query: query),
                ),
                if (queries.length > 5) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      l10n.prasanamHistoryMore(queries.length - 5),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
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

class _PrasanamHistoryTile extends ConsumerStatefulWidget {
  const _PrasanamHistoryTile({required this.query});

  final PrasanamHistoryData query;

  @override
  ConsumerState<_PrasanamHistoryTile> createState() =>
      _PrasanamHistoryTileState();
}

class _PrasanamHistoryTileState extends ConsumerState<_PrasanamHistoryTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final query = widget.query;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    final timestamp = DateTime.fromMillisecondsSinceEpoch(query.timestamp);
    final dateFormat = DateFormat('MMM d, HH:mm', locale.languageCode);
    final band = OracleBand.values.firstWhere(
      (b) => b.name == query.band,
      orElse: () => OracleBand.sunya,
    );
    final bandColor = _bandColor(band, theme);
    final hasOutcome = query.outcomeNotes != null &&
        query.outcomeNotes!.isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Dismissible(
        key: ValueKey(query.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.delete_outline, color: theme.colorScheme.error),
        ),
        confirmDismiss: (_) => _confirmDelete(context, l10n),
        onDismissed: (_) => _deleteQuery(),
        child: InkWell(
          onTap: () => _showOutcomeDialog(context, ref),
          borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Score badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bandColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: bandColor.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  '${query.score}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: bandColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _categoryLabel(query.category, l10n),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (query.queryText.isNotEmpty)
                    Text(
                      query.queryText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Outcome indicator
            if (hasOutcome)
              Icon(
                Icons.note_alt_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              )
            else
              Icon(
                Icons.add_comment_outlined,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            // Desktop delete: trash icon appears on hover (mouse only).
            // Touch users keep swipe-to-delete.
            if (_hovering) ...[
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                tooltip: l10n.prasanamDeleteConfirm,
                visualDensity: VisualDensity.compact,
                onPressed: () async {
                  final confirmed = await _confirmDelete(context, l10n);
                  if (confirmed ?? false) _deleteQuery();
                },
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  void _deleteQuery() {
    ref.read(prasanamRepositoryProvider).deleteQuery(widget.query.id);
    ref.invalidate(prasanamHistoryProvider);
  }

  Future<bool?> _confirmDelete(BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.prasanamDeleteTitle),
        content: Text(l10n.prasanamDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l10n.prasanamDeleteConfirm),
          ),
        ],
      ),
    );
  }

  void _showOutcomeDialog(BuildContext context, WidgetRef ref) {
    showOutcomeNotesDialog(
      context,
      query: widget.query,
      onSave: (notes) async {
        final repo = ref.read(prasanamRepositoryProvider);
        await repo.updateOutcomeNotes(id: widget.query.id, notes: notes);
        ref.invalidate(prasanamHistoryProvider);
      },
    );
  }

  Color _bandColor(OracleBand band, ThemeData theme) {
    return switch (band) {
      OracleBand.siddha => Colors.green.shade700,
      OracleBand.vardhana => Colors.teal.shade600,
      OracleBand.mandha => Colors.orange.shade700,
      OracleBand.stambhana => Colors.deepOrange.shade700,
      OracleBand.sunya => Colors.red.shade800,
    };
  }

  String _categoryLabel(String category, AppLocalizations l10n) {
    return switch (category) {
      'artha' => l10n.prasanamCategoryArtha,
      'kriya' => l10n.prasanamCategoryKriya,
      'yoga' => l10n.prasanamCategoryYoga,
      _ => category,
    };
  }
}
