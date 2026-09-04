# Changelog

All notable changes to Saranidhi are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Planned (v1.3.0 — Layer 2: Action Windows)
- Sprint 28: ActionWindowEngine (24h schedule, Rahu guardrail)
- Sprint 29: 24h Action Bar, Current Mode Focus Card, expansion sheet

### Planned (v2.0.0 — Layer 3: Prasanam Oracle)
- Sprint 30: Prasanam calculation engine (3 vectors, oracle score)
- Sprint 31: FAB trigger, query input, result card, history timeline

---

## [1.5.0-web] — _pending release_

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

[Unreleased]: https://github.com/vteial/saranidhi/compare/v1.2.0-web...main
[1.2.0-web]: https://github.com/vteial/saranidhi/compare/v1.1.0-web...v1.2.0-web
[1.1.0-web]: https://github.com/vteial/saranidhi/compare/v1.0.0-web...v1.1.0-web
[1.0.0-web]: https://github.com/vteial/saranidhi/releases/tag/v1.0.0-web
