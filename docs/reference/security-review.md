[← Back to Root](../../README.md)

# Saranidhi — Security Review

> **Reviewed:** v1.13.0-web (Sprint 47 — Practice Sync Phase 1) · **Next review:** at a major (X) release or when the data/network boundary changes. **v1.13.0 (Practice Sync Phase 1) reopens the network/account/off-device boundary** — introducing an opt-in network path to a user-configured PocketBase backend behind `SyncTransport`. Offline-first remains fully intact. See the *Sprint 47 assessment* below.

## Architecture Security Assessment

### Data Storage Security

| Aspect | Status | Notes |
|--------|--------|-------|
| Local-only by default | ✅ | All data in SQLite via Drift — no server-side storage |
| No developer-owned backend | ✅ | Zero data touches our infrastructure |
| Cloud backup to user's OWN account | ✅ | iCloud (Apple) or Google Drive App Data (Google) |
| No third-party analytics | ✅ | No Firebase, no Amplitude, no Mixpanel |
| No PII transmission | ✅ | Name, location, birth star stay on device |
| SharedPreferences for non-sensitive settings only | ✅ | Theme, locale, notification prefs — no secrets |

### Authentication Security

| Aspect | Status | Notes |
|--------|--------|-------|
| Apple Sign-In (iOS only) | ✅ Stub | For iCloud access only — no account creation |
| Google Sign-In (Android/Web) | ✅ Stub | For Drive App Data only — no account creation |
| No password storage | ✅ | OAuth token handled by platform |
| No custom auth server | ✅ | No server = no auth server vulnerabilities |

### Data at Rest

| Aspect | Status | Notes |
|--------|--------|-------|
| SQLite on device | ✅ | Protected by OS-level app sandboxing |
| Web: IndexedDB/sql.js | ⚠️ | Browser storage — no encryption at rest |
| Backup export: encrypted before upload | ✅ Architecture | Stub implementation — encryption planned |

### Data in Transit

| Aspect | Status | Notes |
|--------|--------|-------|
| HTTPS for cloud backup APIs | ✅ | Apple/Google APIs enforce TLS |
| No custom API calls | ✅ | Zero network dependency for core features |
| Offline-first architecture | ✅ | App fully functional without network |

### Input Validation

| Aspect | Status | Notes |
|--------|--------|-------|
| Latitude: -90 to 90 | ✅ | ArgumentError thrown on invalid input |
| Longitude: -180 to 180 | ✅ | ArgumentError thrown on invalid input |
| Weekday: 0 to 6 | ✅ | ArgumentError thrown on invalid input |
| Nakshatra: validated against known list | ✅ | ArgumentError for unknown names |
| Profile name: no SQL injection risk | ✅ | Drift uses parameterized queries |

### Sprint 44 — Practice Sync Phase 0 assessment (v1.12.0, first data-boundary change)

The first data-portability feature. Reviewed at `/release-update` (data-boundary trigger).

| Aspect | Status | Notes |
|--------|--------|-------|
| New network surface | ✅ None | Phase 0 is manual **file** export/import only — no network calls, no server, no telemetry. Local-first stance unchanged. |
| New account / auth | ✅ None | The **Practice ID (`ownerId`) is a locally-generated UUID v4** — not an account, not a login, no PII, no credential. It is an opaque local identifier, not derived from user data. |
| Cross-user data ingestion | ✅ Guarded | The **owner-identity guard** refuses a merge when the file's `ownerId` ≠ local (with **0 DB mutations**, proven by test) — structurally prevents mixing another person's data. |
| Data leaving the device | ⚠️ User-initiated | Export writes a plaintext JSON file (all tables + non-sensitive prefs) via the user's own share/download — same exposure profile as the pre-existing export. Not encrypted (see limitation #4 below). The user controls where it goes. |
| Data entering the device | ✅ Validated | Import path validates envelope version + schema ceiling; merge is union-by-UUID (skip-existing), never executes file content. Legacy no-`ownerId` files require explicit confirm. |
| Migration integrity | ✅ | Guarded schema v6→v7 (`columnExists`) + UUID backfill; existing data preserved (unit-tested on the upgrade path). |

**Verdict:** v1.12.0 does **not** weaken the security posture — it remains local-first / zero-backend / no-account. The only new exposure is that the (pre-existing) plaintext export now also carries the opaque local `ownerId`, which is not sensitive. **The owner-guard is a net positive** (it prevents accidental cross-user data mixing that the old destructive import allowed).

### Sprint 47 — Practice Sync Phase 1 assessment (v1.13.0, network & account boundary reopening)

The first network-backed cross-device sync feature. Re-evaluated per the mandatory security review trigger.

| Aspect | Status | Notes |
|--------|--------|-------|
| New network surface | ✅ Guarded | Dedicated web-safe HTTP client communicating with PocketBase (Fly.io or self-hosted) over HTTPS / TLS. No third-party tracking or telemetry. |
| Master opt-in consent gate | ✅ Strict Default-OFF | Controlled by `sync_enabled` (default `false`). While OFF, zero network requests are made and client is uninitialized. |
| Account & credentials | ✅ Scoped | User authenticates with personal email + passphrase against PocketBase. **Auth token persisted at rest** in a SharedPreferences-backed `AsyncAuthStore` (survives reload/rebuild — introduced by the v1.13.0 sign-in-state fix); passphrase itself is never stored. No admin credentials ship in the app. _Residual risk: the bearer token sits in browser local storage (SharedPreferences on web) — acceptable for the single-owner opt-in model; a future hardening item is token expiry/rotation UX._ |
| Server-side access control | ✅ Owner-scoped | PocketBase API rules enforce `@request.auth.id != "" && ownerId = @request.auth.id` for list/view/create/update. API deletes disabled (`deleteRule = null`, append-only). |
| Client-side owner guard | ✅ Belt-and-suspenders | Engine verifies all pulled rows belong to local `ownerId`. Aborts immediately with 0 database mutations on any foreign row. |
| Data leaving the device | ⚠️ User-consented | On manual "Sync now", breath sessions and journal rows leave the device to the user's personal PocketBase instance. Data is scoped strictly to user. |
| Data entering the device | ✅ Union-merge | Pulled rows merged via insert-only union by UUID. Never executes incoming code; never overwrites or deletes local data. |
| Offline resilience | ✅ Preserved | Toggle-off or network failure surfaces quiet error without crashing, modals, or data loss. Core app remains 100% offline-first functional. |

**Verdict:** v1.13.0 reopens the network boundary under strict user consent. Security is maintained through dual-layer isolation: server-side PocketBase rule scoping combined with client-side owner guard enforcement, append-only constraints, and default-disabled network activity.

> ℹ️ **Future Phase 2 note:** Auto-sync on app open (fast-follow) operates entirely within this verified network/auth boundary and does not alter the security perimeter.

### Known Limitations (Accepted Risk)

1. **Web platform**: Browser storage (IndexedDB) is not encrypted at rest. User data is accessible via browser DevTools. Mitigation: Google Drive backup is mandatory for web users.
2. **SharedPreferences**: Stores preferences in plain text. Only non-sensitive data (theme, locale, toggle states). No secrets, tokens, or PII.
3. **No certificate pinning**: Cloud backup relies on standard TLS. Certificate pinning deferred to production hardening.
4. **Plaintext export files (v1.12.0)**: the Practice-Sync export is unencrypted JSON (all tables + the opaque local `ownerId` + non-sensitive prefs). The user controls the file; it is the same exposure profile as the pre-existing export. At-rest encryption of exports/synced data is deferred and will be reconsidered at Phase 1 (auto-sync).

---

## Recommendations for Production (Sprint 11)

- [ ] Enable certificate pinning for Google Drive API calls
- [ ] Add SQLCipher encryption for mobile SQLite databases
- [ ] Implement secure key storage (Keychain/Keystore) for backup encryption key
- [ ] Add privacy policy document (required for App Store/Play Store)
- [ ] Implement data export (GDPR compliance)

---

[← Back to Root](../../README.md)
