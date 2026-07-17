import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/astro_engine/domain/oracle_engine.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Dialog for viewing/adding reflective outcome notes to a past Prasanam query.
///
/// Shows the original query details and allows the user to add/edit
/// post-event reflections on whether the Oracle guidance was accurate.
void showOutcomeNotesDialog(
  BuildContext context, {
  required PrasanamHistoryData query,
  required Future<void> Function(String notes) onSave,
}) {
  showDialog<void>(
    context: context,
    builder: (_) => _OutcomeNotesDialog(query: query, onSave: onSave),
  );
}

class _OutcomeNotesDialog extends StatefulWidget {
  const _OutcomeNotesDialog({required this.query, required this.onSave});

  final PrasanamHistoryData query;
  final Future<void> Function(String notes) onSave;

  @override
  State<_OutcomeNotesDialog> createState() => _OutcomeNotesDialogState();
}

class _OutcomeNotesDialogState extends State<_OutcomeNotesDialog> {
  late final TextEditingController _notesController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: widget.query.outcomeNotes ?? '',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final isTamil = locale.languageCode == 'ta';

    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      widget.query.timestamp,
    );
    final dateFormat = DateFormat('MMM d, yyyy HH:mm', locale.languageCode);
    final band = OracleBand.values.firstWhere(
      (b) => b.name == widget.query.band,
      orElse: () => OracleBand.sunya,
    );
    final guidance = isTamil
        ? widget.query.guidanceTa
        : widget.query.guidanceEn;

    return AlertDialog(
      title: Text(l10n.prasanamOutcomeTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original query info
            _InfoRow(
              label: l10n.prasanamOutcomeDate,
              value: dateFormat.format(timestamp),
            ),
            _InfoRow(
              label: l10n.prasanamOutcomeCategory,
              value: _categoryLabel(widget.query.category, l10n),
            ),
            _InfoRow(
              label: l10n.prasanamScore,
              value: '${widget.query.score}/100 (${_bandLabel(band, l10n)})',
            ),
            if (widget.query.queryText.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '"${widget.query.queryText}"',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              guidance,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 24),

            // Outcome notes input
            Text(
              l10n.prasanamOutcomeNotesLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: l10n.prasanamOutcomeNotesHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _onSave,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }

  Future<void> _onSave() async {
    final notes = _notesController.text.trim();
    if (notes.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isSaving = true);
    await widget.onSave(notes);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _categoryLabel(String category, AppLocalizations l10n) {
    return switch (category) {
      'artha' => l10n.prasanamCategoryArtha,
      'kriya' => l10n.prasanamCategoryKriya,
      'yoga' => l10n.prasanamCategoryYoga,
      _ => category,
    };
  }

  String _bandLabel(OracleBand band, AppLocalizations l10n) {
    return switch (band) {
      OracleBand.siddha => l10n.prasanamBandSiddha,
      OracleBand.vardhana => l10n.prasanamBandVardhana,
      OracleBand.mandha => l10n.prasanamBandMandha,
      OracleBand.stambhana => l10n.prasanamBandStambhana,
      OracleBand.sunya => l10n.prasanamBandSunya,
    };
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
