# Pakshi Scoring — Corpus Alignment — Design

## Current-state facts (verified in code, 2026-10-23)

- **Base score:** `IntegratedArudamEngine.getBaseBirdScore(PakshiState)` →
  `ruling:100, eating:80, walking:60, sleeping:30, dying:10` (int).
  `OracleCompositeEngine.getBaseBirdScore` delegates to it.
- **Composite:** `OracleCompositeEngine.evaluate(...)` multiplies base × category-harmony × tarabala ×
  hora/swara, then applies the `DaylightSegmentResolver` Rahu/Emakandam inauspicious floor-lock.
- **Window mapping:** `ActionWindow.fromBirdState` — Ruling/Walking→Artha, Eating→Kriya, Sleeping/Dying→Yoga
  (unchanged by this Spec).
- **No** Adhikara/Padu-day logic exists in `lib/` today (grep-confirmed).

## Corpus facts to encode (Kottumozhi, CONF-PP-007)

**Activity-window success/failure (p12):** Arasu 100% success · Oon 80% success · Nadai 40% (mixed/`இழுபறி`) ·
Thuyil 80% **failure** · Saavu 90% **failure**.

**Adhikara (ruling-power) day table (pp14/22) — to transcribe in full here before `/spec-run`:**
- Vulture: Shukla → Sun-day, Tue-day, Fri-night; Krishna → Sun-night, Fri-day.
- Owl: Shukla → Mon-day, Wed-day, Sat-night; Krishna → Wed-night, Thu-day.
- Crow: Shukla → Sun-night, Tue-night, Thu-day; Krishna → Wed-day, Thu-night.
- Cock: Shukla → Mon-night, Wed-night, Fri-day; Krishna → Mon-night, Tue-day, Sun-day.
- Peacock: Shukla → Thu-night, Sat-day; Krishna → Mon-day, Sat-day.

**Padu-Pakshi (full-downtime) day table (p18):**
- Shukla: Vulture Thu+Sat · Owl Sun+Fri · Crow Mon · Cock Tue · Peacock Wed.
- Krishna: Vulture Tue · Owl Mon · Crow Sun+Thu · Cock Sat · Peacock Wed+Fri.
  (Note: Peacock is Padu on Wednesday in BOTH pakshas.)

> The Executor MUST transcribe these from the rendered page images in the CONF-PP-007 source, not from this
> summary alone, and flag any discrepancy. The grids above are the Operator's reading and are the starting point.

## Approach

### D1 — Rescale `getBaseBirdScore` to carry failure semantics
Proposed (0–100, failure states below a 50 neutral line):
`ruling:100, eating:80, walking:50 (mixed midpoint), sleeping:20, dying:5`.
Rationale: Walking→50 encodes "mixed/dragging" (not the current favourable 60); Sleeping/Dying drop further to
mark active failure (80%/90% fail) while staying ordinal. Exact numbers are a design knob — the **constraint**
is R1.1 (ordering + failure sign), not these literals. Document the mapping with the corpus citation.

### D2 — New `PakshiAdhikara` helper (data-driven)
`lib/features/astro_engine/domain/pakshi_adhikara.dart`:
```
enum AdhikaraStatus { adhikara, padu, normal }
class PakshiAdhikara {
  static AdhikaraStatus statusFor({required PakshiBird bird, required int weekday,
      required LunarPhase paksha, required bool isNight});
}
```
Backed by two const maps transcribed from the corpus tables above. Pure, no I/O.

### D3 — Wiring (minimal, reviewable)
Default: expose D2 as a tested helper and have `evaluate` apply a **modifier** only when status≠normal
(e.g. Padu → ×0.5 adverse, Adhikara → ×1.15 boost), gated behind R4's golden test so the score shift is explicit.
If the owner prefers helper-only (no composite wiring this Spec), D3 reduces to "available + tested" and the
multiplier lands in a follow-up — design.md records which was chosen at `/spec-run`.

## Files
- `lib/features/astro_engine/domain/integrated_arudam_engine.dart` (D1: rescale weights + doc comment)
- `lib/features/astro_engine/domain/pakshi_adhikara.dart` (D2: new)
- `lib/features/astro_engine/domain/oracle_engine.dart` (D3: optional modifier in `evaluate`)
- `test/features/astro_engine/pakshi_adhikara_test.dart` (new)
- `test/features/astro_engine/oracle_scoring_golden_test.dart` (R4 before/after golden)
- `test/features/astro_engine/pakshi_sequence_regression_test.dart` (R3: sequence unchanged)

## Open questions (resolve at /spec-run)
- OQ-1: exact numeric scale for D1 (ordinal constraint fixed; literals are the knob).
- OQ-2: D3 wiring now vs helper-only (owner preference; default = minimal modifier behind golden test).
- OQ-3: surface a "Padu Pakshi day" indicator in UI now? Default NO (keeps RT N/A); backlog if wanted.
