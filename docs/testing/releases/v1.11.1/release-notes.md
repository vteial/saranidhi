[← Back to Smoke Test](./smoke-test.md) · [Releases index](../../smoke-test-results.md)

# Release Notes — v1.11.1-web

> Permanent record of the GitHub Release. The owner creates the tag/release from the
> GitHub UI; this file is the source text so the release stays auditable/reproducible.
> Drafted at `/release-start`, finalized at `/release-update`.

## Tag details (copy into the GitHub Release UI)

| Field | Value |
|-------|-------|
| **Tag** | `v1.11.1-web` |
| **Target** | `prod` branch |
| **Title** | `v1.11.1-web — Localization Defect Fixes` |

## Release notes (body)

A small polish patch fixing three spots where Tamil mode showed English text.

### 🐛 Fixed
- **About card** — the Developer name now displays in Tamil (`இயலரசு`), consistent with the copyright line (previously it stayed `Eialarasu` in Tamil mode).
- **Analytics → Monthly Patterns** — the Best / Needs-Attention **day names** now render in Tamil (e.g. `ஞாயிறு`) instead of English.
- **Best Times This Week** — the yama badge now uses the localized prefix (`யா1`) instead of `Y1`.

### 🔧 Internal
- The Aruḍam "readiness" factor's provenance citation was re-keyed to CONF-014 (the swara clock) — a documentation/traceability fix only, no behavior change.

### Notes
- Cosmetic localization only — no logic, schema, migration, permissions, or data changes.

### Sprint(s)
- Sprint 43 — Localization Defect Fixes

### Smoke test
- See [`smoke-test.md`](./smoke-test.md) — ✅ **PASS** (slim Tamil-mode gate: 3 cards + a column-width fit scenario + regression) + docs-audit ✅ PASS.

---

> **Shipped:** 2026-09-14 · promotion PR #233 · tagged **`v1.11.1-web`** (target `prod`) · live at [saranidhi.vercel.app](https://saranidhi.vercel.app).
