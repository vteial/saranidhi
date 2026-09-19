[← Back to Smoke Test](./smoke-test.md)

# Docs Freshness Audit — v1.13.0-web

> **Owner-run transactional gate** (the doc equivalent of the smoke test). Created at
> `/release-start`, ticked by the **owner** during release verification, confirmed PASS at
> `/release-update`. A doc is "fresh" if its content AND its `> Reviewed:` stamp reflect this release.

## Release under audit

- **Version:** v1.13.0-web · **Sprint(s):** 47 · **Audited by:** owner + Kiro Web · **Date:** _pending_
- **Nature:** **feature minor** — first **network/account/off-device boundary reopening** since
  local-first. No local schema change (schema v7, export v2); adds an opt-in PocketBase sync path.

## Freshness checklist

> **Stamp bump:** `/release-update` bumps each durable doc's `> Reviewed:` line
> `v1.12.1-web` → `v1.13.0-web`. **`security-review.md` is a REAL review this release** (data/network
> boundary changed) — it was re-run in the feature PR #260; the audit confirms + re-stamps it.

| ✓ | Doc | Verify | Stamp → v1.13.0 |
|:-:|-----|--------|:--------------:|
| ⬜ | `README.md` | Current Status → v1.13.0 (once released), 47 sprints, PRs, Latest/Next | n/a (status block) |
| ⬜ | `docs/README.md` | Index matches doc set (pocketbase-hosting.md present) | n/a |
| ⬜ | `docs/process/project-valuation-report.md` | Sprint 46+47 rows + hours (~157.5) + exec (677 tests, v1.13.0) — landed via `/sprint-update` #263 | ✅ |
| ⬜ | `docs/process/project-evaluation.md` | Test count 677 + progression (Sprint 47 +16) — via #263 | ✅ |
| ⬜ | `docs/process/sprint-tracker.md` | Sprint 47 row ✅ (PR #260); flip to ✅ 🚀 + current-state → v1.13.0 live at `/release-update` | ✅ |
| ⬜ | `docs/process/sprint-backlog.md` | Practice Sync Phase 1 row done; auto-on-open fast-follow + device-registry rows accurate | ✅ |
| ⬜ | `docs/process/dev-workflow.md` | No protocol/gate change this release | ✅ |
| ⬜ | `docs/product/user-guide.md` | Practice Sync section (enable Sync + sign in + what syncs + opt-in/offline) present — added in #260 | ✅ |
| ⬜ | `docs/product/product-scope.md` | Confirm the network-boundary reopening is reflected (local-first WITH opt-in sync) — add a line if missing | ✅ |
| ⬜ | `docs/reference/architecture.md` | `SyncTransport` + `PocketBaseSyncTransport` + `PracticeSyncEngine` + Fly/Compose topology — added in #260 | ✅ |
| ⬜ | `docs/reference/security-review.md` | **REAL REVIEW (not stamp-only)** — network path, per-user auth token, owner-scoped server rules + client guard, data egress, opt-in consent. Re-run in #260; **confirm the assessment + re-stamp v1.13.0**. | ✅ (review + bump) |
| ⬜ | `docs/reference/calculation-methodology.md` | No calc change this release | n/a (research doc) |
| ⬜ | `docs/deployment/pocketbase-hosting.md` | Backend runbook matches the shipped Fly instance + rules | n/a (runbook) |
| ⬜ | `docs/testing/testing-plan.md` | Test-count progression (Sprint 47 +16 → 677) — via #263 | ✅ |
| ⬜ | `docs/testing/smoke-test-results.md` | Add the v1.13.0 row (status set at `/release-update`) | n/a (index) |
| ⬜ | `CHANGELOG.md` | `[1.13.0-web]` entry present; date set at `/release-update` | n/a |
| ⬜ | Sprint dossier `sprints/sprint-47-practice-sync-p1/README.md` | Links spec → impl → test → PR #260 → release | n/a |
| ⬜ | `AI_COLLABORATION_FRAMEWORK.md` | No flow/role change this release; stamp bumped | ✅ |

> **Stamp rule:** each durable doc carries `> **Reviewed:** vX.Y.Z`. 11 durable docs read
> `v1.12.1-web` → bump to `v1.13.0-web` at `/release-update`. **security-review.md = real re-review
> this release** (network boundary), not stamp-only.

## Notes for this release

- **`/sprint-update` (#263) already landed** — valuation (Sprint 46 + 47, ~157.5h), evaluation
  (677 tests), testing-plan progression are on `main`. No carry-over.
- **Backend prerequisite ✅** — Fly PocketBase live (`https://saranidhi-pb.fly.dev`), migration
  applied, test user exists. The preview build injects `POCKETBASE_URL` via `scripts/vercel_build.sh`.
- **security-review re-review confirmed** — the network boundary was assessed in #260; the audit's
  job is to confirm it's accurate for what shipped and re-stamp to v1.13.0.

## Result

- **Docs audit:** ⏳ _pending_ — owner ticks each applicable row during release verification; confirmed PASS at `/release-update`.
