<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/deferred-widgets-wiring/tasks.md
  Last verified: 2026-10-25 (baseline v1.13.0-web).
-->
# Wire the Sprint-26 Deferred Widgets — Tasks

> Executor: Antigravity via `/spec-run deferred-widgets-wiring`. Implement on
> `fix/deferred-widgets-wiring` off up-to-date `main`, run `just validate-local` GREEN
> BEFORE the PR (local green is non-negotiable; CI-only is not sufficient — v1.2.1 lesson),
> open the PR, emit the Human Verification Plan, then STOP. Never merge.

## T0 — Preflight (BEFORE any change)
- Confirm P1–P5 (requirements §0). **Pin the exact `flutter --version` in the REPORT.**
- Re-read the four seams in §2 of design.md firsthand; confirm each component still has zero
  external call sites (nothing wired behind your back since the Spec was authored).
- Confirm the isPinned column exists and needs NO new migration.

## T1 — Pin the invariants FIRST (regression-first)
- **T1a** Test: Manual breath capture unchanged — selecting "Manual" leaves `BreathTimerNotifier`
  recording user durations; no auto-advance (RQ.3a).
- **T1b** Test: WhatsNew gate never fires before onboarding/intro completes (RQ.3b).
- **T1c** Test: with nothing pinned, journal list order == today's chronological order (RQ.3c).
- These FAIL or are inert until the wiring lands — that is the point; they lock the "unchanged" contract.

## T2 — isPinned UI (R4)
- Add repository `setPinned(id, bool)` if absent (column + companion already support it).
- Add the per-entry star toggle in `journal_history_list.dart`; pinned-first sort; "Pinned" header or block.
- New ARB strings (pin tooltip/label, header) EN + pure Tamil (RT). Test the toggle round-trips + sort.

## T3 — StreakCelebration (R3)
- On the Home tab watching `dashboardDataProvider`, detect a new milestone crossing on `data.streak`.
- Add the persisted `last_celebrated_streak_milestone` marker (SharedPreferences); fire
  `showStreakCelebration` only on a new crossing; update the marker. Post-frame + `context.mounted` guard.
- Test: fires once at 7; does NOT re-fire on rebuild or on relaunch at an already-passed milestone (R3.2).

## T4 — PresetSelector guidance (R2)
- Render `PresetSelector` in `journal_screen.dart` `entryPanel`; local `selectedPreset` state; Manual default.
- A selected preset shows its target rhythm as guidance (target durations and/or Pacer cadence) WITHOUT
  auto-advancing or overwriting captured durations (R2.2). Any new copy → ARB EN + Tamil (RT).
- Verify T1a still green (manual capture intact).

## T5 — WhatsNew startup gate (R1)
- Wire the post-onboarding gate (design §3.1); push `WhatsNewScreen` once when `shouldShowWhatsNewProvider`.
- Do NOT bump `_currentWhatsNewVersion` (R1.3 — release-gated). Verify T1b (ordering) green.

## TV — Verification (local, pre-PR)
- `just validate-local` GREEN (analyze `--fatal-infos` + test + build web), except the 4 known CloudKit macOS failures.
- Walk V1–V4 + VT + VQ (requirements §4b) on the local web build; record outcomes with build/config.

## TT — Tamil eyeball (RT)
- Switch to Tamil; confirm every NEW affordance renders in pure Tamil script, no English leak.
  Check the journal pin label/header and any preset-guidance copy especially (the partial-localization miss).

## TC — Coverage / integration (RQ)
- Confirm Tier-2 coverage ≥ 19% and the `flutter drive` web integration gate stays green.

## TG — Firewall check
- Confirm `git diff --name-only` shows **0** astro-engine / `pakshi_calculator.dart` files (R4 scope / §4 out-of-scope).

## TP — PR + lockstep + STOP
- Open the PR from `fix/deferred-widgets-wiring` → `main` with the REPORT (the 4 evidence questions,
  each result tagged with build/config) and the Human Verification Plan. State RC is n/a explicitly.
- CHANGELOG `[Unreleased]` + tracker lockstep entry for the four activations.
- Emit the Human Verification Plan and STOP. The Operator runs `/review-pr`; the owner merges.
