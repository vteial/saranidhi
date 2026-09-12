import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// Query category for the Prasanam / Aruḍam evaluation.
enum QueryCategory { artha, kriya, yoga }

/// The 5 Prasanam / Aruḍam answer bands mapped to score ranges.
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

/// A single doctrinal reason contributing to an Aruḍam verdict, with provenance.
///
/// Provenance mappings (single source of truth):
/// - [birdState]: Panja Pakshi bird-state ceiling — CONF-PP-004
/// - [horaSwara]: Hora × swara affinity — CONF-014
/// - [tarabala]: Navatara category weight — CONF-PP-001/002
/// - [categoryHarmony]: Action-window vs query-category harmony — CONF-015
/// - [readiness]: Breath alignment multiplier — CONF-016 / CONF-017
/// - [sushumna]: Sushumna transcendent neutral — CONF-026
/// - [floorLock]: Rahu/Emakandam inauspicious window override — CONF-018
enum ArudamFactor {
  /// Panja Pakshi bird-state ceiling — CONF-PP-004 (ruling planets/state).
  birdState,

  /// Hora × swara affinity — CONF-014 (two clocks) / CONF-012 (tattva).
  horaSwara,

  /// Navatara category weight — Panja Pakshi tarabala (CONF-PP-001/002).
  tarabala,

  /// Action-window vs query-category harmony — CONF-015.
  categoryHarmony,

  /// Breath alignment multiplier — CONF-016 / CONF-017.
  readiness,

  /// Sushumna transcendent neutral — CONF-026.
  sushumna,

  /// Rahu/Emakandam inauspicious window override — CONF-018.
  floorLock,
}

/// Qualitative strength indicator for a doctrinal reason (never shown as raw numbers).
enum FactorStrength { strong, moderate, weak, blocking }

/// One line of the "Why?" explanation: which factor, its qualitative strength,
/// and the CONF id to cite. NO raw numbers.
class ArudamReason {
  const ArudamReason({
    required this.factor,
    required this.strength,
    required this.conf,
  });

  final ArudamFactor factor;
  final FactorStrength strength;
  final String conf;
}

/// Result of an Integrated Aruḍam evaluation.
class IntegratedArudamResult {
  const IntegratedArudamResult({
    required this.score,
    required this.momentScore,
    required this.readinessMultiplier,
    required this.band,
    required this.englishGuidance,
    required this.tamilGuidance,
    required this.isFloorLocked,
    required this.reasons,
  });

  /// The final composite score (0–100) after Readiness multiplier and floor-lock.
  final int score;

  /// The Moment score (0–100) representing the cosmic timing ceiling before readiness.
  final int momentScore;

  /// The Readiness multiplier applied (1.0 for aligned / unknown swara, 0.75 for misaligned).
  final double readinessMultiplier;

  /// The Prasanam / Aruḍam answer band mapped to score range.
  final OracleBand band;

  /// English guidance text.
  final String englishGuidance;

  /// Tamil guidance text.
  final String tamilGuidance;

  /// Whether the score was floor-locked to 10% by an inauspicious window.
  final bool isFloorLocked;

  /// Doctrinal factor breakdown with provenance citations for transparency.
  final List<ArudamReason> reasons;
}

/// The Integrated Aruḍam Engine — multi-factor composite scoring combining
/// Moment (cosmic timing ceiling) and Readiness (breath alignment multiplier).
///
/// Formula:
/// - Moment = Base(BirdState) x Tarabala x Hora-Swara x Category Harmony
/// - Readiness = aligned -> 1.0, misaligned -> 0.75, Sushumna -> Yoga context rule
/// - Final Score = (Moment x Readiness).round().clamp(0, 100)
/// - Floor Lock: Rahu Kaal or Emakandam locks score to 10 (Sunya band).
class IntegratedArudamEngine {
  const IntegratedArudamEngine._();

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

  /// Evaluates the Integrated Aruḍam composite score.
  static IntegratedArudamResult evaluate({
    required PakshiState birdState,
    required ActionWindow window,
    required QueryCategory category,
    required double tarabalaMultiplier,
    required double horaSwaraMultiplier,
    required bool isAligned,
    required BreathFlow? actualSwara,
    required bool isRahuActive,
    required bool isEmakandamActive,
  }) {
    // 1. Hard floor lock if inauspicious window active
    if (isRahuActive || isEmakandamActive) {
      final name = isRahuActive ? 'Rahu Kaal' : 'Emakandam';
      final nameTa = isRahuActive
          ? '\u0BB0\u0BBE\u0B95\u0BC1 \u0B95\u0BBE\u0BB2\u0BAE\u0BCD'
          : '\u0B8E\u0BAE\u0B95\u0BA3\u0BCD\u0B9F\u0BAE\u0BCD';
      return IntegratedArudamResult(
        score: 10,
        momentScore: 10,
        readinessMultiplier: 1,
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
        reasons: const [
          ArudamReason(
            factor: ArudamFactor.floorLock,
            strength: FactorStrength.blocking,
            conf: 'CONF-018',
          ),
        ],
      );
    }

    // 2. Compute Moment score (ceiling)
    final baseScore = getBaseBirdScore(birdState);
    final categoryHarmony = getCategoryHarmony(category, window);
    final rawMoment =
        baseScore * tarabalaMultiplier * horaSwaraMultiplier * categoryHarmony;
    final momentScore = rawMoment.round().clamp(0, 100);

    // 3. Compute Readiness multiplier
    // When swara is null (stale / unknown), readiness defaults to 1.0 (Moment ceiling only).
    final double readiness;
    if (actualSwara == null) {
      readiness = 1;
    } else {
      final effectiveAligned = (actualSwara == BreathFlow.sushumna)
          ? window.isSushumnaAligned
          : isAligned;
      readiness = effectiveAligned ? 1 : 0.75;
    }

    final rawScore = rawMoment * readiness;
    final finalScore = rawScore.round().clamp(0, 100);
    final band = OracleBand.fromScore(finalScore);

    // 4. Build doctrinal reasons breakdown with provenance citations
    final reasons = <ArudamReason>[
      // Moment reasons
      ArudamReason(
        factor: ArudamFactor.birdState,
        strength: baseScore >= 80
            ? FactorStrength.strong
            : (baseScore >= 40 ? FactorStrength.moderate : FactorStrength.weak),
        conf: 'CONF-PP-004',
      ),
      ArudamReason(
        factor: ArudamFactor.horaSwara,
        strength: horaSwaraMultiplier >= 1.1
            ? FactorStrength.strong
            : (horaSwaraMultiplier >= 0.9
                  ? FactorStrength.moderate
                  : FactorStrength.weak),
        conf: 'CONF-014',
      ),
      ArudamReason(
        factor: ArudamFactor.tarabala,
        strength: tarabalaMultiplier >= 1.1
            ? FactorStrength.strong
            : (tarabalaMultiplier >= 0.9
                  ? FactorStrength.moderate
                  : FactorStrength.weak),
        conf: 'CONF-PP-001/002',
      ),
      ArudamReason(
        factor: ArudamFactor.categoryHarmony,
        strength: categoryHarmony >= 1.1
            ? FactorStrength.strong
            : (categoryHarmony >= 0.9
                  ? FactorStrength.moderate
                  : FactorStrength.weak),
        conf: 'CONF-015',
      ),
    ];

    // You reasons (omitted if swara observation is stale / unknown)
    if (actualSwara != null) {
      if (actualSwara == BreathFlow.sushumna) {
        reasons.add(
          const ArudamReason(
            factor: ArudamFactor.sushumna,
            strength: FactorStrength.moderate,
            conf: 'CONF-026',
          ),
        );
      } else {
        reasons.add(
          ArudamReason(
            factor: ArudamFactor.readiness,
            strength: isAligned ? FactorStrength.strong : FactorStrength.weak,
            conf: 'CONF-016 / CONF-017',
          ),
        );
      }
    }

    // 5. Generate guidance text
    final englishText = _getEnglishText(band, actualSwara);
    final tamilText = _getTamilText(band, actualSwara);

    return IntegratedArudamResult(
      score: finalScore,
      momentScore: momentScore,
      readinessMultiplier: readiness,
      band: band,
      englishGuidance: englishText,
      tamilGuidance: tamilText,
      isFloorLocked: false,
      reasons: List.unmodifiable(reasons),
    );
  }

  static String _getEnglishText(OracleBand band, BreathFlow? swara) {
    if (swara == BreathFlow.sushumna) {
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

  static String _getTamilText(OracleBand band, BreathFlow? swara) {
    if (swara == BreathFlow.sushumna) {
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
