[← Back to Smoke Test](./smoke-test.md)

# Docs Freshness Audit — v1.12.0-web

> **Owner-run transactional gate** (the doc equivalent of the smoke test). Created at
> `/release-start`, ticked by the **owner** during release verification, confirmed PASS at
> `/release-update`. A doc is "fresh" if its content AND its `> Reviewed:` stamp reflect this release.

## Release under audit

- **Version:** v1.12.0-web · **Sprint(s):** 44 · **Audited by:** owner + Kiro Web · **Date:** _pending_

## Freshness checklist

> Verified/updated during the Sprint 44 cycle (feature PR #236 + `/sprint-finish` #237 +
> `/sprint-update` #238 + this `/release-start`). **Stamp bump:** `/release-update` bumps each
> durable doc's `> Reviewed:` line `v1.11.1-web` → `v1.12.0-web`. NOTE: `user-guide.md` is already
> at **v1.12.0-web** (refreshed in the feature PR) — the other 10 durable docs bump this release.

| ✓ | Doc | Verify | Stamp → v1.12.0 |
|:-:|-----|--------|:--------------:|
| ⬜ | `README.md` | Current Status → v1.12.0 (once released), 44 sprints, PRs, Latest/Next | n/a (status block) |
| ⬜ | `docs/README.md` | Index still matches the doc set | n/a |
| ⬜ | `docs/process/project-valuation-report.md` | Sprint 44 row + hours (~143.5) + exec summary (649 tests) — done in #238 | ⬜ |
| ⬜ | `docs/process/project-evaluation.md` | Test count 649 + progression (Sprint 44 +17) + 2 Resolved-Defect rows — done in #238 | ⬜ |
| ⬜ | `docs/process/sprint-tracker.md` | Sprint 44 row ✅ (PR #236); flip to ✅ 🚀 + current-state → v1.12.0 live at `/release-update` | ⬜ |
| ⬜ | `docs/process/sprint-backlog.md` | Practice Sync Phase 0 done; Phase 1 (auto-sync) + device-registry rows accurate | ⬜ |
| ⬜ | `docs/process/dev-workflow.md` | No protocol/gate change this release | ⬜ |
| ⬜ | `docs/product/user-guide.md` | Multi-device "export & merge" + Practice ID + **import-before-onboarding** tip present — done in #236 | ✅ (already v1.12.0) |
| ⬜ | `docs/product/product-scope.md` | **Principle reframed** to *local-first WITH optional user-owned sync* — confirm captured (add if missing) | ⬜ |
| ⬜ | `docs/reference/architecture.md` | Owner-id + union-merge model + schema v7 — done in #236 | ⬜ |
| ⬜ | `docs/reference/security-review.md` | **REVIEW (not stamp-only)** — data boundary changed: owner identity + export now carries it + a merge-import path. Phase 0 is still **local-only / no network / no account** (files only), but confirm the review notes: (a) no new network/telemetry surface; (b) the owner-guard prevents cross-user data ingestion; (c) Phase-1 auto-sync WILL require a full re-review (network + account + possible stored secret). | ⬜ (review + bump) |
| ⬜ | `docs/reference/calculation-methodology.md` | No calc change this release | n/a (research doc) |
| ⬜ | `docs/testing/testing-plan.md` | Test-count progression → 649 — done in #238 | ⬜ |
| ⬜ | `docs/testing/smoke-test-results.md` | Add the v1.12.0 row (status set at `/release-update`) | n/a (index) |
| ⬜ | `CHANGELOG.md` | `[1.12.0-web]` entry present; date set at `/release-update` | n/a |
| ⬜ | Sprint dossier `sprints/sprint-44-practice-sync-p0/README.md` | Links spec → impl → test → PR #236 → release | n/a |
| ⬜ | `AI_COLLABORATION_FRAMEWORK.md` | No flow/role change this release; stamp bumped | ⬜ |

> **Stamp rule:** each durable doc carries `> **Reviewed:** vX.Y.Z`. 10 durable docs read
> `v1.11.1-web` → bump to `v1.12.0-web` at `/release-update` (`user-guide.md` already v1.12.0).

## Findings / doc fixes made this release

- **`security-review.md` needs a real review this release** (data-boundary change — first data-portability feature), not just a stamp. Confirm: local-only, no network, owner-guard blocks cross-user ingestion; note Phase-1 will need a full re-review.
- **`product-scope.md`** — confirm the reframed principle (*local-first with optional, user-owned sync*) is captured; add a line if missing.
- _(other rows pending owner verification during release)_

## Result

- **Docs audit:** ⏳ _pending_ — owner ticks each applicable row during release verification; confirmed PASS at `/release-update`.
