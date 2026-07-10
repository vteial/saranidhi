import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/utils/pakshi_l10n.dart';
import 'package:saranidhi/features/breath_journal/domain/alignment_checker.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays the alignment result with micro-advice after breath selection.
class AlignmentResultWidget extends ConsumerWidget {
  const AlignmentResultWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryState = ref.watch(breathEntryNotifierProvider);
    final alignment = entryState.alignmentResult;
    final selectedFlow = entryState.selectedFlow;

    if (alignment == null || selectedFlow == null) {
      return const SizedBox.shrink();
    }

    // Sushumna: don't show alignment result — it's a sacred observation moment
    if (selectedFlow == BreathFlow.sushumna) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isAligned = alignment.isAligned;

    final advice = _localizedAdvice(
      alignment: alignment,
      actualFlow: selectedFlow,
      l10n: l10n,
    );

    return Card(
      color: isAligned
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
          : theme.colorScheme.errorContainer.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAligned ? Icons.check_circle : Icons.info_outline,
                  color: isAligned
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  isAligned ? l10n.aligned : l10n.notAligned,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isAligned
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${l10n.expected}: ${_localizedFlowLabel(alignment.expectedFlow, l10n)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(advice, style: theme.textTheme.bodyMedium),
            if (alignment.activeBird != null) ...[
              const SizedBox(height: 8),
              Text(
                '${alignment.activeBird!.localizedName(l10n)} • '
                '${alignment.activeBirdState?.localizedName(l10n) ?? ""} • '
                '${_localizedYamaLabel(alignment, l10n)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _localizedFlowLabel(BreathFlow flow, AppLocalizations l10n) =>
      switch (flow) {
        BreathFlow.solar => l10n.solar,
        BreathFlow.lunar => l10n.lunar,
        BreathFlow.sushumna => l10n.sushumna,
      };

  String _localizedYamaLabel(AlignmentResult alignment, AppLocalizations l10n) {
    final yama = alignment.activeYama;
    if (yama == null) return '';
    return '${l10n.yamaPrefix} ${yama.index + 1}';
  }

  String _localizedAdvice({
    required AlignmentResult alignment,
    required BreathFlow actualFlow,
    required AppLocalizations l10n,
  }) {
    if (alignment.isAligned) {
      if (actualFlow == BreathFlow.sushumna) {
        return l10n.adviceAlignedSushumna;
      }
      if (actualFlow == BreathFlow.solar) {
        return l10n.adviceAlignedSolar;
      }
      return l10n.adviceAlignedLunar;
    }
    final expected = alignment.expectedFlow;
    if (expected == BreathFlow.solar) {
      return l10n.adviceUnalignedSolar;
    }
    return l10n.adviceUnalignedLunar;
  }
}
