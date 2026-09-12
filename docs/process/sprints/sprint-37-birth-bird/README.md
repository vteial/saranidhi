[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 37 — Birth-Bird Engine Correction (v1.7.0)

> **Dossier index.** All transactional artifacts for this sprint live in this folder.
> This is the audit landing page — spec, what was built, the local test gate, and the
> resulting PR/release, with links.

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) |

## Outcome

- **What:** corrected the Panja Pakshi birth-bird engine to the lineage-canonical
  **5-6-5-5-6** nakshatra partition with a **single permanent birth-star table** (no
  Krishna reverse-swap); waning swap retained only on the name-initial fallback;
  bird attributes (planet / friend-enemy / direction) corrected; **all** affected
  existing users re-migrated on app load. Fixes e.g. Pushya/Krishna: **Cock → Owl**.
- **Doctrine:** owner-confirmed via CONF-PP-001…005 in
  [`panja-pakshi-workshop-knowledge.md`](../../../research/panja-pakshi-workshop-knowledge.md).
- **PR:** [#167](https://github.com/vteial/saranidhi/pull/167) — merged `df303e9`.
- **Process:** first run of the **spec → coding-setup → review** model (Kiro Web spec
  + review; Antigravity implement + local test). One review-flagged item (name-swap
  5-cycle) was verified exact against primary sources before merge.
- **Shipped:** **v1.7.0-web** to production — smoke test
  [`smoke-test.md`](../../../testing/releases/v1.7.0/smoke-test.md) ✅ PASS;
  release notes [`release-notes.md`](../../../testing/releases/v1.7.0/release-notes.md).
