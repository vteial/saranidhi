[← Back to Root](../../README.md)
[← Back to Root](../../README.md)

# Saranidhi — Security Review

> **Reviewed:** v1.7.0-web · **Next review:** at the next **major (X) release**, or
> **whenever the data/network boundary changes** — e.g. adding any backend, a cloud LLM
> API, user accounts, or moving data off-device. The app is deliberately local-first /
> zero-backend, so the security posture is stable by design and does **not** need a
> per-sprint review; it is re-audited only when that boundary moves.

## Architecture Security Assessment

### Data Storage Security

| Aspect | Status | Notes |
|--------|--------|-------|
| Local-only by default | ✅ | All data in SQLite via Drift — no server-side storage |
| No developer-owned backend | ✅ | Zero data touches our infrastructure |
| Cloud sync to user's OWN iCloud (iOS/macOS) | ✅ | CloudKit private database — Android/Web have no cloud sync |
| No third-party analytics | ✅ | No Firebase, no Amplitude, no Mixpanel |
| No PII transmission | ✅ | Name, location, birth star stay on device |
| SharedPreferences for non-sensitive settings only | ✅ | Theme, locale, notification prefs — no secrets |

### Authentication Security

| Aspect | Status | Notes |
|--------|--------|-------|
| No app accounts / no sign-in | ✅ | The app creates no accounts and stores no credentials — there is nothing to authenticate against |
| iCloud (iOS/macOS) via CloudKit | ✅ | Uses the device's existing iCloud identity through CloudKit; no password/OAuth token handled by the app |
| Android/Web cloud sync | ✅ N/A | No cloud sync on Android (stub) or Web — data is local-only there |
| No custom auth server | ✅ | No server = no auth server vulnerabilities |

### Data at Rest

| Aspect | Status | Notes |
|--------|--------|-------|
| SQLite on device (iOS/macOS/Android) | ✅ | Protected by OS-level app sandboxing |
| Web: WASM SQLite (OPFS/IndexedDB) | ⚠️ | Browser storage — no encryption at rest; accessible via browser DevTools |
| JSON export/import (Settings) | ⚠️ | User-triggered plaintext export for manual transfer/backup — stays under user control (share sheet / file picker), never uploaded by the app |

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

### Known Limitations (Accepted Risk)

1. **Web platform**: Browser storage (WASM SQLite via OPFS/IndexedDB) is not encrypted at rest and is accessible via browser DevTools. Accepted for a single-user, on-device, no-PII-transmitted app; the user can clear all data in-app. Web has no cloud sync.
2. **SharedPreferences**: Stores preferences in plain text. Only non-sensitive data (theme, locale, toggle states). No secrets, tokens, or PII.
3. **JSON export is plaintext**: The user-initiated full export (Settings) is unencrypted. It is user-controlled (never auto-uploaded), so this is accepted for the manual-transfer/backup use case.
4. **iCloud is the only cloud path**: Sync uses the device's CloudKit identity (iOS/macOS). No developer-owned backend, no third-party cloud, no Google Drive.

---

## Recommendations (revisit before App Store / Play Store submission)

> These are gated to the **mobile store release** (the one remaining un-shipped domain).
> None are needed for the current web-only production posture.

- [ ] Add SQLCipher (or platform equivalent) encryption for on-device SQLite, if store review or a future feature warrants it
- [ ] If backup encryption is added, use secure key storage (Keychain/Keystore)
- [x] Privacy policy document — **done** (`web/privacy-en.html` + `web/privacy-ta.html`, locale-aware)
- [x] Full data export (portability) — **done** (Settings JSON export/import)

> **If AI-chat / any cloud LLM or backend is ever added** (see the Phase-2b backlog): this
> review MUST be redone — it would introduce a network data path, a new privacy surface,
> and potentially a stored API key, all of which the current assessment explicitly excludes.

---

[← Back to Root](../../README.md)
