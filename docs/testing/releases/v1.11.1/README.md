[← Releases index](../../smoke-test-results.md)

# Release Dossier — v1.11.1-web

**Sprint 43 — Localization Defect Fixes** · Release pending · ⏳

A small, cosmetic **localization patch** clearing three Tamil-mode defects (all the recurring
"label localized but value not" miss) plus one internal citation fix. No logic, no schema, no
migration.

- **About card** — Developer name now renders in Tamil (`இயலரசு`), consistent with the copyright line.
- **Analytics → Monthly Patterns** — best/worst **day names** now render in Tamil (e.g. `ஞாயிறு`), not English.
- **Best Times This Week** — yama badge now uses the localized prefix (`யா1`), not `Y1`.
- **Internal** — the Aruḍam "readiness" factor citation re-keyed to CONF-014 (doc/traceability only).

## Contents

| File | What |
| --- | --- |
| [`smoke-test.md`](./smoke-test.md) | Slim scenario plan (3 cards, Tamil eyeball) — executed on the PR preview |
| [`release-notes.md`](./release-notes.md) | Permanent GitHub Release record (tag / target / title / body) |
| [`docs-audit.md`](./docs-audit.md) | Owner-run docs-freshness gate |
| [`qa-verify-prompt.md`](./qa-verify-prompt.md) | Version-filled QA-Verify agent prompt for this release |

## Links

- **Sprint dossier:** [`sprints/sprint-43-l10n-fixes/`](../../../process/sprints/sprint-43-l10n-fixes/README.md)
- **Changelog:** [`CHANGELOG.md`](../../../../CHANGELOG.md)
- **Releases index:** [`smoke-test-results.md`](../../smoke-test-results.md)

> **Release flow note:** cosmetic l10n patch → **slim gate** (CI green + a Tamil-mode eyeball of
> the three cards on the preview), not a full smoke matrix — consistent with the v1.10.1 light
> patch. The full dossier folder is kept for audit uniformity.
