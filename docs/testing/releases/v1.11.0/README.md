[← Releases index](../../smoke-test-results.md)

# Release Dossier — v1.11.0-web

**Sprint 42 — ★ Swara Clock Engine & Weekday Udhaya** · Release pending · ⏳

The **correctness fix** to expected-nostril prediction — the "readiness" half of the flagship
Aruḍam verdict. The expected nostril is decoupled from the 1.5-hour Panja Pakshi **yama** clock
and rebuilt as an independent **1-hour / 24-cycle** ultradian swara clock (CONF-014), seeded at
astronomical sunrise by the classical **Weekday Udhaya** dawn rule (CONF-013 / CONF-001, incl. the
Thursday paksha split). Rewires `AlignmentChecker` (fixing a latent "always-today" bug), the
oracle `_resolveAlignment`, and the Nostril Pattern dashboard card (hourly blocks + ~1h countdown +
live night cycle). Bird-state / yama engine **unchanged** (regression-gated). Floor-lock citation
re-keyed off the mistaken CONF-018 → `PP-ORACLE`.

> **Why it matters:** this fix MUST ship before the 7-day Accuracy Calibration data collection —
> otherwise every logged breath would be tested against a broken reference.

## Contents

| File | What |
| --- | --- |
| [`smoke-test.md`](./smoke-test.md) | Scenario plan (executed by QA-Verify on the PR preview) |
| [`release-notes.md`](./release-notes.md) | Permanent GitHub Release record (tag / target / title / body) |
| [`docs-audit.md`](./docs-audit.md) | Owner-run docs-freshness gate |
| [`qa-verify-prompt.md`](./qa-verify-prompt.md) | Version-filled QA-Verify agent prompt for this release |

## Links

- **Sprint dossier:** [`sprints/sprint-42-swara-clock/`](../../../process/sprints/sprint-42-swara-clock/README.md)
- **Changelog:** [`CHANGELOG.md`](../../../../CHANGELOG.md)
- **Releases index:** [`smoke-test-results.md`](../../smoke-test-results.md)
