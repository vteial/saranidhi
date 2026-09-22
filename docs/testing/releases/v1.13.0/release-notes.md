[← Back to Smoke Test](./smoke-test.md) · [Releases index](../../smoke-test-results.md)

# Release Notes — v1.13.0-web

> Permanent record of the GitHub Release. The owner creates the tag/release from the GitHub UI;
> this file is the source text. Drafted at `/release-start`, finalized at `/release-update`.

## Tag details (copy into the GitHub Release UI)

| Field | Value |
|-------|-------|
| **Tag** | `v1.13.0-web` |
| **Target** | `prod` branch |
| **Title** | `v1.13.0-web — Practice Sync: sync your practice across devices` |

## Release notes (body)

Your breath practice, together across your devices — safely, and only when you choose. v1.13.0 adds
**opt-in cross-device sync** on top of the local-first app.

### 🔗 What's New
- **Practice Sync (opt-in).** Turn on Sync in Settings, sign in, and tap **"Sync now"** to combine
  your **breath sessions and journal** across devices — your streak, trends, and hold-time history
  finally reflect *all* your practice, wherever you logged it.
- **You choose what syncs** — independent toggles for **Sessions** and **Journal** (both on by
  default; Journal is what powers your streak & hold-time stats).
- **Safe by design** — sync only ever combines *your own* data (guarded by your Practice ID on both
  the app and the server); it **only adds, never deletes**, and re-syncing the same data does
  nothing.

### 🌿 The spirit of it
- **Still local-first.** Everything works fully offline with no sign-in — Sync is **off by default**
  and is purely additive. It's your data, moved between your devices only when you ask.

### 🔒 Under the hood
- Sync uses a self-hosted **PocketBase** backend (your own instance) behind a swappable transport
  layer — a deliberately lean, owned, consent-based design. A full **security review** accompanies
  this release (network path, per-user auth, owner-scoped access, data egress).

### Notes
- No local database change this release. If you don't turn Sync on, nothing about the app changes.
- Hardened during smoke: four fixes landed on the release branch — auth-state surfacing, binding your
  Practice ID to your account, and two PocketBase schema corrections (falsy-value fields; per-owner
  uniqueness). Friendlier error messages + in-app account creation are coming in **v1.13.1**.

### Sprint(s)
- Sprint 47 — ★ Practice Sync Phase 1

### Smoke test
- See [`smoke-test.md`](./smoke-test.md) — feature smoke incl. the live cross-device round-trip
  against the PocketBase backend, opt-in/offline behavior, owner-guard, regression, EN/TA.

---

> **Shipped:** 2026-09-16 — promotion PR #267 · tagged **`v1.13.0-web`** (target `prod`) · live at [saranidhi.vercel.app](https://saranidhi.vercel.app).
