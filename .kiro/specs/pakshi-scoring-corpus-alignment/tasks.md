# Pakshi Scoring — Corpus Alignment — Tasks (/spec-run build plan)

> Executor: Antigravity. Branch `fix/pakshi-scoring-corpus-alignment` from latest `main`.
> Local suite GREEN (except the 4 known CloudKit macOS failures) BEFORE the PR. Does NOT touch `_*Group*` tables.

- **T0 — Seam read + source re-transcribe.** Read `integrated_arudam_engine.dart:getBaseBirdScore`,
  `oracle_engine.dart:evaluate`, `action_window.dart`. Re-transcribe the Adhikara + Padu tables from the
  CONF-PP-007 source page images (`~/.kiro/crew/uploads/9eaaca78c78a4274a6a1dba0cc69d73c_panja_pakashi_aarudan.pdf`,
  pp14/18/22) and CONFIRM or correct design.md's grids. Flag any discrepancy before coding.

- **T1 — Pin the sequence regression FIRST (R3).** Add `pakshi_sequence_regression_test.dart` asserting the
  bird + state for all 10 yamas across a representative week (both pakshas) BEFORE any change. Must stay green
  throughout — it proves the sequence layer is untouched.

- **T2 — Rescale base scores (R1).** Update `getBaseBirdScore` per D1 (ordinal + failure-sign constraint).
  Add the doc comment citing CONF-PP-007 / Kottumozhi p12 with the source percentages.

- **T3 — Golden before/after (R4).** Add `oracle_scoring_golden_test.dart` capturing composite scores for a
  fixed input set; record pre-change values in a comment, assert post-change values. Confirm Rahu/Emakandam
  floor-lock unchanged (R4.2).

- **T4 — `PakshiAdhikara` helper (R2).** New `pakshi_adhikara.dart` with the two const tables + `statusFor`.
  Unit-test every (bird × weekday × paksha × day/night) Adhikara/Padu cell against the transcribed table.

- **T5 — Wiring per OQ-2 (R2.3/D3).** Default: apply the Padu/Adhikara modifier in `evaluate` behind the golden
  test. If owner chose helper-only, skip wiring and note it. Either way the helper is exported + tested.

- **TV — Validate.** `just validate-local` green (except known 4). Coverage ≥ 19%. Integration gate green.

- **TR — Regression statement.** In the REPORT, state explicitly: per-yama sequence UNCHANGED (T1 green);
  only Walking/Sleeping/Dying weighting shifted; Ruling/Eating classification preserved (RQ).

- **TC — Provenance.** REPORT cites CONF-PP-007 + Kottumozhi pages for every weight/rule (RC).

- **TL — Tamil.** If a Padu/Adhikara indicator is surfaced (OQ-3), EN + pure Tamil. Else state RT N/A (RT).

- **TG — Lockstep.** CHANGELOG [Unreleased] entry; tracker row at 👀 In Review.

- **TP — PR + STOP.** Open `fix/pakshi-scoring-corpus-alignment → main`, emit Human Verification Plan, STOP.
  Do NOT merge. Do NOT touch the per-yama sequence tables (CONF-PP-007 unresolved).
