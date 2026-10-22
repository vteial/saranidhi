<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/golden-fixture-gate-v2/design.md
  Last verified: 2026-10-22 (v1.13.0-web).
-->
# Golden-Fixture Gate Hardening (v2) — Design

| Property | Value |
| :--- | :--- |
| **Spec ID** | `golden-fixture-gate-v2` |
| **Surface** | Executor (Antigravity) — independent-truth fixture, expanded reconcile cases, regen-guard. **No `lib/` engine edit.** |

## 1. Approach
Two additive moves on top of the shipped v1 gate — **no new machinery, no engine change**:
1. **Break the self-reference (R1).** Add a second, hand-authored fixture whose `expected` values
   are **transcribed from an external source** (Meeus's printed worked example; the canonical CONF
   star-table rows), each carrying a mandatory `groundTruth` provenance string. The *same* reconcile
   test asserts the real engine against these literals. Because the literal did NOT come from the
   engine, a bug already baked into `v1.13.0` makes the assertion fail — which is the point.
2. **Pin the named unpinned branches (R2).** Add engine-snapshot cases (the v1 pattern is fine for
   coverage-of-a-branch, where "is this branch even exercised" is the question) for night yamas
   Y6–Y10, tattva in yama2–5, Oracle Sushumna/Yoga + Emakandam, peacock + longitude→bird, 7 hora
   day-lords, and the pre-dawn swara rollover.

The distinction is deliberate: **independent-truth cases prove correctness** (external literal);
**coverage cases prove a branch runs and is locked against drift** (engine snapshot). The report's
RC concern is answered by (1); the §4 gap list by (2).

## 2. Independent-truth fixture (`test/golden/astro_independent.json`)
A separate file (not folded into `astro_golden.json`) so the regen tool can mechanically skip it
and so a reviewer sees the ground-truth set at a glance. Format mirrors v1 but adds the required
`groundTruth` field and forbids a `tolerance` loose enough to hide a sign/scale bug:

```json
{
  "meta": {
    "kind": "independent-truth",
    "note": "Hand-transcribed from external/corpus sources. NEVER regenerated from the engine — see tool/regen_golden.dart guard. A failing case here is a REVEALED BUG, not a drift (requirements R4.1).",
    "lastVerified": "2026-10-22"
  },
  "moonLongitude": [
    { "id": "ind-moon-meeus-47a",
      "input": { "datetime": "1992-04-12T00:00:00Z" },
      "expected": { "apparentLongitude": 133.162655 },
      "tolerance": 1e-5,
      "groundTruth": "Meeus, Astronomical Algorithms 2nd ed., Example 47.a — apparent longitude of the Moon 1992 Apr 12 0h TD. Transcribed from the book, NOT the engine." }
  ],
  "nakshatra": [
    { "id": "ind-nak-<star>-<bird>",
      "input": { "dob": "<ISO datetime chosen to land mid-nakshatra>" },
      "expected": { "standardName": "<star>", "birthBird": "<bird>" },
      "groundTruth": "CONF-PP-001 canonical 5-6-5-5-6 star table, row: <star> → <bird>" }
  ]
}
```
- **R1.3 nakshatra set:** pick ≥ 4 rows straight from the CONF 5-6-5-5-6 table, chosen so **peacock
  appears** and so the independent set alone touches ≥ 1 row per bird (vulture/owl/crow/rooster/peacock —
  enum `pakshi_calculator.dart:5-10`). Each DOB is chosen to land **mid-nakshatra** (well away from a
  cusp) so the discrete nakshatra is unambiguous regardless of the `±1e-6°` longitude tolerance.
- **Meeus tolerance (OQ-1):** the book prints Example 47.a to ~1e-5° of apparent longitude; declare
  `tolerance: 1e-5` so the assertion is against the *book's* precision, not the engine's 14-digit output.
  If the engine's definition (apparent vs geometric, ayanamsa applied or not) differs from Meeus's
  worked quantity, that is itself a finding — resolve the exact comparand during T0 (read the engine).
- `groundTruth` is **mandatory** on every independent case; the loader fails a case missing it (R1.2/R3.1).

## 3. Coverage cases — extend `test/golden/astro_golden.json` (R2)
Append to the EXISTING sections (never alter the 37 v1 cases — RQ.3). The reconcile test already
has a `group()` per section and one `test()` per id (`golden_fixture_test.dart:65`+), so new ids
are picked up automatically — **confirm no case count is hard-asserted** beyond the integrity
floor (`:67-102` asserts `total ≥ 20`, which only rises). Per-branch wiring:

| Req | Section | New case(s) | Engine path pinned | Anchor |
| :--- | :--- | :--- | :--- | :--- |
| R2.1 | `tattva` (new night variant) | ≥1 reconcile inside a **night yama** | `YamaCalculator.calculateNight` → `NightYamaResult` → `TattvaCalculator.activeTattva` | `yama_calculator.dart:150-178` |
| R2.2 | `tattva` | cases landing in **yama2–yama5** | `activeYama` selecting later daytime yamas | `astro_golden.json:364-436` (today all yama1) |
| R2.3 | `oracle` | sushumna flow **in Yoga window** (aligned) + **outside** (not) | `_resolveAlignment` `BreathFlow.sushumna → isSushumnaAligned` | `oracle_engine.dart:116-118`, `action_window.dart:58` |
| R2.4 | `oracle` | **Emakandam-active** case | `isEmakandamActive` lockout | `oracle_engine.dart:71` |
| R2.5 | `nakshatra` | **peacock ≥2×** + 1 **longitude→nakshatra→bird** end-to-end | `MoonLongitudeCalculator`→`NakshatraCalculator`→`PakshiCalculator` chained in one case | §2.2 of report |
| R2.6 | `hora` | all **7 day-lords** + **1 day→night boundary** hora | `HoraCalculator.activeHora` across weekdays + `isDayHora` flip | `astro_golden.json:267-363` |
| R2.7 | `swara` | **pre-dawn** (anchorSunrise) + **late-day** (alt-block flip) | `SwaraClock.anchorSunrise` / `blockAt` late | `swara_clock.dart:140-176`, `:118-129` |

- For the **longitude→bird end-to-end** case (R2.5): either chain the calls in the test for that one
  case id, or record the intermediate nakshatra in `expected` so the single case asserts the whole
  path. Pick the approach the existing test structure makes cleanest — read `golden_fixture_test.dart`
  before wiring (the code is the truth).
- **Sushumna setup (R2.3):** `SwaraClock.expectedFlowAt` never *returns* sushumna by design
  (`swara_clock.dart:36-38`), so the oracle case supplies `actualSwara: "sushumna"` as the **recorded**
  flow input to `OracleCompositeEngine.evaluate(...)` — that is the real-world path (a user records a
  sushumna reading); confirm the evaluate signature accepts it during T0.

## 4. The reconcile test (`test/golden/golden_fixture_test.dart`) — minimal additive change
- Add a loader for `astro_independent.json` alongside the existing `astro_golden.json` load, and a
  `group('independent-truth', …)` that iterates its sections with the SAME assertion helpers the v1
  sections use (exact for discrete, within-`tolerance` for continuous). Reuse, don't fork, the
  per-case assert logic — one failure path, one message format naming id/expected/actual (R3.1).
- **R3.3:** the independent group SHALL run even if `astro_golden.json` had zero cases — load the two
  files independently; neither's emptiness short-circuits the other.
- **R1.2 guard:** an independent case missing `groundTruth` fails the test (fail-closed on provenance).
- Determinism unchanged: inputs only from the fixtures; no `DateTime.now()`, DB, or network (R3.2).

## 5. Regen-guard (`tool/regen_golden.dart`, R1.4)
- The tool today rewrites `astro_golden.json` from engine output. It SHALL **not** touch
  `astro_independent.json` — simplest correct design: the tool only ever knows about
  `astro_golden.json` (it never opens the independent file), and its header comment is extended to
  state explicitly: *"Independent-truth cases live in `astro_independent.json` and are hand-authored
  literals transcribed from external sources — they are NEVER regenerated, because regenerating them
  would re-introduce the self-reference that `golden-fixture-gate-v2` removed. Do not add them here."*
- V3 proves it: running the tool leaves `astro_independent.json` byte-identical (`git status` clean for it).

## 6. CI wiring (R2.1 of v1 — already satisfied, confirm only)
- Both fixtures live under `test/golden/`, which the Tier-1 `flutter test` sweep already covers
  (`ci.yml:38-47`, blocking). Adding a second JSON + more cases needs **no CI change** — confirm the
  job does not path-enumerate individual fixture files (it runs the directory). `just validate-local`
  likewise already runs the whole suite — confirm, don't re-wire.

## 7. Open questions (resolve during build — flag to owner if they change acceptance)
- **OQ-1 Meeus comparand:** does `MoonLongitudeCalculator` return *apparent* longitude (nutation +
  aberration) as Meeus 47.a prints, or a geometric/ayanamsa-adjusted quantity? The independent
  expected must match the engine's actual output semantics, transcribed from the book's matching line.
  If they are different quantities, the independent Moon case must transcribe the book value that
  corresponds to what the engine returns — resolve by reading the engine at T0; if ambiguous, STOP and ask.
- **OQ-2 CONF star-table access:** confirm the canonical 5-6-5-5-6 table is readable in-repo (corpus
  under `docs/research/`) so the nakshatra→bird literals are transcribed from a committed source the
  reviewer can check — cite the file:line in `groundTruth`.
- **OQ-3 Emakandam/Sushumna input shapes:** confirm the exact `OracleCompositeEngine.evaluate(...)`
  params needed to drive an Emakandam-active window and a recorded sushumna flow (read `oracle_engine.dart`).
