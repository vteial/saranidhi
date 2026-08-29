import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/somatic/domain/somatic_intervention_session.dart';

void main() {
  group('InterventionType', () {
    test('durations match spec (180s posture, 300s axillary)', () {
      expect(InterventionType.postureShift.duration,
          const Duration(seconds: 180));
      expect(InterventionType.axillaryPressure.duration,
          const Duration(seconds: 300));
      expect(InterventionType.postureShift.durationSeconds, 180);
      expect(InterventionType.axillaryPressure.durationSeconds, 300);
    });

    test('storageValue round-trips via fromStorage', () {
      for (final type in InterventionType.values) {
        expect(InterventionType.fromStorage(type.storageValue), type);
      }
    });

    test('fromStorage falls back to postureShift for unknown values', () {
      expect(InterventionType.fromStorage('nonsense'),
          InterventionType.postureShift);
    });
  });

  group('CrossLateralMapping', () {
    test('target Lunar (left) → act on the Right side (contralateral)', () {
      expect(CrossLateralMapping.bodySideFor(BreathFlow.lunar), BodySide.right);
    });

    test('target Solar (right) → act on the Left side (contralateral)', () {
      expect(CrossLateralMapping.bodySideFor(BreathFlow.solar), BodySide.left);
    });
  });

  group('SomaticInterventionSession', () {
    SomaticInterventionSession makeSession({
      required String target,
      required String initial,
      InterventionType type = InterventionType.postureShift,
    }) {
      return SomaticInterventionSession(
        id: 'test-id',
        startTime: DateTime(2026, 7, 14, 10),
        type: type,
        targetFlow: target,
        initialFlow: initial,
      );
    }

    test('evaluateSuccess true when resolved flow matches target', () {
      final s = makeSession(target: 'right', initial: 'left');
      expect(s.evaluateSuccess('right'), isTrue);
    });

    test('evaluateSuccess false when resolved flow differs from target', () {
      final s = makeSession(target: 'right', initial: 'left');
      expect(s.evaluateSuccess('left'), isFalse);
    });

    test('evaluateSuccess false for sushumna (both) — never matches target',
        () {
      final s = makeSession(target: 'left', initial: 'right');
      expect(s.evaluateSuccess('both'), isFalse);
    });

    test('bodySide reflects the target flow (contralateral)', () {
      expect(makeSession(target: 'left', initial: 'right').bodySide,
          BodySide.right);
      expect(makeSession(target: 'right', initial: 'left').bodySide,
          BodySide.left);
    });

    test('duration comes from the protocol type', () {
      expect(
        makeSession(target: 'left', initial: 'right').duration,
        const Duration(seconds: 180),
      );
      expect(
        makeSession(
          target: 'left',
          initial: 'right',
          type: InterventionType.axillaryPressure,
        ).duration,
        const Duration(seconds: 300),
      );
    });

    test('starts active and copyWith updates status', () {
      final s = makeSession(target: 'left', initial: 'right');
      expect(s.status, SomaticSessionStatus.active);
      final done = s.copyWith(status: SomaticSessionStatus.completed);
      expect(done.status, SomaticSessionStatus.completed);
      // Other fields preserved.
      expect(done.id, s.id);
      expect(done.targetFlow, s.targetFlow);
    });
  });
}
