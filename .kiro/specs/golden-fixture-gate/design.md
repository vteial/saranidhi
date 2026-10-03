<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/golden-fixture-gate/design.md
  Last verified: 2026-10-03 (v1.13.0-web).
-->
# Golden-Fixture Correctness Gate — Design

| Property | Value |
| :--- | :--- |
| **Spec ID** | `golden-fixture-gate` |
| **Surface** | Executor (Antigravity) — fixtures, test, CI wiring, regen tool |

## 1. Approach
Add a reconcile layer, not new machinery. A committed JSON fixture is the **source of truth for
expected outputs**; a single test replays it against the real engines; CI runs that test as a
blocking Tier-1 step. No `lib/` engine code changes. Pattern precedent: nexus-pulse `NP-GOLDEN-001`
(vendored idea — saranidhi owns this copy; cited as provenance, not a dependency).

## 2. Fixture format (`test/golden/astro_golden.json`)
```json
{
  "meta": { "generated": "2026-10-..", "engineVersion": "v1.13.0", "note": "known-correct outputs; regen via tool/regen_golden.dart" },
  "nakshatra": [
    { "id": "nak-01", "input": { "dob": "1990-05-15T06:30:00+05:30" },
      "expected": { "standardName": "...", "birthBird": "..." }, "source": "CONF-PP-00x" }
  ],
  "swara": [
    { "id": "swara-01", "input": { "time": "2026-10-03T07:15:00+05:30", "sunrise": "2026-10-03T06:05:00+05:30", "paksha": "shukla" },
      "expected": { "flow": "..." }, "source": "CONF-0xx" }
  ],
  "moonLongitude": [
    { "id": "moon-01", "input": { "datetime": "2026-10-03T00:00:00Z" },
      "expected": { "longitude": 123.456789 }, "tolerance": 1e-6, "source": "Jean Meeus ELP2000/82 + Lahiri" }
  ],
  "hora": [ … ], "tattva": [ … ],
  "oracle": [
    { "id": "oracle-01", "input": { "category": "artha", "recordedSwara": "...", "time": "..." },
      "expected": { "band": "...", "score": 0.0 }, "tolerance": 1e-9, "source": "Sprint 31 composite" }
  ]
}
```
- **Discrete** fields (names, bird, flow, band) → exact match. **Continuous** (longitude, score) → `tolerance`.
- `source` ties doctrinal values to the resolved CONF (RC.1).

## 3. The reconcile test (`test/golden/golden_fixture_test.dart`)
- Load + parse the JSON (fail on parse error — R2.2). For each section, map `input` → the real
  engine call (§2 of requirements) and assert against `expected`:
  - `moonLongitude`: `MoonLongitudeCalculator().calculate(DateTime.parse(input.datetime)).longitude` within `tolerance`.
  - `nakshatra`: `NakshatraCalculator().calculate(dob)` → `standardName` + birth-bird exact.
  - `swara`: `SwaraClock().blockAt(time:, sunrise:, paksha:).flow` exact.
  - `hora`/`tattva`: the respective calculator's public result, exact/tolerance.
  - `oracle`: `OracleCompositeEngine().evaluate(...)` → band exact, score within `tolerance`.
- Use `group()` per section, one `test()` per case id, so a failure names exactly which case.
- **Determinism:** inputs only from the fixture; never `DateTime.now()`, no DB, no network (R2.3).
- **Confirm the exact constructors/params against the current source before wiring** — §2 lists the
  shapes verified 2026-10-03, but read the files (the Spec is the contract, the code is the truth).

## 4. CI wiring (R3)
- The repo's `test/features/astro_engine/` already runs in Tier-1 (`ci.yml`). Place the golden
  test under `test/golden/` so the existing `flutter test` sweep includes it — confirm the CI job's
  test path/globs cover `test/golden/` (adjust the job if it enumerates paths explicitly). Blocking, no `continue-on-error`.
- Add the golden test to whatever `just validate-local` already runs (it runs `flutter test`), so
  it's covered locally — verify the recipe doesn't path-filter it out.

## 5. Regen tool (`tool/regen_golden.dart`, R4)
- A small Dart entrypoint that recomputes every `expected` from the current engines and rewrites
  the JSON. **Manually run, never in CI.** Its header comment states: changing a golden value is a
  human decision — record it in the PR, and (if doctrinal) the Decision Journal + CONF.

## 6. Open questions (resolve during build)
- **OQ-1 longitude tolerance:** `1e-6°` is a lean; if any chosen DOB sits within tolerance of a
  nakshatra boundary, widen the datetime margin or tighten tolerance so the discrete nakshatra is unambiguous. Confirm with owner if borderline.
- **OQ-2 case count:** 20 is the floor (R1.1); aim for coverage of each engine's branch points (both pakshas, boundary nakshatras, each Oracle band).
