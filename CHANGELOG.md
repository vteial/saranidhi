# Changelog

All notable changes to Saranidhi are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

_No unreleased changes yet. Upcoming work is tracked in the
[Sprint Backlog](docs/process/sprint-backlog.md) and scheduled via `/plan`._

---

## [1.9.0-web] — TBD

> Sprint 39 — **Integrated Aruḍam: "Why?" provenance accordion**. Verdict transparency —
> the "Aruḍam Now" card now explains itself doctrinally, with source citations.

### Added
- **"Why?" accordion on the Aruḍam Now card** — a collapsed-by-default, tap-to-expand section that explains the verdict in plain language. Contributing factors are grouped under **Moment — the timing** (bird state, planetary Hora, Tarabala, activity harmony) and **You — your readiness** (breath alignment), or a single **Blocked** explanation during an inauspicious window.
- **Source provenance on every reason** — each line carries a subdued citation of the traditional practice / confirmation it rests on (e.g. `· CONF-014`), so the guidance is transparent and auditable. No raw arithmetic is ever shown; no tooltips.
- Fully bilingual (English + தமிழ், pure Tamil script).

### Notes
- **Transparency only** — scoring math, bands, and the inauspicious floor-lock are unchanged; the Prasanam Oracle is unaffected. The engine now returns a structured reasons breakdown alongside the score (one new field; behavior-preserving).

---

## [1.8.1-web] — 2026-09-12

> Hotfix — Tamil localization.

### Fixed
- **Settings → Notifications:** the *Rahu Kaal Alerts* and *Morning Summary* toggles (and their subtitles) were hardcoded in English and did not translate in Tamil mode. Now fully localized (EN + தமிழ்).

---

## [1.8.0-web] — 2026-09-12

> Sprint 38 — **Integrated Aruḍam, Slice 1**. The first slice of the flagship epic: an
> always-on **"Aruḍam Now"** verdict card on Home that fuses cosmic timing and breath
> into one answer, over a shared engine extracted from the Prasanam Oracle.

### Added
- **"Aruḍam Now" ambient verdict card** on the Home (Today) view — fuses Panja Pakshi
  bird-state × Hora × Tarabala × auspiciousness into one score/band, with a plain-language
  **two-clock breakdown** (Moment = cosmic ceiling · You = breath readiness).
- **Moment × Readiness** scoring — natural breath alignment claims the full moment
  (×1.0); misalignment softens the verdict (×0.75) but never blocks it.
- **Natural-vs-forced framing** — patience-first guidance when misaligned; a low-emphasis,
  warning-toned "Urgent?" affordance for forced shifting that never promises success; a
  `wasForcedShift` audit flag (schema v6) so only *natural* alignment is celebrated.
- `IntegratedArudamEngine` (extracted from `OracleCompositeEngine`, behavior-preserving).

### Fixed
- **Inauspicious floor-lock is now 24h-correct** — Rahu Kaal / Emakandam gate the verdict
  at night too (previously day-only via `DaylightSegmentResolver`).

### Notes
- Bilingual (EN + தமிழ்). The Prasanam Oracle now shares the same verdict engine.

---

## [1.7.0-web] — 2026-09-11

> Sprint 37 — **Birth-Bird Engine Correction**. A correctness release that fixes the
> core Panja Pakshi birth-bird calculation to the canonical Tamil Siddha lineage model
> (CONF-PP-001…005), overruling the earlier modern-secondary (Pulippani) interpretation.

### Fixed
- **Birth-bird nakshatra partition corrected to the canonical 5-6-5-5-6** (was 5-5-5-5-7).
  Users born under **Purva Phalguni (Pooram)**, **Vishakha (Visakam)**, or **Uttara Ashadha
  (Uthiradam)** now get their correct bird (Owl, Crow, Rooster respectively).
- **Single permanent birth-star table** — the birth bird no longer reverse-swaps for
  Krishna-paksha births; a known birth star yields one permanent lifetime bird.
- **Corrected bird attributes** — ruling planets (Vulture=Jupiter, Owl=Venus, Crow=Mars,
  Rooster=Mercury, Peacock=Saturn), unified friend/enemy affinities, and phase-dependent
  cardinal directions.

### Changed
- **Existing users are auto-corrected on app open** — a one-time silent recalculation
  updates any stored bird affected by the fix (both DOB-based and manual "known-star"
  profiles), with a brief notification. No action needed from the user.
- The waxing/waning bird swap now applies **only** to the name-initial fallback method
  (used when neither birth star nor DOB is known), per lineage.

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
