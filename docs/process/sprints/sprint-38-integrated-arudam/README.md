[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 38 — Integrated Aruḍam, Slice 1 (v1.8.0)

> **Dossier index.** All transactional artifacts for this sprint live here. First
> slice of the flagship **[★ Integrated Aruḍam](../../sprint-backlog.md#-flagship--integrated-aruḍam)**
> epic — an always-on "Aruḍam Now" verdict card on Home. Owner-confirmed in the
> Phase-2b `/plan` (PR #179); scheduled as Sprint 38 in the `/plan` PR #180.

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) |

## Outcome

- **What:** shipped the flagship's first slice — the always-on **"Aruḍam Now"** verdict
  card on Home, fusing **Moment × Readiness** over a shared `IntegratedArudamEngine`
  extracted (behavior-preserving) from `OracleCompositeEngine`. Breath alignment now
  feeds the score (aligned ×1.0 / misaligned ×0.75, never a floor-lock); the inauspicious
  floor-lock is **24h-correct** (Rahu/Emakandam window containment, day + night);
  natural-vs-forced framing (patience-default, warning-toned "Urgent?" affordance that
  never promises success) with a `wasForcedShift` audit flag (schema v6, guarded migration).
- **PR:** [#181](https://github.com/vteial/saranidhi/pull/181) — merged `d83347d`.
  Kiro Web reviewed the real diff and approved; regression gate verified.
- **Process:** spec → coding-setup → review. Antigravity implemented; local run
  564 pass / 4 known-CloudKit baseline / 0 regressions.
- **Shipped:** **v1.8.0 — pending release** (`/release-start` next). At release, the smoke
  test moves from this folder to `docs/testing/releases/smoke-test-v1.8.0.md` (convention).
- **Out of scope (named fast-follows):** "Why?" provenance accordion; native ambient
  surface (widget/watch/macOS); proactive nudge; 0.75-penalty tuning via the 7-day
  comparison; full streak/analytics natural-alignment rework (38.6 shipped the flag only).
