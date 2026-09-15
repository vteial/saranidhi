[← Back to Smoke Test](./smoke-test.md) · [Releases index](../../smoke-test-results.md)

# Release Notes — v1.12.1-web

> Permanent record of the GitHub Release. The owner creates the tag/release from the GitHub UI;
> this file is the source text. Drafted at `/release-start`, finalized at `/release-update`.

## Tag details (copy into the GitHub Release UI)

| Field | Value |
|-------|-------|
| **Tag** | `v1.12.1-web` |
| **Target** | `prod` branch |
| **Title** | `v1.12.1-web — Practice Sync polish` |

## Release notes (body)

A small follow-up to v1.12.0 that smooths out cross-device setup — no new engine, no schema change.

### ✨ What's New
- **Set up a new device by importing.** A new device now shows an **"Already using Saranidhi on
  another device? Import"** link right on the welcome screen — so you can import your backup and
  adopt your existing **Practice ID before** going through onboarding, instead of having to finish
  setup first and then Merge from Settings.
- **Recognizable backup filenames.** Exports now include your Practice ID, e.g.
  `saranidhi_backup_3f9a1c2b_2026-09-15-1034.json`, so you can tell your devices' backups apart.

### 🛠 Fixed
- The **Practice ID in Settings now updates immediately** after a Merge or Restore — no page reload
  needed.

### Notes
- No database change this release. Everything still works fully offline, no account, no server.

### Sprint(s)
- Sprint 45 — Practice Sync polish (v1.12.0 fast-follow)

### Smoke test
- See [`smoke-test.md`](./smoke-test.md) — targeted patch smoke (the 3 changed behaviors + EN/TA +
  regression), run on the release PR's Vercel preview.

---

> **Shipped:** 2026-09-15 · promotion PR #248 · tagged **`v1.12.1-web`** (target `prod`) · live at [saranidhi.vercel.app](https://saranidhi.vercel.app).
