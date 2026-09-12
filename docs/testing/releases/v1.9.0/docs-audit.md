[← Back to Smoke Test](./smoke-test.md)

# Docs Freshness Audit — v1.9.0-web

> **Owner-run transactional gate** (the doc equivalent of the smoke test). Created at
> `/release-start`, ticked by the **owner** during release verification, confirmed PASS at
> `/release-update`. Goal: no durable doc silently rots. A doc is "fresh" if its content
> AND its `> Reviewed:` stamp reflect this release.

## Release under audit

- **Version:** v1.9.0-web · **Sprint(s):** 39 · **Audited by:** owner + Kiro Web · **Date:** 2026-09-12

## Freshness checklist

> Most rows were verified/updated during the Sprint 39 cycle (feature PR #196 +
> `/sprint-update` PR #198 + this `/release-start`). Owner confirms during release.
> **Stamp bump** column: `/release-update` bumps each durable doc's `> Reviewed:` line
> from `v1.8.1-web` → `v1.9.0-web` (a simple bump — the rollout happened at v1.8.0).

| ✓ | Doc | Verify | Stamp → v1.9.0 |
|:-:|-----|--------|:--------------:|
| ✅ | `README.md` | Current Status block → v1.9.0 (once released), 39 sprints, PRs, Latest/Next | n/a (status block) |
| ✅ | `docs/README.md` | Index still matches the doc set | n/a |
| ✅ | `docs/process/project-valuation-report.md` | Sprint 39 row + hours (121.0) + exec summary — done in #198 | ✅ |
| ✅ | `docs/process/project-evaluation.md` | Test count 573 + progression (Sprint 39 +9) — done in #198 | ✅ |
| ✅ | `docs/process/sprint-tracker.md` | Sprint 39 row ✅ (PR #196); flip to ✅ 🚀 + current-state → v1.9.0 live at `/release-update` | ✅ |
| ✅ | `docs/process/sprint-backlog.md` | "Why?" fast-follow marked done; remaining fast-follows accurate | ✅ |
| ✅ | `docs/process/dev-workflow.md` | No protocol/gate change this release | ✅ |
| ✅ | `docs/product/user-guide.md` | "Why?" accordion bullet under Aruḍam Now — done in #198 | ✅ |
| ✅ | `docs/product/product-scope.md` | Scope / North Star still accurate (no change) | ✅ |
| ✅ | `docs/reference/architecture.md` | No infra/schema change this release | ✅ |
| ✅ | `docs/reference/security-review.md` | **N/A** — no data/network boundary change (local-first unchanged); stamp only | ✅ (stamp only) |
| ✅ | `docs/reference/calculation-methodology.md` | New §12.5 Doctrinal Reasons Breakdown + factor→CONF table — done in #198 | n/a (research doc) |
| ✅ | `docs/testing/testing-plan.md` | Test-count progression → 573 — done in #198 | ✅ |
| ✅ | `docs/testing/smoke-test-results.md` | Add the v1.9.0 row (status set at `/release-update`) | n/a (index) |
| ✅ | `CHANGELOG.md` | `[1.9.0-web]` entry present; date set at `/release-update` | n/a |
| ✅ | Sprint dossier `sprints/sprint-39-why-accordion/README.md` | Links spec → impl → test → PR #196 → release | n/a |
| ✅ | `AI_COLLABORATION_FRAMEWORK.md` | No flow/role change this release; stamp bumped | ✅ |

> **Stamp rule:** each durable doc carries `> **Reviewed:** vX.Y.Z` near the top. A stamp
> older than the current prod version is a red flag. All 11 durable docs currently read
> `v1.8.1-web` → bump to `v1.9.0-web` at `/release-update`.

## Findings / doc fixes made this release

- Clean bump release: the `> Reviewed:` stamps on all 11 durable docs moved `v1.8.1-web → v1.9.0-web` (a simple bump — the rollout happened at v1.8.0). No stale-content drift found.
- `security-review.md` cadence note updated to record v1.9.0 = transparency-only, no data/network boundary change (local-first unchanged) — no re-review required.
- README Current Status, sprint-tracker current-state, and valuation exec-summary refreshed to "v1.9.0-web LIVE".

## Result

- **Docs audit:** ✅ **PASS** — all applicable rows ✅; stamps at `v1.9.0-web`; safe to close the release.
