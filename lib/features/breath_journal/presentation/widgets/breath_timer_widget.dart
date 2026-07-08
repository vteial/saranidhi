import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Breath duration timer with inhale/hold/exhale phases.
///
/// Shows live running seconds and uses a simple stopwatch-style UI where
/// the user taps to advance through phases: Inhale → Hold → Exhale → Complete.
class BreathTimerWidget extends ConsumerStatefulWidget {
  const BreathTimerWidget({super.key});

  @override
  ConsumerState<BreathTimerWidget> createState() => _BreathTimerWidgetState();
}

class _BreathTimerWidgetState extends ConsumerState<BreathTimerWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _displayTimer;
  int _displaySeconds = 0;

  @override
  void dispose() {
    _stopwatch.stop();
    _displayTimer?.cancel();
    super.dispose();
  }

  void _startDisplayTimer() {
    _displayTimer?.cancel();
    _displaySeconds = 0;
    _displayTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _displaySeconds = _stopwatch.elapsed.inSeconds;
      });
    });
  }

  void _stopDisplayTimer() {
    _displayTimer?.cancel();
    _displayTimer = null;
  }

  void _onTap() {
    HapticFeedback.mediumImpact();
    final timerState = ref.read(breathTimerNotifierProvider);
    final notifier = ref.read(breathTimerNotifierProvider.notifier);

    switch (timerState.phase) {
      case TimerPhase.idle:
        _stopwatch
          ..reset()
          ..start();
        _startDisplayTimer();
        notifier.startInhale();
      case TimerPhase.inhale:
        _stopwatch.stop();
        _stopDisplayTimer();
        notifier.finishInhale(_stopwatch.elapsedMilliseconds);
        _stopwatch
          ..reset()
          ..start();
        _startDisplayTimer();
      case TimerPhase.hold:
        _stopwatch.stop();
        _stopDisplayTimer();
        notifier.finishHold(_stopwatch.elapsedMilliseconds);
        _stopwatch
          ..reset()
          ..start();
        _startDisplayTimer();
      case TimerPhase.exhale:
        _stopwatch.stop();
        _stopDisplayTimer();
        notifier.finishExhale(_stopwatch.elapsedMilliseconds);
      case TimerPhase.complete:
        notifier.reset();
        _displaySeconds = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(breathTimerNotifierProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isRunning =
        timerState.phase != TimerPhase.idle &&
        timerState.phase != TimerPhase.complete;

    return Semantics(
      button: true,
      label: _phaseLabel(timerState.phase, l10n),
      hint: _phaseInstruction(timerState.phase, l10n),
      child: Card(
        child: InkWell(
          onTap: _onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  _phaseIcon(timerState.phase),
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  _phaseLabel(timerState.phase, l10n),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Live seconds display
                if (isRunning) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${_displaySeconds}s',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _phaseInstruction(timerState.phase, l10n),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (timerState.phase == TimerPhase.complete) ...[
                  const SizedBox(height: 12),
                  _TimerResults(timerState: timerState, l10n: l10n),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _phaseIcon(TimerPhase phase) => switch (phase) {
    TimerPhase.idle => Icons.play_circle_outline,
    TimerPhase.inhale => Icons.arrow_downward,
    TimerPhase.hold => Icons.pause_circle_outline,
    TimerPhase.exhale => Icons.arrow_upward,
    TimerPhase.complete => Icons.check_circle_outline,
  };

  String _phaseLabel(TimerPhase phase, AppLocalizations l10n) => switch (phase) {
    TimerPhase.idle => l10n.breathTimer,
    TimerPhase.inhale => l10n.inhaling,
    TimerPhase.hold => l10n.holding,
    TimerPhase.exhale => l10n.exhaling,
    TimerPhase.complete => l10n.timerComplete,
  };

  String _phaseInstruction(TimerPhase phase, AppLocalizations l10n) => switch (phase) {
    TimerPhase.idle => l10n.tapToStartInhale,
    TimerPhase.inhale => l10n.tapWhenInhaleComplete,
    TimerPhase.hold => l10n.tapWhenReadyToExhale,
    TimerPhase.exhale => l10n.tapWhenExhaleComplete,
    TimerPhase.complete => l10n.tapToReset,
  };
}

class _TimerResults extends StatelessWidget {
  const _TimerResults({required this.timerState, required this.l10n});

  final BreathTimerState timerState;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ResultChip(
          label: l10n.inhale,
          value: '${(timerState.inhaleMs / 1000).toStringAsFixed(1)}s',
          theme: theme,
        ),
        _ResultChip(
          label: l10n.hold,
          value: '${(timerState.holdMs / 1000).toStringAsFixed(1)}s',
          theme: theme,
          highlight: true,
        ),
        _ResultChip(
          label: l10n.exhale,
          value: '${(timerState.exhaleMs / 1000).toStringAsFixed(1)}s',
          theme: theme,
        ),
      ],
    );
  }
}

class _ResultChip extends StatelessWidget {
  const _ResultChip({
    required this.label,
    required this.value,
    required this.theme,
    this.highlight = false,
  });

  final String label;
  final String value;
  final ThemeData theme;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: highlight ? FontWeight.bold : null,
            color: highlight ? theme.colorScheme.primary : null,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
