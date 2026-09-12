import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/tattva_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/chronobiology/domain/somatic_advice.dart';

void main() {
  group('SomaticAdvice.getTemperatureTip', () {
    test('returns cooling for Tattva.fire regardless of stuck flow', () {
      expect(
        SomaticAdvice.getTemperatureTip(
          activeTattva: Tattva.fire,
          stuckFlow: null,
        ),
        equals(TemperatureTip.cooling),
      );

      expect(
        SomaticAdvice.getTemperatureTip(
          activeTattva: Tattva.fire,
          stuckFlow: BreathFlow.solar,
        ),
        equals(TemperatureTip.cooling),
      );

      expect(
        SomaticAdvice.getTemperatureTip(
          activeTattva: Tattva.fire,
          stuckFlow: BreathFlow.lunar,
        ),
        equals(TemperatureTip.cooling),
      );
    });

    test(
      'returns cooling for stuck-right (solar) when tattva is neutral/null',
      () {
        expect(
          SomaticAdvice.getTemperatureTip(
            activeTattva: null,
            stuckFlow: BreathFlow.solar,
          ),
          equals(TemperatureTip.cooling),
        );

        expect(
          SomaticAdvice.getTemperatureTip(
            activeTattva: Tattva.earth,
            stuckFlow: BreathFlow.solar,
          ),
          equals(TemperatureTip.cooling),
        );
      },
    );

    test('returns warming for Tattva.water (apas)', () {
      expect(
        SomaticAdvice.getTemperatureTip(
          activeTattva: Tattva.water,
          stuckFlow: null,
        ),
        equals(TemperatureTip.warming),
      );
    });

    test(
      'returns warming for stuck-left (lunar) when tattva is neutral/null',
      () {
        expect(
          SomaticAdvice.getTemperatureTip(
            activeTattva: null,
            stuckFlow: BreathFlow.lunar,
          ),
          equals(TemperatureTip.warming),
        );

        expect(
          SomaticAdvice.getTemperatureTip(
            activeTattva: Tattva.earth,
            stuckFlow: BreathFlow.lunar,
          ),
          equals(TemperatureTip.warming),
        );
      },
    );

    test('returns null when neither fire/water nor stuck flow is present', () {
      expect(
        SomaticAdvice.getTemperatureTip(
          activeTattva: Tattva.air,
          stuckFlow: null,
        ),
        isNull,
      );

      expect(
        SomaticAdvice.getTemperatureTip(
          activeTattva: Tattva.ether,
          stuckFlow: null,
        ),
        isNull,
      );

      expect(
        SomaticAdvice.getTemperatureTip(activeTattva: null, stuckFlow: null),
        isNull,
      );
    });
  });
}
