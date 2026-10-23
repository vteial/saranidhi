# Pakshi Scoring — Corpus Alignment (bird-state weights + Adhikara/Padu semantics) — Requirements

> **Class:** sprint deliverable, **correctness-critical** (changes shipped Oracle/Aruḍam scoring that users see).
> **Provenance:** grounded in the primary Tamil source *"பஞ்ச பட்சி ஆருடம்"* (Kottumozhi Sathya),
> reviewed 2026-10-23 → **CONF-PP-007** sub-note in `docs/research/panja-pakshi-workshop-knowledge.md`.
> **Scope boundary (hard):** this Spec DOES NOT touch the per-yama state **sequence tables**
> (`_brightGroupA..`, `_*NightGroup*` in `pakshi_calculator.dart`). Those remain **unresolved** under
> CONF-PP-007 pending a full per-yama primary source. This Spec only aligns the **scoring semantics**
> of the 5 states and (optionally) encodes the Adhikara/Padu-day rule the corpus DOES confirm.

## Problem

The shipped base bird-state score (`IntegratedArudamEngine.getBaseBirdScore`) is:

| State | Shipped score | Corpus (Kottumozhi p12) |
|---|---|---|
| Ruling (Arasu) | 100 | **100% success** |
| Eating (Oon) | 80 | **80% success** |
| Walking (Nadai) | 60 | **40% — *mixed / dragging*** |
| Sleeping (Thuyil) | 30 | **80% *failure*** |
| Dying (Saavu) | 10 | **90% *failure*** |

Two corpus-grounded discrepancies:
1. **Walking** is scored as moderately-favourable (60) but the corpus calls it **40% mixed** (`இழுபறி` — dragging, partial).
2. **Sleeping / Dying** are scored as merely low-positive (30 / 10) but the corpus calls them **active failure**
   states (80% / 90% failure) — qualitatively adverse, not just weak.

## EARS Definition of Done

**R1 — Base state scores reflect corpus success/failure semantics.**
R1.1 WHEN `getBaseBirdScore` is called THEN it SHALL return values whose ordering and *sign of favourability*
match the corpus: Ruling ≫ Eating ≫ (Walking = neutral/mixed midpoint) > Sleeping > Dying, with Sleeping/Dying
positioned as adverse (failure-weighted), not merely low-positive.
R1.2 The chosen numeric scale SHALL be documented in the file with a comment citing CONF-PP-007 / Kottumozhi p12
and the exact source percentages (100 / 80 / 40-mixed / 80-fail / 90-fail).
R1.3 The mapping SHALL remain a pure function of `PakshiState` (no new inputs).

**R2 — Adhikara (ruling-power) and Padu-Pakshi (downtime) day rules are encoded as a NAMED, tested helper.**
R2.1 A new pure helper SHALL expose, for a given `(bird, weekday, paksha)`, whether the bird is in its
**Adhikara** (full-strength) day/night block or a **Padu** (full-downtime) day, per the corpus tables
(Kottumozhi pp14/22; Cock Shukla-adhikara = Mon-night/Wed-night/Fri-day, etc. — transcribe the full table into the Spec's design.md).
R2.2 The helper SHALL be data-driven (a const table), not scattered conditionals.
R2.3 Whether/how this helper feeds the composite score is decided in design.md; at minimum it SHALL be
AVAILABLE and unit-tested. (A Padu-Pakshi day is a strong negative signal; Adhikara a strong positive.)

**R3 — No change to the per-yama state sequence (the unresolved layer).**
R3.1 `pakshi_calculator.dart` state **tables** (`_*Group*`) SHALL be byte-unchanged (`git diff` empty for those).
R3.2 The bird assigned to each yama, and its state, SHALL be IDENTICAL before/after for all inputs
(pinned by a regression test over a representative week).

**R4 — Scoring regression is characterised and intentional.**
R4.1 A golden test SHALL record the Oracle/Aruḍam composite score for a fixed set of (date, bird, state, category)
inputs BEFORE and assert the AFTER values, so the score shift is explicit and reviewable (not silent).
R4.2 The daytime-vs-nighttime inauspicious floor-lock behaviour (Rahu/Emakandam) SHALL be UNCHANGED.

**RT — Tamil bilingual (standing).** Any new user-facing string (e.g. a "Padu Pakshi day" badge, if surfaced)
SHALL be EN + pure Tamil script. If nothing is surfaced to the UI this Spec, RT is N/A and SHALL say so.

**RC — CONF provenance (standing).** Every weight/rule changed SHALL cite CONF-PP-007 and the Kottumozhi page.
The owner's CONF-PP-007 lineage decision is source-truth.

**RQ — Regression gate (standing).** Day-time Oracle verdicts whose state is Ruling/Eating SHALL keep the same
favourable classification; only the Walking/Sleeping/Dying weighting shifts. State explicitly what stays unchanged.

## Out of scope (flag, don't fold)
- The per-yama **sequence** rewrite (CONF-PP-007 unresolved — awaiting the research hunt for a full primary grid).
- The `_brightNightGroupD` Y7/Y10 question (subsumed into the unresolved sequence layer).
- Adopting Align27/Drik as canonical (owner decision, separate).
