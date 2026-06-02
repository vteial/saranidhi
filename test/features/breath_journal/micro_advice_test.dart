import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/alignment_checker.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/domain/micro_advice.dart';

void main() {
  group('MicroAdvice', () {
    test('aligned solar gives action advice', () {
      final alignment = AlignmentResult(
        expectedFlow: BreathFlow.solar,
        isAligned: true,
        activeYama: YamaIndex.yama1,
        activeBird: PakshiBird.vulture,
        activeBirdState: PakshiState.ruling,
      );

      final advice = MicroAdvice.generate(
        alignment: alignment,
        actualFlow: BreathFlow.solar,
      );

      expect(advice, contains('RIGHT foot'));
      expect(advice, contains('aligned'));
    });

    test('aligned lunar gives rest advice', () {
      final alignment = AlignmentResult(
        expectedFlow: BreathFlow.lunar,
        isAligned: true,
        activeYama: YamaIndex.yama2,
        activeBird: PakshiBird.owl,
        activeBirdState: PakshiState.eating,
      );

      final advice = MicroAdvice.generate(
        alignment: alignment,
        actualFlow: BreathFlow.lunar,
      );

      expect(advice, contains('LEFT foot'));
      expect(advice, contains('creative'));
    });

    test('aligned sushumna gives meditation advice', () {
      final alignment = AlignmentResult(
        expectedFlow: BreathFlow.solar,
        isAligned: true,
        activeYama: YamaIndex.yama1,
        activeBird: PakshiBird.vulture,
        activeBirdState: PakshiState.ruling,
      );

      final advice = MicroAdvice.generate(
        alignment: alignment,
        actualFlow: BreathFlow.sushumna,
      );

      expect(advice, contains('Sushumna'));
      expect(advice, contains('meditation'));
    });

    test('unaligned when solar expected gives shift advice', () {
      final alignment = AlignmentResult(
        expectedFlow: BreathFlow.solar,
        isAligned: false,
        activeYama: YamaIndex.yama1,
        activeBird: PakshiBird.vulture,
        activeBirdState: PakshiState.ruling,
      );

      final advice = MicroAdvice.generate(
        alignment: alignment,
        actualFlow: BreathFlow.lunar,
      );

      expect(advice, contains('LEFT side'));
    });

    test('unaligned when lunar expected gives shift advice', () {
      final alignment = AlignmentResult(
        expectedFlow: BreathFlow.lunar,
        isAligned: false,
        activeYama: YamaIndex.yama2,
        activeBird: PakshiBird.owl,
        activeBirdState: PakshiState.eating,
      );

      final advice = MicroAdvice.generate(
        alignment: alignment,
        actualFlow: BreathFlow.solar,
      );

      expect(advice, contains('RIGHT side'));
    });

    test('advice is never empty', () {
      for (final flow in BreathFlow.values) {
        for (final aligned in [true, false]) {
          final alignment = AlignmentResult(
            expectedFlow: BreathFlow.solar,
            isAligned: aligned,
            activeYama: YamaIndex.yama1,
            activeBird: PakshiBird.vulture,
            activeBirdState: PakshiState.ruling,
          );

          final advice = MicroAdvice.generate(
            alignment: alignment,
            actualFlow: flow,
          );

          expect(advice.isNotEmpty, isTrue);
        }
      }
    });
  });
}
