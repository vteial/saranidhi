<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/performance-pass/requirements.md
  Saranidhi Kiro Spec — REQUIREMENTS (EARS acceptance criteria = Definition of Done).
  Authored by the Operator; merged to main via /plan-done BEFORE the Executor runs /spec-run.
  Last verified: 2026-10-27 (v1.13.0-web).
-->
# Performance Pass — Startup Latency & Animation Smoothness — Requirements

| Property | Value |
| :--- | :--- |
| **Spec ID** | `performance-pass` |
| **Feature** | Reduce cold-start latency and make repeating animations smooth + reduced-motion-aware, without altering any user-visible behavior or calculation. |
| **Backlog** | Release Polish & v2.0 — "Performance optimization (startup time, animation smoothness)" |
| **Status** | 🟡 Proposed (authored by Operator; executed by Antigravity / Executor) |
| **CONF** | `n/a` — no doctrinal calculation touched (astro-engine firewalled; see R-FW) |
| **Enables** | A confident v2.0 cut; a measured baseline for future perf work |
| **Executor** | Antigravity (`/spec-run performance-pass`) |

---

## 1. Introduction
This is a **measurement-first** optimization pass. It reduces cold-start time to first
interactive frame and makes the app's repeating animations smooth and reduced-motion-aware,
touching ONLY startup wiring and animation widgets — never a calculation, a route, a schema,
or a user-visible behavior. No number is "optimized" without a recorded before/after.
Because it is a code-touching change on the engine-adjacent app spine, it runs the full gate.

## 0. Preconditions (preflight — verify BEFORE any change; enforced by tasks.md T0)
- **P1 — Surface:** Executor (Antigravity on the owner's Mac); local Flutter toolchain able to run `just validate-local`.
- **P2 — Toolchain:** `flutter 3.47.5` (Homebrew cask), Dart SDK, Chrome (web build). `just env-doctor` green. **Pin the exact versions in the REPORT** (the toolchain-rot lesson).
- **P3 — Branch:** `sprint/performance-pass` off up-to-date `main`; clean tree; not `main`/`prod`.
- **P4 — Merge-first:** this Spec merged to `main` before `/spec-run` (satisfied by `/plan-done`).
- **P5 — Baseline green:** `just validate-local` GREEN (the "green except the 4 known CloudKit macOS failures" baseline).

## 2. Current-state facts (of record — verified firsthand 2026-10-27)
- **F1 — `main()` awaits notification init before `runApp`.** `lib/main.dart:16-20` does
  `await NotificationService.instance.initialize()` synchronously before `runApp`. On **web**
  this is a cheap no-op (`notification_service.dart:40-43` returns immediately on `kIsWeb`); on
  **native** (iOS/macOS/Android) it runs `tz.initializeTimeZones()` + plugin init before the
  first frame — a native-only first-paint blocker.
- **F2 — Four on-open widgets wrap every route build.** `main.dart:44-55` nests
  `SyncOnOpenWidget → PracticeSyncAutoTrigger → BirdMigrationOnLoadWidget →
  LocationOnOpenWidget → OnboardingGuard` inside `MaterialApp.router`'s `builder`, which
  rebuilds on every route change.
- **F3 — Eight repeating-animation surfaces, ZERO reduced-motion guards.** `AnimationController`/
  `.repeat()` appear in `shimmer_loading.dart`, `sama_vritti_pacer.dart`, `quick_sync_pacer.dart`,
  `prasanam_screen.dart`, `action_bar.dart`, `streak_celebration.dart`, `oracle_result_card.dart`,
  `home_screen.dart`. A repo-wide grep for `disableAnimations`/`reduceMotion`/`accessibleNavigation`
  returns **0 matches** — nothing honors the platform reduced-motion setting today.
- **F4 — Astro engine is firewalled.** `lib/features/astro_engine/` (incl. `pakshi_calculator.dart`)
  holds no animation/startup code and must stay byte-unchanged (R-FW).

## 3. Requirements (EARS acceptance criteria = Definition of Done)

### R0 — Measure first (gate for every other requirement)
- **R0.1** BEFORE any optimization, the Executor SHALL record a baseline: cold-start time to
  first interactive frame (web, release build) and a native cold-start reading if the native
  toolchain is available, captured the same way before and after.
- **R0.2** Each of R1/R2 SHALL report a **before → after** number from the same measurement
  method and build/config. A change with no recorded delta is NOT accepted (no "looks faster").
- **R0.3** IF a candidate optimization shows no measurable improvement, THEN it SHALL be
  reverted and recorded as "tried, no gain" rather than kept speculatively.

### R1 — Startup latency
- **R1.1** The system SHALL NOT block the first frame on work that can run after `runApp`.
  Specifically, native notification/timezone initialization (F1) SHALL be moved off the
  pre-`runApp` critical path (e.g. post-first-frame, or lazily on first schedule) WITHOUT
  changing notification behavior.
- **R1.2** WHEN the app cold-starts, the on-open side-effect widgets (F2) SHALL NOT perform
  redundant work on every route rebuild; any that need run-once semantics SHALL be guarded so
  they fire once per app launch, not per rebuild.
- **R1.3** The measured cold-start time (R0.1 method) SHALL be **no worse** than baseline, and
  SHOULD improve. Any regression is a fail.

### R2 — Animation smoothness & reduced-motion
- **R2.1** Every repeating animation in F3 SHALL honor the platform reduced-motion setting:
  WHEN `MediaQuery.of(context).disableAnimations` is true, the controller SHALL NOT run a
  continuous `.repeat()` loop — it SHALL present a static end-state instead.
- **R2.2** Repeating animations SHALL dispose their `AnimationController`s correctly (no
  controller left ticking after the widget is gone) — verified by test where feasible.
- **R2.3** The reduced-motion behavior SHALL be the ONLY user-visible change; with reduced
  motion OFF, each animation SHALL look and behave exactly as today (R-REG).

### R-FW — Astro-engine firewall (STANDING for this sprint)
- **R-FW.1** The diff SHALL contain **zero** files under `lib/features/astro_engine/`
  (incl. `pakshi_calculator.dart`). Enforced as a TG check.

<!-- ───────────── STANDING CRITERIA — EVERY saranidhi Spec carries these ───────────── -->

### RT — Tamil bilingual gate (STANDING — collaboration-guardrails §4)
- **RT.1** This pass adds **no new user-facing strings** (it is behavior-preserving). IF any
  string is nonetheless added (it should not be), it SHALL be bilingual EN + pure Tamil script
  via the ARB flow — never transliteration, never a hardcoded literal.
- **RT.2** Tamil mode SHALL be eyeballed to confirm nothing shifted; expected result is "no change".

### RC — CONF provenance (STANDING for doctrinal work)
- **RC.1** `n/a` — no doctrinal rule or calculation is touched. The astro engine is firewalled (R-FW).

### RQ — Quality gates / no regression (STANDING)
- **RQ.1** `just validate-local` SHALL pass: `flutter analyze --fatal-infos` (zero issues),
  `flutter test` (green except the 4 known CloudKit macOS failures), `flutter build web`.
- **RQ.2** Tier-2 coverage SHALL remain **≥ 19%**; the web integration gate (`flutter drive`) SHALL stay green.
- **RQ.3 (R-REG)** The behaviors pinned "unchanged" in §2 — notification scheduling still works,
  on-open side effects still fire once, each animation unchanged with reduced-motion OFF — SHALL
  be pinned by tests BEFORE the optimization (regression-first).

## 4. Out of scope (scope honesty)
- Rewriting any animation's visual design, timing, or easing (reduced-motion gate only).
- Build-size / tree-shaking / deferred-import work, WASM/renderer tuning, image-asset optimization
  — a separate future perf spec owns those.
- Any native platform code (Swift/Kotlin) change; any change to the astro engine (R-FW).
- Adding a perf CI gate / benchmark harness — this sprint measures by hand and records numbers;
  a durable perf-regression gate is a future spec.

## 4b. Human Verification Plan (emitted by /spec-run; recorded by /verification-done)
Run on the deployed PR preview (Vercel) and/or local web build:
- **V1 — Cold start:** hard-reload the preview; app reaches interactive Home without a longer
  blank/white gap than baseline; before→after numbers recorded in the REPORT (R0/R1).
- **V2 — Notifications intact (native, if available):** a scheduled yama notification still fires
  (R1.1 did not break behavior). On web this is n/a (no-op) — state so.
- **V3 — Reduced motion ON:** enable the OS reduced-motion setting; the pacers / shimmer / streak
  celebration / oracle card present a static end-state, no continuous looping (R2.1).
- **V4 — Reduced motion OFF:** animations look and behave exactly as today (R2.3 / R-REG).
- **VT — Tamil mode:** no visible change (RT.2).
- **VQ — gates:** `just validate-local` green; coverage ≥ 19%; integration gate green (RQ).

## 4c. Evidence summary (verification-first — the 4 questions)
- **What am I accepting?** A behavior-preserving startup + animation optimization — R0 (measured),
  R1 (startup off critical path), R2 (reduced-motion-aware animations), R-FW (engine untouched).
- **What could it affect?** Startup wiring (`main.dart`, notification init), the four on-open
  side-effect widgets, eight animation widgets. Blast radius is deliberately UI/startup only — no
  calc, route, schema, or l10n. The §2 "unchanged" behaviors are the risk surface.
- **Why should I believe it works?** The recorded before→after numbers (R0.2), the regression
  tests pinned before the change (RQ.3), V1–V4 outcomes, `validate-local` green — each tagged
  with the commit/preview it came from.
- **What remains unresolved?** Any native cold-start number not captured because the native
  toolchain was unavailable SHALL stay visible as "not measured", never hand-waved. Any candidate
  reverted under R0.3 is listed as "tried, no gain".
