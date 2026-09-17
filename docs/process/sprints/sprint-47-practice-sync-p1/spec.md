[← Back to Dossier](./README.md)

# Sprint 47 Spec — Practice Sync Phase 1 (on-demand cross-device sync, PocketBase)

> **Author:** Kiro Web · **Implementer:** Antigravity (local green vs. the Compose PocketBase before PR) · **Reviewer:** Kiro Web
> **Target:** `vteial/saranidhi` (app code) · **Release:** v1.13.0 (minor) · **PocketBase instance:** Fly.io (deployed) + Docker Compose (local dev)

On demand (opt-in toggle + manual **"Sync now"**), sync the **breath-sessions + journal** tables to
a PocketBase backend via **pull → union-merge → push**, keyed by `(ownerId, id)`, reusing the
Phase-0 append-only union + owner-guard. Offline-first must still fully hold. All touchpoints below
were verified against `main` this session (context-gathered).

> **★ This reopens the network/account/off-device boundary** → the **security-review REDO is a hard
> gate** (§8), not a footnote. It is the first such change since the local-first posture was set.

> **Branch (Antigravity creates it):** implement on a new feature branch off `main` named
> **`feature/sprint47-practice-sync-p1`**, and open the PR from it into `main`. (Kiro Web does not
> pre-create the branch — the coding setup owns the branch + commits + PR, per the spec→implement→
> review handoff. Standardizing on the `feature/sprintNN-<slug>` form.) Never commit to `main`;
> never merge — owner is sole merge authority.

---

## §0 — Prerequisite (gated, owner, in parallel): the PocketBase instance

**Owner** stands up PocketBase and provides its base URL. Implementation greens **locally against the
Docker Compose instance (§6)** meanwhile; the **Fly instance is required before the release smoke**.

- **Deployed:** PocketBase on **Fly.io** (persistent volume for the SQLite file; scale-to-zero OK).
- **Create the two collections below EXACTLY** (same schema for Fly + the local Compose seed).
- **Secret/token handling:** the app authenticates as a PocketBase user (email/passphrase = the
  consent surface); the auth token is stored in the app's secure/local store and **never committed**.
  No PocketBase admin credentials ever ship in the app.

### PocketBase collection schema (authoritative — Fly + Compose must match)

Both collections are **owner-scoped** and mirror the Drift columns 1:1 (camelCase field names, so
the existing `_*ToMap` serializers map straight across). PocketBase auto-adds `id`, `created`,
`updated` — we use our **own `uuid`** field as the stable cross-device key (do NOT rely on
PocketBase's `id`), plus an **`ownerId`** field for the guard/scoping.

**Collection `sessions`** (mirrors `BreathSessions`):
| Field | Type | Notes |
|---|---|---|
| `uuid` | text, **required, unique** | = local Drift row `id` (the cross-device key) |
| `ownerId` | text, required, indexed | = Practice ID |
| `timestamp` | number | epoch ms |
| `totalDurationMs` | number | |
| `nostril` | text | |
| `inhaleLengthMs` / `holdAfterInhaleMs` / `exhaleLengthMs` / `holdAfterExhaleMs` | number | |
| `completedCycles` | number | |
| `mood` | text, optional | |
| `consciousnessRating` | number, optional | |
| `notes` | text, optional | |

**Collection `journal`** (mirrors `SaraKalaiJournal`):
| Field | Type | Notes |
|---|---|---|
| `uuid` | text, **required, unique** | = local Drift row `id` |
| `ownerId` | text, required, indexed | |
| `timestamp` | number | |
| `expectedFlow` / `actualFlow` / `nostril` | text | |
| `isAligned` | bool | |
| `inhaleDurationMs` / `holdDurationMs` / `exhaleDurationMs` | number, optional | `holdDurationMs` drives the aggregates |
| `activeYama` / `activeBird` / `activeBirdState` / `activeElement` | text, optional | |
| `notes` | text, optional | |
| `isPinned` / `wasForcedShift` | bool | |

**Access rules (the network-side half of the owner-guard) — AS SHIPPED (owner-accepted):**
On **both** collections, set the API rules to **`@request.auth.id != "" && ownerId = @request.auth.id`**
for **List / View / Create / Update**; leave **Delete `null` (locked)** (append-only — Phase 1 never
deletes remotely). The **Create rule binds `ownerId` to the authenticated user's id**, so a user
cannot create rows under a foreign `ownerId`, and the List/View/Update rules scope every row to the
caller — a user can't read/write another owner's rows. `ownerId` (the Practice ID) is both the
cross-device grouping key AND the server-enforced scope.

> **Rule-form note (reconciled at `/sprint-finish`):** PR #261 had *pinned* a `user`-relation form
> (a separate `relation → users` field). The implementation shipped the simpler **`ownerId`
> string-match bound on create** instead; the **owner accepted it** — for the 1–6-user trust model
> the create-binding is an adequate server-side guard, and it avoids the extra relation field + the
> app having to set `user` on every write. This doc + the runbook now reflect the shipped form.
> Full runbook: [`docs/deployment/pocketbase-hosting.md`](../../../deployment/pocketbase-hosting.md).

> Until §0 is satisfied for **local** (Compose is enough to build/green), implementation proceeds;
> the **Fly** instance gates the release smoke.

---

## §1 — Add a web-safe HTTP/PocketBase client (Task 47.1a)

No HTTP stack exists today (verified — no `http`/`dio`/`pocketbase` in pubspec, no `HttpClient`
usage). Add one, **web-safe** (must compile + run on Flutter web — no `dart:io`):
- Preferred: the official **`pocketbase`** Dart SDK (handles auth + collections + web). If it pulls
  `dart:io`-only transitive code, fall back to **`package:http`** hand-rolled calls.
- Pin the version; note it in `architecture.md`.

## §2 — `SyncTransport` interface + `PocketBaseSyncTransport` (Task 47.1)

The sync **engine** must be transport-agnostic (owner's long-term "minimal owned backend = adapter
swap" intent). Define an interface and one implementation:

```dart
abstract interface class SyncTransport {
  bool get isConfigured;                 // base URL present + creds available
  Future<void> signIn({required String email, required String passphrase});
  Future<void> signOut();
  bool get isAuthenticated;
  /// Pull all remote rows for this ownerId for the given collections.
  Future<RemoteSyncData> pull({required String ownerId, required Set<SyncScope> scopes});
  /// Push the given local rows (upsert-by-uuid) for this ownerId.
  Future<void> push({required String ownerId, required RemoteSyncData local, required Set<SyncScope> scopes});
}
enum SyncScope { sessions, journal }
```
- `PocketBaseSyncTransport implements SyncTransport` — constructor takes the base URL + an
  **injectable http/pocketbase client** (so tests can mock it, mirroring
  `CloudKitSyncService({MethodChannel? channel})`).
- **Do NOT reuse the CloudKit `_mergeRemoteData` "primary-device-wins" strategy** — Phase 1 uses the
  **Phase-0 union-by-UUID** semantics (§4). CloudKit stays Apple-only + untouched.

## §3 — Extract a shared, transport-agnostic union-merge core (Task 47.2a)

The Phase-0 union helpers in `database_exporter.dart` (`checkOwnerGuard`, `_mergeJournal`,
`_mergeSessions`, the `_*ToMap` serializers) are **reusable but private + JSON-envelope-bound**.
Extract the post-guard merge so both file-import and network-sync share it:
- Add a **public** method to `DatabaseExporter` (or a small `SyncMergeCore`) that takes
  **already-decoded lists of row-maps** (`{sessions: [...], journal: [...]}`) + does the union-by-UUID
  insert-only merge, returning counts. `mergeFromBytes` refactors to call it (behavior unchanged —
  regression-pin with the existing `database_exporter_test`).
- Expose `_journalToMap` / `_sessionToMap` (or public wrappers) to serialize local rows → push body.
- **Owner-guard reused:** `checkOwnerGuard` already takes a `Map` — feed it the pull payload's
  envelope (`{ownerId: <remoteOwnerId>}`) so a foreign-owner pull is refused exactly as a file merge
  is. Client-side guard + the §0 server-side access rules are belt-and-suspenders.

## §4 — On-demand sync engine (Task 47.2)

A `PracticeSyncEngine` (new, in `lib/features/cloud_backup/domain/`) orchestrating one **Sync now**:
1. Resolve `ownerId` via `ownerIdProvider`/`ensureOwnerId()`; if null (pre-onboarding) → no-op with a clear status.
2. Ensure transport `isConfigured` + `isAuthenticated` (else surface a "sign in to sync" status).
3. **Pull** remote rows for `ownerId` + selected scopes.
4. **Owner-guard** the pulled set (must all be this `ownerId`; refuse+abort on any foreign row — should be impossible given §0 rules, but assert).
5. **Union-merge** pulled rows into local (insert-only by `uuid`; never delete; idempotent) via §3 core.
6. **Push** local rows (upsert-by-uuid so re-push is idempotent; never delete remote).
7. Update **last-synced** timestamp; return a `SyncOutcome{pulledInserted, pushed, error?}`.
- **Idempotent both directions**; a second immediate Sync-now inserts 0 and pushes 0 new.
- **Never deletes** locally or remotely (append-only, matches Phase 0). Deletions are explicitly out of scope.

## §5 — Settings UI: opt-in gate + scope checkboxes + Sync now (Tasks 47.3/47.4/47.7)

A new **Sync card** in `settings_screen.dart` `dataSection` (slots after `StorageModeSelector` /
`SyncDeviceConfigWidget`; use the `DataExportImportWidget` `Card` pattern). Persist via the
`StorageModeNotifier` SharedPreferences idiom (new keys):
- **Master opt-in toggle** — `sync_enabled` (default **false**). While off, **nothing touches the
  network** (no client init, no auth prompt). This is the consent gate.
- **Account row** — when enabled: sign-in (email + passphrase) → PocketBase auth; show signed-in
  state; sign-out. Token stored securely, never committed/logged.
- **Two scope checkboxes** — `sync_scope_sessions` / `sync_scope_journal`, **both default ON**, with a
  one-line note: *"Journal drives your streak & hold-time stats."*
- **"Sync now" button** — runs the engine; disabled while busy; shows a spinner.
- **Last-synced status** — quiet text ("Last synced: …" / "Not yet synced" / a non-blocking error
  line). A sync failure is **never** a blocking modal or data loss.
- On success → call `invalidateAllDataProviders(ref)` so dashboards/journal/aggregates/profile refresh
  (verify streak providers refresh — the context-gather flagged they may not be in that set; add if needed).
- **Bilingual EN/TA** for every new string (toggle, checkboxes + note, account/sign-in, Sync now, statuses, errors).
- **Auto-on-open is OUT** (fast-follow) — do not wire any app-open trigger.

## §6 — Local dev infra: Docker Compose for PocketBase (Task 47.6)

`tool/dev/docker-compose.yml` — **PocketBase only** (official image or the binary), a mounted volume
for the SQLite data, port `8090`. Plus:
- A **seed/migration** that creates the `sessions` + `journal` collections + access rules **matching
  §0 exactly** (so local == Fly).
- A short `tool/dev/README.md`: `docker compose up`, the local URL `http://localhost:8090`, admin
  bootstrap, and how Flutter points at it.
- **Gitignore the data volume** (`tool/dev/pb_data/` or similar). **Flutter is NOT containerized** —
  it runs native and takes the PocketBase URL via config (`--dart-define` or a settings field):
  `localhost:8090` local / the Fly URL deployed.

## §7 — Offline-first regression (Task 47.5)

- Toggle **off** (default) ⇒ zero network, app identical to today.
- **Offline** (or PocketBase unreachable) with toggle on ⇒ full app, no blocking, Sync-now surfaces a
  quiet error status and leaves local data intact. Pin with tests.

## §8 — Security-review REDO (HARD GATE, Task = DoD)

`docs/reference/security-review.md` must be **re-run and re-stamped** for the new posture (the doc's
cadence explicitly triggers on a data/network-boundary change). Must assess: the new **network path**
(app ↔ PocketBase over TLS), the **auth token at rest** (where/how stored, never logged), **third-party
/ self-hosted data egress** (rows leave the device), the **opt-in consent** model (default-off gate),
and the **owner-scoped access rules** (server-side guard). Note residual risks + that auto-on-open
(fast-follow) doesn't change the boundary further.

---

## Tests (add with the implementation)
- **Merge core (§3):** extracted union core — disjoint pull → union; overlapping uuids → idempotent 0-dup; regression: `mergeFromBytes` still behaves identically (existing `database_exporter_test` green).
- **Owner-guard on pull:** a pulled set with a foreign `ownerId` is refused (0 local mutations).
- **Engine (§4):** pull→merge→push round-trip with a **mocked `SyncTransport`** (inject a fake); second run is a no-op (0 inserted / 0 pushed).
- **Transport (§2):** `PocketBaseSyncTransport` with a mocked http client — auth, pull maps rows, push upserts by uuid; web-safe (no `dart:io`).
- **Opt-in/offline (§7):** toggle-off ⇒ engine no-ops / no network; transport error ⇒ `SyncOutcome.error` surfaced, no throw, no data change.
- **Scope checkboxes:** journal-only vs sessions-only vs both drive the right collections.
- **l10n:** EN/TA parity for all new keys; Tamil pure-script.

## Definition of Done (Sprint 47)
- [ ] §0 — PocketBase collections (`sessions`/`journal`, owner-scoped rules) created on **Fly** (+ the Compose seed matches); auth token handled securely, never committed.
- [ ] Web-safe HTTP/PocketBase client added (no `dart:io`); builds + runs on Flutter web.
- [ ] `SyncTransport` interface + `PocketBaseSyncTransport` (injectable client for tests); CloudKit untouched.
- [ ] Shared union-merge core extracted; `mergeFromBytes` refactored onto it with **no behavior change** (regression-pinned).
- [ ] `PracticeSyncEngine`: on-demand pull→union-merge→push, **idempotent both ways**, **never deletes**, owner-guard on pull.
- [ ] Settings Sync card: **opt-in toggle (default off)**, sign-in, **two scope checkboxes (both default on)**, **Sync now**, quiet last-synced status; post-sync provider refresh (incl. streak/aggregates).
- [ ] **Offline-first regression** pinned (toggle-off = zero network; error = quiet status, no data loss).
- [ ] **Docker Compose (PocketBase only)** + seed + README in `tool/dev/`; data volume gitignored; Flutter native via config.
- [ ] Bilingual EN/TA for all new copy.
- [ ] **SECURITY-REVIEW REDO** done + re-stamped (§8) — release gate.
- [ ] Local `flutter analyze` clean + full suite green (against the Compose PocketBase) **before** PR; Kiro Web reviews the real diff.
- [ ] Docs: architecture (SyncTransport + PocketBase + Fly/Compose topology), user-guide (enable sync + sign in + what syncs), CHANGELOG.
- [ ] E2E (`saranidhi-e2e`): add a sync scenario where feasible against a test instance; else a manual smoke scenario for v1.13.0.

## Explicitly OUT of scope (named — hold the boundary)
- **Auto-on-open sync** (fast-follow). **Device registry / trusted-device UX** (management layer, not correctness). **Profile / preferences sync** (session + journal only this phase). **Real-time / push**. **Deletions/tombstones** (append-only). **Native CloudKit** (Apple-only, App Store track). **Conflict resolution beyond union** (rows are UUID-keyed + append-only → no real conflicts).
