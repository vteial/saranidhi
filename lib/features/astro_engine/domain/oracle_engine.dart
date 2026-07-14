import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/daylight_segment_resolver.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// Query category for the Prasanam Oracle.
enum QueryCategory { artha, kriya, yoga }

/// The 5 Prasanam answer bands mapped to score ranges.
enum OracleBand {
  siddha(min: 90, max: 100),
  vardhana(min: 70, max: 89),
  mandha(min: 50, max: 69),
  stambhana(min: 30, max: 49),
  sunya(min: 0, max: 29);

  const OracleBand({required this.min, required this.max});

  final int min;
  final int max;

  static OracleBand fromScore(int score) {
    return OracleBand.values.firstWhere(
      (b) => score >= b.min && score <= b.max,
      orElse: () => OracleBand.sunya,
    );
  }
}

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
/// Formula: Base x Tarabala x Hora-Swara x Category Harmony
/// With floor lock if Rahu Kaal or Emakandam is active (clamped to 10%).
class OracleCompositeEngine {
  const OracleCompositeEngine._();

  /// Base bird state scores.
  static int getBaseBirdScore(PakshiState state) {
    return switch (state) {
      PakshiState.ruling => 100,
      PakshiState.eating => 80,
      PakshiState.walking => 60,
      PakshiState.sleeping => 30,
      PakshiState.dying => 10,
    };
  }

  /// Category Harmony multiplier matrix.
  static double getCategoryHarmony(
    QueryCategory category,
    ActionWindow window,
  ) {
    return switch (window) {
      ActionWindow.artha => switch (category) {
        QueryCategory.artha => 1.2,
        QueryCategory.kriya => 0.8,
        QueryCategory.yoga => 0.6,
      },
      ActionWindow.kriya => switch (category) {
        QueryCategory.artha => 0.8,
        QueryCategory.kriya => 1.2,
        QueryCategory.yoga => 0.8,
      },
      ActionWindow.yoga => switch (category) {
        QueryCategory.artha => 0.5,
        QueryCategory.kriya => 0.8,
        QueryCategory.yoga => 1.2,
      },
    };
  }

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
    // 1. Resolve daylight segment for inauspicious check
    final resolver = DaylightSegmentResolver.resolve(
      currentTime: queryTime,
      sunrise: sunrise,
      sunset: sunset,
    );

    final isRahuActive = resolver.isRahuKaal(weekday);
    final isEmakandamActive = resolver.isEmakandam(weekday);

    // 2. Floor lock if inauspicious window active
    if (isRahuActive || isEmakandamActive) {
      final name = isRahuActive ? 'Rahu Kaal' : 'Emakandam';
      final nameTa = isRahuActive
          ? '\u0BB0\u0BBE\u0B95\u0BC1 \u0B95\u0BBE\u0BB2\u0BAE\u0BCD'
          : '\u0B8E\u0BAE\u0B95\u0BA3\u0BCD\u0B9F\u0BAE\u0BCD';
      return PrasanamResult(
        score: 10,
        band: OracleBand.sunya,
        englishGuidance:
            'Void Hour. $name is active. '
            'Rest and avoid beginning any material tasks.',
        tamilGuidance:
            '\u0B9A\u0BC2\u0BA9\u0BBF\u0BAF \u0B95\u0BBE\u0BB2\u0BAE\u0BCD. '
            '$nameTa \u0B9A\u0BC6\u0BAF\u0BB2\u0BCD\u0BAA\u0B9F\u0BC1\u0BB5\u0BA4\u0BBE\u0BB2\u0BCD, '
            '\u0BAA\u0BC1\u0BA4\u0BBF\u0BAF \u0B95\u0BBE\u0BB0\u0BBF\u0BAF\u0B99\u0BCD\u0B95\u0BB3\u0BC8\u0BA4\u0BCD '
            '\u0BA4\u0BB5\u0BBF\u0BB0\u0BCD\u0B95\u0BCD\u0B95\u0BB5\u0BC1\u0BAE\u0BCD.',
        isFloorLocked: true,
      );
    }

    // 3. Compute composite score
    final baseScore = getBaseBirdScore(currentBirdState);
    final categoryHarmony = getCategoryHarmony(category, currentWindow);
    final rawScore =
        baseScore * tarabalaMultiplier * horaSwaraMultiplier * categoryHarmony;
    final finalScore = rawScore.round().clamp(0, 100);
    final band = OracleBand.fromScore(finalScore);

    // 4. Generate guidance text
    final englishText = _getEnglishText(band, actualSwara);
    final tamilText = _getTamilText(band, actualSwara);

    return PrasanamResult(
      score: finalScore,
      band: band,
      englishGuidance: englishText,
      tamilGuidance: tamilText,
      isFloorLocked: false,
    );
  }

  static String _getEnglishText(OracleBand band, String swara) {
    if (swara == 'sushumna') {
      return 'Sushumna Swara is active. Energy is directed inward. '
          'Favorable only for spiritual practices.';
    }
    return switch (band) {
      OracleBand.siddha =>
        'In alignment. Absolute success. Proceed with boldness.',
      OracleBand.vardhana =>
        'Steady alignment. Positive growth. Proceed with sustained effort.',
      OracleBand.mandha =>
        'Mild delay. Hurdles anticipated. '
        'Double-check details before proceeding.',
      OracleBand.stambhana =>
        'High friction. Action is stagnant. '
        'Realignment of breath is advised.',
      OracleBand.sunya =>
        'Void alignment. Complete block. '
        'Postpone external actions and turn inward.',
    };
  }

  static String _getTamilText(OracleBand band, String swara) {
    if (swara == 'sushumna') {
      return '\u0B9A\u0BC1\u0BB4\u0BC1\u0BAE\u0BC1\u0BA9\u0BC8 \u0B9A\u0BC1\u0BB5\u0BBE\u0B9A\u0BAE\u0BCD '
          '\u0B9A\u0BC6\u0BAF\u0BB2\u0BCD\u0BAA\u0B9F\u0BC1\u0B95\u0BBF\u0BB1\u0BA4\u0BC1. '
          '\u0B89\u0BB2\u0B95\u0BBF\u0BAF\u0BB2\u0BCD \u0B9A\u0BBE\u0BB0\u0BCD\u0BA8\u0BCD\u0BA4 '
          '\u0B9A\u0BC6\u0BAF\u0BB2\u0BCD\u0B95\u0BB3\u0BC8\u0BA4\u0BCD '
          '\u0BA4\u0BB3\u0BCD\u0BB3\u0BBF\u0BB5\u0BC8\u0BA4\u0BCD\u0BA4\u0BC1 '
          '\u0BA4\u0BBF\u0BAF\u0BBE\u0BA9\u0BAE\u0BCD \u0B9A\u0BC6\u0BAF\u0BCD\u0BAF\u0BB5\u0BC1\u0BAE\u0BCD.';
    }
    return switch (band) {
      OracleBand.siddha =>
        '\u0B9A\u0BBF\u0BB1\u0BAA\u0BCD\u0BAA\u0BBE\u0BA9 \u0BA8\u0BC7\u0BB0\u0BAE\u0BCD. '
        '\u0B89\u0B9F\u0BA9\u0B9F\u0BBF \u0BB5\u0BC6\u0BB1\u0BCD\u0BB1\u0BBF \u0B95\u0BBF\u0B9F\u0BCD\u0B9F\u0BC1\u0BAE\u0BCD.',
      OracleBand.vardhana =>
        '\u0BB5\u0BB3\u0BB0\u0BCD\u0B9A\u0BCD\u0B9A\u0BBF\u0BAF\u0BBE\u0BA9 \u0BA8\u0BC7\u0BB0\u0BAE\u0BCD. '
        '\u0BA4\u0BCA\u0B9F\u0BB0\u0BCD \u0BAE\u0BC1\u0BAF\u0BB1\u0BCD\u0B9A\u0BBF\u0BAF\u0BBE\u0BB2\u0BCD '
        '\u0BA8\u0BB1\u0BCD\u0BAA\u0BB2\u0BA9\u0BCD\u0B95\u0BB3\u0BCD \u0B95\u0BBF\u0B9F\u0BC8\u0B95\u0BCD\u0B95\u0BC1\u0BAE\u0BCD.',
      OracleBand.mandha =>
        '\u0BAE\u0BA8\u0BCD\u0BA4 \u0BA8\u0BBF\u0BB2\u0BC8. '
        '\u0BA4\u0B9F\u0BC8\u0B95\u0BB3\u0BCD \u0B8F\u0BB1\u0BCD\u0BAA\u0B9F\u0BB2\u0BBE\u0BAE\u0BCD.',
      OracleBand.stambhana =>
        '\u0BA4\u0BC7\u0B95\u0BCD\u0B95 \u0BA8\u0BBF\u0BB2\u0BC8. '
        '\u0B9A\u0BC1\u0BB5\u0BBE\u0B9A\u0BA4\u0BCD\u0BA4\u0BC8 \u0BAE\u0BBE\u0BB1\u0BCD\u0BB1 '
        '\u0BAE\u0BC1\u0BAF\u0BB1\u0BCD\u0B9A\u0BBF\u0B95\u0BCD\u0B95\u0BB5\u0BC1\u0BAE\u0BCD.',
      OracleBand.sunya =>
        '\u0B9A\u0BC2\u0BA9\u0BBF\u0BAF \u0BA8\u0BBF\u0BB2\u0BC8. '
        '\u0BAE\u0BC1\u0BB4\u0BC1\u0BA4\u0BCD \u0BA4\u0B9F\u0BC8. '
        '\u0BAA\u0BC1\u0BA4\u0BBF\u0BAF \u0B95\u0BBE\u0BB0\u0BBF\u0BAF\u0B99\u0BCD\u0B95\u0BB3\u0BC8\u0BA4\u0BCD '
        '\u0BA4\u0BB3\u0BCD\u0BB3\u0BBF\u0BAA\u0BCD\u0BAA\u0BCB\u0B9F\u0BCD\u0B9F\u0BC1 '
        '\u0B85\u0BAE\u0BC8\u0BA4\u0BBF \u0B95\u0BBE\u0B95\u0BCD\u0B95\u0BB5\u0BC1\u0BAE\u0BCD.',
    };
  }
}
