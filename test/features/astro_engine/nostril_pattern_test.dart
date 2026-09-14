// ignore_for_file: deprecated_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/nostril_pattern.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

void main() {
  group('NostrilPattern (Deprecated Shim)', () {
    test(
      'expectedFlowForYama forwards to SwaraClock and returns BreathFlow',
      () {
        final result = NostrilPattern.expectedFlowForYama(
          YamaIndex.yama1,
          date: DateTime(2026, 7, 5, 7, 0),
        );
        expect(
          result,
          anyOf(equals(BreathFlow.solar), equals(BreathFlow.lunar)),
        );
      },
    );

    test('dayStartsWithSolar returns boolean', () {
      final result = NostrilPattern.dayStartsWithSolar(
        date: DateTime(2026, 7, 5),
      );
      expect(result, isA<bool>());
    });
  });
}
