<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/practice-sync-auto-on-open/requirements.md
  Authored by the Operator; merged to main via /plan-done (merge-first) BEFORE /spec-run.
  Last verified: 2026-10-22 (v1.13.0-web).
-->
# Practice Sync — Auto-on-Open (Phase 1 fast-follow) — Requirements

| Property | Value |
| :--- | :--- |
| **Spec ID** | `practice-sync-auto-on-open` |
| **Feature** | Promote the **proven** manual "Sync now" (shipped v1.13.0, PocketBase transport) to an **automatic** pull→union-merge→push on **app open** — strictly gated on the existing opt-in, authenticated, debounced, and **silent-on-failure**, so a logged-in opted-in user's practice aggregate (streak / 30-day trend / hold-time / PB) is current on whichever device they pick up, with no manual tap. |
| **Backlog** | `TSK-sync-auto` — "Phase 1 fast-follow — auto-on-open sync" (`BACKLOG.md:191`, Practice Sync epic). Follows the shipped Phase 1 (Sprint 47, v1.13.0, PR #260/#267). |
| **Status** | 🟡 Proposed (authored on Kiro Crew / Operator; executed by Antigravity / Executor) |
| **Class** | **Sprint deliverable — correctness-critical.** It **re-opens the account/network boundary** → the Phase-1 **security re-review is a HARD GATE** (same standing rule that gated v1.13.0). |
| **CONF** | No new doctrine. Respects the owner-confirmed Practice-Sync decisions (`BACKLOG.md:163-185`): local-first with optional user-owned sync, owner-ID union-merge, opt-in default OFF, cadence = on app open. |
| **Enables** | Removes the one remaining friction in cross-device practice: the user no longer has to remember to tap "Sync now" — the metric the practice is judged by stays correct across the owner's fleet (and future validators') automatically. |
| **Executor** | Antigravity (`/spec-run practice-sync-auto-on-open`) |

---

## 1. Introduction
Phase 1 (shipped v1.13.0) delivered opt-in, authenticated, on-demand Practice Sync over a
`SyncTransport` → PocketBase adapter: pull → union-merge by (`ownerId`, `id`) → push, fired by a
**manual** "Sync now" button on the Settings practice-sync card. The deferred fast-follow is to
make that cycle fire **automatically on app open** once the manual flow has proven out — the
owner-confirmed cadence (`BACKLOG.md:184`, "Sync cadence = on app open, not real-time"). This Spec
adds **only a trigger**: it calls the existing, already-consent-gated
`PracticeSyncNotifier.syncNow()` at the app-open lifecycle point, behind the same opt-in and auth
gates, debounced so it fires at most once per foreground session, and **silent on failure** (a
failed background sync must never block, interrupt, or alarm — the app is offline-first). **No new
sync engine, no new network surface, no change to the merge semantics** — the PocketBase transport,
the union-merge, and the owner-ID safety core are untouched.

## 0. Preconditions (preflight — verify BEFORE any change; enforced by tasks.md T0)
- **P1 — Surface:** Executor (Antigravity on the owner's Mac); local Flutter toolchain able to run `just validate-local`; a reachable PocketBase (local Docker Compose is fine) for the manual-flow baseline.
- **P2 — Toolchain:** `flutter 3.47.5` (Homebrew cask), Dart SDK, Chrome (web build). `just env-doctor` green.
- **P3 — Branch:** `sprint/practice-sync-auto-on-open` off up-to-date `main`; clean tree; not `main`/`prod`.
- **P4 — Merge-first:** this Spec merged to `main` before `/spec-run` (satisfied by `/plan-done`).
- **P5 — Baseline green:** `just validate-local` GREEN (analyze `--fatal-infos` + test + build web; the "green except the 4 known CloudKit macOS failures" baseline).
- **P6 — Manual flow proven:** confirm the manual "Sync now" round-trips against a live PocketBase (opt-in ON + signed in) BEFORE promoting it — the fast-follow's premise (`BACKLOG.md:191`, "once the opt-in manual flow proves out").

## 2. Current-state facts (of record — verified 2026-10-22 against the shipped code)
- **The web sync path is `practice_sync_providers.dart`** (PocketBase), NOT the iCloud path. `PracticeSyncNotifier.syncNow()` (`practice_sync_providers.dart:272`) is the on-demand cycle: it early-returns unless `config.enabled`, sets `isSyncing`, calls `PracticeSyncEngine.performSync(scopes:)`, persists `lastSynced`, and calls `invalidateAllDataProvidersWithRef(ref)` on success. It is invoked today ONLY from the manual card (`practice_sync_card.dart`).
- **Consent + auth gates already exist:** `PracticeSyncConfig.enabled` (default **false**, persisted `sync_enabled`, `practice_sync_providers.dart:33`) and `PracticeSyncState.isAuthenticated` (PocketBase AuthStore, rehydrated in `_initAuth`). `syncNow()` is already a no-op when `!config.enabled`.
- **`lastSyncedEpoch`** is persisted in SharedPreferences (`_kSyncLastSyncedEpochKey`) and exposed as `config.lastSyncedAt` — available for debounce decisions.
- **DO NOT CONFUSE with the iCloud widget.** `SyncOnOpenWidget` (`sync_on_open_widget.dart`) and `SyncTriggerService` (`sync_trigger_service.dart`) are **CloudKit/`StorageMode.icloud`-only** (the parked Apple-native engine) — they fire `syncNotifierProvider.performSync()`, a DIFFERENT path, and are OUT OF SCOPE. The web PocketBase path has **no** auto-open trigger today; that is exactly the gap this Spec closes. The new trigger must not touch, duplicate, or entangle the iCloud widget.
- The transport is a swappable `SyncTransport` interface (`sync_transport.dart:22`); the engine, merge, and owner-ID binding are shipped and MUST remain unchanged.

## 3. Requirements (EARS acceptance criteria = Definition of Done)

### R1 — Automatic trigger on app open (the feature)
- **R1.1** WHEN the app reaches its post-first-frame app-open lifecycle point, the system SHALL invoke the existing `PracticeSyncNotifier.syncNow()` exactly once for that open — WITHOUT any user tap.
- **R1.2** The automatic trigger SHALL be gated: it fires ONLY WHEN `practiceSyncConfigProvider.enabled == true` AND `practiceSyncNotifierProvider.isAuthenticated == true`. IF either is false, the trigger SHALL be a no-op with **zero network traffic** (preserving the opt-in default-OFF guarantee).
- **R1.3** The system SHALL reuse `syncNow()` as-is (same scopes, same merge, same provider-invalidation). It SHALL NOT introduce a second sync code path, a new transport, or new merge logic.

### R2 — Debounce / no redundant syncs
- **R2.1** The system SHALL fire the automatic sync **at most once per foreground session** — a rebuild, a provider refresh, or a theme/locale change SHALL NOT re-trigger it.
- **R2.2** WHERE app-resume-from-background is included (see R2.3), the system SHALL debounce by `config.lastSyncedAt`: it SHALL NOT auto-sync IF a successful sync occurred within a **minimum interval** (default **5 minutes**, a named constant). A manual "Sync now" in the same window SHALL reset the debounce.
- **R2.3** App-open (cold start / first frame) is **in scope (R1)**. App-**resume** from background SHALL be behind the R2.2 debounce; the design (`design.md`) names whether resume ships in this slice or is a parked follow-up — resume MUST NOT cause a sync storm on rapid foreground/background toggling.
- **R2.4** IF a sync is already in flight (`isSyncing == true`), the automatic trigger SHALL NOT start a second one.

### R3 — Silent, non-blocking failure (offline-first invariant)
- **R3.1** The automatic sync SHALL run in the background: it SHALL NOT block app startup, gate first paint, or show a modal/blocking spinner. The app SHALL be fully usable offline exactly as before.
- **R3.2** IF the automatic sync fails (network down, server unreachable, auth expired), the system SHALL fail **silently** — no error dialog, no snackbar, no crash — recording the outcome in `PracticeSyncState` for the Settings card to surface passively. A failed auto-sync SHALL be indistinguishable to startup from sync being off.
- **R3.3** A transient subtle indicator (consistent with the existing manual-sync affordance) MAY show while an auto-sync is in flight, but SHALL NOT be an interruptive/blocking UI.

### R4 — Boundary & safety unchanged (nothing new crosses the wire)
- **R4.1** This Spec SHALL NOT change the owner-ID union-merge, the (`ownerId`, `id`) keying, the `SyncTransport` interface, the PocketBase adapter, or the auth flow. It adds a caller, not a capability. A diff touching `practice_sync_engine.dart`, `pocketbase_sync_transport.dart`, or `sync_transport.dart` logic is OUT OF SCOPE (a wiring/constructor touch to expose the trigger is allowed if unavoidable and called out).
- **R4.2** The opt-in remains **default OFF**; no code path SHALL enable sync, sign in, or transmit data without the user's prior explicit opt-in + sign-in. Turning sync off SHALL stop auto-open syncs with zero residual traffic.

<!-- ───────────── STANDING CRITERIA — EVERY saranidhi Spec carries these ───────────── -->

### RT — Tamil bilingual gate (STANDING — non-negotiable; collaboration-guardrails §4)
- **RT.1** Any NEW user-facing string (e.g. an auto-sync status/last-synced label, if added) SHALL be EN + pure Tamil via the `l10n` ARB flow — never transliteration, never a hardcoded English literal. IF no new string is added (the trigger reuses existing affordances), state **N/A** explicitly in the PR. Eyeball Tamil mode on the practice-sync card before the PR regardless.

### RC — CONF provenance (STANDING for doctrinal work)
- **RC.1** No doctrinal (CONF) value is involved — this is infrastructure. The owner-confirmed Practice-Sync decisions (`BACKLOG.md:163-185`) are the governing record; cite them. **Expected: no CONF citation needed — note it in the PR.**

### RS — Security re-review (STANDING for this feature — HARD GATE)
- **RS.1** Because this re-exercises the network/account boundary, the **Phase-1 security review SHALL be re-run** and its outcome recorded in the REPORT before the PR is marked ready — the same hard gate that governed v1.13.0. Confirm specifically: default-OFF preserved; no auto sign-in; no data transmitted pre-opt-in; auth token handling unchanged; a failed/expired auth auto-sync degrades silently without leaking error detail to the UI.

### RQ — Quality gates / no regression (STANDING)
- **RQ.1** `just validate-local` SHALL pass: `flutter analyze --fatal-infos` (zero issues), `flutter test` (green except the 4 known CloudKit macOS failures), `flutter build web`.
- **RQ.2** Tier-2 coverage SHALL remain **≥ 19%**; the web integration gate (`flutter drive`) SHALL stay green. New trigger/debounce logic SHALL carry unit tests (gate open/closed by enabled×auth, debounce window, in-flight guard, silent-failure).
- **RQ.3** The shipped manual "Sync now", the opt-in toggle, the scopes, sign-in/out, and the iCloud `SyncOnOpenWidget` path SHALL remain UNCHANGED in behavior (regression gate — this is additive).

## 4. Out of scope (scope honesty)
- Real-time / push / background-fetch sync (cadence is on-open per owner decision) → not this Spec.
- Any change to the merge engine, transport interface, PocketBase adapter, or auth flow (R4).
- The device registry / trusted-device UX (separate backlog item).
- Widening sync scope to profile/preferences (separate item).
- The iCloud/CloudKit `SyncOnOpenWidget` path (Apple-native track).

## 4b. Human Verification Plan (emitted by /spec-run; recorded by /verification-done)
- **V1 — fires when it should:** opt-in ON + signed in → open the app → a sync runs automatically (observe `lastSyncedAt` advance + aggregate refresh) with no tap. (R1)
- **V2 — gated when it shouldn't:** opt-in OFF → open app → **zero** network traffic, no sync (verify no request leaves the client). Signed out + opt-in ON → no sync. (R1.2/R4.2)
- **V3 — debounced:** reopen/resume within the min-interval → no redundant sync; after the window → syncs. (R2)
- **V4 — silent failure:** point at an unreachable server, opt-in ON + signed in, open app → app starts normally, no error UI, outcome recorded passively. (R3)
- **V5 — no regression:** manual "Sync now", toggle, scopes, sign-out, and the iCloud path all behave exactly as in v1.13.0. (RQ.3)
- **VS — security re-review:** the Phase-1 security checklist re-run and recorded (RS.1).
- **VQ — gates:** `just validate-local` green; coverage ≥ 19%; integration gate green; new logic unit-tested.

## 4c. Evidence summary (verification-first — the 4 questions)
- **What am I accepting?** A single automatic caller of the existing, consent-gated `syncNow()` at app open, debounced and silent-on-failure. **No new network surface, no merge change.**
- **What could it affect?** App-open path (must stay non-blocking), background traffic for opted-in+signed-in users only. Blast radius = a new trigger widget/hook + a debounce constant + tests; the engine/transport/merge are untouched.
- **Why should I believe it works?** V1 (fires) + V2 (gated, zero traffic when off) + V3 (debounced) + V4 (silent failure, offline-first intact) + V5 (no regression) + VS (security re-review), each tagged with the PR head commit.
- **What remains unresolved?** Whether app-resume ships in this slice or is parked (design decision, R2.3); the exact debounce interval (default 5 min, owner may tune); no doctrinal values involved.
