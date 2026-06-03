[← Back to Root](../README.md)

# Saranidhi — Security Review (Sprint 10)

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

### Known Limitations (Accepted Risk)

1. **Web platform**: Browser storage (IndexedDB) is not encrypted at rest. User data is accessible via browser DevTools. Mitigation: Google Drive backup is mandatory for web users.
2. **SharedPreferences**: Stores preferences in plain text. Only non-sensitive data (theme, locale, toggle states). No secrets, tokens, or PII.
3. **No certificate pinning**: Cloud backup relies on standard TLS. Certificate pinning deferred to production hardening.

---

## Recommendations for Production (Sprint 11)

- [ ] Enable certificate pinning for Google Drive API calls
- [ ] Add SQLCipher encryption for mobile SQLite databases
- [ ] Implement secure key storage (Keychain/Keystore) for backup encryption key
- [ ] Add privacy policy document (required for App Store/Play Store)
- [ ] Implement data export (GDPR compliance)

---

[← Back to Root](../README.md)
