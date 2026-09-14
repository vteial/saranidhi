[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 42 — ★ Swara Clock Engine & Weekday Udhaya (v1.11.0)

> **Dossier index.** All transactional artifacts for this sprint live in this folder.
> This is the audit landing page — spec, what was built, the local test gate, and the
> resulting PR/release, with links.

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) |

## Goal

**Correctness fix to expected-nostril prediction** — the "readiness" half of the flagship
Aruḍam verdict. The app currently predicts the expected nostril on the **Panja Pakshi
1.5-hour yama clock** with a **3-day Tithi-triad** dawn seed; both are wrong. This sprint
moves it onto:

1. **A new `SwaraClock` engine** — the **1-hour / 24-cycle** swara clock (CONF-014),
   decoupled from the bird-state yama clock.
2. **The Weekday Udhaya dawn seed** (CONF-013 / CONF-001) — seeded at astronomical
   sunrise from the weekday→(nostril, 1h/2h) table, with the Thursday paksha split;
   1h-days alternate hourly, 2h-days hold the 2h inception then alternate hourly, across
   the full 24h.

Then **rewire** `AlignmentChecker` (fixing a latent "always-today" bug), the Aruḍam Now
readiness multiplier, the Nostril Pattern dashboard card (rows + next-switch countdown →
~1h), and the oracle `_resolveAlignment` — while keeping the **bird-state / yama engine
byte-for-byte unchanged** (regression-gated). Also re-keys the Rahu/Emakandam floor-lock
citation off the mistaken CONF-018.

**Why now:** the 7-day Accuracy Calibration compares Saranidhi vs Align27 vs Panchangam vs
*actual breath* — if the swara clock stays broken, every logged breath tests the wrong
engine. **Must ship before that data collection.**

## Doctrine (owner-confirmed)

- **CONF-014** — swara alternation = 1 hour / 24-cycle; separate clock from the 1.5h
  Pakshi yama.
- **CONF-013** — Udhaya Weekday dawn schedule (Sun R/1h, Mon L/1h, Tue R/2h, Wed L/2h,
  Thu Shukla L/1h · Krishna R/2h, Fri L/2h, Sat R/1h).
- **CONF-001** — sunrise-to-sunrise civil day; Thursday paksha at the local sunrise instant.
- **CONF-018** — clarified as the Day/Night macro-seal, **not** the inauspicious-window
  floor-lock (citation cleanup, task 42.6).

Full corpus:
[`sarakalai-workshop-knowledge.md`](../../../research/sarakalai-workshop-knowledge.md).

## Process

Uses the **Sprint 37 birth-bird protocol** — Kiro Web authors this spec, Antigravity
implements with a **local green baseline** (correctness-critical: local `flutter analyze`
+ full `flutter test` green **before** the PR, not CI-only), then Kiro Web reviews the
real diff. Owner is the sole merge/release authority.

## Status

✅ **Complete** — merged to `main`; release pending.

- **PR:** [#220](https://github.com/vteial/saranidhi/pull/220) — merged `3303171` (Antigravity implemented + local green; Kiro Web reviewed the real diff; fix commit `0055dea` corrected the doc tables + unified pre-dawn anchoring).
- **Shipped:** _pending — targets v1.11.0-web (`/release-start v1.11.0`)_
