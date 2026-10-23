# Adhikara / Padu-Pakshi Activation — Tasks

> Executor: Antigravity (`/spec-run adhikara-padu-activation`). Branch: `fix/adhikara-padu-activation`.
> Regression-first: pin the invariants BEFORE the behavioural change, so activation is proven safe.

## T0 — Seam re-read (no code)
- [ ] Re-read `OracleCompositeEngine.evaluate` step-4 block, the floor-lock early-return in
      `IntegratedArudamEngine.evaluate`, and the `effectiveBirthBird ?? birthBird` resolution on both
      `prasanam_screen.dart` and `arudam_now_card.dart`. Confirm design.md §1–§2 against live code; flag
      any drift before writing.

## T1 — Pin the safety invariants FIRST (tests that currently pass, must keep passing)
- [ ] **T1a — Null-bird no-op** (R1.2 / R2.2): a test asserting that `evaluate` with `bird: null` (and the
      Home card with null birth bird) returns the SAME score/band as today. This is the regression oracle.
- [ ] **T1b — Floor-lock over boost** (R3): a test asserting an Adhikara day inside a Rahu/Emakandam window
      stays `isFloorLocked: true`, `band: sunya`, score 10 — the ×1.15 does NOT lift it.
- [ ] **T1c — Sequence firewall** (R4): confirm the #304 28-instance SHA-256 regression test
      (`pakshi_sequence_regression_test.dart`) still passes and `pakshi_calculator.dart` diff is empty.

## T2 — Extract the shared derivation helper
- [ ] Add pure `PakshiAdhikara.multiplierFor({bird, weekday, queryTime, sunrise, sunset}) -> double`
      wrapping the existing paksha/isNight + `statusFor` + `scoreModifier` logic. Unit-test it directly
      (Adhikara→1.15, Padu→0.5, normal→1.0, null-bird path handled by caller).
- [ ] Replace the inline block in `OracleCompositeEngine.evaluate` step 4 with a call to it —
      **behaviour-preserving** (T1a must still pass unchanged).

## T3 — Activate Prasanam (R1)
- [ ] Pass `bird: effectiveBirthBird ?? birthBird` to `OracleCompositeEngine.evaluate` in
      `prasanam_screen.dart`. Null bird → omit/`null` (T1a covers it).

## T4 — Activate Home "now" card (R2, chosen path 2b)
- [ ] In `arudam_now_card.dart`, compute `adhikaraMultiplier` via `PakshiAdhikara.multiplierFor(...)` with
      `data.effectiveBirthBird ?? data.birthBird` and the card's existing time/sunrise/sunset, and pass it
      to the direct `IntegratedArudamEngine.evaluate` call.
- [ ] **T4-check — two surfaces agree** (R2.1): a test feeding identical (bird, weekday, paksha, day/night)
      to both the Prasanam composite path and the Home direct path, asserting an identical multiplier.

## T5 — Characterise the score shift (R5)
- [ ] Golden test over a fixed suite: Adhikara day (×1.15), Padu day (×0.5), normal day (×1.0 unchanged),
      floor-locked window on an Adhikara day (still 10). Record before/after; make the shift explicit.
- [ ] Regenerate/update the #304 goldens where a caller now passes `bird:`; the diff must be visible in the PR.

## TV — Verification (Executor self-check before PR)
- [ ] `just validate-local` green on all 4 gates (analyze --fatal-infos, test, coverage ≥ 19%, build web),
      except the 4 known CloudKit macOS failures. Coverage must not drop below threshold.

## TR — Regression statement (RQ)
- [ ] REPORT states explicitly: null-bird users, floor-locked windows, and all normal days are
      byte-identical to pre-activation; only Adhikara (×1.15) and Padu (×0.5) days shift.

## TC — CONF provenance (RC)
- [ ] REPORT cites CONF-PP-007 + Kottumozhi pp14/17/18/22 for the day-block tables, and carries the
      Owl-basis caveat (no external ground truth for the rendered bird; claim is fidelity to the day tables).

## TT — Tamil (RT)
- [ ] If no new user-facing string is surfaced, REPORT declares RT **N/A** with that reason. If a badge/label
      is added, it is EN + pure Tamil script.

## TG — Governance lockstep
- [ ] CHANGELOG `[Unreleased]` entry (`adhikara-padu-activation`) + SPRINT_TRACKER row.

## TP — Open the PR + emit Human Verification Plan, then STOP
- [ ] Open `fix/adhikara-padu-activation` → `main`; emit the verification plan; STOP. Never merge.
