[← Back to Smoke Test](./smoke-test-v1.8.0.md)

# Docs Freshness Audit — v1.8.0-web

> **Owner-run transactional gate** (the doc equivalent of the smoke test) — **first use
> of this gate.** Created at `/release-start`, ticked by the **owner** during release
> verification, confirmed PASS at `/release-update`. Goal: no durable doc silently rots.
> A doc is "fresh" if its content AND its `> Reviewed:` stamp reflect this release.

## Release under audit

- **Version:** v1.8.0-web · **Sprint(s):** 38 · **Audited by:** _(owner)_ · **Date:** ____

## Freshness checklist

> Pre-ticked = already verified/updated during the Sprint 38 cycle (feature PR #181 +
> `/sprint-update` PR #183 + this `/release-start`). Owner confirms during release.
> The **stamp bump** column is where `/release-update` bumps each durable doc's
> `> Reviewed:` line from `v1.7.0-web` → `v1.8.0-web`.

| ✓ | Doc | Verify | Stamp → v1.8.0 |
|:-:|-----|--------|:--------------:|
| ⬜ | `README.md` | Current Status block (v1.8.0, 38 sprints, PR count, Latest/Next) | n/a (has status block) — **update at `/release-update`** |
| ⬜ | `docs/README.md` | Index still matches the doc set (adds release-notes/docs-audit under releases/) | n/a |
| ✅ | `docs/process/project-valuation-report.md` | Sprint 38 row + hours (116.5) + exec summary — done in #183 | ⬜ |
| ✅ | `docs/process/project-evaluation.md` | Test params 564 + progression + night-floor-lock defect — done in #183 | ⬜ |
| ⬜ | `docs/process/sprint-tracker.md` | Flip Sprint 38 row to ✅ 🚀 + current-state → v1.8.0 live | ⬜ |
| ⬜ | `docs/process/sprint-backlog.md` | Flagship slice-1 items → done; fast-follows remain | ⬜ |
| ✅ | `docs/process/dev-workflow.md` | No protocol/gate change this release | ⬜ |
| ✅ | `docs/product/user-guide.md` | "Aruḍam Now" section — done in #181 | ⬜ |
| ✅ | `docs/product/product-scope.md` | Scope/North Star still accurate (no change) | ⬜ |
| ✅ | `docs/reference/architecture.md` | No infra/schema change beyond the schema-v6 flag (noted) | ⬜ |
| ✅ / N/A | `docs/reference/security-review.md` | **N/A** — no data/network boundary change this release (local-first unchanged) | N/A |
| ✅ | `docs/testing/testing-plan.md` | Test-count progression → 564 — done in #183 | ⬜ |
| ⬜ | `docs/testing/smoke-test-results.md` | Add the v1.8.0 row (✅ PASS, date) — at `/release-update` | n/a (index) |
| ⬜ | `CHANGELOG.md` | Set the release date (remove "Pending") — at `/release-update` | n/a |
| ✅ | Sprint dossier `sprints/sprint-38-integrated-arudam/README.md` | Links spec → impl → test → PR #181 → release | n/a |
| ✅ | `AI_COLLABORATION_FRAMEWORK.md` | No flow/role change this release | ⬜ |

> **Stamp rule:** each durable doc carries `> **Reviewed:** vX.Y.Z` near the top. A stamp
> older than the current prod version is a red flag. **All durable-doc stamps are still at
> `v1.7.0-web`** — the `/release-update` step bumps them to `v1.8.0-web` (the ⬜ cells in
> the last column). This is the first release exercising the stamp/gate mechanism.

## Findings / doc fixes made this release

- Smoke test relocated from the sprint dossier folder → `docs/testing/releases/smoke-test-v1.8.0.md` (repo convention) during `/release-start`.
-

## Result

- **Docs audit:** ⬜ PASS (all applicable rows ✅) — safe to close the release at `/release-update`.
