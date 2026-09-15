[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 46 — Web E2E Smoke Automation (Playwright, `vteial/saranidhi-e2e`)

> **Dossier index.** Spec, what was built, the run evidence, and the resulting PR.
> **Internal / QA-tooling sprint — no user-facing change, no `pubspec` bump, no prod release.**
> The deliverable is a test harness in a **separate repo** (`vteial/saranidhi-e2e`), NOT app code
> in `vteial/saranidhi`. This dossier (spec + review) lives here; the implementation PR lands in the
> e2e repo.

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) |
| **Run / evidence summary** (Antigravity) | [`test-summary.md`](./test-summary.md) |

## Goal

Replace the ~2-hour ad-hoc manual smoke gate's **scripted-scenario portion** with a pre-scripted,
deterministic **Playwright/TypeScript** harness that runs against the **deployed Vercel preview**.
Origin: the v1.12.1-web smoke post-mortem (see the
[Release Effort Reference](../../../testing/smoke-test-results.md#release-effort-reference--the-smoke-gate-is-mostly-fixed-cost-per-release)).
First suite = the current **S1–S6** matrix.

> **Scope honesty (load-bearing):** the harness covers **scripted functional scenarios**. The
> **human visual / UX / Tamil-doctrinal-copy eyeball still gates** each release — automation shrinks
> the scripted portion, it does not remove the human gate. The DoD records the **real measured
> runtime**, not the aspirational "~2 min".

## Process

Owner-confirmed: **separate repo `vteial/saranidhi-e2e`** (not in-repo `tool/qa`), **internal / no
version bump**. Vehicle: spec → Antigravity implements in the e2e repo with a **green run before
PR** → Kiro Web reviews. Owner is sole merge authority. ⚠️ **The e2e repo does not exist yet** —
creating it is the first gated step (spec §0).

## Status

🔨 **In Progress** — spec authored; handed to Antigravity.

- **PR:** _pending (in `vteial/saranidhi-e2e`)_
- **Shipped:** _n/a — internal QA tooling, no prod release_
