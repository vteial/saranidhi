[← Back to Smoke Test](./smoke-test.md) · [Releases index](../../smoke-test-results.md)

# Release Notes — v1.12.0-web

> Permanent record of the GitHub Release. The owner creates the tag/release from the GitHub UI;
> this file is the source text. Drafted at `/release-start`, finalized at `/release-update`.

## Tag details (copy into the GitHub Release UI)

| Field | Value |
|-------|-------|
| **Tag** | `v1.12.0-web` |
| **Target** | `prod` branch |
| **Title** | `v1.12.0-web — Practice Sync (Phase 0): use Saranidhi across your devices` |

## Release notes (body)

Practice anywhere, on any device — and bring it all together. v1.12.0 lays the foundation for
**cross-device practice**, safely and with zero backend.

### 🔗 What's New
- **Practice ID** — every device now has a Practice ID (see Settings) that identifies your data as *yours*.
- **Merge across devices** — export your data on one device and **Merge** it into another. Your breath sessions, journal, and hold-time history **combine into one view** — so your streak, trends, and personal-best finally reflect *all* your practice, wherever you logged it. Merging only **adds** what's missing (never deletes), and re-merging the same file does nothing.
- **Safe by design** — a merge only combines data with the **same Practice ID**. A file from a different Practice ID is refused, so you can never accidentally mix someone else's practice into yours.
- **Restore (overwrite)** — the old "replace everything" import is still available as a clearly separate, confirm-gated option.

### 🌿 The spirit of it
- **Local-first, now with optional portability.** Everything still works fully offline with no account and no server — this simply lets *you* move and combine *your own* data between your devices.

### 💡 Tip — setting up a new device
Import your export **before** onboarding on a fresh device, so it adopts your Practice ID. (If you onboard first, the device creates its own ID and a merge will be refused as a mismatch.)

### Notes
- First release with a database schema migration (adds the Practice ID) — existing data is preserved automatically. Exporting a backup before updating is always good practice.

### Sprint(s)
- Sprint 44 — ★ Practice Sync Phase 0

### Smoke test
- See [`smoke-test.md`](./smoke-test.md) — ✅ **PASS (with notes)**, owner-run on real devices (iMac + iPad Mini): cross-device Merge both-ways + aggregate + owner-guard refusal + adopt-via-Restore. Three non-blocking items → v1.12.1 fast-follow.

---

> **Shipped:** 2026-09-15 · promotion PR #241 · tagged **`v1.12.0-web`** (target `prod`) · live at [saranidhi.vercel.app](https://saranidhi.vercel.app).
