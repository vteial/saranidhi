import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/breath_journal/domain/micro_advice.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';

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

    final theme = Theme.of(context);
    final isAligned = alignment.isAligned;

    final advice = MicroAdvice.generate(
      alignment: alignment,
      actualFlow: selectedFlow,
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
                  isAligned ? 'Aligned!' : 'Not Aligned',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isAligned
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Expected: ${alignment.expectedFlow.shortLabel}',
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
                '${alignment.activeBird!.displayName} • '
                '${alignment.activeBirdState?.displayName ?? ""} • '
                '${alignment.activeYama?.label ?? ""}',
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
}
