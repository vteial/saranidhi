[← Releases index](../../smoke-test-results.md)

# Release Dossier — v1.10.1-web

**Sprint 41 — Analytics Tidy + Tamil l10n** · Shipped to production 2026-09-13 · ⚠️ PASS (1 known cosmetic bug) · **Light patch**

A small housekeeping patch: the journal **CSV export moved to Settings** (beside the JSON
export; now shares via the share sheet → works on web too), and the **Analytics-screen Tamil
localization** gaps were fixed (Yama prefix, locale-aware dates, unit suffixes). **No core-calc /
engine change** — closer to a hotfix profile than a feature release, so the smoke gate is **slim**
(the widget-move + l10n paths CI can't fully catch), not the full 8-scenario matrix.

## Contents

| File | What |
| --- | --- |
| [`smoke-test.md`](./smoke-test.md) | Slim scenario plan (CSV-from-Settings + Analytics Tamil) |
| [`release-notes.md`](./release-notes.md) | Permanent GitHub Release record (tag / target / title / body) |
| [`docs-audit.md`](./docs-audit.md) | Owner-run docs-freshness gate |
| [`qa-verify-prompt.md`](./qa-verify-prompt.md) | Version-filled QA-Verify agent prompt for this release |

## Links

- **Sprint dossier:** [`sprints/sprint-41-analytics-tidy/`](../../../process/sprints/sprint-41-analytics-tidy/README.md)
- **Changelog:** [`CHANGELOG.md`](../../../../CHANGELOG.md)
- **Releases index:** [`smoke-test-results.md`](../../smoke-test-results.md)
