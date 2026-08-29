import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// A 3-step guided nostril test modal that helps users identify their
/// true dominant nostril before logging a breath entry.
///
/// Steps:
/// 1. **Exhale test** — "Exhale through both nostrils. Which feels stronger?"
/// 2. **Isolation test** — "Block one nostril and breathe. Switch. Which is clearer?"
/// 3. **Result** — Auto-populates the BreathEntryWidget with the detected flow.
///
/// Launched via a "Guide me" button near the breath entry widget.
class GuidedNostrilTest extends StatefulWidget {
  const GuidedNostrilTest({required this.onResult, super.key});

  /// Callback with the detected flow result.
  final ValueChanged<BreathFlow> onResult;

  @override
  State<GuidedNostrilTest> createState() => _GuidedNostrilTestState();
}

class _GuidedNostrilTestState extends State<GuidedNostrilTest> {
  int _step = 0;
  BreathFlow? _exhaleResult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress indicator
          Row(
            children: List.generate(3, (i) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: LinearProgressIndicator(
                    value: i <= _step ? 1 : 0,
                    minHeight: 3,
                    backgroundColor:
                        theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Step content
          if (_step == 0) _buildStep1(theme, l10n),
          if (_step == 1) _buildStep2(theme, l10n),
          if (_step == 2) _buildStep3(theme, l10n),

          // Reset/restart — available once the user has moved past step 1
          if (_step > 0) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _step = 0;
                  _exhaleResult = null;
                });
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n.nostrilTestRestart),
            ),
          ],
        ],
      ),
    );
  }

  /// Step 1: Exhale test — which nostril feels more air flow?
  Widget _buildStep1(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Icon(
          Icons.air_rounded,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.nostrilTestStep1Title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.nostrilTestStep1Instruction,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // Anatomical order: Lunar (Left) → Sushumna (Both) → Solar (Right)
        Row(
          children: [
            Expanded(
              child: _ChoiceButton(
                label: l10n.nostrilTestLeft,
                icon: Icons.nightlight_outlined,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _exhaleResult = BreathFlow.lunar;
                    _step = 1;
                  });
                },
                theme: theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ChoiceButton(
                label: l10n.nostrilTestBoth,
                icon: Icons.all_inclusive,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _exhaleResult = BreathFlow.sushumna;
                    _step = 2; // Skip isolation for Sushumna
                  });
                },
                theme: theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ChoiceButton(
                label: l10n.nostrilTestRight,
                icon: Icons.wb_sunny_outlined,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _exhaleResult = BreathFlow.solar;
                    _step = 1;
                  });
                },
                theme: theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Step 2: Isolation test — block one nostril, breathe through other.
  Widget _buildStep2(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Icon(
          Icons.touch_app_outlined,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.nostrilTestStep2Title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.nostrilTestStep2Instruction,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _ChoiceButton(
                label: l10n.nostrilTestConfirmRight,
                icon: Icons.wb_sunny_outlined,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _step = 2);
                },
                theme: theme,
                isHighlighted: _exhaleResult == BreathFlow.solar,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ChoiceButton(
                label: l10n.nostrilTestConfirmLeft,
                icon: Icons.nightlight_outlined,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _exhaleResult = BreathFlow.lunar;
                    _step = 2;
                  });
                },
                theme: theme,
                isHighlighted: _exhaleResult == BreathFlow.lunar,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Step 3: Result — confirm and auto-populate.
  Widget _buildStep3(ThemeData theme, AppLocalizations l10n) {
    final flowName = switch (_exhaleResult) {
      BreathFlow.solar => l10n.solar,
      BreathFlow.lunar => l10n.lunar,
      BreathFlow.sushumna => l10n.sushumna,
      null => '',
    };
    final flowIcon = switch (_exhaleResult) {
      BreathFlow.solar => Icons.wb_sunny_outlined,
      BreathFlow.lunar => Icons.nightlight_outlined,
      BreathFlow.sushumna => Icons.all_inclusive,
      null => Icons.help_outline,
    };

    return Column(
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.nostrilTestResultTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        // Detected flow display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(flowIcon, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                flowName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              if (_exhaleResult != null) {
                widget.onResult(_exhaleResult!);
              }
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check),
            label: Text(l10n.nostrilTestConfirm),
          ),
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.theme,
    this.isHighlighted = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isHighlighted
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: isHighlighted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isHighlighted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows the guided nostril test as a bottom sheet.
///
/// Returns the detected [BreathFlow] or null if dismissed.
void showGuidedNostrilTest(
  BuildContext context, {
  required ValueChanged<BreathFlow> onResult,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => GuidedNostrilTest(onResult: onResult),
  );
}
