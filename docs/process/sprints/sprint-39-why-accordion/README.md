[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 39 — Integrated Aruḍam: "Why?" Provenance Accordion (v1.9.0)

> **Dossier index.** All transactional artifacts for this sprint live here. A named
> **fast-follow** of the flagship **[★ Integrated Aruḍam](../../sprint-backlog.md#-flagship--integrated-aruḍam)**
> epic — delivers the verdict-transparency promise (a tap-to-expand "Why?" with doctrinal
> explanation + corpus/CONF provenance) that slice 1 (Sprint 38) deliberately deferred.
> Scheduled via `/plan`.

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) _(seeded — fill after coding)_ |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) _(seeded — fill after local run)_ |

## Goal

An expandable **"Why?"** accordion on the always-on **"Aruḍam Now"** verdict card that
explains the verdict **doctrinally, in plain language, with provenance** — each contributing
factor cites the corpus practice + CONF id it rests on. **No raw math, no tooltips**,
bilingual EN/TA, **collapsed by default**.

## Shape of the work

- **Engine:** add a structured `List<ArudamReason>` factor breakdown (`ArudamFactor` +
  `FactorStrength` + `conf` citation) to `IntegratedArudamResult` — **behavior-preserving**
  (one new field; no existing field changes; Oracle path unaffected).
- **Card:** a small stateful `_WhySection` (collapsed by default) rendering the reasons
  grouped **Moment / You**, or a single **Blocked** reason when floor-locked; new bilingual
  `arudamWhy*` ARB keys; zero hardcoded `Text()`.
- **Tests:** engine `reasons` per case (aligned / misaligned / stale-omits / Sushumna /
  floor-lock + `conf`); card collapse→expand + provenance + floor-lock + misaligned.

## Regression gate

Scoring math, bands, and floor-lock are **untouched** — this is a transparency sprint.
Existing engine + card tests must pass **unchanged**; the collapsed card renders exactly as
today.

## Process

Spec → coding-setup → review (Kiro Web spec + review; Antigravity IDE implements + local
green before PR). Version **v1.9.0**.
