[← Back to Smoke Test](../../testing/releases/smoke-test-vX.Y.Z.md)

# Docs Freshness Audit — vX.Y.Z-web

> **Owner-run transactional gate** (the doc equivalent of the smoke test). Created at
> `/release-start`, ticked by the **owner** during release verification, confirmed PASS
> at `/release-update`. Goal: no durable doc silently rots. A doc is "fresh" if its
> content AND its `> Reviewed:` stamp reflect this release.

## Release under audit

- **Version:** vX.Y.Z-web · **Sprint(s):** NN · **Audited by:** _(owner)_ · **Date:** ____

## Freshness checklist

| ✓ | Doc | Verify | Stamp → vX.Y.Z |
|:-:|-----|--------|:--------------:|
| ⬜ | `README.md` | Current Status block (version, sprints, PR count, Latest/Next) | n/a (status block) |
| ⬜ | `docs/README.md` | Index still matches the doc set | n/a |
| ⬜ | `docs/process/project-valuation-report.md` | Sprint row + hours + exec summary | ⬜ |
| ⬜ | `docs/process/project-evaluation.md` | Defects log + test baseline current | ⬜ |
| ⬜ | `docs/process/sprint-tracker.md` | Sprint row flipped ✅ 🚀 + current-state = new version | ⬜ |
| ⬜ | `docs/process/sprint-backlog.md` | Shipped items removed/moved; next-up accurate | ⬜ |
| ⬜ | `docs/process/dev-workflow.md` | Any protocol/gate/threshold change captured | ⬜ |
| ⬜ | `docs/product/user-guide.md` | Reflects features/behavior shipped | ⬜ |
| ⬜ | `docs/product/product-scope.md` | Scope/North Star still accurate | ⬜ |
| ⬜ | `docs/reference/architecture.md` | New infra/schema/patterns | ⬜ |
| ⬜ / N/A | `docs/reference/security-review.md` | Only if the data/network boundary changed this release | ⬜ / N/A |
| ⬜ | `docs/testing/testing-plan.md` | Test-count progression + new scenarios | ⬜ |
| ⬜ | `docs/testing/smoke-test-results.md` | New version row added (✅ PASS, date) | n/a (index) |
| ⬜ | `CHANGELOG.md` | Release date set (not "Pending") | n/a |
| ⬜ | Sprint dossier `sprints/sprint-NN-*/README.md` | Links spec → impl → test → PR → release | n/a |
| ⬜ | `AI_COLLABORATION_FRAMEWORK.md` | Any flow/role change this release | ⬜ |

> **Stamp rule:** each durable doc carries `> **Reviewed:** vX.Y.Z` near the top. A stamp
> older than the current prod version is a red flag to resolve in this audit.

## Findings / doc fixes made this release

-

## Result

- **Docs audit:** ⬜ PASS (all applicable rows ✅) — safe to close the release at `/release-update`.
