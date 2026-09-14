[← Back to Sprint Dossier](./README.md) · [Sprint Tracker](../../sprint-tracker.md)

# Sprint 42 — Swara Clock Engine & Weekday Udhaya (v1.11.0) — Implementation Spec

> **Authored by Kiro Web for the Antigravity IDE coding setup** (Saranidhi local dev
> = pure Antigravity IDE on the owner's Mac). This is a **correctness-critical** calc
> change (it moves the "readiness" half of the flagship Aruḍam verdict onto a different
> clock), so implement with local `flutter analyze` + full `flutter test` **GREEN before
> opening the PR** — CI-only is not sufficient (v1.2.1 lesson). Kiro Web reviews the real
> diff. All doctrine here is **owner-confirmed** via CONF-001, CONF-013, CONF-014,
> CONF-018 in
> [`docs/research/sarakalai-workshop-knowledge.md`](../../../research/sarakalai-workshop-knowledge.md).

## 0. Prerequisite — environment + known-GREEN baseline (do FIRST)

- **Working Flutter toolchain** per [`docs/process/dev-setup.md`](../../dev-setup.md)
  (macOS: Flutter stable ≥3.44 / Dart ≥3.12.1). One-time per machine — this spec does
  NOT repeat setup.
- **Pre-flight (before touching any Sprint 42 code)** — establish a known-green baseline
  so we never change a core calc on top of an already-red suite (v1.2.1 lesson):
  ```bash
  flutter --version          # confirm stable ≥3.44 / Dart ≥3.12.1
  flutter pub get            # deps + codegen
  flutter analyze            # expect: no issues
  flutter test               # baseline: green EXCEPT the 4 known CloudKit-on-macOS failures
  ```
  **Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected failures**
  in `test/features/cloud_backup/backup_repository_test.dart` (the "on non-Apple platform"
  CloudKit cases) — they fail only because `Platform.isMacOS==true` locally and PASS on CI
  (Ubuntu). See `dev-setup.md`. They have **zero** bearing on this sprint. The baseline to
  protect = "green **except those same 4 CloudKit tests**." If `analyze` is not clean, or
  `test` shows **any failure other than those 4**, STOP and report before starting.
  - **Cleanest noise-free check for this sprint** (no CloudKit):
    `flutter test test/features/astro_engine/ test/features/breath_journal/ test/features/home/ test/features/streaks/`
    — fully green before AND after your changes.

---

## 1. Why (the bug)

The app predicts the **expected nostril** (Solar/Right vs Lunar/Left) via
`NostrilPattern.expectedFlowForYama(...)`, which is driven by **two things it should not
be**:

1. **The wrong clock.** It keys the prediction to the **Panja Pakshi 1.5-hour yama**
   (`YamaIndex`), alternating "per yama". But per **CONF-014** the swara (nostril)
   alternation is a **1-hour / 24-cycle clock** that is a **separate clock** from the
   1.5h bird-state yama clock — the two must not be conflated.
2. **The wrong dawn seed.** It seeds the day's first nostril from the **3-day Tithi
   triad** (`_dayStartsWithSolar` off `LunarPhaseCalculator`). Per **CONF-013 /
   CONF-001** the *daily* dawn swara is the **Udhaya Sara Kalai Weekday** rule, seeded at
   **astronomical sunrise** from a weekday→(nostril, 1h/2h) table (the Tithi-triad is a
   distinct practice, not the daily inception clock).

Consequence: the expected-nostril shown on the dashboard, used for journal alignment, and
fed into the Aruḍam Now **readiness multiplier** is computed on the wrong cadence and the
wrong seed — so a user checking their breath against the app is validated against a
broken reference. This **must** be fixed before the 7-day Accuracy Calibration data
collection, or every logged breath tests the wrong engine.

There is also a **latent bug** to fix in passing (see §4.1): `AlignmentChecker` calls the
pattern helper **without passing the entry's timestamp**, so it silently evaluates
"today" even when checking a historical/other-time entry.

Authority: owner-adjudicated against the Day-08 workshop video + Telegram Audio 04
(CONF-013), Day 01/08/12/13 (CONF-014), Day 08 (CONF-001). Recorded video/transcript is
primary; where the owner's handwritten notes conflicted (Saturday duration), the video
(**Sat = 1h Right**) governs.

---

## 2. Task 42.1 — New `SwaraClock` engine (1-hour / 24-cycle)

**New file:** `lib/features/astro_engine/domain/swara_clock.dart`

Create a pure-Dart, dependency-light engine that answers **"which nostril is expected at
this instant?"** on the **1-hour / 24-cycle** clock, anchored to the **sunrise-to-sunrise
civil day** (CONF-001), seeded by the **Weekday Udhaya** rule (CONF-013, §3), progressing
hourly (§3.3), across the **full 24h** (day and night).

### 2.1 Public surface (proposed — implementer may refine names, keep semantics)

```dart
/// The expected swara (nostril) on the 1-hour / 24-cycle clock (CONF-014),
/// seeded at astronomical sunrise by the Weekday Udhaya rule (CONF-013 / CONF-001).
class SwaraClock {
  const SwaraClock._();

  /// Expected flow at [time] for a civil day whose dawn is [sunrise].
  /// [sunrise] is the astronomical sunrise of the civil day that CONTAINS [time]
  /// (sunrise-to-sunrise reckoning — see §3.4 for the day-boundary rule).
  /// [paksha] is the lunar phase at that sunrise (only consulted for Thursday).
  /// Returns Solar (Right) or Lunar (Left). Never returns Sushumna
  /// (Sushumna is the ≤5-min transition, not a scheduled hour — CONF-014/026).
  static BreathFlow expectedFlowAt({
    required DateTime time,
    required DateTime sunrise,
    required LunarPhase paksha,
  });

  /// The seed for the given civil day: the dawn nostril + Udhaya inception
  /// duration (1h or 2h). Exposed for the dashboard card + tests.
  static SwaraSeed seedFor({
    required int sunBasedWeekday, // 1=Sun … 7=Sat (PakshiCalculator convention)
    required LunarPhase paksha,   // only affects Thursday
  });

  /// Start of the current ~1h swara block that contains [time], and the next
  /// switch instant — powers the "next switch in N min" countdown on the card.
  static SwaraBlock blockAt({
    required DateTime time,
    required DateTime sunrise,
    required LunarPhase paksha,
  });
}

class SwaraSeed {
  const SwaraSeed({required this.dawnFlow, required this.inceptionHours});
  final BreathFlow dawnFlow;   // Solar or Lunar
  final int inceptionHours;    // 1 or 2
}

class SwaraBlock {
  const SwaraBlock({required this.flow, required this.start, required this.end});
  final BreathFlow flow;
  final DateTime start;
  final DateTime end;          // == next switch instant
}
```

> **Do NOT model Sushumna as a scheduled block.** Per CONF-014/CONF-026 the Sushumna
> transition is the ≤4–5 min crossover between nostrils (~90 min/day total), not one of
> the 24 hourly slots. The expected-flow clock is a clean Solar/Lunar alternation; the
> existing Sushumna handling (context-dependent alignment) stays in `AlignmentChecker`
> and the Aruḍam engine and is **out of scope** for this clock.

### 2.2 Reuse existing utilities

- Weekday: `PakshiCalculator.dartWeekdayToSunBased(time.weekday)` (1=Sun … 7=Sat).
- Paksha: `LunarPhaseCalculator.phaseForDate(sunrise)` — evaluate paksha **at the
  sunrise instant** (CONF-001), not at `time`.
- `BreathFlow` (`solar` / `lunar` / `sushumna`) from `breath_journal/domain/breath_flow.dart`.

---

## 3. Task 42.2 + 42.3 — Weekday Udhaya dawn seed + hourly progression

### 3.1 The Weekday Udhaya dawn table (CONF-013, owner-confirmed)

Seed = the nostril the day's breath must initiate in **at astronomical sunrise**, plus
the **Udhaya inception duration** (how long the seed is held before hourly alternation
begins). Mnemonic: **Heating/Copper → Right (Solar)**, **Cooling/Silver → Left (Lunar)**.

| Sun-based weekday | Day | Dawn nostril | Inception |
|:--:|-----|:--:|:--:|
| 1 | Sunday    | **Right (Solar)** | 1h |
| 2 | Monday    | **Left (Lunar)**  | 1h |
| 3 | Tuesday   | **Right (Solar)** | 2h |
| 4 | Wednesday | **Left (Lunar)**  | 2h |
| 5 | Thursday  | **paksha split** *(see below)* | *(see below)* |
| 6 | Friday    | **Left (Lunar)**  | 2h |
| 7 | Saturday  | **Right (Solar)** | 1h |

**Thursday paksha split** (evaluated at the sunrise instant, CONF-001):
- **Shukla / Valarpirai** (waxing, toward Pournami = cooling) → **Left (Lunar), 1h**
- **Krishna / Theipirai** (waning, toward Amavasai = heating) → **Right (Solar), 2h**

> **Sourcing note for the implementer:** encode this table **exactly** as above. The only
> historical ambiguity was Saturday (owner's note said 2h; the Day-08 **video says 1h** →
> **1h is correct**). Reproduce the full table verbatim in the PR description for owner
> cross-check. Do not infer or "regularize" it.

Map `LunarPhase` → paksha: the app's `LunarPhase.waxing` == Shukla/Valarpirai,
`LunarPhase.waning` == Krishna/Theipirai. Verify the enum's exact member names in
`lunar_phase_calculator.dart` before use (the code uses `LunarPhase.waxing`).

### 3.2 `seedFor(weekday, paksha)` — returns `SwaraSeed`

Straight table lookup returning `(dawnFlow, inceptionHours)` per §3.1, with the Thursday
branch on `paksha`.

### 3.3 Hourly progression (`expectedFlowAt`)

Given the civil day's `sunrise`, its `seed`, and a query `time`:

1. Compute elapsed = `time.difference(sunrise)` (may be negative if `time` is before
   this civil day's sunrise — the caller should pass the sunrise of the **containing**
   civil day; see §3.4).
2. Let `h = inceptionHours` (1 or 2).
3. **Inception window** `[sunrise, sunrise + h hours)` → expected flow = `seed.dawnFlow`.
4. **After inception**, alternate **every 1 hour** (CONF-014). The first post-inception
   block flips to the opposite of `dawnFlow`, then alternates hourly thereafter:
   - For `h == 1`: blocks are `[0,1)=seed`, `[1,2)=¬seed`, `[2,3)=seed`, … (pure hourly
     alternation from sunrise — the 1h inception is just the first block).
   - For `h == 2`: blocks are `[0,2)=seed` (held 2h), then `[2,3)=¬seed`, `[3,4)=seed`,
     `[4,5)=¬seed`, … (hourly alternation begins at hour 2).
5. Determine which block `elapsed` falls into and return that block's flow.

Concretely, an integer block model:
```text
if elapsed < h hours:            flow = dawnFlow
else:                            n = floor(elapsed_hours) - h   // 0,1,2,…
                                 flow = (n even) ? ¬dawnFlow : dawnFlow
```
(Implementer: derive/verify this parity against the worked examples in §3.5 — those are
the acceptance oracle.)

### 3.4 Day boundary — sunrise-to-sunrise (CONF-001), full 24h

The clock runs **continuously across midnight** until the **next** sunrise. Nighttime is
NOT a dead zone (unlike the yama-based predecessor, which defaulted night to Lunar). The
caller must anchor to the **sunrise of the civil day that contains `time`**:

- If `time` is **at/after** today's sunrise → use today's sunrise as the seed anchor.
- If `time` is **before** today's sunrise (i.e. after midnight, pre-dawn) → the governing
  civil day began at **yesterday's** sunrise; use that.

Provide a small helper (in `SwaraClock` or the caller) that, given `time` + a
sunrise-provider, resolves the correct anchoring sunrise. Since `SunriseCalculator`
computes per-date, the cleanest approach: compute sunrise for `time`'s date; if
`time.isBefore(sunrise)`, recompute for `time - 1 day` and use that. Keep this logic in
ONE place and unit-test the pre-dawn case explicitly (§7).

> The 2h-Thursday-Krishna seed can legitimately straddle across sunrise math — make sure
> the inception window is measured from the **anchoring** sunrise, not a naive midnight.

### 3.5 Worked examples (acceptance oracle — encode as tests)

Assume sunrise at 06:00 for readability (real code uses the computed instant).

- **Sunday (seed R, 1h):** 06:00–07:00 **R**, 07:00–08:00 **L**, 08:00–09:00 **R**, …
  → 06:30 = R, 07:30 = L, 13:00 = R (7h after → n=6 even → ¬seed? check: n=floor(7)-1=6 → even → ¬R = L)… **derive carefully and pin the exact expected values in tests.**
- **Tuesday (seed R, 2h):** 06:00–08:00 **R** (held), 08:00–09:00 **L**, 09:00–10:00 **R**, …
  → 07:30 = R, 08:30 = L, 09:30 = R.
- **Thursday Shukla (seed L, 1h):** 06:00–07:00 **L**, 07:00–08:00 **R**, …
- **Thursday Krishna (seed R, 2h):** 06:00–08:00 **R** (held), 08:00–09:00 **L**, …
- **Pre-dawn continuity:** at 02:00 (before 06:00 sunrise), anchor to *yesterday's*
  sunrise and continue that day's alternation across midnight.

> **Implementer:** compute each block by hand from §3.3, put the exact Solar/Lunar
> expectation for each sample instant into `swara_clock_test.dart`, and make the code
> match. If any example above looks off once you work the parity, resolve it against the
> §3.3 rule (the rule is authoritative; the inline "= R/L" hints are illustrative).

---

## 4. Task 42.4 — Rewire consumers onto `SwaraClock`

Retire the yama-based prediction. `NostrilPattern.expectedFlowForYama` (and its
`_dayStartsWithSolar` tithi seed) is **replaced** by `SwaraClock`. Either delete
`nostril_pattern.dart` outright, or gut it to a thin deprecated shim — **but no live code
path may call the yama-based predictor after this sprint.**

### 4.1 `AlignmentChecker` (`lib/features/breath_journal/domain/alignment_checker.dart`)

- Replace `_expectedFlowForYama(activeYamaSegment?.index)` with a `SwaraClock` call.
  `check(...)` already computes `sunResult` (has `sunrise`/`sunset`) and has `time` +
  `LunarPhaseCalculator` in scope — feed `SwaraClock.expectedFlowAt(time: time,
  sunrise: <anchored sunrise>, paksha: <phase at sunrise>)`.
- **Fix the latent bug**: the old code called the helper with **no date**, so it used
  `DateTime.now()` regardless of the entry's `time`. The new call MUST use the entry's
  `time` and the anchored sunrise for that `time` (§3.4). This changes historical/other-
  time alignment results to be *correct* — call this out in the PR (it is an intended
  correctness change, not a regression).
- `activeYama` stays in `AlignmentResult` for display, but it MUST NOT drive
  `expectedFlow` anymore. Sushumna handling (`actionWindow.isSushumnaAligned`) is
  unchanged.

### 4.2 Aruḍam Now readiness multiplier

- The readiness multiplier consumes `AlignmentChecker.check(...).isAligned` (see the 3
  call sites in `arudam_now_card.dart` and the `IntegratedArudamEngine.evaluate(isAligned:
  …)` path). Because §4.1 changes how `isAligned` is derived for non-Sushumna flows, the
  readiness multiplier now reflects the **correct** swara clock automatically — **no
  signature change** to `IntegratedArudamEngine`. Verify the card still passes
  `isAligned` from the (now-corrected) checker and does not separately call the retired
  `NostrilPattern`.

### 4.3 Nostril Pattern dashboard card (`nostril_dominance_chart.dart`)

Today it renders **5 per-yama rows** (one per `YamaSegment`) with a **next-switch =
`yama.end`** countdown. This is the yama clock and must change to the **~1h swara clock**:

- **Rows:** render the expected nostril as **hourly blocks across the civil day** (the
  1h/24 clock), not 5 yama rows. Recommended: show the current block prominently + the
  upcoming few blocks (implementer's UX call — keep it compact and consistent with the
  card's current density). At minimum, the **currently-active** expected nostril must come
  from `SwaraClock.expectedFlowAt(now, sunrise, paksha)`.
- **Next-switch countdown:** must be the **~1h swara switch** (`SwaraClock.blockAt(...).end
  − now`), NOT `yama.end`. This is the headline correctness-visible change.
- **Night:** the card previously showed a "no pattern at night" note. With the 24h clock,
  the nostril pattern **is** defined at night — replace the dead-zone note with the live
  night block (keep any gentle "night = rest/inward" wellness copy, but the expected
  nostril is now shown). Confirm `DashboardData` exposes the needed sunrise/paksha; it
  already carries `sunrise` and `isNight`.

### 4.4 `oracle_engine.dart` `_resolveAlignment`

- `_resolveAlignment` currently calls `NostrilPattern.expectedFlowForYama(activeYama?.index,
  date: queryTime)`. Repoint it to `SwaraClock.expectedFlowAt(time: queryTime, sunrise:
  <anchored sunrise for queryTime>, paksha: <phase at that sunrise>)`. It already has
  `sunrise`/`sunset`/`queryTime`/`currentWindow` in scope. Sushumna branch unchanged.

> **Grep gate:** after rewiring, `grep -rn "expectedFlowForYama\|NostrilPattern" lib`
> must return **no live call sites** (only the deprecated shim/file itself, if retained).

---

## 5. Task 42.5 — Regression gate (bird-state / yama UNCHANGED)

Only the **nostril clock** moves. The **Panja Pakshi bird-state / yama** engine
(`PakshiCalculator`, `YamaCalculator`, bird states, action windows, oracle Moment score)
must be **byte-for-byte unchanged** in behavior.

- **Pin with tests:** the existing `pakshi_calculator_test.dart`, `yama_calculator_test.dart`,
  `oracle_engine_test.dart`, `integrated_arudam_engine_test.dart` must pass **unchanged**
  (do not edit their expectations except where a test *explicitly* asserted the old
  nostril prediction — those specific assertions move to `swara_clock_test.dart`).
- **Aruḍam Now score:** may change **only** where the corrected nostril clock legitimately
  flips `isAligned` (readiness ×1.0 ↔ ×0.75). The **Moment** score (bird × tarabala ×
  hora-swara × category) and the floor-lock must be unchanged. Add/keep a test that pins a
  Moment-only scenario (swara stale → readiness 1.0) to prove Moment is untouched.
- **No schema change.** No DB migration this sprint.

---

## 6. Task 42.6 — Citation cleanup (floor-lock is NOT CONF-018)

In `integrated_arudam_engine.dart`, the Rahu/Emakandam floor-lock reason is cited as
`conf: 'CONF-018'`:

```dart
reasons: const [
  ArudamReason(
    factor: ArudamFactor.floorLock,
    strength: FactorStrength.blocking,
    conf: 'CONF-018',   // ← WRONG
  ),
],
```

**Why it's wrong:** CONF-018 is the **Daytime-Left / Nighttime-Right macro-seal** (the
Earth's-breath descriptive layer + point-inception sadhana) — it has nothing to do with
the **Rahu Kaal / Emakandam** inauspicious-window 10% floor-lock. That floor-lock is a
**Panja Pakshi / Prasanam Oracle** mechanic, documented in
[`docs/research/prasanam_oracle_engine.md`](../../../research/prasanam_oracle_engine.md)
(§ Guardrail Lockouts) with the day-indexed Rahu `[8,2,7,5,6,4,3]` / Emakandam
`[5,4,3,2,1,7,6]` tables. There is **no CONF-0xx** backing it (the Sara Kalai CONFs stop
at the swara/tattva doctrine; the Panja Pakshi tracker has only CONF-PP-001…006, none for
inauspicious windows).

**Fix:** re-key the floor-lock citation off `CONF-018` to a citation that points at the
Prasanam Oracle guardrail doctrine. Recommended: introduce a stable citation token for
the oracle-engine mechanics (e.g. `PP-ORACLE` or `PRASANAM-GUARDRAIL`) whose provenance
is `prasanam_oracle_engine.md § Guardrail Lockouts`, and update the doc-comment block at
the top of `ArudamFactor` (which currently maps `floorLock` → CONF-018) to match.

- Update the enum doc-comment: `[floorLock]` provenance → the new token, and its inline
  `/// Rahu/Emakandam … — CONF-018.` comment.
- **Optional (owner call — implement only if trivially clean):** CONF-018 *does*
  legitimately back a **day/night macro-framing** reason. If (and only if) you are adding
  a day/night descriptive reason this sprint, cite it CONF-018. Otherwise leave CONF-018
  out entirely — do not invent a factor just to home the citation.

> **Flag for owner review (do NOT change without sign-off):** the `readiness` factor is
> cited `CONF-016 / CONF-017` (therapeutic occlusion / Kumbhaka-consistency). Now that
> readiness rides the swara clock, **CONF-014** is arguably the better citation. Note this
> in the PR/implementation-summary as a source-derived question for the owner; the
> in-scope, must-do citation fix this sprint is the **floor-lock** one above.

---

## 7. Tests (`test/features/astro_engine/swara_clock_test.dart` + updates)

New `swara_clock_test.dart` (the correctness heart of the sprint):

- **Weekday seeds** — all 7 seeds from §3.1: Sun R/1h, Mon L/1h, Tue R/2h, Wed L/2h,
  Fri L/2h, Sat R/1h, **Thu Shukla L/1h**, **Thu Krishna R/2h**.
- **1h vs 2h inception** — dawn block length correct (seed held 1h vs 2h before first flip).
- **Hourly alternation** — sample instants across a full day for a 1h-day and a 2h-day
  match the §3.5 worked oracle exactly.
- **Day/night boundary + pre-dawn** — a nighttime instant returns a live Solar/Lunar
  block (not a dead default); a **pre-dawn (post-midnight, before sunrise)** instant
  anchors to *yesterday's* sunrise and continues correctly across midnight.
- **Sunrise anchoring** — changing sunrise shifts the block boundaries accordingly.
- **`blockAt` countdown** — `end − time` is ≤ 60 min and lands on the next hour boundary.

Updates:
- `alignment_checker` test(s): assert `expectedFlow` now comes from the swara clock and
  that a **non-`now` entry time** is honored (locks in the §4.1 latent-bug fix).
- Move any yama-based nostril assertions out of `oracle_engine_test.dart` /
  `nostril_pattern_test.dart` into `swara_clock_test.dart`; if `nostril_pattern.dart` is
  deleted, delete/replace its test file.
- Widget: `nostril_dominance_chart` test updated for hourly blocks + ~1h countdown (not
  yama rows / `yama.end`).
- **Regression:** bird/yama/oracle Moment tests unchanged & green (§5).

**Local gate:** `flutter analyze` clean + full `flutter test` = same 4 CloudKit failures
and **no others**, BEFORE the PR.

---

## 8. Bilingual (Task 42.7)

- Any **new/changed** nostril-pattern copy (card labels, night line replacement,
  next-switch/"switches in ~N min" phrasing) must have **both** `app_en.arb` and
  `app_ta.arb` keys, matching the existing ARB patterns. Run codegen
  (`flutter gen-l10n` / part of `pub get`) and keep EN/TA key parity (Kiro-Web pre-PR
  Tamil gate — the recurring miss). No hardcoded English `Text()` in the card.
- Existing keys (`nostrilPattern`, `solar`, `lunar`, `now`, `nextSwitch`) are reused where
  still applicable; only add keys for genuinely new strings.

---

## 9. Out of scope (this sprint)

- **Accuracy Calibration** — the 7-day 3-way (Saranidhi vs Align27 vs Panchangam vs actual
  breath) comparison is the *validation gate* and a separate backlog epic **gated behind
  this sprint shipping** + owner data collection. This sprint is the *correction*.
- **Sushumna scheduling** — Sushumna stays the ≤5-min transition / context-dependent
  alignment; it is not a scheduled block on this clock.
- **Vidiyal Sara Kalai** (bedside awakening sadhana) — CONF-013 names it as a distinct
  practice from Udhaya; not modeled here. `SwaraClock` implements **Udhaya** only.
- **Tattva sub-schedule** (CONF-012 20/16/12/8/4 min) — not part of the nostril clock.
- Native "Now" surface, broader analytics — separate sprints.

---

## 10. Definition of Done

See the Sprint 42 Delivery Checklist in [`sprint-tracker.md`](../../sprint-tracker.md).
Key gates:

1. **Local `flutter analyze` clean + full `flutter test` green** (same 4 CloudKit only)
   BEFORE the PR — correctness-critical, CI-only is insufficient.
2. **Grep gate:** no live call sites of `NostrilPattern.expectedFlowForYama` remain.
3. **Regression gate:** bird-state / yama / Pakshi / oracle-Moment outputs unchanged
   (pinned); Aruḍam Now score changes ONLY where the corrected nostril clock legitimately
   moves readiness; **no schema change**.
4. **Docs:** User Guide (Nostril Pattern now on the ~1h swara clock + weekday dawn rule)
   + `calculation-methodology.md` (new §: Swara Clock + Weekday Udhaya table) + the
   CONF-018 floor-lock citation fix.
5. **Bilingual EN/TA** for all new/changed copy.
6. Fill [`implementation-summary.md`](./implementation-summary.md) +
   [`test-summary.md`](./test-summary.md); Kiro Web reviews the real diff before owner merge.
