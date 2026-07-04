# Changelog

All notable changes to Saranidhi are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Added
- Sprint 20: UI Polish + Home Layout Redesign (Today/Explore tabs)
- Sprint 21: Pakshi Accuracy (DOB-based Moon longitude calculation)
- Sprint 22: Widget Test Coverage (10 test files)

---

## [1.2.0-web] — 2026-07-04

### Added
- **Analytics tab** (4th bottom nav) with 6 insight cards (Sprint 19)
- Weekly alignment summary with progress bars
- Monthly patterns (best/worst day, most active yama)
- Streak insights (longest, current, avg gap, consistency %)
- Yama performance breakdown (sorted by practice frequency)
- Hold time progression (weekly/monthly avg, personal best, trend direction)
- CSV export of complete journal history
- **Historical View** (Sprint 18)
- Date selector on Home (arrows + picker + Tomorrow/Today)
- Browse any past/future date's Pakshi schedule
- "Best Times This Week" card (7-day Ruling yama scan)
- Historical entries card for past dates
- Calendar month view with entry dot indicators
- **Notifications** (Sprint 17)
- Real local notifications via flutter_local_notifications
- Personalized bird state alerts ("Your Vulture is now Ruling")
- Rahu Kaal start/end notifications
- Morning summary at sunrise (best time today)
- 4 configurable toggles (Ruling, Eating, Rahu Kaal, Morning)
- **Tamil Wisdom** (Sprint 17)
- 52+ Tamil proverbs for Daily Wisdom
- Locale-aware selection (switches instantly with language)
- Cache invalidation on language change
- **iCloud Sync architecture** (Sprint 16)
- CloudKit record-level sync (MethodChannel + native Swift)
- Sync-on-open, push-after-write, primary device conflict resolution
- Settings UI: device name, primary toggle, sync status, other devices
- **macOS target** (Sprint 16)
- Full platform scaffold with CloudKit entitlements
- Native Swift CloudKitPluginMacOS

### Changed
- Dashboard provider parameterized by selected date (not hardcoded today)
- Notification preferences expanded from 2 to 4 toggles
- ICloudBackupRepository upgraded from stub to real CloudKit service

---

## [1.1.0-web] — 2026-07-03

### Added
- **Night Yamas** (Sprint 15) — full 24h Pakshi coverage (sunset→sunrise)
- **Birth Bird Dashboard** (Sprint 14) — personalized hero card, full-day schedule, Rahu Kaal, nostril chart, hold time
- **Responsive layout** — two-column on medium+ devices (≥600px)
- **Production safety gate** — `main` (staging) → `prod` (production) promotion

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
- Sprints 1–11: Full app foundation
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

[Unreleased]: https://github.com/vteial/saranidhi/compare/prod...main
[1.2.0-web]: https://github.com/vteial/saranidhi/compare/v1.1.0-web...main
[1.1.0-web]: https://github.com/vteial/saranidhi/compare/v1.0.0-web...v1.1.0-web
[1.0.0-web]: https://github.com/vteial/saranidhi/releases/tag/v1.0.0-web
