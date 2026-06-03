import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';

void main() {
  group('BreathTimerState', () {
    test('initial state is idle and not running', () {
      const state = BreathTimerState();
      expect(state.isRunning, isFalse);
      expect(state.phase, equals(TimerPhase.idle));
      expect(state.elapsedMs, equals(0));
      expect(state.inhaleMs, equals(0));
      expect(state.holdMs, equals(0));
      expect(state.exhaleMs, equals(0));
    });

    test('totalMs is sum of all phases', () {
      const state = BreathTimerState(
        inhaleMs: 4000,
        holdMs: 2000,
        exhaleMs: 6000,
      );
      expect(state.totalMs, equals(12000));
    });

    test('totalMs is 0 for initial state', () {
      const state = BreathTimerState();
      expect(state.totalMs, equals(0));
    });
  });

  group('TimerPhase', () {
    test('has all expected phases', () {
      expect(TimerPhase.values, contains(TimerPhase.idle));
      expect(TimerPhase.values, contains(TimerPhase.inhale));
      expect(TimerPhase.values, contains(TimerPhase.hold));
      expect(TimerPhase.values, contains(TimerPhase.exhale));
      expect(TimerPhase.values, contains(TimerPhase.complete));
    });

    test('has exactly 5 phases', () {
      expect(TimerPhase.values.length, equals(5));
    });
  });

  group('BreathEntryState', () {
    test('initial state has no selection', () {
      const state = BreathEntryState();
      expect(state.selectedFlow, isNull);
      expect(state.alignmentResult, isNull);
      expect(state.isSubmitting, isFalse);
      expect(state.lastEntryId, isNull);
    });

    test('copyWith preserves unmodified fields', () {
      const state = BreathEntryState(isSubmitting: true);
      final updated = state.copyWith(lastEntryId: 'abc-123');
      expect(updated.isSubmitting, isTrue);
      expect(updated.lastEntryId, equals('abc-123'));
    });
  });
}
