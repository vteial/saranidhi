import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/swara_clock.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// Legacy nostril pattern predictor.
///
/// Deprecated in Sprint 42 in favor of [SwaraClock] which implements the
/// 1-hour / 24-cycle swara clock (CONF-014) seeded at astronomical sunrise
/// by the Weekday Udhaya schedule (CONF-013 / CONF-001).
@Deprecated('Replaced by SwaraClock in Sprint 42 (CONF-014 / CONF-013)')
class NostrilPattern {
  @Deprecated('Replaced by SwaraClock in Sprint 42')
  const NostrilPattern._();

  /// Deprecated legacy shim forwarding to [SwaraClock].
  @Deprecated('Use SwaraClock.expectedFlowAt instead')
  static BreathFlow expectedFlowForYama(YamaIndex? yama, {DateTime? date}) {
    final target = date ?? DateTime.now();
    final paksha = LunarPhaseCalculator.phaseForDate(target);
    final sunrise = DateTime(target.year, target.month, target.day, 6);
    return SwaraClock.expectedFlowAt(
      time: target,
      sunrise: sunrise,
      paksha: paksha,
    );
  }

  /// Deprecated legacy shim.
  @Deprecated('Use SwaraClock.seedFor instead')
  static bool dayStartsWithSolar({DateTime? date}) {
    final target = date ?? DateTime.now();
    final paksha = LunarPhaseCalculator.phaseForDate(target);
    final weekday = target.weekday % 7 + 1;
    final seed = SwaraClock.seedFor(sunBasedWeekday: weekday, paksha: paksha);
    return seed.dawnFlow == BreathFlow.solar;
  }
}
