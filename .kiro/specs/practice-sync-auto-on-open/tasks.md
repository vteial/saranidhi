<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/practice-sync-auto-on-open/tasks.md
  Authored by the Operator; the forward build plan for /spec-run (Executor). All unchecked.
  Last verified: 2026-10-22 (v1.13.0-web).
-->
# Practice Sync — Auto-on-Open — Tasks (`/spec-run` build plan)

> **Execution:** Executor = Antigravity (`/spec-run practice-sync-auto-on-open`) on the owner's Mac
> (local Flutter toolchain). Branch `sprint/practice-sync-auto-on-open` off up-to-date `main`.
> Implement top-to-bottom; local suite GREEN before the PR; emit the Human Verification Plan; STOP.
> **Correctness-critical + re-opens the network boundary → the security re-review (TS) is a HARD
> pre-PR gate.** Never merge/tag (owner-only).

- [x] **T0 — Preflight + seam read (P1-P6; OQ-1/2/3).**
  Verify preconditions. READ the app shell / `main.dart` bootstrap to resolve **OQ-1** (wrapper
  widget vs bootstrap hook) and confirm the exact app-open lifecycle point. Confirm **P6** — the
  manual "Sync now" round-trips against a live/local PocketBase (opt-in ON + signed in) — this
  fast-follow only proceeds on a proven manual flow. Record OQ resolutions in REPORT.

- [x] **T1 — The trigger (R1).** Add `PracticeSyncAutoTrigger` (Option A) OR the bootstrap hook
  (Option B per T0), calling `practiceSyncNotifierProvider.notifier.syncNow()` on the post-first-frame
  app-open point. Mount it once, high in the tree, isolated from the iCloud `SyncOnOpenWidget`.

- [x] **T2 — The gate (R1.2, R2.4, R4.2).** Implement `_shouldAutoSync` = `enabled && isAuthenticated
  && !isSyncing`, reading `practiceSyncConfigProvider` + `practiceSyncNotifierProvider`. No transport
  construction/call when false (zero traffic). Rely on `syncNow()`'s own `enabled` self-guard as
  defence-in-depth.

- [x] **T3 — Debounce (R2).** Add `_firedThisSession` (per-session once) and, for resume,
  `kAutoSyncMinInterval = Duration(minutes:5)` compared against persisted `config.lastSyncedAt`. Cold
  open fires; resume fires only outside the interval. Reset on manual "Sync now".

- [x] **T4 — Silent / non-blocking (R3).** Fire-and-forget (no `await` on UI path); no `catch`-to-UI;
  unexpected throw → `debugPrint` only. Startup never blocks on sync. Reuse the existing `isSyncing`
  affordance; add no blocking overlay.

- [x] **T5 — Tests (RQ.2).** `test/features/cloud_backup/practice_sync_auto_trigger_test.dart`: gate
  matrix (incl. zero-transport-interaction when off), debounce (per-session + interval), in-flight
  guard, silent-failure, and independence from the iCloud path + manual `syncNow()`.

- [x] **TS — Security re-review (RS.1 — HARD GATE).** Re-run the Phase-1 security checklist (design
  §D5): default-OFF preserved, no auto sign-in, no pre-opt-in traffic (assert by test), auth-expiry
  degrades silently, off kills traffic. Record the outcome in REPORT **before** marking the PR ready.

- [x] **TL — l10n (RT.1).** IF a new user-facing string was added, wire EN + pure Tamil via the ARB
  flow and eyeball Tamil mode on the practice-sync card. ELSE record **N/A** explicitly.

- [x] **TG — Governance lockstep.** `CHANGELOG.md` entry + `SPRINT_TRACKER.md` row (sprint section +
  summary) for this deliverable.

- [x] **TQ — Quality gates (RQ).** `just validate-local` GREEN (analyze `--fatal-infos`, tests green
  except the 4 known CloudKit macOS failures, build web); coverage ≥ 19%; integration gate green;
  the manual-sync / opt-in / scopes / sign-out / iCloud paths unchanged (regression).

- [x] **TP — PR + Human Verification Plan.** Open the PR from `sprint/practice-sync-auto-on-open`;
  emit V1-V5 + VS + VQ; STOP for the owner's `/review-pr` + merge gate. (Operator opens/reviews;
  **owner merges**.)

## Delivery Checklist (Definition of Done — mirror into the PR body)
- [x] Auto-sync fires on app open for opt-in + signed-in users, no tap (R1).
- [x] Zero network traffic when opt-in OFF or signed out (R1.2/R4.2) — asserted by test.
- [x] Debounced: per-session once + 5-min resume interval; no sync storm (R2).
- [x] Silent, non-blocking on failure; offline-first startup intact (R3).
- [x] Merge engine / transport / auth / owner-ID core UNCHANGED (R4); iCloud path untouched.
- [x] **Security re-review re-run + recorded in REPORT** (RS.1 — hard gate).
- [x] RT: new strings EN + pure Tamil, or N/A noted. RC: no CONF needed, noted.
- [x] `just validate-local` green; coverage ≥ 19%; integration green; regression gate met (RQ).
