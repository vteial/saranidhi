[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 43 — Localization Defect Fixes (v1.11.1)

> **Dossier index.** All transactional artifacts for this sprint live in this folder —
> spec, what was built, the local test gate, and the resulting PR/release, with links.

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) |

## Goal

A small, tight **bug-fix patch** clearing known localization defects (the recurring
"partially-localized widget / value-not-localized" miss — same class as the v1.8.1
notification-l10n hotfix), plus one trivial parked citation fix. Ships as **v1.11.1-web**.

- **43.1 · BUG-v1.11.1-01** — About-card **Developer name** not localized: Tamil shows
  `Eialarasu` in the Developer row while the copyright line already renders `இயலரசு`. Fix via a
  new `aboutDeveloperName` ARB key. *(owner-found, 2026-09-14)*
- **43.2 · BUG-v1.10.1-01** — Monthly-Patterns **day-name value** unlocalized (`Sunday` not
  `ஞாயிறு` in Tamil). Fix by carrying the integer weekday on the domain model and localizing via
  `DateFormat.EEEE(locale)` in the widget; add a localized-weekday test.
- **43.3** — `readiness` factor **citation** `CONF-016/017 → CONF-014` (readiness rides the swara
  clock since Sprint 42). Comment/string only; no logic change.
- **43.4** — DoD **l10n sweep** of the About + Analytics cards.

## Process

**Spec → Antigravity (local green) → Kiro Web review.** 43.1 + 43.3 are trivial; **43.2 touches
the analytics domain model + a widget**, so the sprint runs the local-green-before-PR path with a
localized-weekday test (not CI-only). **User Guide = n/a** (cosmetic). Owner is sole merge authority.

## Status

🔄 **In progress** — spec authored; awaiting Antigravity implementation.

- **PR:** _pending_
- **Shipped:** _pending — targets v1.11.1-web_
