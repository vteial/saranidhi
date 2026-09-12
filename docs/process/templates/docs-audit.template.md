[← Back to Smoke Test](../../testing/releases/smoke-test-vX.Y.Z.md)

# Docs Freshness Audit — vX.Y.Z-web

> **Owner-run transactional gate** (the doc equivalent of the smoke test). Created at
> `/release-start`, ticked by the **owner** during release verification, committed as the
> audit record. Goal: no durable doc silently rots. A doc is "fresh" if its content AND
> its `> Reviewed:` stamp reflect this release. **Do not** issue `/release-finish` (or, at
> the latest, close `/release-update`) until every applicable row is ✅ or explicitly N/A.
>
> Lives beside the release's [`smoke-test-vX.Y.Z.md`](../../testing/releases/smoke-test-vX.Y.Z.md)
> and [`release-notes-vX.Y.Z.md`](../../testing/releases/release-notes-vX.Y.Z.md).

## Release under audit

- **Version:** vX.Y.Z-web · **Sprint(s):** NN · **Audited by:** _(owner)_ · **Date:** ____

## Freshness checklist

| ✓ | Doc | Verify | Stamp bumped? |
|:-:|-----|--------|:-------------:|
| ☐ | `README.md` | Current Status table (version, sprints, PRs, hours), Latest/Next, Development section | n/a (has status block) |
| ☐ | `docs/README.md` | Index rows still match the actual doc set (no new/renamed/removed docs missing) | n/a |
| ☐ | `docs/process/project-valuation-report.md` | Executive summary (prod version), new Sprint Delivery Summary row, phase hours | ☐ |
| ☐ | `docs/process/project-evaluation.md` | Resolved Defects log has this release's fixes; test baseline current | ☐ |
| ☐ | `docs/process/sprint-tracker.md` | Sprint row flipped ✅ 🚀; "current state" note = new prod version | ☐ |
| ☐ | `docs/process/sprint-backlog.md` | Shipped items removed/moved; next-up reflects reality | ☐ |
| ☐ | `docs/process/dev-workflow.md` | Any protocol/gate/threshold change this release captured | ☐ |
| ☐ | `docs/product/user-guide.md` | Reflects features/behavior shipped this release | ☐ |
| ☐ | `docs/product/product-scope.md` | Scope/North Star still accurate | ☐ |
| ☐ | `docs/reference/architecture.md` | New infra/schema/patterns from this release | ☐ |
| ☐ | `docs/reference/security-review.md` | Only if the data/network boundary changed this release (else N/A) | ☐ / N/A |
| ☐ | `docs/testing/testing-plan.md` | Test-count progression + new scenarios | ☐ |
| ☐ | `docs/testing/smoke-test-results.md` | New version row added (✅ PASS, date) | n/a (index) |
| ☐ | `CHANGELOG.md` | Release date set (not "Pending") | n/a |
| ☐ | Sprint dossier `docs/process/sprints/sprint-NN-*/README.md` | Index links spec → impl → test → PR → release | n/a |

> **Stamp rule:** each durable doc carries a `> **Reviewed:** vX.Y.Z` line near the top.
> Bumping it to this release is the visible signal the doc was checked. A stamp older than
> the current prod version = a red flag to investigate in this audit.

## Findings / doc fixes made this release

> List any doc that was found stale and the fix (PR/commit). If a doc is intentionally
> left at an older stamp (e.g. security-review — no boundary change), note it here as N/A.

-

## Result

- **Docs audit:** ☐ PASS (all applicable rows ✅) — safe to close the release.
