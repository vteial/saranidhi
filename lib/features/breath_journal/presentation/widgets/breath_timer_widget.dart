import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';

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
    final isRunning =
        timerState.phase != TimerPhase.idle &&
        timerState.phase != TimerPhase.complete;

    return Card(
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
                _phaseLabel(timerState.phase),
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
                _phaseInstruction(timerState.phase),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (timerState.phase == TimerPhase.complete) ...[
                const SizedBox(height: 12),
                _TimerResults(timerState: timerState),
              ],
            ],
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

  String _phaseLabel(TimerPhase phase) => switch (phase) {
    TimerPhase.idle => 'Breath Timer',
    TimerPhase.inhale => 'Inhaling...',
    TimerPhase.hold => 'Holding...',
    TimerPhase.exhale => 'Exhaling...',
    TimerPhase.complete => 'Complete!',
  };

  String _phaseInstruction(TimerPhase phase) => switch (phase) {
    TimerPhase.idle => 'Tap to start inhale',
    TimerPhase.inhale => 'Tap when inhale complete',
    TimerPhase.hold => 'Tap when ready to exhale',
    TimerPhase.exhale => 'Tap when exhale complete',
    TimerPhase.complete => 'Tap to reset',
  };
}

class _TimerResults extends StatelessWidget {
  const _TimerResults({required this.timerState});

  final BreathTimerState timerState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ResultChip(
          label: 'Inhale',
          value: '${(timerState.inhaleMs / 1000).toStringAsFixed(1)}s',
          theme: theme,
        ),
        _ResultChip(
          label: 'Hold',
          value: '${(timerState.holdMs / 1000).toStringAsFixed(1)}s',
          theme: theme,
          highlight: true,
        ),
        _ResultChip(
          label: 'Exhale',
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
