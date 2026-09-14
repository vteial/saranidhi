[← Releases index](../../smoke-test-results.md)

# Release Dossier — v1.12.0-web

**Sprint 44 — ★ Practice Sync Phase 0: owner-stamped safe merge-import** · Release pending · ⏳

The first **cross-device data-portability** step. Each install gets a locally-generated
**Practice ID** (`ownerId`); the destructive JSON import is replaced by a **non-destructive
union-merge by UUID** guarded by owner identity — so the owner can **aggregate practice data
across devices** (streak / hold-time / personal-best now span all devices) with **zero backend**,
and mixing another person's data is structurally refused. Reframes the principle to
*local-first **with optional, user-owned sync***.

## Contents

| File | What |
| --- | --- |
| [`smoke-test.md`](./smoke-test.md) | Full scenario plan (migration + cross-device merge + owner guard + aggregate + Restore + bilingual + regression) |
| [`release-notes.md`](./release-notes.md) | Permanent GitHub Release record (tag / target / title / body) |
| [`docs-audit.md`](./docs-audit.md) | Owner-run docs-freshness gate |
| [`qa-verify-prompt.md`](./qa-verify-prompt.md) | Version-filled QA-Verify agent prompt for this release |

## Links

- **Sprint dossier:** [`sprints/sprint-44-practice-sync-p0/`](../../../process/sprints/sprint-44-practice-sync-p0/README.md)
- **Epic:** [`sprint-backlog.md#-practice-sync--cross-device-aggregate`](../../../process/sprint-backlog.md#-practice-sync--cross-device-aggregate)
- **Changelog:** [`CHANGELOG.md`](../../../../CHANGELOG.md)
- **Releases index:** [`smoke-test-results.md`](../../smoke-test-results.md)

> **Release flow:** **full smoke matrix** (real capability + a schema migration touching user
> data — not a light patch). Highest-value scenario = the genuine **cross-device flow on real
> devices** (export from one → merge on another → aggregate spans both).
