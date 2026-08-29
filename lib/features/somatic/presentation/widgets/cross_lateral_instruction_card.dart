import 'package:flutter/material.dart';
import 'package:saranidhi/features/somatic/domain/somatic_intervention_session.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Shows the contralateral body-position instruction for a given intervention
/// protocol + target flow.
///
/// Respiratory channels respond to pressure on the *opposite* side of the
/// body, so to activate the target nostril the user acts on the other side:
/// - Posture shift → lie on the [BodySide] returned by [CrossLateralMapping].
/// - Axillary pressure → apply pressure under that side's armpit.
///
/// See `docs/research/advanced_somatic_mastery.md` §1.1.
class CrossLateralInstructionCard extends StatelessWidget {
  const CrossLateralInstructionCard({
    required this.type,
    required this.bodySide,
    super.key,
  });

  final InterventionType type;
  final BodySide bodySide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final sideLabel =
        bodySide == BodySide.left ? l10n.somaticSideLeft : l10n.somaticSideRight;

    final instruction = switch (type) {
      InterventionType.postureShift => l10n.somaticInstructionPosture(sideLabel),
      InterventionType.axillaryPressure =>
        l10n.somaticInstructionAxillary(sideLabel),
    };

    final icon = switch (type) {
      InterventionType.postureShift => Icons.airline_seat_flat,
      InterventionType.axillaryPressure => Icons.pan_tool_outlined,
    };

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                instruction,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
