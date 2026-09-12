import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/daylight_segment_resolver.dart';
import 'package:saranidhi/features/astro_engine/domain/integrated_arudam_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/nostril_pattern.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

export 'package:saranidhi/features/astro_engine/domain/integrated_arudam_engine.dart';

/// Result of a Prasanam Oracle evaluation.
class PrasanamResult {
  const PrasanamResult({
    required this.score,
    required this.band,
    required this.englishGuidance,
    required this.tamilGuidance,
    required this.isFloorLocked,
  });

  final int score;
  final OracleBand band;
  final String englishGuidance;
  final String tamilGuidance;
  final bool isFloorLocked;
}

/// The Prasanam Oracle Engine — multi-factor composite scoring.
///
/// Refactored in Sprint 38 (Task 38.1) to delegate composite scoring to the shared
/// [IntegratedArudamEngine] while preserving the exact caller signature and
/// day-only [DaylightSegmentResolver] behavior.
class OracleCompositeEngine {
  const OracleCompositeEngine._();

  /// Base bird state scores (delegates to [IntegratedArudamEngine]).
  static int getBaseBirdScore(PakshiState state) =>
      IntegratedArudamEngine.getBaseBirdScore(state);

  /// Category Harmony multiplier matrix (delegates to [IntegratedArudamEngine]).
  static double getCategoryHarmony(
    QueryCategory category,
    ActionWindow window,
  ) => IntegratedArudamEngine.getCategoryHarmony(category, window);

  /// Evaluates the Prasanam Oracle composite score.
  static PrasanamResult evaluate({
    required DateTime queryTime,
    required DateTime sunrise,
    required DateTime sunset,
    required int weekday,
    required PakshiState currentBirdState,
    required ActionWindow currentWindow,
    required double tarabalaMultiplier,
    required double horaSwaraMultiplier,
    required QueryCategory category,
    required String actualSwara,
  }) {
    // 1. Resolve daylight segment for inauspicious check (Oracle path unchanged)
    final resolver = DaylightSegmentResolver.resolve(
      currentTime: queryTime,
      sunrise: sunrise,
      sunset: sunset,
    );

    final isRahuActive = resolver.isRahuKaal(weekday);
    final isEmakandamActive = resolver.isEmakandam(weekday);

    // 2. Parse swara string to BreathFlow
    final flow = _parseSwara(actualSwara);

    // 3. Derive alignment for the Oracle query time (Task 38.2)
    final isAligned = _resolveAlignment(
      flow: flow,
      queryTime: queryTime,
      sunrise: sunrise,
      sunset: sunset,
      currentWindow: currentWindow,
    );

    // 4. Delegate to IntegratedArudamEngine
    final result = IntegratedArudamEngine.evaluate(
      birdState: currentBirdState,
      window: currentWindow,
      category: category,
      tarabalaMultiplier: tarabalaMultiplier,
      horaSwaraMultiplier: horaSwaraMultiplier,
      isAligned: isAligned,
      actualSwara: flow,
      isRahuActive: isRahuActive,
      isEmakandamActive: isEmakandamActive,
    );

    return PrasanamResult(
      score: result.score,
      band: result.band,
      englishGuidance: result.englishGuidance,
      tamilGuidance: result.tamilGuidance,
      isFloorLocked: result.isFloorLocked,
    );
  }

  static BreathFlow? _parseSwara(String swara) {
    final lower = swara.toLowerCase().trim();
    if (lower == 'solar' || lower == 'right') return BreathFlow.solar;
    if (lower == 'lunar' || lower == 'left') return BreathFlow.lunar;
    if (lower == 'sushumna' || lower == 'both') return BreathFlow.sushumna;
    return null;
  }

  static bool _resolveAlignment({
    required BreathFlow? flow,
    required DateTime queryTime,
    required DateTime sunrise,
    required DateTime sunset,
    required ActionWindow currentWindow,
  }) {
    if (flow == null) return true;
    if (flow == BreathFlow.sushumna) {
      return currentWindow.isSushumnaAligned;
    }
    final yamaResult = YamaCalculator.calculate(
      sunrise: sunrise,
      sunset: sunset,
    );
    final activeYama = yamaResult.activeYama(queryTime);
    final expectedFlow = NostrilPattern.expectedFlowForYama(
      activeYama?.index,
      date: queryTime,
    );
    return flow == expectedFlow;
  }
}
