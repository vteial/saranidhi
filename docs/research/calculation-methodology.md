[← Back to Docs](../README.md)

# Saranidhi — Calculation Methodology & Sources

> Reference document for how each Vedic calculation is derived, what sources are used,
> and known accuracy issues with current implementation.

---

## 1. Birth Bird Derivation

### Source
- **Prof. Dr. U.S. Pulippani** — *Biorhythms of Natal Moon (Mysteries of Pancha Pakshi)*, Sagar Publications, New Delhi
- **vedastro.org** — [Pancha Pakshi Part 2: Finding Your Birth Bird](https://vedastro.org/blog/Pancha-Pakshi-Part-2-Finding-Your-Birth-Bird.html)

### Correct Method (Sprint 36 fix required)

Birth bird depends on **two factors**:
1. Moon's Nakshatra at birth (which of 27 lunar mansions)
2. Birth Paksha (was the moon waxing or waning at the moment of birth?)

#### Bright Half (Shukla Paksha) Table

| Bird | Element | Nakshatras |
|------|---------|-----------|
| Vulture | Fire | Ashwini, Bharani, Krittika, Rohini, Mrigashira |
| Owl | Air | Ardra, Punarvasu, Pushya, Ashlesha, Magha |
| Crow | Earth | Purva Phalguni, Uttara Phalguni, Hasta, Chitra, Swati |
| Cock | Water | Vishakha, Anuradha, Jyeshtha, Mula, Purva Ashadha |
| Peacock | Ether | Uttara Ashadha, Shravana, Dhanishta, Shatabhisha, Purva Bhadrapada, Uttara Bhadrapada, Revati |

#### Dark Half (Krishna Paksha) Table — Reverse Order

| Bird | Element | Nakshatras |
|------|---------|-----------|
| Vulture | Fire | Revati, Uttara Bhadrapada, Purva Bhadrapada, Shatabhisha, Dhanishta |
| Owl | Air | Shravana, Uttara Ashadha, Purva Ashadha, Mula, Jyeshtha |
| Crow | Earth | Anuradha, Vishakha, Swati, Chitra, Hasta |
| Cock | Water | Uttara Phalguni, Purva Phalguni, Magha, Ashlesha, Pushya |
| Peacock | Ether | Punarvasu, Ardra, Mrigashira, Rohini, Krittika, Bharani, Ashwini |

#### Key Rule

> **Your birth bird is PERMANENT.** Once determined from birth nakshatra + birth paksha,
> it never changes. The current lunar phase does NOT alter your bird identity — only the
> daily state schedule tables change between paksha.

#### Example: User Eialarasu

- DOB: October 27, 1975, 8:00 PM IST, Chennai
- Moon Nakshatra: Pushya (8th nakshatra)
- Moon age at birth: ~22 days (past full moon)
- Birth Paksha: **Krishna (Dark Half)**
- Table lookup: Pushya in Dark Half → **Cock (Rooster)**
- Permanent bird: **Cock** (matches Align27)

### Current Implementation (CORRECT — Sprint 33)

Birth bird depends on **two factors**:
1. Moon's Nakshatra at birth (which of 27 lunar mansions)
2. Birth Paksha (was the moon waxing or waning at the moment of birth?)

Two lookup tables (Bright Half + Dark Half) per Prof. Pulippani.
The resulting bird is **permanent** — never changes with current lunar phase.

**API:** `PakshiCalculator.birthBirdFromNakshatraAndPaksha(nakshatra, birthPaksha)`

### Fix Applied (Sprint 33)

1. ✅ Dual nakshatra→bird lookup tables implemented (Bright + Dark)
2. ✅ Birth Paksha determined from DOB via `birthPakshaFromDOB()`
3. ✅ `birthBirdForPhase()` swap logic neutralized (always returns natal bird)
4. ✅ Onboarding + Settings use correct dual-table derivation
5. ✅ Manual "I know my star" path still uses Bright Half as default (no DOB available)

---

## 2. Daily Bird State Tables (Yama Schedule)

### Source
- **Prof. Dr. U.S. Pulippani** — Tables 4–12 in *Biorhythms of Natal Moon*
- Implemented in Sprint 12 (authentic 2D lookup tables)

### Method

Each day has a **ruling bird sequence** for 5 yamas, determined by:
- **Weekday** (7 days × 2 phases = ~14 table variants)
- **Lunar phase** (Shukla uses "bright half" tables, Krishna uses "dark half" tables)

The state table is a 5×5 matrix: `stateTable[bird][yama]` → PakshiState

States cycle: **Ruling → Eating → Walking → Sleeping → Dying**

Each bird occupies exactly one state per yama, and each state is occupied by exactly one bird per yama.

### Current Implementation

- 9 day-group lookup tables (4 bright + 5 dark half, per weekday groups)
- `PakshiCalculator.calculate(weekday, lunarPhase)` → `PakshiDayResult`
- Night yamas (Y6–Y10) use separate night tables (Sprint 15)

### Accuracy Status: ✅ Correct (validated against Pulippani reference)

---

## 3. Sunrise / Sunset Calculation

### Source
- **NOAA Solar Position Algorithm** — [NOAA Solar Calculator](https://gml.noaa.gov/grad/solcalc/solareqns.PDF)

### Method

Pure Dart implementation using:
- Day of year → solar declination + equation of time
- Location (lat/lng) + UTC offset → hour angle at zenith 90.833°
- Result: sunrise and sunset as local DateTime

### Accuracy: ±2 minutes (validated against timeanddate.com for Chennai)

---

## 4. Yama Calculation (5 Day + 5 Night Segments)

### Source
- **Siva Swarodaya** — daylight divided into 5 equal segments

### Method

- Day yamas: `(sunset - sunrise) / 5` = 5 equal segments (Y1–Y5)
- Night yamas: `(next_sunrise - sunset) / 5` = 5 equal segments (Y6–Y10)

### Accuracy: ✅ Correct (derived directly from sunrise/sunset)

---

## 5. Nostril Pattern (Expected Breath Flow)

### Source
- **Siva Swarodaya** — Sutras 52–56

### Current Implementation (CORRECT — Sprint 33)

Tithi-based starting nostril per Siva Swarodaya (Sutras 52–56):
- **Shukla Paksha**: Days 1-3 start Lunar, 4-6 start Solar, 7-9 start Lunar, 10-12 start Solar, 13-15 start Lunar
- **Krishna Paksha**: Days 1-3 start Solar, 4-6 start Lunar, 7-9 start Solar, 10-12 start Lunar, 13-15 start Solar

After the starting nostril, it alternates each yama (odd yamas keep start, even yamas switch).

**API:** `NostrilPattern.expectedFlowForYama(yamaIndex, date: date)`

### Accuracy Status: ✅ Correct (tithi-based per Siva Swarodaya)

### Correct Traditional Method (Sprint 36 accuracy target)

The starting nostril depends on **Tithi** (lunar day within 15-day cycle):
- **Shukla Paksha**: Days 1-3 start Lunar, 4-6 start Solar, 7-9 start Lunar, 10-12 start Solar, 13-15 start Lunar
- **Krishna Paksha**: Days 1-3 start Solar, 4-6 start Lunar, 7-9 start Solar, 10-12 start Lunar, 13-15 start Solar

After the starting nostril, it alternates each yama.

### Accuracy Status: ⚠️ Approximate (~70% correct, depends on tithi alignment)

---

## 6. Rahu Kaal Calculation

### Source
- Traditional Vedic astrology — 8-segment division of daylight

### Method

Daylight divided into 8 equal segments. The Rahu Kaal segment varies by weekday:
- Sunday: 8th segment
- Monday: 2nd segment
- Tuesday: 7th segment
- Wednesday: 5th segment
- Thursday: 6th segment
- Friday: 4th segment
- Saturday: 3rd segment

### Accuracy: ✅ Correct (matches standard panchangam sources)

---

## 7. Kuligai Kaal Calculation

### Source
- Traditional Tamil panchangam

### Method

Same 8-segment division, different offset per weekday:
- Sun=7, Mon=6, Tue=5, Wed=4, Thu=3, Fri=2, Sat=1

### Accuracy: ✅ Correct

---

## 8. Emakandam Calculation

### Source
- Traditional Tamil panchangam

### Method

Same 8-segment division, specific offset per weekday (different from Rahu/Kuligai).

### Accuracy: ✅ Correct

---

## 9. Hora (Planetary Hours)

### Source
- **Hora Shastra** — Chaldean order of planets

### Method

- Day: sunrise→sunset divided into 12 equal segments
- Night: sunset→next_sunrise divided into 12 equal segments
- First day hora ruled by weekday lord (Sun=Sunday, Moon=Monday, etc.)
- Subsequent horas follow Chaldean sequence: Saturn→Jupiter→Mars→Sun→Venus→Mercury→Moon

### Accuracy: ✅ Correct (matches standard hora calculators)

---

## 10. Lunar Phase Calculation

### Source
- Astronomical synodic month calculation

### Method

- Reference epoch: New Moon January 6, 2000, 18:14 UTC
- Synodic month: 29.53058867 days
- Moon age = (current_date - reference) mod synodic_month
- Waxing: 0 to 14.77 days, Waning: 14.77 to 29.53 days

### Accuracy: ±1 day (simplified algorithm, suitable for Paksha determination)

---

## 11. Moon Longitude (for Nakshatra from DOB)

### Source
- **Jean Meeus** — *Astronomical Algorithms*, ELP 2000/82

### Method

Pure Dart implementation computing Moon's ecliptic longitude:
- Julian Day Number from date
- Moon's mean elongation, anomaly, argument of latitude
- Periodic terms (major terms from ELP 2000/82)
- Lahiri Ayanamsa correction for sidereal longitude
- Nakshatra index = sidereal_longitude / 13.333°

### Accuracy: ~0.5° (acceptable for nakshatra determination; boundary warning shown)

---

## 12. Oracle Composite Engine (Prasanam)

### Source
- Composite of multiple traditional systems (Tarabala, Hora-Swara, Panja Pakshi)

### Method

```
Score = BaseBirdScore × TarabalaMultiplier × HoraSwaraMultiplier × CategoryHarmony
```

- Base bird score: Ruling=100, Eating=80, Walking=60, Sleeping=30, Dying=10
- Tarabala: Navatara modulo-9 formula (0.2x to 1.5x) — currently defaulted to 1.0
- Hora-Swara: Planet energy vs breath flow alignment (0.5x to 1.5x)
- Category Harmony: Query category vs active Action Window (0.5x to 1.2x)
- Floor lock: Rahu Kaal or Emakandam → hard lock to 10%

### Accuracy Status: ✅ Correct — Tarabala integrated (Sprint 33)

Transit nakshatra computed from current Moon position via `NakshatraCalculator.calculate(now)`.
Birth nakshatra from user profile. `TaraCategory.resolve(birthIndex, transitIndex).weight` gives the multiplier.

---

## 13. Action Windows

### Source
- Sara Kalai interpretation of Pakshi states for lifestyle guidance

### Method

Bird states are consolidated into 3 action windows:
- **Artha (Material)**: Ruling + Walking states
- **Kriya (Nourishment)**: Eating state
- **Yoga (Spiritual)**: Sleeping + Dying states

Consecutive yamas with the same window type are merged into single blocks.
Rahu Kaal overlay blocks Artha/Kriya windows (clamped to 10% effectiveness).

### Accuracy: ✅ Correct (derived directly from bird state calculations)

---

## Known Issues & Remaining Accuracy Targets

| Issue | Impact | Status |
|-------|--------|--------|
| ~~Birth bird uses only Bright Half table~~ | ~~Wrong bird for ~50% of users~~ | ✅ Fixed Sprint 33 |
| ~~Monthly bird swap logic~~ | ~~Bird identity changes incorrectly~~ | ✅ Fixed Sprint 33 |
| ~~Nostril pattern simplified~~ | ~~~30% incorrect predictions~~ | ✅ Fixed Sprint 33 |
| ~~Tarabala defaulted to 1.0~~ | ~~Oracle score missing key multiplier~~ | ✅ Fixed Sprint 33 |
| Manual "I know my star" uses Bright Half only | May be wrong if user born in Krishna Paksha | Low (user should use DOB path for accuracy) |
| Daily state table selection by current lunar phase | Needs validation against Align27 | Sprint 37 (calibration) |

---

## References

1. Pulippani, U.S. *Biorhythms of Natal Moon — Mysteries of Pancha Pakshi*. Sagar Publications, New Delhi.
2. Meeus, Jean. *Astronomical Algorithms*. Willmann-Bell, 1991.
3. NOAA. *Solar Position Algorithm*. [gml.noaa.gov](https://gml.noaa.gov/grad/solcalc/solareqns.PDF)
4. vedastro.org. *Pancha Pakshi Shastra — Modern Student's Guide*. [vedastro.org/blog](https://vedastro.org/blog/Pancha-Pakshi-Part-2-Finding-Your-Birth-Bird.html)
5. suzhimunai.wordpress.com. *Tamil Panchapakshi Reference*. (Note: bird swap interpretation was incorrect — corrected in Sprint 36)
6. dasarpai.com, swarayoga.org. *Siva Swarodaya* references.

---

[← Back to Docs](../README.md)
