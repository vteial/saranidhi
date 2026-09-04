import 'package:flutter/material.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// The four equal phases of Sama Vritti (equal-ratio) breathing.
enum SamaVrittiPhase {
  inhale,
  holdIn,
  exhale,
  holdOut;

  /// Localized label for the current phase.
  String label(AppLocalizations l10n) => switch (this) {
        SamaVrittiPhase.inhale => l10n.pacerInhale,
        SamaVrittiPhase.holdIn => l10n.pacerHold,
        SamaVrittiPhase.exhale => l10n.pacerExhale,
        SamaVrittiPhase.holdOut => l10n.pacerHold,
      };
}

/// A breathing pacer animation for Sama Vritti (equal-ratio) breathing:
/// 4s inhale → 4s hold → 4s exhale → 4s hold, looping continuously.
///
/// An expanding/contracting circle guides the breath: it grows during
/// inhale, stays large during hold-in, shrinks during exhale, and stays
/// small during hold-out. The current phase label and a per-phase second
/// count are shown in the centre.
///
/// See `docs/research/advanced_somatic_mastery.md` §1.2.
class SamaVrittiPacer extends StatefulWidget {
  const SamaVrittiPacer({this.phaseSeconds = 4, super.key});

  /// Seconds per phase (default 4 — the 4:4:4:4 ratio).
  final int phaseSeconds;

  @override
  State<SamaVrittiPacer> createState() => _SamaVrittiPacerState();
}

class _SamaVrittiPacerState extends State<SamaVrittiPacer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _phaseOrder = [
    SamaVrittiPhase.inhale,
    SamaVrittiPhase.holdIn,
    SamaVrittiPhase.exhale,
    SamaVrittiPhase.holdOut,
  ];

  @override
  void initState() {
    super.initState();
    // One full cycle = 4 phases * phaseSeconds.
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.phaseSeconds * 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Current phase index (0..3) from the controller's progress.
  int _phaseIndex(double t) => (t * 4).floor().clamp(0, 3);

  /// Seconds elapsed within the current phase (1..phaseSeconds).
  int _phaseSecond(double t) {
    final withinPhase = (t * 4) % 1; // 0..1 within the phase
    return (withinPhase * widget.phaseSeconds).floor() + 1;
  }

  /// Circle scale (0.5..1.0): grows on inhale, holds high, shrinks on
  /// exhale, holds low.
  double _scale(double t) {
    final phase = _phaseIndex(t);
    final withinPhase = (t * 4) % 1;
    return switch (_phaseOrder[phase]) {
      SamaVrittiPhase.inhale => 0.5 + 0.5 * withinPhase,
      SamaVrittiPhase.holdIn => 1.0,
      SamaVrittiPhase.exhale => 1.0 - 0.5 * withinPhase,
      SamaVrittiPhase.holdOut => 0.5,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final phase = _phaseOrder[_phaseIndex(t)];
        final scale = _scale(t);
        final second = _phaseSecond(t);

        return SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Guide circle
              Transform.scale(
                scale: scale,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              // Phase label + second count
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    phase.label(l10n),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$second',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
