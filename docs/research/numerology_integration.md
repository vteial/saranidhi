# Saranidhi Research: Numerology & Sankhya Sastra Integration

This document defines the mathematical, phonetic, and astronomical rules for integrating Vedic and Tamil Siddha Numerology (Sankhya Sastra) into the Saranidhi Astro Engine. 

These specifications serve as the conceptual blueprint for **Kiro Web** to generate domain models, database migrations, and business logic.

---

## 1. Name-to-Bird Fallback Parser (Phonetic Numerology)

When precise birth metrics (birth star or exact epoch) are missing, Saranidhi uses the phonetic properties of the user's name to assign their birth bird.

### 1.1 The Phonetic Vowel Rule
In Tamil Panja Pakshi Shastra, the first dominant vowel sound of a name represents the vital breath element (Prana) of the person.

* **Vulture (Earth)**: A, Ā (அ, ஆ, ஐ)
* **Owl (Water)**: I, Ī (இ, ஈ)
* **Crow (Fire)**: U, Ū (உ, ஊ)
* **Rooster (Air)**: E, Ē (எ, ஏ)
* **Peacock (Ether)**: O, Ō, AU (ஒ, ஓ, ஔ)

### 1.2 Transliterated English Fallback Logic
For names input in Latin script:
1. Strip leading whitespace and convert to lowercase.
2. Scan the name sequentially to locate the first vowel (`a`, `i`, `u`, `e`, `o`).
3. If no vowel is found, default to `a` (Vulture).

### 1.3 Dart Blueprint

```dart
enum PakshiBird { vulture, owl, crow, rooster, peacock }

class NameBirdParser {
  /// Resolves the birth bird using the name's phonetic vowel sounds.
  static PakshiBird parse(String name) {
    final cleaned = name.trim().toLowerCase();
    if (cleaned.isEmpty) return PakshiBird.vulture;

    // 1. Attempt Tamil Unicode Character Mapping
    final firstChar = cleaned[0];
    final tamilBird = _mapTamilVowel(firstChar);
    if (tamilBird != null) return tamilBird;

    // 2. Scan for the first English vowel sound
    final vowelRegExp = RegExp(r'[aeiou]');
    final match = vowelRegExp.firstMatch(cleaned);
    if (match == null) {
      return PakshiBird.vulture; // Default fallback
    }

    final firstVowel = match.group(0)!;
    return switch (firstVowel) {
      'a' => PakshiBird.vulture,
      'i' => PakshiBird.owl,
      'u' => PakshiBird.crow,
      'e' => PakshiBird.rooster,
      'o' => PakshiBird.peacock,
      _   => PakshiBird.vulture,
    };
  }

  static PakshiBird? _mapTamilVowel(String char) {
    const mappings = {
      'அ': PakshiBird.vulture,
      'ஆ': PakshiBird.vulture,
      'ஐ': PakshiBird.vulture,
      'இ': PakshiBird.owl,
      'ஈ': PakshiBird.owl,
      'உ': PakshiBird.crow,
      'ஊ': PakshiBird.crow,
      'எ': PakshiBird.rooster,
      'ஏ': PakshiBird.rooster,
      'ஒ': PakshiBird.peacock,
      'ஓ': PakshiBird.peacock,
      'ஔ': PakshiBird.peacock,
    };
    return mappings[char];
  }
}
```

---

## 2. Navatara Modulo-9 Biorhythm Weights

The Navatara system assesses daily compatibility based on the numerical distance between the user's birth Nakshatra and the transit Nakshatra of the day.

### 2.1 The Mathematical Equation
Given Nakshatras 1 through 27 (Ashwini = 1, Revati = 27):

$$\text{TaraIndex} = ((\text{Transit Nakshatra Index} - \text{Birth Nakshatra Index} + 27) \pmod 9) + 1$$

### 2.2 Category & Auspiciousness Weights
The resulting `TaraIndex` (1 to 9) maps to a specific category and an Oracle Engine modifier weight:

| Index | Tara Name | Nature | Multiplier | Description |
| :--- | :--- | :--- | :--- | :--- |
| **1** | Janma | Neutral | `1.0` | Focus on physical body, maintenance, self-reflection. |
| **2** | Sampat | **Highly Favorable** | `1.5` | Material gain, positive energy, transaction success. |
| **3** | Vipat | **Critical Avoidance** | `0.4` | High chance of obstacles, accidental delays. |
| **4** | Kshema | **Favorable** | `1.3` | Safety, protection, comfort, domestic actions. |
| **5** | Pratyak | **Unfavorable** | `0.5` | Opposition, conflicts, arguments. |
| **6** | Sadhana | **Highly Favorable** | `1.5` | Success in research, spiritual practices, realizations. |
| **7** | Naidhana | **Severe Hazard** | `0.2` | Danger, vital energy depletion, complete containment. |
| **8** | Mitra | **Favorable** | `1.2` | Friendly meetings, collaborative tasks. |
| **9** | Adhimitra | **Favorable** | `1.3` | Ease of workflow, great alliance harmony. |

### 2.3 Dart Blueprint

```dart
enum TaraCategory {
  janma(weight: 1.0, isAuspicious: true),
  sampat(weight: 1.5, isAuspicious: true),
  vipat(weight: 0.4, isAuspicious: false),
  kshema(weight: 1.3, isAuspicious: true),
  pratyak(weight: 0.5, isAuspicious: false),
  sadhana(weight: 1.5, isAuspicious: true),
  naidhana(weight: 0.2, isAuspicious: false),
  mitra(weight: 1.2, isAuspicious: true),
  adhimitra(weight: 1.3, isAuspicious: true);

  final double weight;
  final bool isAuspicious;

  const TaraCategory({required this.weight, required this.isAuspicious});

  static TaraCategory resolve(int birthIdx, int transitIdx) {
    // Both indices are expected 1-indexed (1 to 27)
    final diff = (transitIdx - birthIdx + 27) % 9;
    return TaraCategory.values[diff]; // 0-based enum index matches (diff)
  }
}
```

---

## 3. Hora-Swara Affinity Multipliers

This system compares the current planetary hour ruler (Hora) with the physical flow of breath (Swara) to score user alignment.

### 3.1 Planetary Energy Classification
Each planet exhibits heating (Solar), cooling (Lunar), or transitional (Neutral) properties:

* **Solar (Surya)**: Sun, Mars
* **Lunar (Chandra)**: Moon, Mercury, Venus, Jupiter
* **Neutral (Sandhi/Sushumna)**: Saturn

In Sankhya Sastra, their numeric assignments are:

$$\text{Sun} = 1, \quad \text{Moon} = 2, \quad \text{Jupiter} = 3, \quad \text{Mercury} = 5, \quad \text{Venus} = 6, \quad \text{Saturn} = 8, \quad \text{Mars} = 9$$

### 3.2 Hora-Swara Alignment Rules
Somatic alignment occurs when the dominant nostril matches the planetary hour's energy:

| Active Hora | Energy Type | Ideal Flow | Alignment Score | Mismatched Score |
| :--- | :--- | :--- | :--- | :--- |
| **Sun / Mars** | Solar | Right (Pingala) | `1.5` | `0.5` |
| **Moon / Venus / Jupiter / Mercury** | Lunar | Left (Ida) | `1.5` | `0.5` |
| **Saturn** | Neutral | Sushumna / Balanced | `1.5` (if Sushumna) | `1.0` (otherwise) |

### 3.3 Dart Blueprint

```dart
enum Swara { left, right, sushumna }

enum HoraPlanet {
  sun(energy: HoraEnergy.solar),
  moon(energy: HoraEnergy.lunar),
  mars(energy: HoraEnergy.solar),
  mercury(energy: HoraEnergy.lunar),
  jupiter(energy: HoraEnergy.lunar),
  venus(energy: HoraEnergy.lunar),
  saturn(energy: HoraEnergy.neutral);

  final HoraEnergy energy;
  const HoraPlanet({required this.energy});
}

enum HoraEnergy { solar, lunar, neutral }

class HoraSwaraAffinity {
  static double getMultiplier(HoraPlanet planet, Swara actualFlow) {
    return switch (planet.energy) {
      HoraEnergy.solar => (actualFlow == Swara.right) ? 1.5 : 0.5,
      HoraEnergy.lunar => (actualFlow == Swara.left) ? 1.5 : 0.5,
      HoraEnergy.neutral => (actualFlow == Swara.sushumna) ? 1.5 : 1.0,
    };
  }
}
```

---

## 4. Synthesis: Composite Oracle Scoring

Kiro Web should implement a composite scoring algorithm that feeds into `OracleCalculator`:

$$\text{Auspiciousness Score} = \text{Base Score (Bird State)} \times \text{Tarabala Multiplier} \times \text{Hora-Swara Multiplier}$$

```dart
class OracleCompositeEngine {
  static int calculateAuspiciousness({
    required int baseBirdStateScore, // e.g. Ruling=100, Eating=80, Dying=10
    required int birthNakshatra,
    required int transitNakshatra,
    required HoraPlanet activeHora,
    required Swara actualFlow,
  }) {
    final tarabala = TaraCategory.resolve(birthNakshatra, transitNakshatra).weight;
    final horaSwara = HoraSwaraAffinity.getMultiplier(activeHora, actualFlow);

    final rawScore = baseBirdStateScore * tarabala * horaSwara;
    return rawScore.round().clamp(0, 100);
  }
}
```
