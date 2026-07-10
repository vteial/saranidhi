import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/alignment_result_widget.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/breath_entry_widget.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/breath_timer_widget.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/journal_history_list.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/quick_sync_pacer.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// The Breath Journal screen — the core interaction surface of Saranidhi.
///
/// Displays:
/// - Two-click breath entry (Solar/Lunar/Sushumna)
/// - Alignment result with micro-advice
/// - Optional breath timer (inhale/hold/exhale)
/// - Quick Sync Pacer animation
/// - Submit button
/// - Journal history list (chronological, grouped by date)
class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryState = ref.watch(breathEntryNotifierProvider);
    final timerState = ref.watch(breathTimerNotifierProvider);
    final hasSelection = entryState.selectedFlow != null;
    final alignment = entryState.alignmentResult;
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;

    final entryPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Two-click breath entry
        const BreathEntryWidget(),
        const SizedBox(height: 16),

        // Alignment result + micro-advice
        const AlignmentResultWidget(),

        // Show timer and pacer only after selection
        if (hasSelection) ...[
          const SizedBox(height: 16),

          // Sushumna: disable timer, show meditation advice, log as moment
          if (entryState.selectedFlow == BreathFlow.sushumna) ...[
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.self_improvement,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.sushumnaAdvice,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Direct log button (no timer needed for Sushumna moment)
            Semantics(
              button: true,
              label: l10n.logBreathEntry,
              child: FilledButton.icon(
                onPressed: entryState.isSubmitting
                    ? null
                    : () => _submitSushumna(ref),
                icon: entryState.isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  entryState.isSubmitting ? l10n.saving : l10n.logBreathEntry,
                ),
              ),
            ),
          ] else ...[
            const BreathTimerWidget(),
            const SizedBox(height: 12),

            // Quick Sync Pacer (show if not aligned)
            if (alignment != null && !alignment.isAligned)
              const QuickSyncPacer(),

            const SizedBox(height: 16),

            // Submit button — only enabled after timer completes
            Semantics(
              button: true,
              label: timerState.phase == TimerPhase.complete
                  ? l10n.logBreathEntry
                  : l10n.completeTimerToLog,
              child: FilledButton.icon(
                onPressed:
                    entryState.isSubmitting ||
                        timerState.phase != TimerPhase.complete
                    ? null
                    : () => _submitEntry(ref, timerState),
                icon: entryState.isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  entryState.isSubmitting
                      ? l10n.saving
                      : timerState.phase == TimerPhase.complete
                      ? l10n.logBreathEntry
                      : l10n.completeTimerToLog,
                ),
              ),
            ),
          ],
        ],

        // Success message
        if (entryState.lastEntryId != null) ...[
          const SizedBox(height: 12),
          Card(
            color: Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.entryLoggedSuccess),
                ],
              ),
            ),
          ),
        ],
      ],
    );

    return Scaffold(
      appBar: BrandedAppBar(title: l10n.breathJournalTitle),
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.enter): () {
            if (!entryState.isSubmitting &&
                timerState.phase == TimerPhase.complete) {
              _submitEntry(ref, timerState);
            }
          },
        },
        child: Focus(
          autofocus: true,
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column: entry controls
                  Expanded(child: entryPanel),
                  const SizedBox(width: 16),
                  // Right column: journal history
                  const Expanded(child: JournalHistoryList()),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  entryPanel,
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  const JournalHistoryList(),
                ],
              ),
      ),
      ),
      ),
    );
  }

  void _submitEntry(WidgetRef ref, BreathTimerState timerState) {
    ref
        .read(breathEntryNotifierProvider.notifier)
        .submitEntry(
          inhaleDurationMs: timerState.phase == TimerPhase.complete
              ? timerState.inhaleMs
              : null,
          holdDurationMs: timerState.phase == TimerPhase.complete
              ? timerState.holdMs
              : null,
          exhaleDurationMs: timerState.phase == TimerPhase.complete
              ? timerState.exhaleMs
              : null,
        );
    // Reset timer after submit
    ref.read(breathTimerNotifierProvider.notifier).reset();
  }

  /// Submit a Sushumna entry as a "moment" (no timer data — duration tracking only).
  void _submitSushumna(WidgetRef ref) {
    ref.read(breathEntryNotifierProvider.notifier).submitEntry();
  }
}
