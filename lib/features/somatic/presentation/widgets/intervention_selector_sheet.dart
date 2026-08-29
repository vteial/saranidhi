import 'package:flutter/material.dart';
import 'package:saranidhi/features/somatic/domain/somatic_intervention_session.dart';
import 'package:saranidhi/features/somatic/presentation/somatic_timer_room.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:uuid/uuid.dart';

/// Bottom sheet offering the two somatic intervention protocols to shift the
/// breath channel toward [targetFlow]. Selecting one builds a
/// [SomaticInterventionSession] and pushes the [SomaticTimerRoom].
///
/// [targetFlow] / [initialFlow] are nostril strings (`'left'` / `'right'`).
///
/// See `docs/research/advanced_somatic_mastery.md` §1.2.
class InterventionSelectorSheet extends StatelessWidget {
  const InterventionSelectorSheet({
    required this.targetFlow,
    required this.initialFlow,
    super.key,
  });

  final String targetFlow;
  final String initialFlow;

  static const _uuid = Uuid();

  void _startProtocol(BuildContext context, InterventionType type) {
    final session = SomaticInterventionSession(
      id: _uuid.v4(),
      startTime: DateTime.now(),
      type: type,
      targetFlow: targetFlow,
      initialFlow: initialFlow,
    );

    // Close the sheet, then open the full-screen timer room.
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute<bool>(
        fullscreenDialog: true,
        builder: (_) => SomaticTimerRoom(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.somaticSelectorTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.somaticSelectorSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _ProtocolTile(
            icon: Icons.airline_seat_flat,
            title: l10n.somaticProtocolPosture,
            subtitle: l10n.somaticProtocolPostureDesc,
            durationLabel: l10n.somaticMinutes(3),
            onTap: () => _startProtocol(context, InterventionType.postureShift),
          ),
          const SizedBox(height: 12),
          _ProtocolTile(
            icon: Icons.pan_tool_outlined,
            title: l10n.somaticProtocolAxillary,
            subtitle: l10n.somaticProtocolAxillaryDesc,
            durationLabel: l10n.somaticMinutes(5),
            onTap: () =>
                _startProtocol(context, InterventionType.axillaryPressure),
          ),
        ],
      ),
    );
  }
}

class _ProtocolTile extends StatelessWidget {
  const _ProtocolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.durationLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String durationLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          durationLabel,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows the intervention protocol selector as a modal bottom sheet.
void showInterventionSelector(
  BuildContext context, {
  required String targetFlow,
  required String initialFlow,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => InterventionSelectorSheet(
      targetFlow: targetFlow,
      initialFlow: initialFlow,
    ),
  );
}
