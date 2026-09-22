[← Releases index](../../smoke-test-results.md)

# Release Dossier — v1.13.0-web

**Sprint 47 — ★ Practice Sync Phase 1: on-demand cross-device sync (PocketBase)** · Release pending · ⏳

The first real **cross-device sync over a network**, on the Phase-0 owner-identity + union-merge
foundation. Opt-in (default OFF) + manual **"Sync now"**: pull → union-merge → push of
**breath-sessions + journal** to a self-hosted **PocketBase** backend (**Fly.io**), keyed by
`(ownerId, uuid)`, with server-side owner-scoped rules + a client-side owner-guard. Offline-first
fully preserved. **This release reopens the network/account boundary** — hence a **security-review
redo** (done) and a live-backend smoke.

## Contents

| File | What |
| --- | --- |
| [`smoke-test.md`](./smoke-test.md) | Feature smoke — the sync round-trip (sign in → Sync now → cross-device) + opt-in/offline + regression + EN/TA |
| [`release-notes.md`](./release-notes.md) | Permanent GitHub Release record (tag / target / title / body) |
| [`docs-audit.md`](./docs-audit.md) | Owner-run docs-freshness gate |
| [`qa-verify-prompt.md`](./qa-verify-prompt.md) | Version-filled QA-Verify agent prompt |

## Links

- **Sprint dossier:** [`sprints/sprint-47-practice-sync-p1/`](../../../process/sprints/sprint-47-practice-sync-p1/README.md)
- **Epic:** [`sprint-backlog.md#-practice-sync--cross-device-aggregate`](../../../process/sprint-backlog.md#-practice-sync--cross-device-aggregate)
- **Backend runbook:** [`deployment/pocketbase-hosting.md`](../../deployment/pocketbase-hosting.md)
- **Changelog:** [`CHANGELOG.md`](../../../../CHANGELOG.md)
- **Releases index:** [`smoke-test-results.md`](../../smoke-test-results.md)

> **New this release — a live backend is part of the gate.** Unlike every prior web release (which
> only needed the Vercel preview), v1.13.0's smoke exercises a **real network round-trip** to the
> Fly.io PocketBase instance (`https://saranidhi-pb.fly.dev`). The preview build is wired with
> `--dart-define=POCKETBASE_URL=https://saranidhi-pb.fly.dev` (via `scripts/vercel_build.sh`), so
> Sync in the preview points at the live instance. **Highest-value scenario = the actual
> cross-device sync round-trip** (device A pushes → device B pulls → aggregate spans both).
>
> **Backend prerequisite: ✅ satisfied** — owner stood up the Fly instance (migration applied →
> `sessions`/`journal` collections live; a test user exists).
