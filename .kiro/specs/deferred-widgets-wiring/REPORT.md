<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/deferred-widgets-wiring/REPORT.md
  Append-only verification log for the deferred-widgets-wiring Spec.
-->
# Wire the Sprint-26 Deferred Widgets — Verification Report

Spec: `.kiro/specs/deferred-widgets-wiring/` · Spec ID: `deferred-widgets-wiring` · PR #312
(`fix/deferred-widgets-wiring` → `main`).

### Preflight & Baseline (T0)
- **Preflight (P1–P5):** Flutter `3.47.5` / Dart `3.13.4`, branch `fix/deferred-widgets-wiring` off `main` (`85260ba`), working tree clean.
- **Seams verified firsthand:** Zero external call sites existed prior to wiring.
- **Database:** `isPinned` column confirmed present in `tables.dart` and `app_database.dart`; no new migration required.
- **Baseline:** `just validate-local` green except 4 accepted CloudKit macOS failures (coverage 42.9% ≥ 19%).

### Invariants Pinned First (T1)
- **T1a (RQ.3a):** Manual breath capture records exact user durations without auto-advance or overwrite.
- **T1b (RQ.3b):** WhatsNew startup gate never displays before onboarding/intro completes.
- **T1c (RQ.3c):** Journal entries with no pin render and sort in exact chronological order without a "Pinned" header.
- Pinned in `test/features/deferred_widgets/deferred_widgets_invariants_test.dart`.

### Verification Log — 2026-10-27 (PR #312)

| Plan step | Result | Finding / correction |
| :--- | :---: | :--- |
| V1 — WhatsNew startup gate (R1) | ❌→✅ | **Finding:** WhatsNew screen displayed stale `v1.2.0` string with Sprint 26 feature bullets. **Correction:** Tied `currentWhatsNewVersion` to `AppConstants.appVersion` (`1.13.0`), refreshed feature bullets to highlight Practice Sync alongside the newly wired deferred widgets, added pure Tamil RT widget verification, and documented `AppConstants.appVersion` in `dev-workflow.md` release checklist (fixup commit `34a2dec`). User re-verified: works as expected. |
| V2 — PresetSelector guidance (R2) | ✅ | Selecting a preset in `journal_screen.dart` surfaces target rhythm guidance without auto-advancing or altering `BreathTimerNotifier` manual capture. "Manual" default preserved. |
| V3 — StreakCelebration trigger (R3) | ✅ | Milestone crossing (7, 30, 100, 365) triggers celebratory overlay once, de-duplicated by persisted `last_celebrated_streak_milestone` in `SharedPreferences`. |
| V4 — isPinned journal UI (R4) | ✅ | Star toggle writes `SaraKalaiJournal.isPinned` via repository, sorts into pinned-first block at top of journal history, and retains chronological order for unpinned entries. |
| VT — Tamil mode (RT) | ✅ | Pure Tamil script verified across all new affordances: pin tooltip/semantics (`பின் செய்`, `நீக்கு`), section header (`பின் செய்தவை`), preset guidance cards, and WhatsNew content (`புதியது என்ன`, `பயிற்சி ஒத்திசைவு`, `தொடர் கொண்டாட்டங்கள்`, `புரிந்தது!`). Zero English leaks. |
| VQ — quality gates (RQ) | ✅ | `just validate-local` green: analyze clean (0 issues), tests green (485 passed, 4 accepted CloudKit macOS baseline failures), coverage 46.5% ≥ 19%, web build passes; web integration gate (`integration_test/app_test.dart`) passes. |

- **Iterations:** 2 (Initial implementation commit `c76d9d7`; verification fixup commit `34a2dec` resolved WhatsNew version desynchronization and content freshness).
- **Verdict:** PASS — human functional verification complete.
- **Verified by:** owner (Human) · **Surface:** Executor (Antigravity).
- **Provenance note:** Local validation gates and mechanical checks verified by Executor; functional verification on live web build attested by owner.

#### Evidence summary (the 4 questions — requirements §4c), tagged with build/config
- **What am I accepting?** Four UX activations (R1–R4) wired into their live application surfaces (WhatsNew startup gate, PresetSelector guidance card, StreakCelebration milestone trigger, isPinned journal UI) with full RT pure Tamil compliance and regression-first invariant locks (RQ.3a–c). Tagged: commit `34a2dec`, PR #312.
- **What could it affect?** Blast radius: app root/startup guard (`OnboardingGuard` — R1), breath entry panel and timer guidance (`JournalScreen` — R2, manual capture untouched), Home tab streak listener (`TodayTab` — R3, deduplicated), and journal history presentation (`JournalRepository`, `JournalHistoryList` — R4). Sequence firewall check confirmed 0 engine / `pakshi_calculator.dart` files touched (TG); no database schema changes.
- **Why believe it works?** `just validate-local` green with zero analyzer issues, coverage at 46.5% (well above 19% floor), web build compiling, 3 invariant regression tests (`deferred_widgets_invariants_test.dart`) passing, V1–V4 + VT verified by the owner on local web build, and RC explicitly confirmed as n/a (touches no doctrinal calculation).
- **What remains unresolved?** Higher streak milestones (30, 100, 365) are unit-tested via stubs; live verification exercised the milestone 7 threshold. Version string is now synchronized with `AppConstants.appVersion` (`1.13.0`).
