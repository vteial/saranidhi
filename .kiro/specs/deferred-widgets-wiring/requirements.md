<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/deferred-widgets-wiring/requirements.md
  Saranidhi Kiro Spec — REQUIREMENTS (EARS acceptance criteria = Definition of Done).
  Authored by the Operator; merged to main via /plan-done (merge-first) BEFORE /spec-run.
  Last verified: 2026-10-25 (baseline v1.13.0-web).
-->
# Wire the Sprint-26 Deferred Widgets — Requirements

| Property | Value |
| :--- | :--- |
| **Spec ID** | `deferred-widgets-wiring` |
| **Feature** | Activate four built-but-unwired UX components — WhatsNew startup gate, PresetSelector, StreakCelebration, and the isPinned journal star — so they reach users. |
| **Backlog** | "Wire Sprint 26 deferred widgets (WhatsNew startup, PresetSelector, StreakCelebration, isPinned star)" (`BACKLOG.md` L441) |
| **Status** | 🟡 Proposed (authored by the Operator; executed by the Executor) |
| **CONF** | `n/a` — pure UX wiring; touches no doctrinal calculation. |
| **Enables** | v2.0 feature-set freeze (one of the five v2.0 critical-path items). |
| **Executor** | Antigravity (`/spec-run deferred-widgets-wiring`) |

---

## 1. Introduction
Four UX components were built during Sprint 26 but left unwired — their code exists in `lib/`
with **zero call sites** outside their own definitions, and (for isPinned) the DB column and
sync/export plumbing already shipped but the UI never did. This Spec wires each into its live
surface so users actually get the feature. It touches **no** calculation/engine code — it is
UI/plumbing activation only. There is no doctrinal (CONF) dimension.

A key honesty note shaping scope: the **PresetSelector** is NOT a drop-in. The breath timer
(`BreathTimerNotifier`) is a *manual, user-advanced* capture timer — `finishInhale(durationMs)`
records how long the user actually held each phase. A `BreathPreset` is a *guided* pattern with
prescribed durations. Converting the timer into an auto-advancing runner would **change the core
breath-capture behavior** (a regression risk on the app's primary interaction). So this Spec
scopes PresetSelector as **guidance only** (R2) — selecting a preset surfaces its target rhythm;
it does NOT replace manual capture. An auto-runner is explicitly out of scope (§4).

## 0. Preconditions (preflight — verify BEFORE any change; enforced by tasks.md T0)
- **P1 — Surface:** Executor (Antigravity on the owner's Mac); local Flutter toolchain able to run `just validate-local`.
- **P2 — Toolchain:** pinned Flutter (Homebrew cask) + Dart SDK + Chrome (web build). `just env-doctor` green. **Pin the exact `flutter --version` in the REPORT before authoring.**
- **P3 — Branch:** `fix/deferred-widgets-wiring` off up-to-date `main`; clean tree; not `main`/`prod`.
- **P4 — Merge-first:** this Spec merged to `main` before `/spec-run` (satisfied by `/plan-done`).
- **P5 — Baseline green:** `just validate-local` GREEN (analyze `--fatal-infos` + test + build web), except the 4 known CloudKit macOS failures.

## 2. Current-state facts (of record — verified firsthand 2026-10-25)
- **WhatsNew** — `lib/features/whats_new/presentation/whats_new_screen.dart` exists with
  `shouldShowWhatsNewProvider`, `WhatsNewScreen`, `markWhatsNewSeen()`. It is **never invoked**
  (grep: no usage outside its own file). `_currentWhatsNewVersion = '1.2.0'` is **stale** (prod is v1.13.0-web).
- **PresetSelector** — `lib/features/breath_journal/presentation/widgets/preset_selector.dart`
  exists (`selectedPreset` + `onSelect` API) with `breathPresets` in `.../domain/breath_presets.dart`.
  **Zero call sites.** The breath entry surface is `.../journal/presentation/journal_screen.dart`
  (`entryPanel`), driven by `BreathEntryNotifier` + the manual `BreathTimerNotifier`.
- **StreakCelebration** — `lib/features/streaks/presentation/widgets/streak_celebration.dart`
  exists: `isStreakMilestone(int)` (milestones `[7,30,100,365]`), `showStreakCelebration(context, milestone)`.
  **Zero call sites.** The streak count is `DashboardData.streak` (a `StreakResult`) from
  `dashboardDataProvider`, watched on the Home tabs (`today_tab.dart`).
- **isPinned** — DB column + migration **already shipped** (`lib/database/tables.dart` L50;
  `lib/database/app_database.dart` L47-51 Sprint-26 migration), and sync/export already read it
  (`pocketbase_sync_transport.dart`, `database_exporter.dart`). The **journal-list UI has no
  pin toggle and no pinned-first sort** — that is the entire gap.
- **l10n already exists** for the widget bodies (`whatsNew*`, `celebration*`, `preset*`) — so the
  widget interiors carry no new-string burden. Only brand-new wiring affordances (e.g. a pin
  tooltip/semantics label, a "Pinned" section header) may need new ARB strings → RT applies to those.
- **Sequence firewall unaffected:** this Spec touches no `pakshi_calculator.dart` / engine files.

## 3. Requirements (EARS acceptance criteria = Definition of Done)

### R1 — WhatsNew startup gate
- **R1.1** WHEN the app reaches its post-onboarding root AND `shouldShowWhatsNewProvider` is `true`,
  the system SHALL present `WhatsNewScreen` once, and dismissing it SHALL call `markWhatsNewSeen()`
  so it does not reappear for that version.
- **R1.2** The WhatsNew gate SHALL fire only AFTER onboarding/intro is complete (never interrupting
  or racing the `OnboardingGuard` / first-run flow).
- **R1.3** The system SHALL NOT bump `_currentWhatsNewVersion` in this Spec — the version bump is
  **release-gated** (owner bumps it at `/release-update`, per steering). This Spec wires the *mechanism*;
  the content/version it shows is the existing `1.2.0` value until the release step updates it.

### R2 — PresetSelector (guidance only)
- **R2.1** The system SHALL render `PresetSelector` in the breath-entry panel (`journal_screen.dart`),
  letting the user pick a preset or "Manual".
- **R2.2** Selecting a preset SHALL surface that preset's target rhythm as **guidance** (e.g. the
  displayed target durations and/or the Quick Sync Pacer cadence). It SHALL NOT auto-advance or
  overwrite the user's manually-captured `inhaleMs/holdMs/exhaleMs`.
- **R2.3** "Manual" (null preset) SHALL be the default and SHALL preserve today's exact behavior.

### R3 — StreakCelebration trigger
- **R3.1** WHEN the user's streak count transitions to a value for which `isStreakMilestone(streak)`
  is true (i.e. it newly reaches 7 / 30 / 100 / 365), the system SHALL call
  `showStreakCelebration(context, milestone)` exactly once for that crossing.
- **R3.2** The celebration SHALL NOT fire on every rebuild, on app relaunch at an already-passed
  milestone, or when the streak is unchanged — it fires only on a *new* crossing (de-duplicated via
  a persisted "last-celebrated milestone" marker).

### R4 — isPinned journal UI
- **R4.1** The journal history list SHALL expose a pin/star toggle per entry that writes
  `SaraKalaiJournal.isPinned` (via the repository), reflecting current state.
- **R4.2** Pinned entries SHALL sort first in the journal list (pinned block, then the existing
  chronological order within each group).
- **R4.3** The toggle SHALL round-trip through the existing persistence (no new migration — the
  column already exists) and SHALL be reflected after reload.

<!-- ───────────── STANDING CRITERIA — EVERY saranidhi Spec carries these ───────────── -->

### RT — Tamil bilingual gate (STANDING — non-negotiable; collaboration-guardrails §4)
- **RT.1** Every NEW/changed user-facing string (pin tooltip/label, any "Pinned" header, any new
  preset-guidance copy) SHALL be bilingual: English + **pure Tamil script** (தமிழ்) via the `l10n`
  ARB flow — never transliteration, never a hardcoded English literal. (Widget interiors already
  localized — RT applies to the new wiring affordances only.)
- **RT.2** The four wired surfaces SHALL be eyeballed in Tamil mode before the PR; partially-localized
  widgets (the recurring v1.8.1 miss) SHALL be explicitly checked.
- **RT.3** Trilingual nakshatra selection SHALL use `NakshatraL10n.trilingualDisplay()` — n/a here
  (no nakshatra selection touched).

### RC — CONF provenance (STANDING for doctrinal work)
- **RC.1 / RC.2** — **n/a.** This Spec touches no doctrinal calculation; no CONF applies. State this
  explicitly in the PR body so the reviewer need not hunt for a provenance citation.

### RQ — Quality gates / no regression (STANDING)
- **RQ.1** `just validate-local` SHALL pass: `flutter analyze --fatal-infos` (zero issues),
  `flutter test` (green except the 4 known CloudKit macOS failures), `flutter build web`.
- **RQ.2** Tier-2 coverage SHALL remain **≥ 19%**; the web integration gate (`flutter drive`) SHALL stay green.
- **RQ.3** The behaviors pinned "UNCHANGED" below SHALL each be held by a test:
  - **RQ.3a** Breath capture is unchanged with Manual selected — `BreathTimerNotifier` still records
    the user's actual durations; no auto-advance (the R2 guidance must not regress manual capture).
  - **RQ.3b** Onboarding/intro first-run flow is unchanged — WhatsNew never fires before it (R1.2).
  - **RQ.3c** Journal entries with no pin render and sort exactly as today when nothing is pinned.

## 4. Out of scope (scope honesty)
- **Auto-advancing guided breath timer** — converting `BreathTimerNotifier` into a preset-driven
  auto-runner. That changes the core capture behavior and deserves its own Spec + golden characterisation.
- **Bumping `_currentWhatsNewVersion` / authoring new WhatsNew content** — release-gated (owner, `/release-update`).
- **Any engine/calculation change** — `pakshi_calculator.dart` and all astro-engine files stay byte-unchanged.
- **New DB migration** — the isPinned column already exists; this Spec adds no schema change.

## 4b. Human Verification Plan (emitted by /spec-run; recorded by /verification-done)
Run on the deployed PR preview (Vercel) and/or local web build:
- **V1 — WhatsNew:** fresh profile (or cleared `whats_new_last_seen_version`) → complete onboarding →
  WhatsNew appears once; dismiss → relaunch → it does NOT reappear.
- **V2 — PresetSelector:** on the Journal screen, pick a preset → its target rhythm shows as guidance;
  log a manual entry → the captured durations are the user's own (guidance did not overwrite them);
  "Manual" behaves exactly as before.
- **V3 — StreakCelebration:** drive a streak to 7 (or stub the provider) → celebration fires once;
  relaunch at streak 7 → it does NOT fire again.
- **V4 — isPinned:** star an entry → it jumps to the pinned block at the top; reload → still pinned;
  unstar → returns to chronological position.
- **VT — Tamil mode:** switch to Tamil; every new affordance (pin label, any header/guidance copy)
  renders in pure Tamil script, no English leak (RT).
- **VQ — gates:** `just validate-local` green; coverage ≥ 19%; integration gate green (RQ).

## 4c. Evidence summary (verification-first — the 4 questions)
`/verification-done` records evidence so a reviewer decides WITHOUT reconstructing it. Tag every
result with the build + config (commit/preview) it came from:
- **What am I accepting?** Four UX activations (R1–R4) + their standing-criteria compliance (RT/RQ).
- **What could it affect?** Blast radius: app root/startup (R1), the breath-entry panel + timer (R2 —
  the primary interaction, guarded by RQ.3a), the Home tabs' streak watch (R3), and the journal list +
  repository write path (R4). No DB migration, no engine/calc, no l10n for existing widget interiors.
- **Why should I believe it works?** `validate-local` result + V1–V4 + VT outcomes, each with build/config;
  the three RQ.3 regression tests green.
- **What remains unresolved?** Any affordance not demonstrated (e.g. a milestone > 7 not reachable in
  test without stubbing) stays visible as missing, never explained away.
