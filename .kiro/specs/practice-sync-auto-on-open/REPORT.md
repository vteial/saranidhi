<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/practice-sync-auto-on-open/REPORT.md
  Append-only verification log for the practice-sync-auto-on-open Spec.
-->
# Practice Sync — Auto-on-Open Fast-Follow — Verification Report

Spec: `.kiro/specs/practice-sync-auto-on-open/` · Spec ID: `practice-sync-auto-on-open` · Branch `sprint/practice-sync-auto-on-open` → `main`.

### Preflight & Seam Read (T0)
- **OQ-1 (A vs B):** Resolved in favor of **Option A** (`PracticeSyncAutoTrigger` ConsumerStatefulWidget wrapper). Mounted cleanly in `lib/main.dart` builder next to `SyncOnOpenWidget`.
- **OQ-2 (Resume):** Resolved as default ship resume-with-debounce (`kAutoSyncMinInterval = Duration(minutes: 5)`).
- **OQ-3 (Indicator):** Resolved as non-blocking / headless trigger. Reuses existing manual Settings card `isSyncing` affordance; no blocking modal or progress overlay.
- **Preconditions (P1-P6):** Baseline `just validate-local` verified green (except 4 known CloudKit macOS failures). Working tree clean.

### Security Re-Review (TS / RS.1 — Hard Gate)
Re-evaluation of the Phase-1 security posture against the automated trigger:
1. **Default-OFF preserved:** `PracticeSyncConfig.enabled` defaults to `false`. The trigger is strictly read-only regarding config. (Verified by test `default-OFF: initial config is disabled, zero transport interactions`).
2. **No auto sign-in:** Trigger never invokes `signIn()`; it checks `state.isAuthenticated` and only invokes `syncNow()`. (Verified by test `trigger never calls signIn (no auto sign-in guarantee)`).
3. **No pre-opt-in traffic:** Asserted by unit tests with `enabled == false`: zero transport calls (0 pulls, 0 pushes).
4. **Auth-expiry path:** Expired token / 401 degrades to silent `SyncOutcome` failure, passively recorded in `PracticeSyncState.errorMessage` with no blocking UI and no retry storms.
5. **Off kills traffic:** Turning sync OFF stops subsequent auto-open and resume syncs immediately (verified by test `toggling sync OFF stops all future auto-open and resume syncs`).

### Verification Checklist
- **V1 (Fires when it should):** Opt-in ON + authenticated triggers `syncNow()` automatically on cold open without tap.
- **V2 (Gated when it shouldn't):** Opt-in OFF or signed-out results in zero transport traffic.
- **V3 (Debounced):** Debounced once per session on cold open, and within 5-min window on resume. Manual sync resets debounce window.
- **V4 (Silent failure):** Network errors or transport exceptions fail silently without blocking app launch or navigation.
- **V5 (No regression):** iCloud `SyncOnOpenWidget` and manual sync function independently without conflict.
- **VS (Security):** Phase-1 security invariants preserved and tested.
- **VQ (Gates):** `just validate-local` green: analyze clean (zero issues), 16 new unit/widget tests green, coverage 42.9% (>= 19%), web build compiles.
