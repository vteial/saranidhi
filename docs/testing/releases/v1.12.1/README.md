[← Releases index](../../smoke-test-results.md)

# Release Dossier — v1.12.1-web

**Sprint 45 — Practice Sync polish** (v1.12.0 fast-follow) · Release pending · ⏳

A light patch smoothing cross-device setup: an onboarding **"Import from another device"** link
(adopt your Practice ID before onboarding), the **Practice ID refreshing in place** after a
Merge/Restore, and the **Practice ID in export filenames**. **No schema change** (schema v7,
export v2).

## Contents

| File | What |
| --- | --- |
| [`smoke-test.md`](./smoke-test.md) | Targeted patch smoke (3 changed behaviors + EN/TA + regression) |
| [`release-notes.md`](./release-notes.md) | Permanent GitHub Release record (tag / target / title / body) |
| [`docs-audit.md`](./docs-audit.md) | Owner-run docs-freshness gate |
| [`qa-verify-prompt.md`](./qa-verify-prompt.md) | Version-filled QA-Verify agent prompt (if an Antigravity run is used) |

## Links

- **Sprint dossier:** [`sprints/sprint-45-practice-sync-polish/`](../../../process/sprints/sprint-45-practice-sync-polish/README.md)
- **Epic:** [`sprint-backlog.md#-practice-sync--cross-device-aggregate`](../../../process/sprint-backlog.md#-practice-sync--cross-device-aggregate)
- **Changelog:** [`CHANGELOG.md`](../../../../CHANGELOG.md)
- **Releases index:** [`smoke-test-results.md`](../../smoke-test-results.md)

> **Release flow:** **targeted patch smoke** (light polish, no schema change — like v1.8.1 / v1.11.1,
> not the full matrix v1.12.0 got). The one genuinely new UX flow — **import-before-onboarding on a
> new device (S1)** — is the highest-value scenario and is owner/QA-verifiable on the preview. CI
> green + the S1–S6 targeted smoke on the preview is the proportionate gate.
>
> **Carry-over note:** `/sprint-update` (Sprint 45 valuation row + evaluation/testing-plan
> progression) was **not** run before `/release-start` this cycle — see [`docs-audit.md`](./docs-audit.md);
> those docs must land before `/release-update` marks the audit PASS.
