<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/golden-fixture-gate/tasks.md
  Last verified: 2026-10-03 (v1.13.0-web).
-->
# Golden-Fixture Correctness Gate — Tasks (`/spec-run` build plan)

## Execution header
- **Kickoff:** `/spec-run golden-fixture-gate`
- **Surface:** Executor (Antigravity) + local `just validate-local`
- **Branch to create:** `sprint/golden-fixture-gate` (off up-to-date `main`)
- **EARS target (DoD):** `requirements.md` §3 R1–R4 + RT/RC/RQ; verify §4b V1–V3, VQ; evidence §4c
- **Merge-first:** this Spec on `main` before kickoff (via `/plan-done`)

> Executor runs these in order, self-validates against the EARS DoD, opens a PR, emits the Human
> Verification Plan, STOPs. **Never merges, never tags. Never modifies `lib/` engine logic (RQ.3).**

- [x] **T0 — Preflight (gate — STOP on any ❌)**
  - P1–P5: on `sprint/golden-fixture-gate` off clean `main`; `just env-doctor` green; baseline `just validate-local` green except the 4 CloudKit macOS failures.
  - **Read the real engine source** (`lib/features/astro_engine/domain/*.dart`) and confirm the constructor/param shapes in `design.md` §3 against the current code before wiring (the code is the truth).

- [x] **T1 — Author the fixture (R1)**
  - Create `test/golden/astro_golden.json` (format: `design.md` §2) with ≥ 20 cases across nakshatra+bird, swara (both pakshas × weekdays × times), moonLongitude, hora, tattva, oracle. Each: `input`, `expected`, `tolerance` (continuous), `source` (CONF where doctrinal).
  - **Expected values must be known-correct**: compute from the current engine (that is the behavior we lock), and for doctrinal cases cross-check the cited CONF. Add `test/golden/README.md` (provenance + regen).

- [x] **T2 — The reconcile test (R2)**
  - `test/golden/golden_fixture_test.dart`: load+parse (fail on bad parse), `group` per section, one `test` per case id, call the real engine, assert exact/within-tolerance. Fail-closed on missing field / unevaluable case (R2.2). No `DateTime.now()`/DB/network (R2.3).

- [x] **T3 — Regen tool (R4)**
  - `tool/regen_golden.dart` — recompute all `expected` from current engines, rewrite the JSON. Header comment: manual only, never CI; changing a golden value is a human decision (PR + Decision Journal/CONF if doctrinal).

- [x] **T4 — CI + validate-local wiring (R3)**
  - Confirm Tier-1 `ci.yml`'s `flutter test` includes `test/golden/` (adjust if it path-enumerates). Blocking, no `continue-on-error`. Confirm `just validate-local` covers it.

- [x] **TG — Governance lockstep**
  - `CHANGELOG.md [Unreleased]` entry for `TSK-golden-01`; `SPRINT_TRACKER.md` → 👀 In Review. STATUS.md untouched (that's `/sprint-update`).

- [x] **TQ — Quality gates + no-regression (RQ)**
  - `just validate-local` green incl. the reconcile; coverage ≥ 19%; `test/features/astro_engine/` unchanged + green. **No `lib/` engine edit** — if the reconcile reveals a bug, STOP and flag it (out of scope, §4), do not fix.

- [ ] **TP — Commit, open PR, emit Human Verification Plan, STOP**
  - `feat(astro): golden-fixture correctness gate (TSK-golden-01)`; push `sprint/golden-fixture-gate`; `gh pr create --base main`. CI green. Emit §4b (V1 perturb→fail→revert, V2 blocking, V3 malformed→fail). STOP. **Never merge/tag.**

- [ ] **TV — After human verification: `/verification-done`**
  - Record §4b results + the §4c 4-question evidence summary in `REPORT.md` (same PR). On pass → `/review-pr` → owner merges.
