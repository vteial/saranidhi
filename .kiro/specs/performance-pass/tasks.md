<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/performance-pass/tasks.md
  Saranidhi Kiro Spec — TASKS (the ordered /spec-run build plan, run by the Executor).
  Last verified: 2026-10-27 (v1.13.0-web).
-->
# Performance Pass — Tasks (`/spec-run` build plan)

## Execution header
- **Kickoff:** `/spec-run performance-pass`
- **Surface:** Executor (Antigravity) + local web build / PR preview for verification
- **Branch to create:** `sprint/performance-pass` (off up-to-date `main`)
- **EARS target (DoD):** `requirements.md` §3 R0, R1, R2, R-FW + STANDING RT / RC(n/a) / RQ;
  verify against §4b (V1–V4, VT, VQ)
- **Merge-first:** this Spec must be on `main` before kickoff (satisfied by `/plan-done`)

> Ordered plan for `/spec-run` (Executor / Antigravity). Executes the tasks, self-validates
> against the EARS DoD, opens a PR into `main`, emits the Human Verification Plan (§4b), and
> **STOPs in verification**. **Never merges, never tags.**

- [x] **T0 — Preflight (gate — STOP on any ❌)**
  - Confirm P1–P5: on `sprint/performance-pass` off up-to-date `main`, clean tree; `just env-doctor`
    green; baseline `just validate-local` green (except the 4 CloudKit macOS failures).
  - **Pin exact toolchain versions in the REPORT** (flutter/Dart/Chrome) — toolchain-rot lesson.

- [x] **T1 — MEASURE the baseline FIRST (R0.1) — before touching anything**
  - Choose ONE reproducible cold-start method (OQ-1; lean = in-code `Stopwatch` main→first frame).
  - Record web release cold-start baseline; record native baseline IF the native toolchain is
    available, else record "native not measured". Write the method + numbers to the REPORT.

- [x] **T2 — Pin regression tests BEFORE optimizing (RQ.3 / R-REG)**
  - Test: notification init is idempotent and still wires `onNotificationTap`.
  - Test: each on-open side effect fires once per launch, not per route rebuild.
  - Test (where feasible): an animation widget with reduced-motion ON does not run `.repeat()`
    and disposes its controller; with reduced-motion OFF it behaves as today.

- [x] **T3 — Startup: move init off the critical path (R1.1, R1.2)**
  - `main.dart`: `runApp` first; kick notification/timezone init from `addPostFrameCallback`
    (OQ-2), preserving `onNotificationTap`. Add run-once guards to the on-open widgets (F2) that
    lack them. No widget-tree reshape.

- [x] **T4 — Animations: reduced-motion helper + apply (R2.1, R2.2, R2.3)**
  - Add `core/utils/reduced_motion.dart`. Apply at the `.repeat()`/`forward()` site in all eight
    F3 widgets: `shimmer_loading`, `sama_vritti_pacer`, `quick_sync_pacer`, `prasanam_screen`,
    `action_bar`, `streak_celebration` (OQ-3: still shows, instantly), `oracle_result_card`,
    `home_screen`. OFF path byte-equivalent to today. Confirm all controllers dispose.

- [x] **T5 — MEASURE after (R0.2, R1.3) + prune (R0.3)**
  - Re-measure with the SAME method; record before→after per R1. Revert any candidate with no
    measurable gain and log it as "tried, no gain". Confirm no cold-start regression.

- [x] **TL — Localization (RT)**
  - Expect NO new strings. If any slipped in, add EN + pure Tamil, regenerate `lib/l10n/generated/`,
    eyeball Tamil mode (expected: no change).

- [x] **TC — CONF provenance (RC)** — n/a (no doctrinal calc; astro engine firewalled).

- [x] **TG — Governance lockstep + firewall check**
  - **R-FW:** confirm the diff has **0** files under `lib/features/astro_engine/`.
  - `CHANGELOG.md` `[Unreleased]` entry. `SPRINT_TRACKER.md` → 👀 In Review on the PR.
    STATUS.md untouched here (updated at `/sprint-update`).

- [x] **TQ — Quality gates + no-regression (RQ)**
  - `just validate-local` green; coverage ≥ 19%; integration gate green; the §2 "unchanged"
    behaviors pinned by the T2 tests.

- [x] **TP — Commit, open PR, emit Human Verification Plan, STOP**
  - Commit `perf(app): performance-pass — startup off critical path + reduced-motion animations`;
    `git push -u origin sprint/performance-pass`; `gh pr create --base main --head sprint/performance-pass ...`.
    CI green. Emit §4b (V1–V4, VT, VQ) with the before→after numbers. STOP. **Never merge, never tag.**

- [x] **TV — After human verification passes: `/verification-done`**
  - Human runs §4b (esp. V3 reduced-motion ON / V4 OFF). Fixes ride the SAME PR (Single-PR rule).
    On pass → `/verification-done` → `/review-pr` (Operator gate) → owner merges.
