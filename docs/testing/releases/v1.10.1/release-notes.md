[← Back to Smoke Test](./smoke-test.md) · [Releases index](../../smoke-test-results.md)

# Release Notes — v1.10.1-web

> Permanent record of the GitHub Release. The owner creates the tag/release from the
> GitHub UI; this file is the source text. Drafted at `/release-start`, finalized at `/release-update`.

## Tag details (copy into the GitHub Release UI)

| Field | Value |
|-------|-------|
| **Tag** | `v1.10.1-web` |
| **Target** | `prod` branch |
| **Title** | `v1.10.1-web — Analytics tidy + Tamil` |

## Release notes (body)

A small housekeeping patch tidying the Analytics screen and polishing Tamil.

### Changed
- **Journal CSV export moved to Settings.** "Export as CSV" now lives in **Settings → Data Export / Import**, right beside the full JSON backup — its natural home. It shares via the standard share sheet, so it now works on the **web** too (previously mobile-only).

### Fixed
- **Analytics screen in Tamil.** The Yama badge, date formatting, and day/second unit labels now render correctly in Tamil (தமிழ்) instead of showing English.

### Notes
- No functional/calculation changes — the numbers, charts, and CSV contents are unchanged; this only moves the export and fixes localization.

### Sprint(s)
- Sprint 41 — Analytics Tidy + Tamil l10n

### Smoke test
- See [`smoke-test.md`](./smoke-test.md) (slim — light patch) — ⚠️ **PASS** (3/3 + version; one pre-existing cosmetic bug noted, BUG-v1.10.1-01, backlogged).

---

> **Shipped:** 2026-09-13 · tag [`v1.10.1-web`](https://github.com/vteial/saranidhi/releases/tag/v1.10.1-web) @ `prod` · promotion PR #216. Live at [saranidhi.vercel.app](https://saranidhi.vercel.app).
