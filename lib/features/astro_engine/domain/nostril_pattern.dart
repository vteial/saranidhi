import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// Determines the expected nostril flow (Solar/Lunar) for each yama
/// based on the tithi (lunar day) per Siva Swarodaya Sutras 52–56.
///
/// Traditional rule:
/// - **Shukla Paksha** (waxing): Days 1-3 start Lunar, 4-6 start Solar,
///   7-9 start Lunar, 10-12 start Solar, 13-15 start Lunar.
/// - **Krishna Paksha** (waning): Days 1-3 start Solar, 4-6 start Lunar,
///   7-9 start Solar, 10-12 start Lunar, 13-15 start Solar.
///
/// After the starting nostril, it alternates each yama.
class NostrilPattern {
  const NostrilPattern._();

  /// Returns the expected breath flow for a given yama on a given date.
  ///
  /// Uses tithi-based logic from Siva Swarodaya.
  /// Returns [BreathFlow.lunar] as default for nighttime (yama == null).
  static BreathFlow expectedFlowForYama(YamaIndex? yama, {DateTime? date}) {
    if (yama == null) return BreathFlow.lunar;

    final targetDate = date ?? DateTime.now();
    final lunarResult = LunarPhaseCalculator.calculate(targetDate);
    final startsWithSolar = _dayStartsWithSolar(lunarResult);

    // Alternate from starting nostril per yama
    // Odd yamas (1,3,5) keep the starting nostril
    // Even yamas (2,4) switch to the opposite
    final yamaNumber = yama.index + 1; // 1-5
    final bool isSolarForThisYama;
    if (yamaNumber.isOdd) {
      isSolarForThisYama = startsWithSolar;
    } else {
      isSolarForThisYama = !startsWithSolar;
    }

    return isSolarForThisYama ? BreathFlow.solar : BreathFlow.lunar;
  }

  /// Returns whether the day starts with Solar nostril based on tithi.
  ///
  /// Exposed for UI display (NostrilDominanceChart) to determine
  /// all 5 yama patterns at once without calling per-yama.
  static bool dayStartsWithSolar({DateTime? date}) {
    final targetDate = date ?? DateTime.now();
    final lunarResult = LunarPhaseCalculator.calculate(targetDate);
    return _dayStartsWithSolar(lunarResult);
  }

  static bool _dayStartsWithSolar(LunarPhaseResult lunarResult) {
    final daysSinceNewMoon = lunarResult.daysSinceNewMoon;
    final isShukla = lunarResult.phase == LunarPhase.waxing;

    // Calculate tithi day (1-15 within current paksha)
    final int tithiDay;
    if (isShukla) {
      tithiDay = (daysSinceNewMoon ~/ 1) + 1; // 1-15
    } else {
      tithiDay = ((daysSinceNewMoon - 14.765) ~/ 1) + 1; // 1-15
    }
    final clampedTithi = tithiDay.clamp(1, 15);

    // Determine starting nostril for the day based on tithi block (3-day groups)
    // Shukla: 1-3=Lunar, 4-6=Solar, 7-9=Lunar, 10-12=Solar, 13-15=Lunar
    // Krishna: 1-3=Solar, 4-6=Lunar, 7-9=Solar, 10-12=Lunar, 13-15=Solar
    final blockIndex = (clampedTithi - 1) ~/ 3; // 0,1,2,3,4
    if (isShukla) {
      // Shukla blocks: Lunar(0), Solar(1), Lunar(2), Solar(3), Lunar(4)
      return blockIndex.isOdd;
    } else {
      // Krishna blocks: Solar(0), Lunar(1), Solar(2), Lunar(3), Solar(4)
      return blockIndex.isEven;
    }
  }
}
