import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/alignment_result_widget.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/breath_entry_widget.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/breath_timer_widget.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/journal_history_list.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/quick_sync_pacer.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';

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

    return Scaffold(
      appBar: const BrandedAppBar(title: 'Breath Journal'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
              const BreathTimerWidget(),
              const SizedBox(height: 12),

              // Quick Sync Pacer (show if not aligned)
              if (alignment != null && !alignment.isAligned)
                const QuickSyncPacer(),

              const SizedBox(height: 16),

              // Submit button — only enabled after timer completes
              FilledButton.icon(
                onPressed: entryState.isSubmitting ||
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
                      ? 'Saving...'
                      : timerState.phase == TimerPhase.complete
                          ? 'Log Breath Entry'
                          : 'Complete timer to log',
                ),
              ),
            ],

            // Success message
            if (entryState.lastEntryId != null) ...[
              const SizedBox(height: 12),
              Card(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.check, size: 20),
                      SizedBox(width: 8),
                      Text('Entry logged successfully!'),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            // Journal history
            const JournalHistoryList(),
          ],
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
}
