<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/golden-fixture-gate/requirements.md
  Authored by the Operator; merged to main via /plan-done (merge-first) BEFORE /spec-run.
  Last verified: 2026-10-03 (v1.13.0-web).
-->
# Golden-Fixture Correctness Gate — Requirements

| Property | Value |
| :--- | :--- |
| **Spec ID** | `golden-fixture-gate` |
| **Feature** | A frozen fixture of known-correct astro-engine outputs that CI reconciles against **exactly**, failing closed on any drift — the executable, path-independent correctness gate for the calculation layer. |
| **Backlog** | `TSK-golden-01` (Quality, CI & E2E epic — `BACKLOG.md`) |
| **Status** | 🟡 Proposed (authored on Kiro Crew / Operator; executed by Antigravity / Executor) |
| **CONF** | References the already-resolved Sara Kalai (26/26) + Panja Pakshi (6/6) CONFs — this Spec adds **no** new doctrine, it pins the EXISTING resolved behavior. |
| **Enables** | Trustworthy agent-written changes to the engine (ReqProof verification-first); safe refactors of `astro_engine`. |
| **Executor** | Antigravity (`/spec-run golden-fixture-gate`) |

---

## 1. Introduction
Saranidhi's value is calculation correctness (Jean Meeus Moon longitude + Lahiri ayanamsa →
nakshatra → birth-bird; the swara clock; Hora/Tattva; the Oracle composite). Today CI proves
only that code *runs* and that coverage ≥ 19% — not that the **outputs are right** (the
"100% coverage, weak tests" trap). This Spec adds a **golden-fixture reconcile**: a committed
dataset of inputs → known-correct outputs that a test replays and asserts **exactly** (within a
declared tolerance for floating-point longitude). It is a *path-independent acceptance rule* —
it holds regardless of how the engine is implemented, and a drifted value **fails closed** (the
implementing agent cannot explain it away). This is a **regression lock on already-shipped,
CONF-resolved behavior**, not a new calculation.

## 0. Preconditions (preflight — T0)
- **P1 — Surface:** Executor (Antigravity); local Flutter toolchain runs `just validate-local`.
- **P2 — Toolchain:** `flutter 3.47.5`, Dart SDK, Chrome. `just env-doctor` green.
- **P3 — Branch:** `sprint/golden-fixture-gate` off up-to-date `main`; clean tree; not `main`/`prod`.
- **P4 — Merge-first:** this Spec on `main` before `/spec-run` (via `/plan-done`).
- **P5 — Baseline green:** `just validate-local` green except the 4 known CloudKit macOS failures.

## 2. Current-state facts (of record — verified 2026-10-03)
- Pure-Dart engines in `lib/features/astro_engine/domain/`: `moon_longitude_calculator.dart`
  (`MoonLongitudeCalculator.calculate(DateTime)→MoonLongitudeResult{longitude}`),
  `lahiri_ayanamsa.dart`, `nakshatra_calculator.dart`
  (`NakshatraCalculator.calculate(DateTime)→NakshatraResult{standardName,…}`),
  `pakshi_calculator.dart` (birth-bird), `swara_clock.dart` (`SwaraClock.blockAt(...)→SwaraBlock{flow}`),
  `hora_calculator.dart`, `tattva_calculator.dart`, `oracle_engine.dart`
  (`OracleCompositeEngine.evaluate(...)→PrasanamResult{score,…}`).
- Per-engine unit tests already exist under `test/features/astro_engine/`. **This Spec adds a
  reconcile ON TOP — it does not replace them.**
- The engines are **pure + deterministic** (zero network) — so a fixed input has one correct output.

## 3. Requirements (EARS acceptance criteria = Definition of Done)

### R1 — The golden fixture dataset
- **R1.1** The system SHALL add a committed, human-readable fixture at
  `test/golden/astro_golden.json` (+ a short `test/golden/README.md` explaining provenance and
  how to regenerate), holding N ≥ 20 cases spanning: multiple DOBs across the year (nakshatra +
  birth-bird), both pakshas × multiple weekdays × times (swara block flow), several Hora/Tattva
  moments, and several Oracle inputs (category × recorded swara → score band).
- **R1.2** Each case SHALL record the **input** (ISO datetime, lat/lng, paksha, etc.) and the
  **expected output** of the real engine API, plus a `source` note (which CONF / corpus practice
  the expected value traces to, where doctrinal).
- **R1.3** Longitude/continuous outputs SHALL carry an explicit **tolerance** (e.g. `±1e-6°`
  for Moon longitude); discrete outputs (nakshatra name, bird, flow, band) SHALL match **exactly**.

### R2 — The reconcile test (fail-closed)
- **R2.1** The system SHALL add `test/golden/golden_fixture_test.dart` that loads the fixture and,
  for every case, calls the **real** engine API (§2) and asserts output == expected (within R1.3
  tolerance). A mismatch SHALL **fail** the test with a message naming the case id, expected, and actual.
- **R2.2** A **missing** expected field, an **unparseable** fixture, or a case the engine cannot
  evaluate SHALL fail the test — never silently skip (a missing result stays missing).
- **R2.3** The test SHALL NOT reach the network, DB, or wall-clock `DateTime.now()` — inputs come
  only from the fixture (determinism).

### R3 — CI wiring (the gate)
- **R3.1** The reconcile SHALL run in **Tier-1 CI** (`ci.yml`, every PR) as part of the
  domain/provider test job, so a drift blocks the PR — not only on merge.
- **R3.2** The gate SHALL be **blocking** (not `continue-on-error`).
- **R3.3** `just validate-local` SHALL include the golden reconcile so the Executor sees drift locally BEFORE the PR.

### R4 — Regeneration discipline (controlled, not automatic)
- **R4.1** A documented, **manually-run** regeneration path SHALL exist (e.g.
  `dart run tool/regen_golden.dart`) that rewrites expected values from the current engine.
- **R4.2** Regeneration SHALL NOT run in CI and SHALL NOT be automatic — changing a golden value
  is a **human decision** recorded in the PR (and, when doctrinal, the Decision Journal + CONF),
  so the implementing agent cannot "fix" a drift by regenerating the truth. *(This is the article's
  core rule: the impl agent must not control its own acceptance values.)*

<!-- ───────── STANDING CRITERIA ───────── -->
### RT — Tamil bilingual gate (STANDING)
- **RT.1** This Spec adds no user-facing strings (test/CI only). IF any surface string is touched, it SHALL be EN + pure Tamil via l10n. (Expected: N/A — note it explicitly in the PR.)

### RC — CONF provenance (STANDING)
- **RC.1** Each doctrinal golden value SHALL cite the resolved `CONF-nn`/`CONF-PP-nn` it encodes (R1.2 `source`). No NEW doctrine is introduced; conflicts, if any surface, are raised — not resolved here.

### RQ — Quality gates / no regression (STANDING)
- **RQ.1** `just validate-local` green (analyze `--fatal-infos`, test, build web) — now including the golden reconcile.
- **RQ.2** Coverage SHALL NOT drop below 19%; existing `test/features/astro_engine/` tests SHALL remain green and UNCHANGED in behavior.
- **RQ.3** No engine `lib/` logic SHALL be modified by this Spec — it only ADDS fixtures/tests/CI/tooling. IF the reconcile surfaces a real bug in an engine, that is **out of scope**: raise it (R4.2 / §4), do not fix it here.

## 4. Out of scope (scope honesty)
- **Fixing** any calculation bug the reconcile reveals → a separate `fix/*` Spec (this Spec only LOCKS current behavior; a revealed bug is a finding, flagged to the owner).
- AST/architecture-boundary fitness tests (the other adoption item) → a later Spec.
- E2E/UI verification → the `saranidhi-e2e` repo.

## 4b. Human Verification Plan
- **V1 — gate catches drift:** temporarily perturb one engine constant locally → the reconcile FAILS naming the case; revert → green. (Proves fail-closed, R2.1.)
- **V2 — CI blocking:** the reconcile appears in Tier-1 CI on the PR and is a required, blocking check (R3.1/R3.2).
- **V3 — no silent skip:** a deliberately malformed fixture entry FAILS the test (R2.2).
- **VQ — gates:** `just validate-local` green incl. the reconcile; coverage ≥ 19%; existing astro tests unchanged (RQ).

## 4c. Evidence summary (the 4 questions — tag each with build/config)
- **What am I accepting?** a frozen correctness gate over the astro engines (R1–R4), no engine logic changed.
- **What could it affect?** CI timing (one more test job step) + `validate-local`; nothing user-facing, no `lib/` behavior.
- **Why believe it works?** V1 (perturb→fail→revert→green) + V2 (blocking in CI) + V3 (malformed→fail), each on the PR head commit/preview.
- **What remains unresolved?** any engine bug the reconcile surfaces (flagged, out of scope); the tolerance value for longitude (confirm with the owner if a case sits near a nakshatra boundary).
