[← Back to Smoke Test](./smoke-test.md)

# Docs Freshness Audit — v1.12.1-web

> **Owner-run transactional gate** (the doc equivalent of the smoke test). Created at
> `/release-start`, ticked by the **owner** during release verification, confirmed PASS at
> `/release-update`. A doc is "fresh" if its content AND its `> Reviewed:` stamp reflect this release.

## Release under audit

- **Version:** v1.12.1-web · **Sprint(s):** 45 · **Audited by:** owner + Kiro Web · **Date:** _pending_
- **Nature:** light **patch** (Practice-Sync polish) — **no schema change** (schema v7, export v2).

## Freshness checklist

> **Stamp bump:** `/release-update` bumps each durable doc's `> Reviewed:` line
> `v1.12.0-web` → `v1.12.1-web`. Because this is a patch with no data/network-boundary change,
> **`security-review.md` is stamp-only this release** (the boundary was reviewed at v1.12.0; no new
> surface here).

| ✓ | Doc | Verify | Stamp → v1.12.1 |
|:-:|-----|--------|:--------------:|
| ⬜ | `README.md` | Current Status → v1.12.1 (once released), 45 sprints, PRs, Latest/Next | n/a (status block) |
| ⬜ | `docs/README.md` | Index still matches the doc set | n/a |
| ⬜ | `docs/process/project-valuation-report.md` | Sprint 45 row + hours + exec summary — **pending `/sprint-update`** (see note) | ⬜ |
| ⬜ | `docs/process/project-evaluation.md` | Test count (+12 → ~661 local / new-baseline) + progression + Resolved-Defect row (BUG-v1.12.0-01) — **pending `/sprint-update`** | ⬜ |
| ⬜ | `docs/process/sprint-tracker.md` | Sprint 45 row ✅ (PR #244); flip to ✅ 🚀 + current-state → v1.12.1 live at `/release-update` | ⬜ |
| ⬜ | `docs/process/sprint-backlog.md` | The three v1.12.1 fast-follow rows → done; Practice Sync Phase 1 accurate | ⬜ |
| ⬜ | `docs/process/dev-workflow.md` | No protocol/gate change this release | ⬜ |
| ⬜ | `docs/product/user-guide.md` | "Set up a new device by importing" present (FAQ string added in #244); confirm the guide body mentions it too | ⬜ |
| ⬜ | `docs/product/product-scope.md` | No principle change this release (portability was reframed at v1.12.0) | ⬜ |
| ⬜ | `docs/reference/architecture.md` | Shared `MergeImportController` + `profileProvider` + import-before-onboarding path — confirm noted (add a line if wanted) | ⬜ |
| ⬜ | `docs/reference/security-review.md` | **Stamp-only** — no data/network-boundary change (patch over v1.12.0's already-reviewed model) | ⬜ (stamp only) |
| ⬜ | `docs/reference/calculation-methodology.md` | No calc change this release | n/a (research doc) |
| ⬜ | `docs/testing/testing-plan.md` | Test-count progression (+12) — **pending `/sprint-update`** | ⬜ |
| ⬜ | `docs/testing/smoke-test-results.md` | Add the v1.12.1 row (status set at `/release-update`) | n/a (index) |
| ⬜ | `CHANGELOG.md` | `[1.12.1-web]` entry present; date set at `/release-update` | n/a |
| ⬜ | Sprint dossier `sprints/sprint-45-practice-sync-polish/README.md` | Links spec → impl → test → PR #244 → release | n/a |
| ⬜ | `AI_COLLABORATION_FRAMEWORK.md` | No flow/role change this release; stamp bumped | ⬜ |

> **Stamp rule:** each durable doc carries `> **Reviewed:** vX.Y.Z`. 11 durable docs read
> `v1.12.0-web` → bump to `v1.12.1-web` at `/release-update` (`security-review.md` = stamp-only).

## Open note carried into this release

- **`/sprint-update` was NOT run before `/release-start` this cycle.** The Sprint 45 **valuation
  row**, **evaluation test-count/Resolved-Defect row**, and **testing-plan progression** are still
  pending. Options: (a) run `/sprint-update` as a separate docs PR before merge, or (b) fold those
  edits onto this release branch. Whichever is chosen, the docs-audit must confirm they landed
  **before** `/release-update` marks PASS. (Kiro flagged this at `/release-start`.)

## Result

- **Docs audit:** ⏳ _pending_ — owner ticks each applicable row during release verification; confirmed PASS at `/release-update`.
