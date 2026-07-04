# Changelog

All notable changes to Saranidhi are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Planned
- Sprint 20: UI Polish + Home Layout Redesign (Today/Explore tabs)
- Sprint 21: Pakshi Accuracy (DOB-based Moon longitude calculation)
- Sprint 22: Widget Test Coverage (10 test files)

### Added (on staging, not yet released to production)
- **Analytics tab** (4th bottom nav) with 6 insight cards (Sprint 19)
- Weekly alignment summary, monthly patterns, streak insights
- Yama performance breakdown, hold time progression, CSV export
- **Historical View** (Sprint 18)
- Date selector on Home, calendar month view, best times this week
- Browse any past/future date's Pakshi schedule
- **Notifications** (Sprint 17)
- Real local notifications (flutter_local_notifications)
- Personalized bird state alerts, Rahu Kaal, morning summary
- 4 configurable toggles
- **Tamil Wisdom** (Sprint 17) — 52+ proverbs, locale-aware
- **iCloud Sync architecture** (Sprint 16)
- CloudKit record-level sync, primary device conflict resolution
- **macOS target** (Sprint 16) — full scaffold with CloudKit
- **Night Yamas** (Sprint 15) — full 24h Pakshi coverage

### Changed
- Dashboard provider parameterized by selected date
- Notification preferences expanded from 2 to 4 toggles
- ICloudBackupRepository upgraded from stub to real CloudKit service

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

[Unreleased]: https://github.com/vteial/saranidhi/compare/v1.1.0-web...main
[1.1.0-web]: https://github.com/vteial/saranidhi/compare/v1.0.0-web...v1.1.0-web
[1.0.0-web]: https://github.com/vteial/saranidhi/releases/tag/v1.0.0-web
