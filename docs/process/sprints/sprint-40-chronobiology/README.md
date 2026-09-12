[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 40 — Chronobiology & Holistic Guidance (v1.10.0)

> **Dossier index.** All transactional artifacts for this sprint live here. Derives from the
> **[Chronobiology & Holistic Guidance](../../sprint-backlog.md#chronobiology--holistic-guidance)**
> backlog epic. Scheduled via `/plan`.

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) _(seeded — fill after coding)_ |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) _(seeded — fill after local run)_ |

## Goal

Turn the app from "what is my rhythm now" into "your rhythm has drifted — here is a holistic
correction," grounded in the chronobiology corpus. All bilingual EN/TA, gentle/reliability-first
tone (CONF-017), never medical-diagnostic.

## Deliverables

1. **`ChronobiologyAnalytics`** — time-weighted sliding-window nostril-**stagnancy** detection
   over the rolling-24h journal (**mild ≥6h & ≥3 logs**, **chronic ≥8h & ≥4 logs**; Sushumna
   breaks a run).
2. **Dashboard stagnancy-warning card** — heating (stuck-left/cold) vs cooling
   (stuck-right/hot) recommendation; hidden when healthy; routes into the **existing Sprint 35
   somatic timer** for the shift.
3. **Swara-Ahara "fire" prompt** on the **Kriya** Focus Card (flow-aware; flip-to-right nudge
   reuses the somatic engine).
4. **Tattva temperature tips** — fire → Sheetali (cooling), cold → Surya Bhedana (warming);
   advisory text only.
5. **Swara Pada Gamana waking advice** in the morning-summary notification — **bilingual** via
   a threaded `languageCode` (the morning-summary body is currently hardcoded English).

## Reuse, don't rebuild

The Swara-Ahara / stagnancy "shift your breath" action routes into the **shipped Sprint 35
somatic engine** (`lib/features/somatic/`) — no new timed protocol. Doctrine prose for
Pada Gamana / Swara-Ahara is **already localized** (`guidePadaGamanaBody`, `guideSwaraAharaBody`).

## Regression gate

`DashboardData` + `FocusCard` gain optional/defaulted fields only; existing
dashboard/focus/notification tests pass **unchanged**. `createTestDashboardData` updated with a
`none` default.

## Process

Spec → coding-setup → review (Kiro Web spec + review; Antigravity IDE implements + local green
before PR). Version **v1.10.0**.
