<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/golden-fixture-gate-v2/tasks.md
  Last verified: 2026-10-22 (v1.13.0-web).
-->
# Golden-Fixture Gate Hardening (v2) — Tasks (`/spec-run` build plan)

## Execution header
- **Kickoff:** `/spec-run golden-fixture-gate-v2`
- **Surface:** Executor (Antigravity) + local `just validate-local`
- **Branch to create:** `sprint/golden-fixture-gate-v2` (off up-to-date `main`)
- **EARS target (DoD):** `requirements.md` §3 R1–R4 + RT/RC/RQ; verify §4b V1–V5, VQ; evidence §4c
- **Merge-first:** this Spec on `main` before kickoff (via `/plan-done`)

> Executor runs these in order, self-validates against the EARS DoD, opens a PR, emits the Human
> Verification Plan, STOPs. **Never merges, never tags. Never modifies `lib/` engine logic (R4.2).**
> **A failing independent-truth case is a REVEALED BUG → STOP and flag it, do NOT make it pass (R4.1).**

- [ ] **T0 — Preflight (gate — STOP on any ❌)**
  - P1–P5: on `sprint/golden-fixture-gate-v2` off clean `main`; `just env-doctor` green; baseline `just validate-local` green except the 4 CloudKit macOS failures.
  - **Read the real engine source** before wiring (the code is the truth): `moon_longitude_calculator.dart` (OQ-1: apparent vs geometric longitude — what quantity does it return?), `oracle_engine.dart` (OQ-3: `evaluate(...)` params to drive Emakandam-active + recorded sushumna), `yama_calculator.dart:150-178` (`calculateNight`/`NightYamaResult`), `swara_clock.dart:140-176` (`anchorSunrise`), `golden_fixture_test.dart` (assert-helper shapes; confirm no hard case-count assertion beyond the `≥20` integrity floor).
  - **Confirm the CONF star table is readable in-repo** (OQ-2, under `docs/research/`) so nakshatra→bird literals are transcribed from a committed, reviewer-checkable source.
  - If OQ-1 is ambiguous (engine returns a quantity Meeus 47.a does not print directly) → **STOP and ask the owner** before authoring the Moon independent case.

- [ ] **T1 — Independent-truth fixture (R1 — the headline)**
  - Create `test/golden/astro_independent.json` (format: `design.md` §2) with N ≥ 6 cases whose `expected` is **transcribed from an external source, NOT engine output**, each carrying a mandatory `groundTruth` string.
  - Include: (a) Meeus Example 47.a Moon longitude transcribed from the book (tolerance `1e-5`, matching the engine's actual comparand per T0/OQ-1); (b) ≥ 4 nakshatra→bird rows read straight from the CONF 5-6-5-5-6 table — **peacock MUST appear**, aim for ≥ 1 row per bird, each DOB mid-nakshatra (unambiguous).
  - For every doctrinal case, cite the resolved `CONF-PP-nn`/`CONF-nn` in `groundTruth` (RC.1).

- [ ] **T2 — Extend the reconcile test for the independent set (R1, R3)**
  - In `test/golden/golden_fixture_test.dart`: load `astro_independent.json` alongside `astro_golden.json`; add `group('independent-truth', …)` reusing the EXISTING per-case assert helpers (exact / within-tolerance). Fail-closed on a missing `groundTruth` or expected field (R1.2/R3.1). The independent group runs even if the snapshot block is empty (R3.3). No `DateTime.now()`/DB/network (R3.2).

- [ ] **T3 — Regen-guard (R1.4)**
  - Extend `tool/regen_golden.dart` so it NEVER touches `astro_independent.json` (it only ever opens `astro_golden.json`). Add the header comment from `design.md` §5 stating why the independent block is never regenerated. Running the tool must leave `astro_independent.json` byte-identical (V3).

- [ ] **T4 — Coverage cases for the unpinned branches (R2)**
  - APPEND to `test/golden/astro_golden.json` (never alter the 37 v1 cases — RQ.3), per the `design.md` §3 table:
    - R2.1 night yama (Y6–Y10) tattva reconcile · R2.2 tattva in yama2–yama5 · R2.3 Oracle sushumna in Yoga window (aligned) + outside (not) · R2.4 Oracle Emakandam-active · R2.5 peacock ≥2× + one longitude→nakshatra→bird end-to-end · R2.6 all 7 hora day-lords + 1 day→night boundary · R2.7 pre-dawn swara (anchorSunrise) + late-day alt-block flip.
  - Expected values for these coverage cases are engine snapshots (the v1 pattern) — they pin "this branch runs + is drift-locked"; the correctness proof is T1's independent set.

- [ ] **T5 — CI + validate-local (R2.1/R3 of v1 — confirm only, no re-wire)**
  - Confirm Tier-1 `ci.yml` runs the `test/golden/` directory (picks up the new fixture + cases with no path change) and `just validate-local` covers it. Adjust ONLY if a path is hard-enumerated.

- [ ] **TG — Governance lockstep**
  - `CHANGELOG.md [Unreleased]` entry for `TSK-golden-02`; `SPRINT_TRACKER.md` → 👀 In Review. STATUS.md untouched (that's `/sprint-update`).

- [ ] **TQ — Quality gates + no-regression (RQ)**
  - `just validate-local` green incl. the expanded reconcile; coverage ≥ 19%; the **37 v1 golden cases unchanged + green** (RQ.3); `test/features/astro_engine/` unchanged + green. **No `lib/` engine edit.**
  - **If an independent-truth case fails (R4.1): STOP.** Record the case, its external source, expected vs actual; flag to the owner as a separate `fix/*` finding. Do NOT regenerate, loosen tolerance, delete the case, or edit `lib/` to pass.

- [ ] **TP — Commit, open PR, emit Human Verification Plan, STOP**
  - `test(astro): golden-fixture gate hardening — independent truth + branch coverage (TSK-golden-02)`; push `sprint/golden-fixture-gate-v2`; `gh pr create --base main`. CI green. Emit §4b (V1 independent≠snapshot, V2 perturb→ground-truth-fail→revert, V3 regen leaves independent untouched, V4 new branches present, V5 malformed→fail). List every independent literal + its source in the PR body (RC.1). STOP. **Never merge/tag.**

- [ ] **TV — After human verification: `/verification-done`**
  - Record §4b results + the §4c 4-question evidence summary in `REPORT.md` (same PR). On pass → `/review-pr` → owner merges.
