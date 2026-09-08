# Changelog

All notable changes to Saranidhi are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

_No unreleased changes yet. Upcoming work is tracked in the
[Sprint Backlog](docs/process/sprint-backlog.md) and scheduled via `/plan`._

---

## [1.6.0-web] — 2026-09-07

> Sprint 36 — a Stability & Test Hardening release (internal quality and CI
> hardening; no new user-facing features).

### Added
- **Geolocation-first onboarding**: on web, the Location step now tries browser
  geolocation first, with the city picker as fallback (mobile/desktop keep the
  picker as source of truth).

### Changed
- Re-gated the in-repo web integration tests (removed `continue-on-error`;
  added a ChromeDriver readiness poll to fix the `ConnectionClosedException`
  flake) so they are a trustworthy CI gate again.
- Un-skipped the navigation widget test and made the `alignment_checker` tests
  date-independent.
- Added a reusable DB migration existence-check helper (`tableExists` /
  `columnExists`) and refactored the schema `onUpgrade` steps onto it.
- Added regression tests for existing-profile birth-bird auto-recalculation on
  load.
- Added widget/unit tests for the Sprint 35 somatic UI and raised the CI
  coverage gate to 19%.

### Fixed
- Settings About-card row no longer overflows horizontally on narrow viewports
  (value text now ellipsizes).

---

## [1.5.0-web] — 2026-09-04

> Bundled release of Sprint 34 (Migration + Onboarding UX Polish) and
> Sprint 35 (Somatic Intervention Engine).

### Added
- **Somatic Intervention Engine** (Sprint 35): guided, time-bound protocols to
  shift the breath channel when a breath entry is unaligned. A
  **Clear Breath Channel** action opens a selector (Posture Shift 3 min /
  Axillary Pressure 5 min); a full-screen room shows the contralateral
  instruction, a Sama Vritti (4:4:4:4) breathing pacer, and a countdown; on
  completion the guided nostril test verifies the result and the session is
  logged (`SomaticInterventionLogs`, schema v5).
- **Auto-recalculate birth bird on app load** (Sprint 34): existing profiles
  with a stored DOB are corrected to the dual-table bird with a one-time
  notice; manual (no-DOB) profiles are left untouched.
- **Onboarding redesign** (Sprint 34): three co-equal tabs (I know my star /
  Calculate from DOB / Calculate from name), a summary confirmation step with
  per-row edit, and Complete-Setup validation (requires bird + location).
- **Web geolocation on startup** (Sprint 34): auto-updates the stored location
  when moved >5 km (silent, one-time notice); city picker remains the fallback.
- **Guided nostril test**: Start-over reset + anatomical button order
  (Lunar / Sushumna / Solar).
- **Oracle history desktop delete**: hover trash icon (mouse) alongside
  swipe-to-delete (touch).

### Fixed
- Onboarding DOB tab IST-assumption note is now localized (Tamil).

### Changed
- Database schema bumped to v5 (adds `somatic_intervention_logs`; idempotent
  migration safe for both fresh install and upgrade from v4).

---

## [1.4.1-web] — 2026-08-27

> Sprint 33 — Panja Pakshi Accuracy Fix (patch): corrects birth-bird derivation
> to be permanent and makes the nostril pattern tithi-based.

### Added
- **Five Birds reference table** added to the User Guide.

### Changed
- Nostril pattern is now **tithi-based** and uses the selected date (not always
  today).
- Updated the `alignment_checker` tests for the tithi-based nostril logic.

### Fixed
- **Birth-bird accuracy overhaul**: the birth bird is now derived from the birth
  Paksha via dual bright/dark-half tables and is **permanent** (removed the
  incorrect monthly lunar-phase swap).
- Smoke test 21/21 pass.

---

## [1.4.0-web] — 2026-07-17

> Sprints 31 + 32 — Prasanam Oracle (plus Numerology and GPS).

### Added
- **Prasanam Oracle** as a dedicated bottom-nav tab (category selector
  Artha/Kriya/Yoga, intention field, readiness score + guidance, user-initiated
  save to history, swipe-to-delete, window-status banner).
- **Prasanam calculation engine** (multi-vector oracle score,
  Rahu/Kuligai/Emakandam floor lockout, `DaylightSegmentResolver`).
- **Numerology name-bird derivation** (`NameBirdParser` in onboarding).
- **GPS/geolocation**.
- **30-min nostril-timing validation gate**.

### Changed
- Database schema bumped to v4 (adds `PrasanamHistory` table).

(Sprints 31–32; PRs #115, #118.)

---

## [1.2.2-web] — 2026-07-11

> UI Polish + UX Consistency.

### Added
- **Emakandam (எமகண்டம்)** third inauspicious window (with Rahu & Kuligai).
- Rahu card 4-row layout.
- Journal history pagination (today expanded, older collapsed).
- Settings layout — About card moves to bottom on narrow screens.

### Changed
- UX consistency: Best Times card format (Y# first column, time range, date,
  Today badge); "Today's Schedule" → "☀️ Day Schedule"; "Yama 1" → "Y1" in
  Analytics; Explore Rahu card height matches Bird card.
- i18n: DOB result translated (nakshatra + bird show Tamil names).
- Smoke test 23/23 pass.

---

## [1.2.1-web] — 2026-07-10

> Bugfix + UX Polish.

### Added
- **Kuligai Kaal** (second inauspicious window).
- Enhanced Rahu card (sunrise/sunset, moon phase, Kuligai).
- Timer cancel button.
- Export/import schema versioning.
- `AppConstants` metadata.

### Changed
- UX: Sushumna redesign (meditation mode, no timer, direct log); nostril button
  order Lunar → Sushumna → Solar; Tattva format "Earth / Prithvi"; Explore tab
  (removed inline calendar, Today button); User Guide SliverAppBar.
- i18n: Best Times, calendar weekdays, moon-phase labels Tamil.
- Smoke test 29/30 pass (1 accepted cosmetic).

### Fixed
- Birth bird swaps with lunar phase (Vulture↔Peacock, Owl↔Rooster on waning)
  per traditional Sara Kalai (later superseded by the permanent dual-table
  model in v1.4.1).
- AlignmentChecker uses actual moon phase (was hardcoded waxing).
- DB migration adds `isPinned` column for existing installs.

---

## [1.2.0-web] — 2026-07-08

### Added
- **Empty states & shimmer loading** (Sprint 24) — friendly empty states for journal, analytics, explore; animated skeleton loading cards; error boundary widgets
- **Daily Engagement** (Sprint 26) — What's New screen (version-tracked), streak celebrations (7/30/100/365 days), breath timer presets (4-7-8, Box, Energize, Calm), daily summary card, pin/star entries, quick-log from notification
- **Layer 1 Gap Fixes** (Sprint 27) — ActionWindow enum (Artha/Kriya/Yoga), context-dependent Sushumna alignment, guided nostril test (3-step modal), Hora + Tattva display in Birth Bird card, reference table in User Guide (bilingual), language toggle in onboarding, DOB recalculation from Settings, trilingual nakshatra display
- **Accessibility** (Sprint 25) — keyboard Enter key submit, haptic feedback, Semantics audit

### Fixed
- Safari white page — removed canvasKitVariant 'chromium' (broke all non-Chrome browsers)
- COOP/COEP headers removed — broke Safari WASM initialization
- Analytics not refreshing after journal entry (reactive providers)
- Dashboard not updating after location change (provider invalidation)
- Night schedule now always visible (not just at nighttime)
- Notification timezone derived from profile location (no more hardcoded IST)
- Onboarding steps 2 & 3 fully translated to Tamil
- sqlparser 0.44.6 compatibility (pinned to 0.44.5)

### Changed
- Smoke test plan rewritten: slimmer 62-scenario critical-path (9 sections)
- Versioned smoke test results (per-release files)
- Sprint tracker expanded with v2.0 roadmap (Sprints 28–31)

---

## [1.1.0-web] — 2026-07-03

### Added
- **Birth Bird Dashboard** (Sprint 14) — personalized hero card, full-day schedule, Rahu Kaal, nostril chart, hold time
- **Responsive layout** — two-column on medium+ devices (>=600px)
- **Production safety gate** — `main` (staging) -> `prod` (production) promotion

---

## [1.0.0-web] — 2026-07-01

### Added
- Web production deployment on Vercel (saranidhi.vercel.app)
- Privacy policy page
- Complete Tamil localization (130+ ARB keys, all 3 pages)
- Panja Pakshi algorithm rewrite (authentic 2D lookup tables)
- Manual smoke test execution (all sections PASS)

### Fixed
- Bird state calculation accuracy (A-04 critical fix)
- Tamil translation gaps (D-01 through D-05)

---

## [0.9.0] — 2026-06-03

### Added
- Sprints 1-11: Full app foundation
- Astro-Logic Engine (8 pure Dart calculators)
- Sara Kalai Breath Journal (two-click entry, timer, history)
- Streak & Consistency Engine (streaks, ribbons, trends)
- Cloud Backup architecture (stubs for iCloud + Google Drive)
- Notifications + Onboarding (4-step flow)
- AI Wisdom Engine (rules-based, 60+ proverbs, daily caching)
- Theming (8 variants) + Profile system
- i18n (English + Tamil) + accessibility
- Testing & Hardening (264 tests, CI pipeline)
- Smoke Test Plan + CI polish

---

[Unreleased]: https://github.com/vteial/saranidhi/compare/v1.6.0-web...main
[1.6.0-web]: https://github.com/vteial/saranidhi/compare/v1.5.0-web...v1.6.0-web
[1.5.0-web]: https://github.com/vteial/saranidhi/compare/v1.4.1-web...v1.5.0-web
[1.4.1-web]: https://github.com/vteial/saranidhi/compare/v1.4.0-web...v1.4.1-web
[1.4.0-web]: https://github.com/vteial/saranidhi/compare/v1.2.2-web...v1.4.0-web
[1.2.2-web]: https://github.com/vteial/saranidhi/compare/v1.2.1-web...v1.2.2-web
[1.2.1-web]: https://github.com/vteial/saranidhi/compare/v1.2.0-web...v1.2.1-web
[1.2.0-web]: https://github.com/vteial/saranidhi/compare/v1.1.0-web...v1.2.0-web
[1.1.0-web]: https://github.com/vteial/saranidhi/compare/v1.0.0-web...v1.1.0-web
[1.0.0-web]: https://github.com/vteial/saranidhi/releases/tag/v1.0.0-web
