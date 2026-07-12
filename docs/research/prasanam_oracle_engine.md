# Saranidhi Research: Layer 3 — Prasanam (Oracle) Engine Spec

This document details the mathematical algorithms, multi-factor rules, and Dart blueprints for the **Prasanam Oracle Engine** (Layer 3). 

The Prasanam Oracle calculates the energetic and auspicious alignment of the current moment to guide the user's specific lifestyle queries. It integrates astronomical cycles, name/birth numerology, and the user's immediate physical breath flow (*Saram*).

---

## 1. Multi-Factor Oracle Scoring Matrix

The Oracle Readiness Score (representing the cosmic and biological alignment of the current moment) is calculated dynamically using a multi-layered scoring matrix.

```
+--------------------------------------------------------------+
|                    BASE BIRD STATE SCORE                     |
|           (Ruling: 100, Eating: 80, Walking: 60)             |
|           (Sleeping: 30, Dying: 10)                          |
+------------------------------+-------------------------------+
                               |
                               v
+------------------------------+-------------------------------+
|                  TARABALA MODULO-9 MULTIPLIER                |
|               (Range: 0.2x to 1.5x based on birth)           |
+------------------------------+-------------------------------+
                               |
                               v
+------------------------------+-------------------------------+
|                 HORA-SWARA AFFINITY MULTIPLIER               |
|               (Range: 0.5x to 1.5x based on nostril)         |
+------------------------------+-------------------------------+
                               |
                               v
+------------------------------+-------------------------------+
|               CATEGORY HARMONY SHIFT MULTIPLIER              |
|        (1.2x if Category matches Current Action Window)      |
|        (0.6x if Category conflicts with Action Window)       |
+------------------------------+-------------------------------+
                               |
                               v
+------------------------------+-------------------------------+
|                 RAHU KAAL FLOOR LOCK FILTER                  |
|                 (Hard lock to 10% if active)                 |
+--------------------------------------------------------------+
```

---

## 2. Oracle Calculators & Coefficients

### 2.1 Base Bird State Scores
The initial score is derived from the user's birth bird state in the current Yama:
* **Ruling:** 100
* **Eating:** 80
* **Walking:** 60
* **Sleeping:** 30
* **Dying:** 10

### 2.2 Category Harmony Multipliers
When asking a question, the user selects a **Query Category** matching one of the three life paths. The engine compares this with the current active **Action Window** to apply a harmony coefficient:

* **Artha Query** (business, money, contracts, travel, conflict)
* **Kriya Query** (health, nourishment, learning, exercise)
* **Yoga Query** (meditation, relationships, introspection, rest)

| Current Action Window | Artha Query | Kriya Query | Yoga Query |
| :--- | :--- | :--- | :--- |
| **Artha Window** | **1.2** (Harmonious) | **0.8** (Mismatched) | **0.6** (Conflicting) |
| **Kriya Window** | **0.8** (Mismatched) | **1.2** (Harmonious) | **0.8** (Mismatched) |
| **Yoga Window** | **0.5** (Conflicting) | **0.8** (Mismatched) | **1.2** (Harmonious) |

### 2.3 The Swara-Query Alignment Rule
In Swarodaya Shastra, the direction of the question determines the ideal nostril flow:
* **Active / Outbound Queries (Artha):** Ideal flow is **Right Nostril (Pingala / Solar)**.
* **Passive / Inbound Queries (Kriya / Yoga):** Ideal flow is **Left Nostril (Ida / Lunar)**.
* **Sushumna (Neutral/Both nostrils):** Generates a warning lock. Sushumna represents zero external manifestation force, rendering any worldly action unsuccessful (Score clamped or flagged as "Turn Inward").

---

## 3. The 5 Prasanam Answer Bands

The final percentage score is translated into five guidance categories, mapped to English and Tamil:

| Score Band | Sanskrit Term | English Meaning | Tamil Term | Actionable Guidance |
| :--- | :--- | :--- | :--- | :--- |
| **90% – 100%** | **Siddha** | Absolute Success | **சித்தி (உடனடி வெற்றி)** | Highly auspicious. Proceed with maximum confidence immediately. |
| **70% – 89%** | **Vardhana** | Growth / Success | **விருத்தி (முயற்சி வெற்றி)** | Favorable. Success is assured with steady, deliberate effort. |
| **50% – 69%** | **Mandha** | Delays / Obstacles | **மந்தம் (தடை/தாமதம்)** | Neutral. Progress will be slow. Re-evaluate details before acting. |
| **30% – 49%** | **Stambhana** | Friction / Stagnant | **ஸ்தம்பனம் (தேக்க நிலை)** | Unfavorable. Actions will hit walls. Shift/realign your breath first. |
| **0% – 29%** | **Sunya** | Void / Inauspicious | **சூனியம் (முழுத் தடை)** | Hard block. Do not act externally. Best for spiritual contemplation. |

---

## 4. Dart Engine Specification

The domain structures and calculations for Kiro Web to implement:

```dart
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

enum QueryCategory { artha, kriya, yoga }

enum OracleBand {
  siddha(min: 90, max: 100),
  vardhana(min: 70, max: 89),
  mandha(min: 50, max: 69),
  stambhana(min: 30, max: 49),
  sunya(min: 0, max: 29);

  final int min;
  final int max;
  const OracleBand({required this.min, required this.max});

  static OracleBand fromScore(int score) {
    return OracleBand.values.firstWhere(
      (b) => score >= b.min && score <= b.max,
      orElse: () => OracleBand.sunya,
    );
  }
}

class PrasanamQuery {
  final DateTime queryTime;
  final QueryCategory category;
  final String actualSwara; // 'left', 'right', or 'sushumna'
  
  const PrasanamQuery({
    required this.queryTime,
    required this.category,
    required this.actualSwara,
  });
}

class PrasanamResult {
  final int score;
  final OracleBand band;
  final String englishGuidance;
  final String tamilGuidance;
  final bool isRahuLocked;

  const PrasanamResult({
    required this.score,
    required this.band,
    required this.englishGuidance,
    required this.tamilGuidance,
    required this.isRahuLocked,
  });
}

class PrasanamOracleEngine {
  /// Resolves the base bird score.
  static int getBaseBirdScore(PakshiState state) {
    return switch (state) {
      PakshiState.ruling => 100,
      PakshiState.eating => 80,
      PakshiState.walking => 60,
      PakshiState.sleeping => 30,
      PakshiState.dying => 10,
    };
  }

  /// Calculates the Category Harmony Multiplier.
  static double getCategoryHarmony(QueryCategory category, ActionWindow window) {
    switch (window) {
      case ActionWindow.artha:
        return switch (category) {
          QueryCategory.artha => 1.2,
          QueryCategory.kriya => 0.8,
          QueryCategory.yoga  => 0.6,
        };
      case ActionWindow.kriya:
        return switch (category) {
          QueryCategory.artha => 0.8,
          QueryCategory.kriya => 1.2,
          QueryCategory.yoga  => 0.8,
        };
      case ActionWindow.yoga:
        return switch (category) {
          QueryCategory.artha => 0.5,
          QueryCategory.kriya => 0.8,
          QueryCategory.yoga  => 1.2,
        };
    }
  }

  /// Calculates the final composite score and maps to a Prasanam Result.
  static PrasanamResult evaluate({
    required PrasanamQuery query,
    required PakshiState currentBirdState,
    required ActionWindow currentWindow,
    required double tarabalaMultiplier,
    required double horaSwaraMultiplier,
    required bool isRahuKaalActive,
  }) {
    // 1. Check Rahu Kaal Floor Lock
    if (isRahuKaalActive) {
      return const PrasanamResult(
        score: 10,
        band: OracleBand.sunya,
        englishGuidance: "Void Hour. Rahu Kaal is active. Rest and avoid beginning any material tasks.",
        tamilGuidance: "சூனிய காலம். ராகு காலம் செயல்படுவதால், புதிய காரியங்களைத் தவிர்க்கவும்.",
        isRahuLocked: true,
      );
    }

    // 2. Base Bird State Calculation
    final baseScore = getBaseBirdScore(currentBirdState);

    // 3. Category Harmony Multiplier
    final categoryHarmony = getCategoryHarmony(query.category, currentWindow);

    // 4. Compounding calculations
    final rawScore = baseScore * tarabalaMultiplier * horaSwaraMultiplier * categoryHarmony;
    final finalScore = rawScore.round().clamp(0, 100);

    final band = OracleBand.fromScore(finalScore);

    // 5. Generate localized descriptions based on band results
    final englishText = _getEnglishText(band, query.actualSwara);
    final tamilText = _getTamilText(band, query.actualSwara);

    return PrasanamResult(
      score: finalScore,
      band: band,
      englishGuidance: englishText,
      tamilGuidance: tamilText,
      isRahuLocked: false,
    );
  }

  static String _getEnglishText(OracleBand band, String swara) {
    if (swara == 'sushumna') {
      return "Sushumna Swara is active. Energy is directed inward. Favorable only for spiritual practices.";
    }
    return switch (band) {
      OracleBand.siddha => "In alignment. Absolute success. Proceed with boldness.",
      OracleBand.vardhana => "Steady alignment. Positive growth. Proceed with sustained effort.",
      OracleBand.mandha => "Mild delay. Hurdles anticipated. Double-check details before proceeding.",
      OracleBand.stambhana => "High friction. Action is stagnant. Realignment of breath is advised.",
      OracleBand.sunya => "Void alignment. Complete block. Postpone external actions and turn inward.",
    };
  }

  static String _getTamilText(OracleBand band, String swara) {
    if (swara == 'sushumna') {
      return "சுழுமுனை சுவாசம் செயல்படுகிறது. உலகியல் சார்ந்த செயல்களைத் தள்ளிவைத்து தியானம் செய்யவும்.";
    }
    return switch (band) {
      OracleBand.siddha => "சிறப்பான நேரம். உடனடி வெற்றி கிட்டும். காரியங்களில் துணிந்து இறங்கலாம்.",
      OracleBand.vardhana => "வளர்ச்சியான நேரம். தொடர் முயற்சியால் நற்பலன்கள் கிடைக்கும்.",
      OracleBand.mandha => "மந்த நிலை. தடைகள் ஏற்படலாம். திட்டமிட்டு எச்சரிக்கையுடன் செயல்படவும்.",
      OracleBand.stambhana => "தேக்க நிலை. தடைகள் சுவர்கள் எழுப்பலாம். சுவாசத்தை மாற்ற முயற்சிக்கவும்.",
      OracleBand.sunya => "சூனிய நிலை. முழுத் தடை. புதிய காரியங்களைத் தள்ளிப்போட்டு அமைதி காக்கவும்.",
    };
  }
}
```
