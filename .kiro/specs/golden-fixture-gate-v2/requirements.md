<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/golden-fixture-gate-v2/requirements.md
  Authored by the Operator; merged to main via /plan-done (merge-first) BEFORE /spec-run.
  Last verified: 2026-10-22 (v1.13.0-web).
-->
# Golden-Fixture Gate Hardening (v2) — Requirements

| Property | Value |
| :--- | :--- |
| **Spec ID** | `golden-fixture-gate-v2` |
| **Feature** | Harden the existing golden-fixture reconcile so it is a **correctness proof**, not only a self-referential snapshot: introduce independent ground-truth cases that break the engine-regenerates-its-own-expectations loop, and pin the engine branches the v1 gate leaves uncovered (night yamas Y6–Y10, Sushumna/Yoga Oracle alignment, Emakandam lockout, tattva beyond `yama1`, broader bird/hora/swara coverage). |
| **Backlog** | `TSK-golden-02` (Quality, CI & E2E epic — `BACKLOG.md`); follows `TSK-golden-01` (v1 gate, shipped). |
| **Status** | 🟡 Proposed (authored on Kiro Crew / Operator; executed by Antigravity / Executor) |
| **CONF** | References the already-resolved Sara Kalai (26/26) + Panja Pakshi (6/6) CONFs — this Spec adds **no** new doctrine. It transcribes EXISTING resolved values (Meeus 47.a, the canonical 5-6-5-5-6 star table) into independent literals; it does not resolve or invent any. |
| **Enables** | A gate that can catch a latent bug already baked into `v1.13.0` — not just future drift — turning agent-written engine changes from "it still matches yesterday" into "it still matches the corpus." |
| **Provenance** | Scoped from `.kiro/reports/golden-fixture-gate-investigation.md` (Kiro Workflows Step-1 investigation, merged #288) — §4 gap list + §5 PROPOSALS are this Spec's source. |
| **Executor** | Antigravity (`/spec-run golden-fixture-gate-v2`) |

---

## 1. Introduction
The v1 golden-fixture gate (`TSK-golden-01`, shipped) is wired correctly as a blocking Tier-1
check, but the investigation report's central finding is a **provenance weakness**: every one of
the 37 `expected` values in `test/golden/astro_golden.json` was produced by calling the very
engine the gate polices (`tool/regen_golden.dart`), with `source` strings that *claim* lineage
(Meeus, CONF) but do not *demonstrate* it. The gate therefore catches future drift (valuable) but
would freeze a bug already present at `v1.13.0` as "correct" — it is a snapshot, not a proof. This
is the exact CONF/RC concern. Secondarily, several engine branches are entirely unpinned (night
yamas Y6–Y10, Sushumna/Yoga Oracle alignment, Emakandam lockout, tattva outside `yama1`). This
Spec hardens the gate by (a) committing a small set of **independent ground-truth** cases whose
expected values are transcribed from a published source or read straight from the CONF corpus —
asserted against the engine so a baked-in bug fails closed — and (b) adding cases for the unpinned
branches. It remains a **test/fixture/tooling-only** change: **no `lib/` engine logic is modified.**

## 0. Preconditions (preflight — verify BEFORE any change; enforced by tasks.md T0)
- **P1 — Surface:** Executor (Antigravity on the owner's Mac); local Flutter toolchain able to run `just validate-local`.
- **P2 — Toolchain:** `flutter 3.47.5` (Homebrew cask), Dart SDK, Chrome (web build). `just env-doctor` green.
- **P3 — Branch:** `sprint/golden-fixture-gate-v2` off up-to-date `main`; clean tree; not `main`/`prod`.
- **P4 — Merge-first:** this Spec merged to `main` before `/spec-run` (satisfied by `/plan-done`).
- **P5 — Baseline green:** `just validate-local` — analyze `--fatal-infos` + test + build web GREEN (the "green except the 4 known CloudKit macOS failures" baseline).

## 2. Current-state facts (of record — verified 2026-10-22, cross-checked against the investigation report)
- v1 gate: one reconcile test `test/golden/golden_fixture_test.dart` (6 sections + integrity guard) replays `test/golden/astro_golden.json` (37 cases) against the real pure-Dart engines in `lib/features/astro_engine/domain/`. Blocking in Tier-1 CI (`.github/workflows/ci.yml:38-47`, no `continue-on-error`) and in `just validate-local` (`scripts/validate-local.sh:35`).
- **Provenance:** every `expected` is engine output captured by `tool/regen_golden.dart` (Moon `:62-72`, nakshatra/bird `:135-150`, and the same pattern per section). `astro_golden.json:5` `meta.note` says so plainly. `source`/CONF strings are hand-written annotations, NOT independently-derived literals (report §3).
- **Unpinned branches (report §2, §4):**
  - Night yamas Y6–Y10: `YamaCalculator.calculateNight` (`yama_calculator.dart:150-178`) — zero golden cases; tattva reconcile only calls the daytime path (`golden_fixture_test.dart:338-341`).
  - Tattva: all 5 cases share one date and all land in `yama1` (`astro_golden.json:364-436`) — yama2–yama5 unverified.
  - Oracle Sushumna/Yoga: `_resolveAlignment`'s `BreathFlow.sushumna → isSushumnaAligned` branch (`oracle_engine.dart:116-118`, aligned only in Yoga window per `action_window.dart:58`) — every oracle case passes solar/lunar (`astro_golden.json:446`+), never sushumna.
  - Oracle Emakandam: `isEmakandamActive` (`oracle_engine.dart:71`) — only Rahu Kaal floor-lock is pinned (oracle-05).
  - Birth-bird: 8/27 nakshatras, 4/5 birds; peacock asserted once (nak-03); no longitude→nakshatra→bird end-to-end reconcile.
  - Hora: ~2/7 day-lords and a thin slice of the 24-hora Chaldean cycle; no day→night boundary hora.
  - Swara: no pre-dawn case for `SwaraClock.anchorSunrise` (`swara_clock.dart:140-176`); late-day alternating-block flip lightly covered.
- The engines are **pure + deterministic** (zero network) — a fixed input has exactly one correct output, so an independent literal is a hard assertion.
- `tool/regen_golden.dart` exists and rewrites `expected` from the current engine (R4 discipline of v1 remains in force).

## 3. Requirements (EARS acceptance criteria = Definition of Done)

### R1 — Independent ground-truth cases (break the self-reference — the headline, RC concern)
- **R1.1** The system SHALL add a committed, human-readable **independent-truth** fixture block — distinct from the engine-regenerated cases — at `test/golden/astro_independent.json` (or a clearly-marked `independent` section inside the existing fixture), holding N ≥ 6 cases whose `expected` value is **transcribed from an external/corpus source, NOT produced by the engine**.
- **R1.2** Each independent case SHALL record: the `input`, the `expected` literal, a mandatory `groundTruth` field naming the external source verbatim (e.g. `"Meeus, Astronomical Algorithms 2nd ed., Example 47.a, p.342"` or `"CONF-PP-001 star table, row: Ashwini→Vulture"`), and — for a doctrinal value — the resolved `CONF-nn`/`CONF-PP-nn` id.
- **R1.3** The independent set SHALL include at minimum: (a) the **Meeus Example 47.a Moon longitude** transcribed from the published worked example (not the engine's current `133.16265468515903`), asserted within a declared tolerance; and (b) **≥ 4 nakshatra→bird rows read directly from the canonical 5-6-5-5-6 CONF star table**, chosen to cover birds the v1 fixture under-asserts (peacock MUST appear; aim for ≥ 1 row per bird across the independent set).
- **R1.4** The regeneration tool (`tool/regen_golden.dart`) SHALL **NOT** overwrite the independent-truth `expected` values — they are hand-authored literals, not engine snapshots. The tool SHALL skip or refuse the independent block, and its header SHALL state why (regenerating them would re-introduce the self-reference this Spec removes).

### R2 — Pin the unpinned engine branches (coverage)
- **R2.1 — Night schedule (Y6–Y10):** The system SHALL add golden cases exercising `YamaCalculator.calculateNight` (`yama_calculator.dart:150-178`), including at least one **tattva reconcile inside a night yama** (so the `NightYamaResult` → tattva path is pinned, not just the daytime path).
- **R2.2 — Tattva across yamas:** The system SHALL add tattva cases that land in **yama2–yama5** (not only `yama1`), so the 5-element cycle in later daylight yamas is reconciled.
- **R2.3 — Oracle Sushumna/Yoga alignment:** The system SHALL add ≥ 1 oracle case with `actualSwara`/recorded flow = **sushumna** inside the **Yoga action window**, pinning the `isSushumnaAligned` branch (`oracle_engine.dart:116-118`), and ≥ 1 sushumna case OUTSIDE the Yoga window to pin the not-aligned result.
- **R2.4 — Oracle Emakandam:** The system SHALL add ≥ 1 oracle case that triggers the **Emakandam lockout** (`oracle_engine.dart:71` `isEmakandamActive`), parallel to the existing Rahu Kaal floor-lock case.
- **R2.5 — Bird table breadth:** The system SHALL expand nakshatra→bird coverage so **every one of the 5 birds is asserted at least once** (peacock appearing more than once) and SHALL add **one longitude→nakshatra→bird end-to-end case** (a known datetime reconciled straight through to a bird).
- **R2.6 — Hora breadth:** The system SHALL add hora cases covering **all 7 weekday day-lords** and **≥ 1 day→night boundary hora** (the transition at `isDayHora` flip).
- **R2.7 — Swara rollover:** The system SHALL add **≥ 1 pre-dawn swara case** exercising `SwaraClock.anchorSunrise` (`swara_clock.dart:140-176`, the sunrise-to-sunrise civil-day rollover) and **≥ 1 late-day case** probing the alternating-block flip (`swara_clock.dart:118-129`).

### R3 — Fail-closed and determinism (inherited v1 discipline, re-asserted)
- **R3.1** Every new case SHALL be asserted by the reconcile test the same way v1 cases are: a mismatch SHALL **fail** naming the case id, expected, and actual; a missing expected field, an unparseable fixture, or an unevaluable case SHALL fail — never silently skip (R2.2 of v1).
- **R3.2** New cases SHALL NOT reach the network, DB, or wall-clock `DateTime.now()` — inputs come only from the fixture (determinism).
- **R3.3** Independent-truth cases (R1) SHALL be loaded and asserted even if the engine-regenerated block is empty — the two sets are independent inputs to the reconcile, and the independent set alone must constitute a runnable gate.

### R4 — Revealed-bug discipline (the whole point — a failing independent case is a FINDING, not a drift)
- **R4.1** IF an independent-truth case (R1) **fails** against the current engine, that is a **revealed correctness bug** in `lib/` — the Executor SHALL **STOP** and flag it to the owner as a separate `fix/*` finding (with the case, the independent source, expected vs actual). The Executor SHALL **NOT** "fix" it by regenerating the value, loosening the tolerance, deleting the case, or editing engine `lib/` logic to pass. *(This is the article's core rule applied to ground truth: the gate must be able to fail on a real bug, and the implementing agent must not control its own acceptance values.)*
- **R4.2** No engine `lib/` logic SHALL be modified by this Spec — it only ADDS fixtures/tests/tooling-guard. A revealed bug (R4.1) is **out of scope** here: raise it, do not fix it.

<!-- ───────────── STANDING CRITERIA — EVERY saranidhi Spec carries these ───────────── -->

### RT — Tamil bilingual gate (STANDING — non-negotiable; collaboration-guardrails §4)
- **RT.1** This Spec adds no user-facing strings (test/fixture/tooling only). IF any surface string is touched, it SHALL be EN + pure Tamil via the `l10n` ARB flow — never transliteration, never a hardcoded English literal. **Expected: N/A — note it explicitly in the PR.**
- **RT.2** No nakshatra-selection UI is touched; `NakshatraL10n.trilingualDisplay()` usage is unchanged. (Expected: N/A.)

### RC — CONF provenance (STANDING for doctrinal work; collaboration-guardrails §4)
- **RC.1** Each independent doctrinal value (R1.3 nakshatra→bird rows, and any CONF-derived expectation) SHALL cite in its `groundTruth` field the resolved `CONF-PP-nn`/`CONF-nn` row it transcribes, and the PR body SHALL list every independent literal with its source. **No new doctrine is introduced** — only EXISTING resolved values are transcribed.
- **RC.2** Where a transcribed value appears to conflict with the engine's output (R4.1), the owner's CONF-tracker lineage decision SHALL be treated as source truth and the conflict raised by id — **not resolved in this Spec**.

### RQ — Quality gates / no regression (STANDING)
- **RQ.1** `just validate-local` SHALL pass: `flutter analyze --fatal-infos` (zero issues), `flutter test` (green except the 4 known CloudKit macOS failures), `flutter build web` — now including the expanded reconcile.
- **RQ.2** Tier-2 coverage SHALL remain **≥ 19%** (`THRESHOLD=19`); the web integration gate (`flutter drive`) SHALL stay green (blocking as of Sprint 36).
- **RQ.3** The 37 EXISTING v1 golden cases SHALL remain green and UNCHANGED (this Spec is additive — it must not alter or delete a v1 case). The existing `test/features/astro_engine/` unit tests SHALL remain green and unchanged in behavior.

## 4. Out of scope (scope honesty)
- **Fixing** any engine bug an independent-truth case reveals (R4.1) → a separate `fix/*` Spec. This Spec only ADDS the proving cases; a revealed bug is a finding flagged to the owner.
- **Exhaustive** 27-nakshatra and full 24-hora/5×5-bird-state coverage → a later incremental Spec; this Spec closes the *named* gaps (R2) and establishes the independent-truth pattern (R1), not 100% branch coverage.
- AST/architecture-boundary fitness tests → a later Spec.
- E2E/UI verification → the `saranidhi-e2e` repo.
- Any change to the v1 fixture's existing 37 cases, the engine `lib/`, or CONF doctrine.

## 4b. Human Verification Plan (emitted by /spec-run; recorded by /verification-done)
- **V1 — independent truth proves, not snapshots:** the independent-truth cases (R1) assert against transcribed literals; confirm at least the Meeus 47.a case's expected value in the fixture is the **book's printed value**, not the engine's regenerated number. (Proves the self-reference is broken — R1.1/R1.3.)
- **V2 — gate catches a real bug:** temporarily perturb one engine constant locally → an independent-truth case FAILS naming the case + its external source (not just a drift message); revert → green. (Proves R4.1 fail-closed on ground truth.)
- **V3 — regen cannot launder the truth:** run `dart run tool/regen_golden.dart` → the independent block (R1) is **untouched**; only the engine-snapshot block is rewritten. (Proves R1.4.)
- **V4 — new branches pinned:** confirm the night-yama, tattva-yama2–5, Sushumna/Yoga, Emakandam, peacock, 7-day-lord-hora, and pre-dawn-swara cases are present and green (R2).
- **V5 — no silent skip:** a deliberately malformed independent entry FAILS the test (R3.1).
- **VQ — gates:** `just validate-local` green incl. the expanded reconcile; coverage ≥ 19%; integration gate green; the 37 v1 cases unchanged + green (RQ).

## 4c. Evidence summary (verification-first — the 4 questions; tag each with build/config)
- **What am I accepting?** An expanded, independently-grounded correctness gate over the astro engines (R1–R4): ≥ 6 ground-truth literals that break the self-reference + cases for the named unpinned branches. **No engine `lib/` logic changed.**
- **What could it affect?** CI timing (more reconcile cases) + `validate-local`; nothing user-facing, no `lib/` behavior. The 37 v1 cases are untouched (RQ.3). Blast radius = `test/golden/**` + `tool/regen_golden.dart` guard.
- **Why should I believe it works?** V1 (independent literal ≠ engine snapshot) + V2 (perturb → a ground-truth case fails → revert → green) + V3 (regen leaves independent block untouched) + V4 (new branches present + green) + V5 (malformed → fail), each tagged with the PR head commit / preview.
- **What remains unresolved?** Any engine bug a ground-truth case reveals (flagged, out of scope, R4.1); the chosen tolerance for the transcribed Meeus value (confirm with the owner if the book's printed precision differs from the engine's); exhaustive coverage (deferred, §4).
