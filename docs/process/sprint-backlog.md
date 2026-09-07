[← Back to Root](../../README.md)

# Saranidhi — Sprint Backlog

Candidate work not yet scheduled into a numbered sprint. Items graduate into the
[Sprint Tracker](sprint-tracker.md) (with a Delivery Checklist) when picked up
during `/plan`. Keep entries small and outcome-focused.

> Legend: ⬜ Not started · 🔄 In progress · ✅ Done (moved to tracker)

---

## Table of Contents

- [Scheduled-Next Candidates](#scheduled-next-candidates)
- [Planned Sprints](#planned-sprints)
  - [Sprint 36 — Chronobiology Analytics + Holistic Cards](#sprint-36--chronobiology-analytics--holistic-cards)
  - [Sprint 37 — v2.0.0 Release Polish & Integration Testing](#sprint-37--v200-release-polish--integration-testing)
  - [Sprint 38 — Panja Pakshi Accuracy Calibration & Validation](#sprint-38--panja-pakshi-accuracy-calibration--validation)
  - [Sprint E2E — Automated End-to-End Testing](#sprint-e2e--automated-end-to-end-testing)
  - [Sprint X — App Store Prep & Submission](#sprint-x--app-store-prep--submission)
- [Open Decisions (for `/plan`)](#open-decisions-for-plan)
- [Prioritized](#prioritized)
- [Deferred / Confirmed Decisions](#deferred--confirmed-decisions)
- [Ideas / Unscoped](#ideas--unscoped)

---

## Scheduled-Next Candidates

Small, ready-to-pick items surfaced during the v1.5.0 cycle:

- ⬜ **Analytics export — reconsider.** The Analytics screen's `_ExportCard`
  exports journal-only CSV; Settings already has full data export/import (JSON,
  a superset). Decide: (1) remove CSV from Analytics and replace the slot with a
  higher-value card (alignment-rate insight, hold-time chart expansion, streak
  heatmap, or a shareable summary report); (2) move CSV to Settings alongside
  JSON; or (3) keep as-is. *(Owner-raised; CSV = human-readable/journal-only vs
  JSON = full machine backup — weigh before removing.)*
- ⬜ **Geolocation-first onboarding (Task 34.8).** On web, try browser geolocation
  first on the Location step, with the city picker as fallback; keep the >5 km
  auto-update silent. Mobile/desktop keep the picker as source of truth.
- ⬜ **Auto-recalc deep verify (Sprint 34.1).** Existing-profile upgrade path for
  the on-load birth-bird recalculation still owed a proper verification.

---

## Planned Sprints

### Sprint 36 — Chronobiology Analytics + Holistic Cards
> Version TBD (v1.5.1 vs v1.6.0 — see Open Decisions). Spec:
> [`research/advanced_somatic_mastery.md`](../research/advanced_somatic_mastery.md) §2.

- ⬜ 36.1: ChronobiologyAnalytics — time-weighted sliding-window stagnancy detection (≥6h mild, ≥8h chronic)
- ⬜ 36.2: Dynamic Somatic Cards — Swara-Ahara dietary fire prompt on the Kriya Focus Card
- ⬜ 36.3: Tattva-Somatic temperature-regulation tips (Sheetali for excess fire, Surya Bhedana for cold)
- ⬜ 36.4: Swara Pada Gamana waking advice in the morning summary notification
- ⬜ 36.5: Dashboard stagnancy warning card (heating/cooling lifestyle recommendations)
- ⬜ 36.6: Cognitive Energy Budgeting labels in Best Times / Explore (Artha/Kriya/Yoga suggestions)
- ⬜ 36.7: Tamil translations for all holistic/somatic guidance text

### Sprint 37 — v2.0.0 Release Polish & Integration Testing
- ⬜ 37.1: End-to-end feature integration testing (all layers together)
- ⬜ 37.2: Performance optimization (startup time, animation smoothness)
- ⬜ 37.3: Comprehensive smoke test plan for v2.0.0 (all features)
- ⬜ 37.4: User Guide refresh — complete rewrite covering all v2.0 features
- ⬜ 37.5: Wire Sprint 26 deferred widgets (WhatsNew startup, PresetSelector, StreakCelebration, isPinned star)

### Sprint 38 — Panja Pakshi Accuracy Calibration & Validation
> **Prerequisite:** Owner collects 7-day Align27 (38.1) + Tamil Panchangam (38.2) data BEFORE the sprint starts.

- ⬜ 38.1: Collect 7 consecutive days of Align27 Pancha Pakshi states (all 10 yamas, times, moon phase) for Rooster/Pushya *[owner task]*
- ⬜ 38.2: Collect the same 7 days from a Tamil Panchangam (drikpanchang.com or physical calendar) *[owner task]*
- ⬜ 38.3: Saranidhi diagnostic dump — generate matching 7-day output (bird states, sunrise/sunset, lunar phase, weekday)
- ⬜ 38.4: Three-way comparison matrix — Saranidhi vs Align27 vs Panchangam; identify divergence points
- ⬜ 38.5: Root-cause diagnosis — lookup tables / lunar-phase calc / weekday convention / phase-swap timing
- ⬜ 38.6: Calibration fix based on diagnosis
- ⬜ 38.7: Re-run the 7-day comparison; confirm match with the most authentic source
- ⬜ 38.8: Document findings in `docs/research/accuracy-calibration.md`

### Sprint E2E — Automated End-to-End Testing
> Ties to the in-repo web integration tests (see Open Decisions — those are
> currently non-blocking, flaky/stale, and candidates to migrate here).

- ⬜ E2E.1: Set up Playwright for Flutter Web E2E tests (separate repo `vteial/saranidhi-e2e`)
- ⬜ E2E.2: Automate critical-path scenarios from the smoke test (onboarding, log entry, streak, intervention)
- ⬜ E2E.3: Integrate E2E into CI (run against deployed staging URL)
- ⬜ E2E.4: Visual regression snapshots for key screens

### Sprint X — App Store Prep & Submission
> Deferred — target when the web app is compelling enough to retain users.

- ⬜ X.1: Apple Developer + Google Play accounts
- ⬜ X.2: App icon variants for all required sizes (iOS, macOS, Android adaptive)
- ⬜ X.3: Splash/launch screen with branding
- ⬜ X.4: Store screenshots guide (key screens, light+dark, EN+TA)
- ⬜ X.5: Finalize `docs/deployment/store-listing.md` copy (EN + TA)
- ⬜ X.6: Build release iOS + macOS + Android
- ⬜ X.7: Submit for review
- ⬜ X.8: Verify live + tag `v1.0.0-mobile`

---

## Open Decisions (for `/plan`)

- ⬜ **Fate of the in-repo web integration tests.** Currently **non-blocking**
  (`continue-on-error`) because they are flaky (ChromeDriver
  `ConnectionClosedException`) and stale (assert UI that changed in Sprints
  34/35). Decide: (a) migrate to the Playwright E2E repo and delete from the main
  repo, or (b) fix + stabilize + re-gate. *(Same class as the v1.2.1 lesson: keep
  integration tests in sync with UI; don't expand CI scope without pre-validating.)*
- ⬜ **Sprint 36 target version** — v1.5.1 vs v1.6.0 (orphaned when the v1.5.0
  batching shipped only Sprints 34 + 35).
- ⬜ **DB migration strategy** — a cleaner pattern than ad-hoc `sqlite_master`
  existence checks (e.g., a small helper, or `PRAGMA table_info`).
- ⬜ **`v1.4.1-web` tag backfill** — that version was released but never tagged
  (minor housekeeping).

---

## Prioritized

### Detection / accuracy
- ⬜ Validate the dual-table birth-bird derivation against a labeled 7-day dataset (feeds Sprint 38).

### Alerting / notifications
- ⬜ Notification de-duplication / cooldown to avoid repeats during a sustained window.

### Developer experience & CI
- ⬜ Revisit the coverage gate (currently 18%) once UI has E2E coverage — raise it back.
- ✅ Two-tier CI (fast PRs + full on merge/prod) — in place.

### Reliability & observability
- ⬜ Periodic staging-data / smoke-data hygiene as the app grows.

---

## Deferred / Confirmed Decisions

Salvaged from the retired `session-handoff.md` — standing decisions and deferrals
(most are also captured as Kiro learnings):

- ⬜ **Home tab restructure** (Today / Past / Future) — deferred post-v1.4.
- ⬜ **Prasanam "sacred consultation" UX** — cooldown, pre-query breath ritual,
  intention-anchor hold, daily query limit, deity/mantra prompt, session-quality
  score. Deferred post-v1.4.
- ⬜ **Ayanamsa variants** (Raman, KP, Vakya) — deferred to v2.0 (Lahiri sufficient for ~99%).
- ⬜ **Google Drive sync** (web + Android) — deferred to v1.1+ (architecture stub exists).
- ✅ **On-device LLM** — removed from plan (rules-based engine sufficient).
- ✅ **Sushumna = sacred observation** — no breath holding; log duration only; brief (~4 min max).
- ✅ **Birth bird is permanent** — derived from birth Paksha (dual-table); no monthly swap.

---

## Ideas / Unscoped

- ⬜ Widget support (iOS/macOS home screen).
- ⬜ Apple Watch / Wear OS companion.
- ⬜ Advanced analytics / shareable PDF reports.
- ⬜ Additional languages beyond EN + TA.
- ⬜ Configurable detection thresholds via config (avoid code edits for tuning).

---

[← Back to Root](../../README.md)
