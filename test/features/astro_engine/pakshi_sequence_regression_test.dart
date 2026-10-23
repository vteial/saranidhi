import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

/// Regression test pinning the per-yama sequence tables in [PakshiCalculator].
///
/// Under CONF-PP-007, the 18 static 5x5 state tables remain unresolved pending
/// a full primary-source grid. This test verifies that the bird assigned to each
/// yama and every bird's state across all 10 yamas (5 day + 5 night) for all 7
/// weekdays and both moon phases are 100% identical and unchanged by this spec.
void main() {
  group('Pakshi Sequence Regression (R3 / CONF-PP-007 sequence invariant)', () {
    final expectedDayRulers = <(int, LunarPhase), List<PakshiBird>>{
      (0, LunarPhase.waxing): [PakshiBird.owl, PakshiBird.rooster, PakshiBird.vulture, PakshiBird.crow, PakshiBird.peacock],
      (0, LunarPhase.waning): [PakshiBird.rooster, PakshiBird.vulture, PakshiBird.owl, PakshiBird.crow, PakshiBird.peacock],
      (1, LunarPhase.waxing): [PakshiBird.peacock, PakshiBird.vulture, PakshiBird.owl, PakshiBird.rooster, PakshiBird.crow],
      (1, LunarPhase.waning): [PakshiBird.peacock, PakshiBird.crow, PakshiBird.rooster, PakshiBird.owl, PakshiBird.vulture],
      (2, LunarPhase.waxing): [PakshiBird.owl, PakshiBird.rooster, PakshiBird.vulture, PakshiBird.crow, PakshiBird.peacock],
      (2, LunarPhase.waning): [PakshiBird.rooster, PakshiBird.vulture, PakshiBird.owl, PakshiBird.crow, PakshiBird.peacock],
      (3, LunarPhase.waxing): [PakshiBird.peacock, PakshiBird.vulture, PakshiBird.owl, PakshiBird.rooster, PakshiBird.crow],
      (3, LunarPhase.waning): [PakshiBird.owl, PakshiBird.rooster, PakshiBird.crow, PakshiBird.vulture, PakshiBird.peacock],
      (4, LunarPhase.waxing): [PakshiBird.rooster, PakshiBird.peacock, PakshiBird.crow, PakshiBird.owl, PakshiBird.vulture],
      (4, LunarPhase.waning): [PakshiBird.vulture, PakshiBird.crow, PakshiBird.rooster, PakshiBird.peacock, PakshiBird.owl],
      (5, LunarPhase.waxing): [PakshiBird.crow, PakshiBird.owl, PakshiBird.rooster, PakshiBird.vulture, PakshiBird.peacock],
      (5, LunarPhase.waning): [PakshiBird.crow, PakshiBird.owl, PakshiBird.vulture, PakshiBird.peacock, PakshiBird.rooster],
      (6, LunarPhase.waxing): [PakshiBird.peacock, PakshiBird.vulture, PakshiBird.owl, PakshiBird.rooster, PakshiBird.crow],
      (6, LunarPhase.waning): [PakshiBird.peacock, PakshiBird.crow, PakshiBird.rooster, PakshiBird.owl, PakshiBird.vulture],
    };

    final expectedNightRulers = <(int, LunarPhase), List<PakshiBird>>{
      (0, LunarPhase.waxing): [PakshiBird.peacock, PakshiBird.vulture, PakshiBird.crow, PakshiBird.rooster, PakshiBird.owl],
      (0, LunarPhase.waning): [PakshiBird.peacock, PakshiBird.crow, PakshiBird.rooster, PakshiBird.owl, PakshiBird.vulture],
      (1, LunarPhase.waxing): [PakshiBird.crow, PakshiBird.owl, PakshiBird.rooster, PakshiBird.vulture, PakshiBird.peacock],
      (1, LunarPhase.waning): [PakshiBird.vulture, PakshiBird.rooster, PakshiBird.crow, PakshiBird.peacock, PakshiBird.owl],
      (2, LunarPhase.waxing): [PakshiBird.peacock, PakshiBird.vulture, PakshiBird.crow, PakshiBird.rooster, PakshiBird.owl],
      (2, LunarPhase.waning): [PakshiBird.peacock, PakshiBird.crow, PakshiBird.rooster, PakshiBird.owl, PakshiBird.vulture],
      (3, LunarPhase.waxing): [PakshiBird.crow, PakshiBird.owl, PakshiBird.rooster, PakshiBird.vulture, PakshiBird.peacock],
      (3, LunarPhase.waning): [PakshiBird.rooster, PakshiBird.vulture, PakshiBird.peacock, PakshiBird.owl, PakshiBird.crow],
      (4, LunarPhase.waxing): [PakshiBird.vulture, PakshiBird.crow, PakshiBird.owl, PakshiBird.peacock, PakshiBird.rooster],
      (4, LunarPhase.waning): [PakshiBird.owl, PakshiBird.rooster, PakshiBird.vulture, PakshiBird.crow, PakshiBird.rooster],
      (5, LunarPhase.waxing): [PakshiBird.peacock, PakshiBird.rooster, PakshiBird.vulture, PakshiBird.owl, PakshiBird.crow],
      (5, LunarPhase.waning): [PakshiBird.rooster, PakshiBird.peacock, PakshiBird.owl, PakshiBird.vulture, PakshiBird.crow],
      (6, LunarPhase.waxing): [PakshiBird.crow, PakshiBird.owl, PakshiBird.rooster, PakshiBird.vulture, PakshiBird.peacock],
      (6, LunarPhase.waning): [PakshiBird.vulture, PakshiBird.rooster, PakshiBird.crow, PakshiBird.peacock, PakshiBird.owl],
    };

    test('All 28 table instances produce exact pinned ruling bird sequence', () {
      for (var weekday = 0; weekday < 7; weekday++) {
        for (final phase in LunarPhase.values) {
          final dayResult = PakshiCalculator.calculate(
            weekday: weekday,
            lunarPhase: phase,
          );
          final dayRulers = dayResult.entries.map((e) => e.bird).toList();
          expect(
            dayRulers,
            equals(expectedDayRulers[(weekday, phase)]),
            reason: 'Daytime ruling sequence mismatch for weekday=$weekday, phase=$phase',
          );

          final nightResult = PakshiCalculator.calculateNight(
            weekday: weekday,
            lunarPhase: phase,
          );
          final nightRulers = nightResult.entries.map((e) => e.bird).toList();
          expect(
            nightRulers,
            equals(expectedNightRulers[(weekday, phase)]),
            reason: 'Nighttime ruling sequence mismatch for weekday=$weekday, phase=$phase',
          );
        }
      }
    });

    test('Full 28-instance 5x5 state table output matches pinned SHA256 digest', () {
      final buffer = StringBuffer();
      for (var w = 0; w < 7; w++) {
        for (final p in LunarPhase.values) {
          final dayRes = PakshiCalculator.calculate(weekday: w, lunarPhase: p);
          buffer.writeln('DAY:w=$w:p=${p.name}');
          for (final bird in PakshiBird.values) {
            final states = YamaIndex.values
                .map((y) => dayRes.stateForBird(bird, y).name)
                .join(',');
            buffer.writeln('  ${bird.name}:$states');
          }
          final nightRes = PakshiCalculator.calculateNight(weekday: w, lunarPhase: p);
          buffer.writeln('NIGHT:w=$w:p=${p.name}');
          for (final bird in PakshiBird.values) {
            final states = YamaIndex.values
                .map((y) => nightRes.stateForBird(bird, y).name)
                .join(',');
            buffer.writeln('  ${bird.name}:$states');
          }
        }
      }

      final text = buffer.toString();
      final digest = sha256.convert(utf8.encode(text)).toString();
      expect(
        digest,
        equals('4c97e1eedc031e4b74cb61b6f27fc29819e6635855c72802b0cb6fdbc104f29b'),
        reason: 'State sequence table mutated! R3 requires tables to be 100% byte-identical.',
      );
    });
  });
}
