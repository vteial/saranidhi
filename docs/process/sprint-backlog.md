[← Back to Root](../../README.md)

# Saranidhi — Sprint Backlog

Candidate work not yet scheduled into a numbered sprint, organized by **logical
named epics** rather than sprint number. Items graduate into the
[Sprint Tracker](sprint-tracker.md) (with a Delivery Checklist) when picked up
during `/plan`. Keep entries small and outcome-focused.

> The product's Release Vision and current functional scope live in
> [`docs/product/product-scope.md`](../product/product-scope.md); the technical
> design lives in [`docs/reference/architecture.md`](../reference/architecture.md).

> Status legend: ⬜ Not started · 🔄 In progress · ✅ Done (moved to tracker)
>
> Priority legend: 🔴 High · 🟡 Medium · 🟢 Low

---

## Table of Contents

- [Chronobiology & Holistic Guidance](#chronobiology--holistic-guidance)
- [Analytics & Insights](#analytics--insights)
- [Prasanam Oracle UX](#prasanam-oracle-ux)
- [Accuracy & Validation](#accuracy--validation)
- [Quality, CI & E2E](#quality-ci--e2e)
- [Release Polish & v2.0](#release-polish--v20)
- [Distribution (App Store)](#distribution-app-store)
- [Sync & Platform](#sync--platform)
- [Ideas / Unscoped](#ideas--unscoped)
- [Confirmed Decisions](#confirmed-decisions)

---

## Chronobiology & Holistic Guidance

> Spec: [`research/advanced_somatic_mastery.md`](../research/advanced_somatic_mastery.md) §2.

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | ⬜ | ChronobiologyAnalytics — time-weighted sliding-window stagnancy detection (≥6h mild, ≥8h chronic) |
| 🟡 | ⬜ | Dynamic Somatic Cards — Swara-Ahara dietary fire prompt on the Kriya Focus Card |
| 🟡 | ⬜ | Tattva-Somatic temperature-regulation tips (Sheetali for excess fire, Surya Bhedana for cold) |
| 🟡 | ⬜ | Swara Pada Gamana waking advice in the morning summary notification |
| 🟡 | ⬜ | Dashboard stagnancy warning card (heating/cooling lifestyle recommendations) |
| 🟢 | ⬜ | Cognitive Energy Budgeting labels in Best Times / Explore (Artha/Kriya/Yoga suggestions) |
| 🔴 | ⬜ | Tamil translations for all holistic/somatic guidance text |

---

## Analytics & Insights

| Priority | Status | Item |
|----------|--------|------|
| 🟡 | ⬜ | **Analytics export — reconsider.** The Analytics screen's `_ExportCard` exports journal-only CSV; Settings already has full data export/import (JSON, a superset). Decide: (1) remove CSV from Analytics and replace the slot with a higher-value card (alignment-rate insight, hold-time chart expansion, streak heatmap, or a shareable summary report); (2) move CSV to Settings alongside JSON; or (3) keep as-is. *(CSV = human-readable/journal-only vs JSON = full machine backup — weigh before removing.)* |
| 🟢 | ⬜ | Shareable summary / PDF report of alignment and hold-time progress. |

---

## Prasanam Oracle UX

> Single canonical home for the consultation-ritual friction set (previously
> duplicated across the backlog Deferred section and the old project plan).

| Priority | Status | Item |
|----------|--------|------|
| 🟢 | ⬜ | **Prasanam "sacred consultation" UX** — cooldown, pre-query breath ritual, intention-anchor hold, daily query limit, deity/mantra prompt, session-quality score. Deferred post-v1.4. |

---

## Accuracy & Validation

> **Prerequisite:** Owner collects 7-day Align27 + Tamil Panchangam data BEFORE calibration work starts.

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | ⬜ | Collect 7 consecutive days of Align27 Pancha Pakshi states (all 10 yamas, times, moon phase) for Rooster/Pushya *[owner task]* |
| 🔴 | ⬜ | Collect the same 7 days from a Tamil Panchangam (drikpanchang.com or physical calendar) *[owner task]* |
| 🟡 | ⬜ | Saranidhi diagnostic dump — generate matching 7-day output (bird states, sunrise/sunset, lunar phase, weekday) |
| 🟡 | ⬜ | Three-way comparison matrix — Saranidhi vs Align27 vs Panchangam; identify divergence points |
| 🟡 | ⬜ | Root-cause diagnosis — lookup tables / lunar-phase calc / weekday convention / phase-swap timing |
| 🔴 | ⬜ | Calibration fix based on diagnosis |
| 🟡 | ⬜ | Re-run the 7-day comparison; confirm match with the most authentic source |
| 🟢 | ⬜ | Document findings in `docs/research/accuracy-calibration.md` |
| 🟡 | ⬜ | Validate the dual-table birth-bird derivation against a labeled 7-day dataset. |

---

## Quality, CI & E2E

> Ties to the in-repo web integration tests (now fixed and re-gated as REQUIRED)
> and the future Playwright E2E repo.

| Priority | Status | Item |
|----------|--------|------|
| 🟡 | ⬜ | Set up Playwright for Flutter Web E2E tests (separate repo `vteial/saranidhi-e2e`) |
| 🟡 | ⬜ | Automate critical-path scenarios from the smoke test (onboarding, log entry, streak, intervention) |
| 🟡 | ⬜ | Integrate E2E into CI (run against deployed staging URL) |
| 🟢 | ⬜ | Visual regression snapshots for key screens |
| 🟡 | ⬜ | Notification de-duplication / cooldown to avoid repeats during a sustained window. |
| 🟢 | ⬜ | Periodic staging-data / smoke-data hygiene as the app grows. |
| 🟡 | ⬜ | Revisit the 19% coverage gate once UI/E2E coverage exists — raise it then. |
| — | ✅ | Two-tier CI (fast PRs + full on merge/prod, with ci-full now also running on PRs to main) — in place. |

---

## Release Polish & v2.0

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | ⬜ | End-to-end feature integration testing (all layers together) |
| 🟡 | ⬜ | Performance optimization (startup time, animation smoothness) |
| 🔴 | ⬜ | Comprehensive smoke test plan for v2.0.0 (all features) |
| 🟡 | ⬜ | User Guide refresh — complete rewrite covering all v2.0 features |
| 🟢 | ⬜ | Wire Sprint 26 deferred widgets (WhatsNew startup, PresetSelector, StreakCelebration, isPinned star) |

---

## Distribution (App Store)

> Deferred — target when the web app is compelling enough to retain users.

| Priority | Status | Item |
|----------|--------|------|
| 🟢 | ⬜ | Apple Developer + Google Play accounts |
| 🟢 | ⬜ | App icon variants for all required sizes (iOS, macOS, Android adaptive) |
| 🟢 | ⬜ | Splash/launch screen with branding |
| 🟢 | ⬜ | Store screenshots guide (key screens, light+dark, EN+TA) |
| 🟢 | ⬜ | Finalize `docs/deployment/store-listing.md` copy (EN + TA) |
| 🟢 | ⬜ | Build release iOS + macOS + Android |
| 🟢 | ⬜ | Submit for review |
| 🟢 | ⬜ | Verify live + tag `v1.0.0-mobile` |

---

## Sync & Platform

| Priority | Status | Item |
|----------|--------|------|
| 🟢 | ⬜ | **Google Drive sync** (web + Android) — deferred to v1.1+ (architecture stub exists). |
| 🟢 | ⬜ | **Ayanamsa variants** (Raman, KP, Vakya) — deferred to v2.0 (Lahiri sufficient for ~99%). |
| 🟢 | ⬜ | **Derive nakshatra from DOB + Time** — deferred to v2.0. |
| 🟢 | ⬜ | **Home tab restructure** (Today / Past / Future) — deferred post-v1.4. |

---

## Ideas / Unscoped

| Priority | Status | Item |
|----------|--------|------|
| 🟢 | ⬜ | Widget support (iOS/macOS home screen). |
| 🟢 | ⬜ | Apple Watch / Wear OS companion. |
| 🟢 | ⬜ | Additional languages beyond EN + TA. |
| 🟢 | ⬜ | Configurable detection thresholds via config (avoid code edits for tuning). |
| 🟢 | ⬜ | Breath session guided programs (was roadmap-deferred v1.2; breath_sessions table is live). |

---

## Confirmed Decisions

Standing decisions (also captured as Kiro learnings):

- ✅ **On-device LLM** — removed from plan (rules-based wisdom engine sufficient).
- ✅ **Sushumna = sacred observation** — no breath holding; log duration only; brief (~4 min max).
- ✅ **Birth bird is permanent** — derived from birth Paksha (dual-table); no monthly swap.

---

[← Back to Root](../../README.md)
