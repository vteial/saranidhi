import 'package:flutter/material.dart';
import 'package:saranidhi/features/astro_engine/domain/tattva_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/chronobiology/domain/chronobiology_analytics.dart';
import 'package:saranidhi/features/chronobiology/domain/somatic_advice.dart';
import 'package:saranidhi/features/somatic/presentation/widgets/intervention_selector_sheet.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Dashboard warning card for nostril flow stagnancy.
///
/// Renders only when the stagnancy level is not [StagnancyLevel.none].
/// Suggests thermal/lifestyle rebalancing and routes into the Sprint 35
/// somatic intervention sheet with the opposite flow as the target.
class StagnancyCard extends StatelessWidget {
  const StagnancyCard({required this.data, super.key});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final stagnancy = data.stagnancy;
    if (stagnancy.level == StagnancyLevel.none || stagnancy.stuckFlow == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isChronic = stagnancy.level == StagnancyLevel.chronic;
    final isSolar = stagnancy.stuckFlow == BreathFlow.solar;

    final accentColor = isChronic
        ? Colors.deepOrange.shade700
        : Colors.amber.shade800;

    final hours = stagnancy.continuousDuration.inHours;
    final minutes = stagnancy.continuousDuration.inMinutes % 60;
    final durationStr = minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';

    final title = isChronic
        ? l10n.stagnancyChronicTitle
        : l10n.stagnancyMildTitle;

    final description = switch ((isSolar, isChronic)) {
      (true, true) => l10n.stagnancyRightChronicDesc(durationStr),
      (true, false) => l10n.stagnancyRightMildDesc(durationStr),
      (false, true) => l10n.stagnancyLeftChronicDesc(durationStr),
      (false, false) => l10n.stagnancyLeftMildDesc(durationStr),
    };

    final activeTattva = data.activeTattva?.tattva;
    final agreesWithTattva =
        (isSolar && activeTattva == Tattva.fire) ||
        (!isSolar && activeTattva == Tattva.water);

    final String? tattvaTipText;
    if (agreesWithTattva) {
      final tip = SomaticAdvice.getTemperatureTip(
        activeTattva: activeTattva,
        stuckFlow: stagnancy.stuckFlow,
      );
      tattvaTipText = switch (tip) {
        TemperatureTip.cooling => l10n.tattvaTipCooling,
        TemperatureTip.warming => l10n.tattvaTipWarming,
        null => null,
      };
    } else {
      tattvaTipText = null;
    }

    return Card(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: accentColor, width: 4)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSolar ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                  color: accentColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    durationStr,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (tattvaTipText != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.bubble_chart_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      tattvaTipText,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () {
                  final stuck = stagnancy.stuckFlow!;
                  final target = stuck == BreathFlow.solar ? 'left' : 'right';
                  final initial = stuck.nostril;
                  showInterventionSelector(
                    context,
                    targetFlow: target,
                    initialFlow: initial,
                  );
                },
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                icon: const Icon(Icons.sync_alt, size: 16),
                label: Text(l10n.stagnancyRebalanceAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
