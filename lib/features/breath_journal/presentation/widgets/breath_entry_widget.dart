import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Two-click breath entry widget.
///
/// Displays three large buttons for Solar (Right), Lunar (Left),
/// and Sushumna (Both). Tapping logs the selection and triggers
/// alignment checking.
class BreathEntryWidget extends ConsumerWidget {
  const BreathEntryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryState = ref.watch(breathEntryNotifierProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.selectNostril, style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        Row(
          children: BreathFlow.values.map((flow) {
            final isSelected = entryState.selectedFlow == flow;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _FlowButton(
                  flow: flow,
                  isSelected: isSelected,
                  label: _localizedFlowLabel(flow, l10n),
                  onTap: () {
                    ref
                        .read(breathEntryNotifierProvider.notifier)
                        .selectFlow(flow);
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _localizedFlowLabel(BreathFlow flow, AppLocalizations l10n) =>
      switch (flow) {
        BreathFlow.solar => l10n.solar,
        BreathFlow.lunar => l10n.lunar,
        BreathFlow.sushumna => l10n.sushumna,
      };
}

class _FlowButton extends StatelessWidget {
  const _FlowButton({
    required this.flow,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  final BreathFlow flow;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                _iconForFlow(flow),
                size: 32,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForFlow(BreathFlow flow) => switch (flow) {
    BreathFlow.solar => Icons.wb_sunny_outlined,
    BreathFlow.lunar => Icons.nightlight_outlined,
    BreathFlow.sushumna => Icons.all_inclusive,
  };
}
