<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/practice-sync-auto-on-open/design.md
  Authored by the Operator; merged to main via /plan-done (merge-first) BEFORE /spec-run.
  Last verified: 2026-10-22 (v1.13.0-web).
-->
# Practice Sync — Auto-on-Open — Design

> HOW the EARS DoD in `requirements.md` is met, grounded in the shipped
> `lib/features/cloud_backup/` code. This is **trigger + guard + tests**, not a new engine.

## D1. Shape — a dedicated web-sync trigger, parallel to (never fused with) the iCloud one
The shipped `SyncOnOpenWidget` is CloudKit-only and must stay untouched. Introduce a **separate**,
small trigger for the PocketBase path so the two never entangle (requirements §2, R4):

- **Option A (preferred): a `PracticeSyncAutoTrigger` wrapper widget** (`ConsumerStatefulWidget`),
  mounted once high in the tree (beside/within the existing app shell), mirroring the proven
  `SyncOnOpenWidget` lifecycle pattern (`initState` → `addPostFrameCallback`; an
  `AppLifecycleListener` for resume) but calling **`practiceSyncNotifierProvider.notifier.syncNow()`**
  and reading **`practiceSyncConfigProvider` / `practiceSyncNotifierProvider`** for the gate — NOT
  `storageModeProvider` / `syncNotifierProvider`.
- **Option B: an app-open hook in the existing bootstrap** (wherever first-frame app init already
  runs). Chosen only if there is a single obvious app-open seam already used for one-shot startup
  work; otherwise prefer A (keeps the concern isolated and testable).

**T0 resolves A vs B** by reading the app shell / `main.dart` bootstrap. Either way the trigger is a
thin caller; all behavior lives behind `syncNow()`.

## D2. The gate (R1.2, R4.2) — pure, cheap, zero-traffic when off
```
bool get _shouldAutoSync {
  final cfg   = ref.read(practiceSyncConfigProvider);
  final state = ref.read(practiceSyncNotifierProvider);
  return cfg.enabled               // opt-in, default false
      && state.isAuthenticated     // PocketBase AuthStore rehydrated
      && !state.isSyncing;         // R2.4 in-flight guard
}
```
`syncNow()` ALSO self-guards on `config.enabled` (`practice_sync_providers.dart:273-275`), so even if
the trigger mis-fires there is a second gate — defence in depth. When `_shouldAutoSync` is false the
trigger returns before any transport call → **zero network traffic** (V2).

## D3. Debounce (R2)
- **Per-session once:** a `bool _firedThisSession` on the trigger state, set after the first
  post-frame fire — guards against rebuilds (R2.1), the same `_hasSyncedOnce` idea the iCloud widget
  uses.
- **Resume interval (R2.2):** on `onResume`, additionally require
  `config.lastSyncedAt == null || now.difference(lastSyncedAt) >= kAutoSyncMinInterval`
  with `const kAutoSyncMinInterval = Duration(minutes: 5);` (named constant, one place to tune).
  `lastSyncedAt` is already persisted (`_kSyncLastSyncedEpochKey`) and survives restart, so the
  debounce holds across a cold reopen too.
- **R2.3 decision:** **cold app-open fires (R1); app-resume is INCLUDED but strictly behind the
  interval debounce.** This matches the owner cadence ("on app open") while covering the common
  "switch back to the tab" case without a storm. If resume proves noisy in QA, it can be gated off
  by a flag — but the default ships resume-with-debounce.

## D4. Silent, non-blocking execution (R3)
- The post-frame callback calls `syncNow()` **without `await`** on the UI path (fire-and-forget);
  `syncNow()` already flips `isSyncing` and records `lastOutcome`/`errorMessage` into
  `PracticeSyncState`, so the Settings card surfaces success/failure passively — no new dialog.
- `syncNow()` delegates to `PracticeSyncEngine.performSync`, whose failures resolve into a
  `SyncOutcome` with `error` set (not thrown to the UI); the trigger adds **no** `catch`-to-UI. A
  thrown/unexpected error is caught and `debugPrint`-logged only (mirrors `SyncTriggerService`),
  never surfaced (R3.2).
- The transient in-flight affordance (R3.3) reuses whatever the manual card already shows via
  `isSyncing`; the trigger adds no blocking overlay. (If the iCloud `_SyncIndicator` pattern is
  reused, it is a copy scoped to the web state — not a shared widget.)

## D5. Security re-review (RS.1) — recorded in REPORT before PR-ready
Re-run the Phase-1 checklist and record findings:
1. **Default-OFF preserved** — `PracticeSyncConfig.enabled` default `false` unchanged; new trigger
   cannot flip it.
2. **No auto sign-in** — the trigger never calls `signIn`; it only calls `syncNow()`, which no-ops
   unless already authenticated.
3. **No pre-opt-in traffic** — assert via a test that with `enabled=false` the transport is never
   constructed/called on app open (V2 is the manual mirror).
4. **Auth-expiry path** — a 401/expired token during auto-sync degrades to a silent `SyncOutcome`
   error; no token/detail leaked to UI; no retry loop.
5. **Off kills traffic** — toggling opt-in off stops all auto-open syncs (no residual timer).

## D6. Testing (RQ.2)
Unit tests (ProviderContainer + fakes, no network — the project's test-authoring rules):
- gate matrix: (enabled × authenticated × isSyncing) → `syncNow()` called exactly when
  `enabled && authed && !isSyncing`; **asserts zero transport interaction otherwise**.
- debounce: second fire within `kAutoSyncMinInterval` → no call; after the window → one call;
  per-session-once holds across a rebuild.
- silent failure: a transport fake that throws / returns an error `SyncOutcome` → no exception
  escapes the trigger, state records the error, startup path unaffected.
- regression: the iCloud `SyncOnOpenWidget` path and manual `syncNow()` unaffected (construct both,
  assert independence).
Widget test (optional, if Option A): mounting the trigger with gate-false performs no sync.

## D7. Open design questions (resolve in T0, flag any that need the owner)
- **OQ-1 (A vs B):** is there an existing one-shot app-open bootstrap seam, or do we mount a wrapper
  widget? → read the app shell in T0; default to the wrapper (Option A) if no clean seam.
- **OQ-2 (resume):** ship app-resume-with-debounce now (D3 default) or park it? → default ship; flip
  only if QA shows noise. Owner-notifiable, not owner-blocking.
- **OQ-3 (indicator):** reuse a subtle in-flight indicator or none at all on auto-sync? → reuse the
  manual card's existing `isSyncing` affordance; add no new blocking UI. Cosmetic.

## D8. Files (expected touch set)
- **New:** `lib/features/cloud_backup/presentation/widgets/practice_sync_auto_trigger.dart` (Option A)
  OR a small hook in the app bootstrap (Option B); `kAutoSyncMinInterval` constant (co-located).
- **New:** `test/features/cloud_backup/practice_sync_auto_trigger_test.dart`.
- **Edit (minimal):** the app shell / bootstrap to mount the trigger once; possibly an l10n ARB pair
  IF a new string is added (RT.1 — else N/A).
- **UNCHANGED:** `practice_sync_engine.dart`, `pocketbase_sync_transport.dart`, `sync_transport.dart`,
  `practice_sync_providers.dart` logic (a constructor/export touch only if unavoidable, called out),
  and the entire iCloud path.
