<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/deferred-widgets-wiring/design.md
  Last verified: 2026-10-25 (baseline v1.13.0-web).
-->
# Wire the Sprint-26 Deferred Widgets — Design

## 1. Approach
Four independent activations, each landing its already-built component on its live surface with the
smallest safe change. No shared refactor ties them together, so they can be implemented and reviewed
as four discrete diffs inside one PR. The only non-trivial design decision is PresetSelector (§3.2),
which is deliberately scoped to *guidance* to protect the breath-capture behavior.

## 2. The real seams (verified firsthand)

| Item | Built component | Live surface to wire into |
| :--- | :--- | :--- |
| WhatsNew | `whats_new_screen.dart` — `shouldShowWhatsNewProvider`, `WhatsNewScreen`, `markWhatsNewSeen()` | app root after onboarding — `core/router/onboarding_guard.dart` / `app_router.dart` / `main.dart` |
| PresetSelector | `preset_selector.dart` (`selectedPreset`/`onSelect`), `breath_presets.dart` | `journal/presentation/journal_screen.dart` `entryPanel` |
| StreakCelebration | `streak_celebration.dart` — `isStreakMilestone`, `showStreakCelebration` | Home tab watching `dashboardDataProvider.streak` — `home/presentation/today_tab.dart` |
| isPinned | `tables.dart`/`app_database` column + migration (shipped); sync/export read it | `breath_journal/presentation/widgets/journal_history_list.dart` + its repository |

## 3. Design per item

### 3.1 WhatsNew (R1)
- Add a post-onboarding gate: in the root/guard, once `introSeenProvider` + onboarding are satisfied,
  read `shouldShowWhatsNewProvider`; if `true`, push `WhatsNewScreen` (its own dismiss already calls
  `markWhatsNewSeen()` + invalidates the provider). Mirror the `OnboardingGuard` Navigator/ValueKey
  pattern already used for web picker dialogs (steering note).
- **Ordering invariant (R1.2):** the gate must sit AFTER the onboarding/intro branch so a first-run
  user never sees WhatsNew before finishing setup. Pin with a test (RQ.3b).
- **No version bump (R1.3):** leave `_currentWhatsNewVersion` at `1.2.0`. The mechanism is what ships;
  the owner bumps the version at `/release-update`.

### 3.2 PresetSelector — guidance only (R2) — the one design decision
- `BreathTimerNotifier` captures the user's *actual* phase durations (`finishInhale(durationMs)` …).
  A preset is a *target* rhythm. Rebuilding the timer into an auto-advancing runner would overwrite
  that capture → a regression on the core interaction. **Rejected.**
- **Chosen:** PresetSelector sets a local `selectedPreset` in the entry panel. A non-null preset renders
  its target rhythm as guidance (target inhale/hold/exhale, and the Quick Sync Pacer can adopt the
  preset cadence as its visual rhythm). The manual timer still records what the user actually does —
  `submitEntry` still receives the user-captured durations, unchanged. "Manual" (null) = today's behavior.
- This keeps R2 additive and makes RQ.3a (manual capture unchanged) straightforward to pin.

### 3.3 StreakCelebration (R3)
- On a Home tab that already watches `dashboardDataProvider`, read `data.streak` (the `StreakResult`
  streak count). When it transitions to a milestone value, call `showStreakCelebration(context, milestone)`.
- **De-dup (R3.2):** persist a `last_celebrated_streak_milestone` (SharedPreferences, same pattern as
  WhatsNew's last-seen key). Fire only when the new milestone > the stored one; update the marker on fire.
  This prevents re-firing on rebuild and on relaunch at an already-passed milestone.
- Guard the `showDialog` with a post-frame callback + `context.mounted` so it never fires mid-build.

### 3.4 isPinned UI (R4)
- In `journal_history_list.dart`, add a star/pin `IconButton` per entry that calls a repository
  `setPinned(id, value)` (add the method if absent; the column/`companion` already support it).
- Sort: pinned entries first, then the existing chronological grouping within each partition. Keep the
  existing date-group rendering for the non-pinned remainder (or show a small "Pinned" header + the rest).
- No migration (column exists). New strings (pin tooltip/label, optional "Pinned" header) go through ARB → RT.

## 4. Invariants pinned by tests (RQ.3)
- **RQ.3a** Manual breath capture unchanged (no auto-advance; captured durations are the user's).
- **RQ.3b** WhatsNew never precedes onboarding (ordering).
- **RQ.3c** With nothing pinned, journal list renders/sorts exactly as today.

## 5. Risks
- **Startup races (R1):** mis-ordering the gate could flash WhatsNew during onboarding — mitigated by
  the ordering test (RQ.3b).
- **Celebration spam (R3):** without the persisted marker the dialog re-fires — mitigated by R3.2 + test.
- **Pin-sort regressions (R4):** changing list ordering can disturb the date-grouping — mitigated by RQ.3c.
- All four are UI-local; none touch the engine or DB schema, so blast radius is bounded to presentation + one repo method.
