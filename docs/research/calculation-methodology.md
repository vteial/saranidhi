[← Back to Docs](../../README.md)

# Saranidhi — Calculation Methodology & Sources

> Reference document for how each Vedic calculation is derived, what sources are used,
> and known accuracy issues with current implementation.

---

## 1. Birth Bird Derivation

### Authority & Sources
- 🥇 **2025 Panja Pakshi Workshop Video** (Teacher's class, Day 1 @ 29:00, 33:00, 34:00–51:00) — Primary authority
- 🥇 **Master's 56-page book** (*Panja Pakshi Aarudan*, pp. 7–8) — Same-lineage confirmation (venba meter)
- 🥈 **1930 *Pancha Pakshi Rathinam*** (pp. 46–47) — Ancient classical Tamil Siddha root text
- **Overruled:** Prof. Dr. U.S. Pulippani's modern secondary 5-5-5-5-7 partition and dual Krishna reverse-table (overruled per owner confirmations **CONF-PP-001** and **CONF-PP-002** in [`panja-pakshi-workshop-knowledge.md`](panja-pakshi-workshop-knowledge.md)).

### Canonical Method (Sprint 37 — v1.7.0)

Birth bird derivation for natives with a known birth star (Janma Nakshatra) depends **solely on the birth star** using a **single permanent table** (no Krishna reverse-swap).

> *"ஜென்ம நட்சத்திரம் தெரிஞ்சவங்க தேய்பிறையை பயன்படுத்த வேண்டாம், வளர்பிறை மட்டும் பயன்படுத்தினா போதும்"*  
> — 2025 Workshop Day 1 @ 33:00; Master's Book p. 8; *Rathinam* p. 46.

#### Canonical 5-6-5-5-6 Birth Star Table

| Bird | Element (Bhoota) | Ruling Planet (Graha) | Nakshatras (Canonical 5-6-5-5-6) | Count |
|------|------------------|-----------------------|----------------------------------|:-----:|
| **Vulture** (வல்லூறு) | Earth (நிலம் / Prithvi) | Jupiter (குரு / Guru) | Ashwini, Bharani, Krittika, Rohini, Mrigashira | 5 |
| **Owl** (ஆந்தை) | Water (நீர் / Apas) | Venus (சுக்கிரன் / Sukran) | Ardra, Punarvasu, Pushya, Ashlesha, Magha, **Purva Phalguni (Pooram)** | 6 |
| **Crow** (காகம்) | Fire (நெருப்பு / Tejas) | Mars (செவ்வாய் / Sevvai) | Uttara Phalguni, Hasta, Chitra, Swati, **Vishakha (Visakam)** | 5 |
| **Rooster** (சேவல் / கோழி) | Air (காற்று / Vayu) | Mercury (புதன் / Budhan) | Anuradha, Jyeshtha, Mula, Purva Ashadha, **Uttara Ashadha (Uthiradam)** | 5 |
| **Peacock** (மயில்) | Ether (ஆகாயம் / Akasha) | Saturn (சனி / Shani) | Shravana, Dhanishta, Shatabhisha, Purva Bhadrapada, Uttara Bhadrapada, Revati | 6 |

**The 3 stars that moved vs shipped Pulippani engine:**
- **Purva Phalguni (Pooram):** Crow → **Owl** (CONF-PP-001)
- **Vishakha (Visakam):** Rooster → **Crow** (CONF-PP-001; internally corroborated by Murugan's Visakam being Crow/Fire)
- **Uttara Ashadha (Uthiradam):** Peacock → **Rooster** (CONF-PP-001)

#### Key Doctrines

1. **Your birth bird is PERMANENT (CONF-PP-002).** Once determined from your birth nakshatra, it never changes. The current lunar phase does NOT alter your bird identity — only the daily yama schedule tables shift between waxing and waning fortnights.
2. **Pushya / Krishna Native Case (Owner Adjudication):** Under the old dual-table reverse logic, Pushya + Krishna was mis-computed as Cock (Rooster). Under the canonical single permanent table, Pushya is permanently **Owl** across both lunar halves.
3. **Name-Initial (Nama Pakshi) Fallback carries the Lunar Phase Swap (CONF-PP-002, Task 37.3):**
   - For individuals without a known birth star or birth date, bird derivation uses their spoken name's initial vowel sound (`NameBirdParser.birthBirdFromNameInitialAndPaksha`).
   - The waxing/waning bird split applies **strictly to this name fallback path**:
     - *Valarpirai (Waxing):* A → Vulture, I → Owl, U → Crow, E → Rooster, O → Peacock.
     - *Theipirai (Waning):* Vulture → Rooster, Owl → Vulture, Crow → Owl, Rooster → Peacock, Peacock → Crow.

### Bird Attributes & Relationships (CONF-PP-003, CONF-PP-004, CONF-PP-005)

- **Ruling Planets & Colours (CONF-PP-004):**
  - Vulture: Jupiter (Guru) · Yellow / Sandal / Gold
  - Owl: Venus (Sukran) · Pure White / Silk
  - Crow: Mars (Sevvai) · Deep Red / Crimson
  - Rooster: Mercury (Budhan) · Green / Emerald
  - Peacock: Saturn (Shani) · Black / Navy Blue
- **Unified Natural Affinities (CONF-PP-003):** Mutually symmetric friend/enemy matrix (no phase split; dual tables fail in practice per *Rathinam* p. 46):
  - Vulture: Friends = [Peacock, Owl] | Enemies = [Crow, Rooster] (Vulture↔Peacock permanent ally; Vulture↔Rooster permanent enemy)
  - Owl: Friends = [Vulture, Crow] | Enemies = [Peacock, Rooster] (Owl↔Peacock permanent enemy)
  - Crow: Friends = [Owl, Rooster] | Enemies = [Vulture, Peacock] (Crow↔Peacock permanent enemy)
  - Rooster: Friends = [Peacock, Crow] | Enemies = [Vulture, Owl]
  - Peacock: Friends = [Vulture, Rooster] | Enemies = [Owl, Crow]
- **Cardinal Directions (CONF-PP-005):** Phase-dependent tactical positioning:
  - *Valarpirai (Waxing):* Vulture = East, Owl = South, Crow = West, Rooster = North, Peacock = Center / Sky.
  - *Theipirai (Waning):* Vulture = East (permanent), Owl = North, Crow = South, Rooster = Center, Peacock = West.

### Implementation Summary (Sprint 37 — v1.7.0)

1. ✅ Nakshatra partition corrected from 5-5-5-5-7 to canonical 5-6-5-5-6 (`PakshiCalculator`).
2. ✅ Single permanent birth-star table implemented; `birthBirdFromNakshatraAndPaksha` delegates to `birthBirdFromNakshatraSafe` (CONF-PP-002).
3. ✅ Name-initial lunar phase swap added (`NameBirdParser.birthBirdFromNameInitialAndPaksha`).
4. ✅ Automatic re-migration extended on load to ALL affected users including manual "known-star" profiles (`BirdMigrationService`).
5. ✅ Bird attributes corrected: ruling planets, colours, symmetric friendships/enmities, phase-dependent directions (`PakshiAttributes`).

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

### Location Source (Sprint 34)

Sunrise/sunset — and therefore the entire daily Pakshi rhythm (yamas, Rahu
Kaal, nostril windows) — depend on the user's **current** geographic
position, not their birth place. (Birth place/time is used only for the
permanent birth-bird derivation; see §1.)

- **Stored location:** the profile's `locationLat` / `locationLng`
  (default Chennai `13.08, 80.27`). Editable in Settings.
- **Auto-update on web:** on app open, the browser Geolocation API is
  queried (`WebGeolocation.getCurrentPosition`, wired via
  `LocationOnOpenWidget`). If the reported position is **more than 5 km**
  from the stored location (Haversine distance via
  `LocationService.hasMovedSignificantly`), the profile location is updated
  silently and the user sees a one-time notice. This keeps timings accurate
  when travelling without a manual Settings edit.
- **Mobile/desktop:** the geolocation facade resolves to a no-op stub
  (`web_geolocation_stub.dart`); the stored profile location is used as-is.
- **Permission denied / unavailable / timeout (10 s):** falls back silently
  to the stored location — no error is shown.

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

[← Back to Docs](../../README.md)
