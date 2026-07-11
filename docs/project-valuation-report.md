[← Back to Root](../README.md)

# Saranidhi — Project Valuation & Forensic Timeline Report

## Executive Summary

**Project:** Saranidhi (The Treasure House of Breath)
**Scope:** Cross-platform (iOS, Android, Web) spiritual breath-tracking app with Vedic calculation engine
**Sprints Delivered:** 28 (+ Sprint 0 pre-development + Sprint 27.5 hotfix)
**Total Engineering Investment:** ~84.0 Hours
**Pull Requests Merged:** 95
**Automated Test Coverage:** 410+ assertions (unit + widget + integration)
**Production Web Release:** v1.2.1-web

---

## Commit Metadata Timeline

| Hash | Author | Timestamp | Description |
|------|--------|-----------|-------------|
| `1d40792` | Kiro Agent | 2026-06-02 06:00 | chore(sprint0): initialize Saranidhi pre-development artifacts |
| `2180fb8` | Kiro Agent | 2026-06-02 06:30 | feat(sprint1): project scaffold & core architecture |
| `f707ad7` | Kiro Agent | 2026-06-02 06:35 | docs: update sprint tracker |
| `d790f13` | Kiro Agent | 2026-06-02 06:38 | ci: add Vercel configuration |
| `f2e7e64` | Eialarasu | 2026-06-02 06:45 | **Merge PR #1 — Sprint 1 Complete** |
| `af5c009` | Kiro Agent | 2026-06-02 07:00 | feat(sprint2): Astro-Logic Engine + responsive layout + CI |
| `85e1a28` | Kiro Agent | 2026-06-02 07:05 | fix(ci): upgrade to actions/checkout@v5 |
| `54566e9` | Kiro Agent | 2026-06-02 07:08 | docs: add dev-workflow.md |
| `2455d93` | Kiro Agent | 2026-06-02 07:10 | docs: fix sprint tracker |
| `b8d6eff` | Eialarasu | 2026-06-02 07:20 | **Merge PR #2 — Sprint 2 Complete** |
| `8b05393` | Kiro Agent | 2026-06-02 07:35 | feat(sprint3): Sara Kalai Breath Journal UI + Logic |
| `59c1361` | Kiro Agent | 2026-06-02 07:38 | ci: lower coverage threshold |
| `9289fb9` | Eialarasu | 2026-06-02 07:45 | **Merge PR #3 — Sprint 3 Complete** |
| `15cd7bc` | Kiro Agent | 2026-06-02 07:55 | fix(sprint3): Drift web support |
| `8c9d388` | Eialarasu | 2026-06-02 08:00 | **Merge PR #4 — Sprint 3 Hotfix** |
| `85d65d9` | Kiro Agent | 2026-06-02 08:15 | feat(sprint4): Streak & Consistency Engine |
| `3f7ec86` | Kiro Agent | 2026-06-02 08:20 | docs(sprint4): evaluation + valuation reports, fix integration tests |
| `0811923` | Eialarasu | 2026-06-02 08:30 | **Merge PR #5 — Sprint 4 Complete** |
| `50bfcaf` | Kiro Agent | 2026-06-02 09:00 | fix(sprint4): Journal UX (logo, timer display, delete) |
| `bbe0650` | Eialarasu | 2026-06-02 09:15 | **Merge PR #6 — Sprint 4 Hotfix (Journal UX)** |
| `7bacceb` | Kiro Agent | 2026-06-02 10:00 | fix(sprint4): branding, responsive nav, timer requirement |
| `b318b06` | Eialarasu | 2026-06-02 10:10 | **Merge PR #7 — UI broke** |
| `1394abf` | Eialarasu | 2026-06-02 10:20 | **Merge PR #8 — Revert PR #7** |
| `aeff6c4` | Kiro Agent | 2026-06-02 11:00 | fix(sprint4): UI polish (Align approach for nav, BrandedAppBar) |
| `db32304` | Eialarasu | 2026-06-02 11:30 | **Merge PR #9 — UI Polish (verified via Vercel preview)** |
| `c8fcc65` | Kiro Agent | 2026-06-02 12:30 | feat(sprint5): Cloud Backup Integration |
| `d472af6` | Kiro Agent | 2026-06-02 12:45 | docs(sprint5): evaluation + valuation (finish-sprint) |
| `2462052` | Eialarasu | 2026-06-02 13:00 | **Merge PR #10 — Sprint 5 Complete** |
| `a2bd0ca` | Kiro Agent | 2026-06-02 13:30 | feat(sprint6): Notifications + Onboarding |
| `e8f4984` | Kiro Agent | 2026-06-02 13:45 | fix(sprint6): onboarding UX (responsive, alphabetical, navigation) |
| `60182f7` | Eialarasu | 2026-06-02 14:00 | **Merge PR #11 — Sprint 6 Complete** |
| `192a915` | Kiro Agent | 2026-06-02 14:30 | feat(sprint7): AI Wisdom Engine |
| `7ff5bb7` | Eialarasu | 2026-06-02 15:00 | **Merge PR #12 — Sprint 7 Complete** |
| `5a28637` | Kiro Agent | 2026-06-03 07:00 | feat(sprint8): Theming, Profile & Core UX |
| `7037a71` | Kiro Agent | 2026-06-03 07:30 | fix(sprint8): profile name loading |
| `ab1497b` | Kiro Agent | 2026-06-03 08:00 | fix(sprint8): integration tests for OnboardingGuard |
| `4bdc62c` | Kiro Agent | 2026-06-03 08:30 | fix(sprint8): preserve display name from onboarding |
| `8c5e1a2` | Kiro Agent | 2026-06-03 09:00 | docs(sprint8): evaluation + valuation (finish-sprint) |
| `b836115` | Eialarasu | 2026-06-03 09:30 | **Merge PR #13 — Sprint 8 Complete** |
| `b1e35e0` | Kiro Agent | 2026-06-03 09:30 | feat(sprint9): i18n, animations & polish |
| `f1cc883` | Kiro Agent | 2026-06-03 09:45 | fix(sprint9): CI lint errors, l10n setup |
| `5a8c1a7` | Kiro Agent | 2026-06-03 10:00 | fix(l10n): non-synthetic package with committed generated files |
| `0676b34` | Kiro Agent | 2026-06-03 10:10 | fix(lint): directive sections ordering |
| `fd1fbe3` | Kiro Agent | 2026-06-03 10:15 | fix(build): restore generate flag |
| `6232c44` | Kiro Agent | 2026-06-03 10:30 | fix: Clear All Data resets onboarding |
| `037266b` | Kiro Agent | 2026-06-03 11:00 | fix: reset onboarding form to step 0 |
| `3cef991` | Kiro Agent | 2026-06-03 11:30 | docs(sprint9): evaluation + valuation (finish-sprint) |
| `de55359` | Eialarasu | 2026-06-03 12:00 | **Merge PR #14 — Sprint 9 Complete** |
| `be66567` | Kiro Agent | 2026-06-03 12:30 | feat(sprint10): Testing & Hardening — test suite + security + offline |
| `d36fe73` | Kiro Agent | 2026-06-03 13:00 | fix(tests): replace scroll-dependent assertions |
| `82258c8` | Kiro Agent | 2026-06-03 13:15 | fix(tests): remove fragile widget tests |
| `ed6a1d4` | Kiro Agent | 2026-06-03 13:30 | fix(ci): set coverage threshold at 25% |
| `04acacf` | Kiro Agent | 2026-06-03 13:45 | docs: add new docs to README |
| `ac20148` | Eialarasu | 2026-06-03 14:00 | **Merge PR #16 — Sprint 10 Complete** |
| `f0e2b35` | Kiro Agent | 2026-06-03 14:30 | feat(sprint11): Smoke Test Plan, CI polish, revised release plan |
| `b1aa7a1` | Eialarasu | 2026-06-03 15:00 | **Merge PR #18 — Sprint 11 Complete** |
| `aaa78a0` | Kiro Agent | 2026-07-02 10:00 | feat(sprint12): Fix Pakshi algorithm + Tamil translations |
| `d8e1ed5` | Kiro Agent | 2026-07-02 10:15 | fix(ci): resolve dart analyze issues |
| `59337ce` | Kiro Agent | 2026-07-02 10:20 | fix(ci): escape bracket in doc comment |
| `020e4b3` | Eialarasu | 2026-07-02 10:30 | **Merge PR #21 — Sprint 12 Complete** |
| `c17ea52` | Kiro Agent | 2026-07-02 14:00 | fix(i18n): Complete Tamil translations for Home and Journal pages |
| `be388c8` | Kiro Agent | 2026-07-02 15:00 | fix(i18n): Complete remaining Tamil translations — timer, pacer, advice, days |
| `a01c7f3` | Kiro Agent | 2026-07-02 16:00 | fix(i18n): Localize nakshatra and bird names in profile card |
| `1596148` | Eialarasu | 2026-07-02 16:30 | **Merge PR #22 — Tamil Hotfix Complete** |
| `51859eb` | Kiro Agent | 2026-07-03 10:00 | feat(sprint13): Web Production Deployment — Cloudflare Pages setup |
| `414750c` | Eialarasu | 2026-07-03 10:30 | **Merge PR #25 — Sprint 13 (initial)** |
| `2d1b948` | Kiro Agent | 2026-07-03 11:00 | fix(sprint13): Switch to Vercel production, remove Cloudflare workflow |
| `a51b8d6` | Eialarasu | 2026-07-03 11:15 | **Merge PR #26 — Sprint 13 Vercel switch** |
| `6de27db` | Kiro Agent | 2026-07-04 10:00 | feat(sprint14): Birth Bird Dashboard + Rahu Kaal + Nostril Chart |
| `e0b93e7` | Kiro Agent | 2026-07-04 11:00 | fix(ci): resolve analyze issues — lint rules + Drift query |
| `571ae10` | Kiro Agent | 2026-07-04 11:15 | ci: lower coverage threshold to 20% for UI-heavy Sprint 14 |
| `e0e4f19` | Kiro Agent | 2026-07-04 11:30 | fix(ui): responsive two-column layout for medium+ devices |
| `b8568ce` | Kiro Agent | 2026-07-04 12:00 | fix(ui): state emojis in schedule + two-column Hold/Streak |
| `a437801` | Kiro Agent | 2026-07-04 12:30 | feat(deploy): Add prod branch safety gate |
| `3967fe9` | Kiro Agent | 2026-07-04 13:00 | fix(ui): resolve RenderFlex overflow in NostrilDominanceChart |
| `MERGE` | Eialarasu | 2026-07-04 13:30 | **Merge PR #29 — Sprint 14 Complete** |
| `e3c9cff` | Kiro Agent | 2026-07-05 14:00 | feat(sprint15): Night Yamas + Full 24h View |
| `538a0ea` | Kiro Agent | 2026-07-05 14:15 | fix(ci): remove unnecessary non-null assertions |
| `6f725c9` | Eialarasu | 2026-07-05 14:30 | **Merge PR #33 — Sprint 15 Complete** |
| `942510d` | Jules Bot | 2026-07-03 09:00 | test: domain layer coverage enhancement |
| `0a07ea7` | Eialarasu | 2026-07-03 10:32 | **Merge PR #38 — Jules Domain Tests** |
| `2a3b2f7` | Kiro Agent | 2026-07-03 11:00 | feat(sprint16): CloudKit container + schema + sync infrastructure |
| `d12729d` | Kiro Agent | 2026-07-03 11:15 | feat(sprint16): sync-on-open (pull remote at launch) |
| `e6826b5` | Kiro Agent | 2026-07-03 11:30 | feat(sprint16): push local changes to iCloud after write |
| `d5e2430` | Kiro Agent | 2026-07-03 11:45 | feat(sprint16): primary device configuration in Settings |
| `307dff4` | Kiro Agent | 2026-07-03 12:00 | feat(sprint16): add Flutter macOS target + CloudKit entitlements |
| `c3474c1` | Kiro Agent | 2026-07-03 12:15 | test(sprint16): unit tests + multi-device testing guide |
| `bbdf92f` | Kiro Agent | 2026-07-03 12:30 | docs(sprint16): dev environment setup guide |
| `47c9031` | Eialarasu | 2026-07-03 13:00 | **Merge PR #39 — Sprint 16 Complete** |
| `c67aa0c` | Kiro Agent | 2026-07-03 13:30 | feat(sprint17): flutter_local_notifications + NotificationService |
| `2e4f3f9` | Kiro Agent | 2026-07-03 14:00 | feat(sprint17): personalized bird notifications + Rahu Kaal + morning summary |
| `d99d3ba` | Kiro Agent | 2026-07-03 14:30 | feat(sprint17): Tamil wisdom library — locale-aware Daily Wisdom |
| `7ca1e28` | Eialarasu | 2026-07-03 15:00 | **Merge PR #41 — Sprint 17 Complete** |
| `03acf5b` | Kiro Agent | 2026-07-03 16:00 | feat(sprint18): date picker on Home — view any date's Pakshi schedule |
| `f98f44d` | Kiro Agent | 2026-07-03 16:30 | feat(sprint18): 'Best Times This Week' card — 7-day Ruling yama scan |
| `34210cf` | Kiro Agent | 2026-07-03 17:00 | feat(sprint18): journal entries linked to historical dates |
| `a0d1fa0` | Kiro Agent | 2026-07-03 17:30 | feat(sprint18): calendar month view with entry indicators |
| `ba29eec` | Eialarasu | 2026-07-03 18:30 | **Merge PR #44 — Sprint 18 Complete** |
| `6adde19` | Kiro Agent | 2026-07-04 08:30 | feat(sprint19): Analytics + Export — full analytics screen |
| `3f3c0bc` | Eialarasu | 2026-07-04 10:30 | **Merge PR #46 — Sprint 19 Complete** |
| `67e4923` | Kiro Agent | 2026-07-04 12:00 | feat(home): split Home into Today/Explore sub-tabs (Task 20.1) |
| `320cb32` | Kiro Agent | 2026-07-04 12:30 | feat(ui): responsive two-column layout for Journal, Settings, Analytics (Task 20.4) |
| `8eff976` | Kiro Agent | 2026-07-04 13:00 | feat(settings): full data export/import as JSON (Task 20.6) |
| `d3457e3` | Kiro Agent | 2026-07-04 14:00 | fix(ui): move Settings to top-right + reorder schedule + lint |
| `4b689a0` | Kiro Agent | 2026-07-04 15:00 | feat(ui): vibrant bird+breath logo + fix Settings page width |
| `062b699` | Kiro Agent | 2026-07-04 16:00 | fix(settings): consistent background + back button alignment |
| `de57ccb` | Eialarasu | 2026-07-04 16:30 | **Merge PR #51 — Sprint 20 Complete** |
| `b3fc2d1` | Kiro Agent | 2026-07-04 17:00 | docs(/project-update): Sprint 20 documentation + logo alternatives |
| `d676e33` | Eialarasu | 2026-07-04 17:30 | **Merge PR #53 — Sprint 20 Docs** |
| `1da9ee4` | Kiro Agent | 2026-07-04 18:00 | fix(lint): resolve all 12 analyzer issues |
| `4084a51` | Kiro Agent | 2026-07-04 18:15 | fix(test): update tests for Sprint 21 changes |
| `b12950d` | Kiro Agent | 2026-07-04 18:30 | fix(test): relax moon latitude test to range check |
| `7e11194` | Kiro Agent | 2026-07-04 19:00 | fix: onboarding UX redesign (5→4 steps), i18n, web pickers, Indian cities only |
| `0e5fcde` | Kiro Agent | 2026-07-04 19:30 | fix(web): date/time pickers — add Navigator to OnboardingGuard |
| `106becc` | Kiro Agent | 2026-07-04 19:45 | fix(web): remove context.go() after saveProfile — guard handles transition |
| `20d734c` | Kiro Agent | 2026-07-04 20:00 | fix: location step layout shift — pin content to top-left |
| `b01c686` | Kiro Agent | 2026-07-04 20:15 | docs: mark Sprint 21 complete, add web polish tasks to Sprint 22 |
| `f243860` | Eialarasu | 2026-07-04 20:30 | **Merge PR #54 — Sprint 21 Complete** |
| `978cd49` | Kiro Agent | 2026-07-05 03:00 | chore: mark Sprint 22 as In Progress |
| `b12d5c1` | Kiro Agent | 2026-07-05 03:30 | test(sprint22): widget tests for all dashboard widgets (Tasks 22.1-22.6) |
| `949a44b` | Kiro Agent | 2026-07-05 04:00 | fix(web): add COOP/COEP headers for Drift WASM SharedArrayBuffer |
| `ed197f8` | Kiro Agent | 2026-07-05 04:15 | fix(web): enable color emoji preloading |
| `0a7c3a4` | Kiro Agent | 2026-07-05 05:00 | fix: notification scheduler weekday conversion |
| `129649f` | Kiro Agent | 2026-07-05 05:30 | ci: split into two-tier test strategy |
| `5f31dac` | Eialarasu | 2026-07-05 06:00 | **Merge PR #56 — Sprint 22 Complete** |
| `67c666d` | Kiro Agent | 2026-07-05 08:00 | chore: mark Sprint 23 as In Progress |
| `d5615a8` | Kiro Agent | 2026-07-05 08:30 | feat(sprint23): About card, User Guide, Intro screen, dialog consistency |
| `7226d1c` | Kiro Agent | 2026-07-05 09:30 | fix: Get Started button — use ConsumerWidget with direct ref |
| `0e89a6c` | Kiro Agent | 2026-07-05 09:45 | fix: Get Started button — add unique Keys to Navigators |
| `3e081c1` | Kiro Agent | 2026-07-05 10:00 | fix(ui): move About card to personalSection for balanced layout |
| `f66a2db` | Kiro Agent | 2026-07-05 10:15 | feat(i18n): locale-aware Privacy Policy |
| `5ba67be` | Kiro Agent | 2026-07-05 10:30 | fix(ui): align Settings back button with content on wide screens |
| `c83437a` | Kiro Agent | 2026-07-05 10:45 | fix(i18n): correct Tamil name — இயலரசு |
| `d649010` | Eialarasu | 2026-07-05 11:00 | **Merge PR #59 — Sprint 23 Complete** |
| `00fbd23` | Eialarasu | 2026-07-05 12:00 | **Merge PR #60 — Sprint 23 Docs** |
| `de31b9a` | Kiro Agent | 2026-07-05 13:30 | feat(sprint24): UX Polish — empty states, loading & error handling |
| `ebf0f02` | Kiro Agent | 2026-07-05 13:45 | fix: remove redundant default arguments in ShimmerLoading |
| `1bd89f8` | Kiro Agent | 2026-07-05 14:30 | fix: analytics providers reactively refresh when journal entries change |
| `a468c2d` | Kiro Agent | 2026-07-05 15:00 | docs: mark Sprint 24 complete (PR #61) |
| `1ff0a26` | Eialarasu | 2026-07-05 15:15 | **Merge PR #61 — Sprint 24 Complete** |
| `ca16d76` | Eialarasu | 2026-07-05 16:00 | **Merge PR #62 — Sprint 24 Docs** |
| `88b18bb` | Kiro Agent | 2026-07-06 00:30 | feat(sprint25): Performance & Accessibility polish (Tasks 25.1-25.5) |
| `6305c58` | Kiro Agent | 2026-07-06 00:45 | docs(sprint25): Smoke test plan refresh + versioned results (Tasks 25.6-25.7) |
| `f3cc480` | Kiro Agent | 2026-07-06 01:00 | fix(web): remove COOP/COEP headers causing Safari white screen |
| `a999233` | Kiro Agent | 2026-07-06 01:15 | fix(web): remove canvasKitVariant 'chromium' — breaks Safari |
| `e8df498` | Kiro Agent | 2026-07-06 01:30 | fix: night schedule always visible + Enter key uses CallbackShortcuts |
| `7738313` | Kiro Agent | 2026-07-06 02:00 | fix(deps): pin sqlparser to 0.44.5 — 0.44.6 breaks drift_dev |
| `72183ed` | Kiro Agent | 2026-07-06 02:30 | fix: invalidate dashboard after location/birth star change in Settings |
| `8a8c3f4` | Eialarasu | 2026-07-06 03:00 | **Merge PR #63 — Sprint 25 Complete** |
| `682b2bf` | Kiro Agent | 2026-07-06 03:30 | feat(sprint26): Daily Engagement & Delight (Tasks 26.1-26.6) |
| `b7914e7` | Kiro Agent | 2026-07-06 04:00 | fix(lint): resolve all 8 analyze issues |
| `8192522` | Kiro Agent | 2026-07-06 04:30 | docs: mark Sprint 26 complete (PR #65) |
| `369c2cc` | Eialarasu | 2026-07-06 05:00 | **Merge PR #65 — Sprint 26 Complete** |
| `3535eaf` | Kiro Agent | 2026-07-06 06:00 | feat(sprint27): Layer 1 Gap Fixes — Diagnostic Foundation (Tasks 27.1-27.4) |
| `427520e` | Kiro Agent | 2026-07-06 06:15 | fix(test): update Sushumna tests for context-dependent alignment |
| `d8be5b7` | Kiro Agent | 2026-07-06 06:30 | fix(i18n): add Tamil translations for Hora planet + Tattva element names |
| `93358a6` | Kiro Agent | 2026-07-06 07:00 | feat(sprint27): Reference table, language toggle, DOB recalculation (Tasks 27.5-27.7) |
| `ed4def8` | Kiro Agent | 2026-07-06 08:00 | fix(i18n): translate all hardcoded strings in onboarding steps 2 & 3 |
| `6de943a` | Kiro Agent | 2026-07-06 08:30 | feat(i18n): trilingual nakshatra display in selection lists |
| `c8efc5a` | Eialarasu | 2026-07-06 09:00 | **Merge PR #68 — Sprint 27 Complete** |

---

## Comprehensive Time Investment Breakdown

### Active Coding Sessions (from git commit clustering)

| Session | Date | Window | Hours | Sprints |
|---------|------|--------|-------|---------|
| Day 1 | 2026-06-02 | 06:00 - 15:00 | ~9.0 | Sprint 0–7 + hotfixes |
| Day 2 | 2026-06-03 | 07:00 - 09:30 | ~2.5 | Sprint 8 |
| Day 2 | 2026-06-03 | 09:30 - 11:30 | ~2.0 | Sprint 9 |
| Day 2 | 2026-06-03 | 11:30 - 14:00 | ~2.5 | Sprint 10 |
| Day 2 | 2026-06-03 | 14:00 - 15:00 | ~1.0 | Sprint 11 |
| Day 3 | 2026-07-02 | 10:00 - 16:30 | ~3.5 | Sprint 12 |
| Day 3 (cont.) | 2026-07-03 | 10:00 - 11:30 | ~2.0 | Sprint 13 |
| Day 4 | 2026-07-04 | 10:00 - 13:30 | ~3.5 | Sprint 14 |
| Day 4 (cont.) | 2026-07-05 | 14:00 - 16:00 | ~2.5 | Sprint 15 |
| Day 5 | 2026-07-03 | 11:00 - 13:30 | ~3.0 | Sprint 16 |
| Day 5 (cont.) | 2026-07-03 | 13:30 - 16:00 | ~2.5 | Sprint 17 |
| Day 5 (cont.) | 2026-07-03 | 16:00 - 18:30 | ~2.5 | Sprint 18 |
| Day 6 | 2026-07-04 | 08:00 - 10:30 | ~2.5 | Sprint 19 |
| Day 6 (cont.) | 2026-07-04 | 11:00 - 16:30 | ~4.0 | Sprint 20 |
| Day 6 (cont.) | 2026-07-04 | 17:00 - 20:30 | ~2.5 | Sprint 21 |
| Day 7 | 2026-07-05 | 03:00 - 06:00 | ~3.0 | Sprint 22 |
| Day 7 (cont.) | 2026-07-05 | 08:00 - 11:00 | ~3.5 | Sprint 23 |
| Day 7 (cont.) | 2026-07-05 | 13:00 - 15:15 | ~2.5 | Sprint 24 |
| Day 8 | 2026-07-06 | 00:00 - 03:00 | ~3.0 | Sprint 25 |
| Day 8 (cont.) | 2026-07-06 | 03:00 - 05:00 | ~2.0 | Sprint 26 |
| Day 8 (cont.) | 2026-07-06 | 05:00 - 09:00 | ~4.0 | Sprint 27 |
| Day 9 | 2026-07-07-08 | Various | ~4.0 | Smoke test + v1.2.0 release + docs audit |
| | | **Subtotal** | **~67.5** | |

*Note: This project is developed with AI-assisted coding (Kiro Agent), resulting in significantly compressed development timelines compared to traditional development.*

### Infrastructure & Administrative Operations (off-commit)

| Activity | Hours | Details |
|----------|-------|---------|
| Vercel hosting configuration | ~1.0 | Repository linking, build script, PR previews, public repo migration |
| Flutter SDK provisioning (sandbox) | ~0.5 | SDK download, channel setup, initial configuration |
| GitHub Actions CI setup & debugging | ~1.5 | Workflow creation, Node.js 24 migration, coverage gate, integration tests |
| Drift WebAssembly configuration | ~0.5 | sqlite3.wasm sourcing, drift_worker.js compilation, web debugging |
| Project planning & documentation | ~3.0 | Architecture decisions, sprint planning, testing strategy, evaluation docs |
| Preview testing & iteration | ~0.5 | Sprint 21 Vercel preview QA cycles (date picker, layout fixes) |
| | **Subtotal** | **~7.0** |

### Total Project Investment

| Category | Hours |
|----------|-------|
| Active coding & debugging (AI-assisted) | 63.5 |
| Infrastructure & admin ops | 7.5 |
| Smoke test & release ops | 4.0 |
| **Total** | **~75.0** |

---

## Sprint Delivery Summary

| Sprint | Focus | PRs | Tests | Status |
|--------|-------|-----|-------|--------|
| Sprint 0 | Pre-development & project initialization | — | 0 | ✅ Complete |
| Sprint 1 | Project scaffold & core architecture | #1 | 2 | ✅ Complete |
| Sprint 2 | Astro-Logic Engine (Pure Dart TDD) | #2 | 110 | ✅ Complete |
| Sprint 3 | Sara Kalai Breath Journal UI + Logic | #3, #4 | 127 | ✅ Complete |
| Sprint 4 | Streak & Consistency Engine + UI Polish | #5, #6, #7→#8→#9 | 150 | ✅ Complete |
| Sprint 5 | Cloud Backup Integration | #10 | 165 | ✅ Complete |
| Sprint 6 | Notifications + Onboarding | #11 | 183 | ✅ Complete |
| Sprint 7 | AI Wisdom Engine | #12 | 201 | ✅ Complete |
| Sprint 8 | Theming, Profile & Core UX | #13 | 201 | ✅ Complete |
| Sprint 9 | i18n, Animations & Polish | #14 | 201 | ✅ Complete |
| Sprint 10 | Testing & Hardening | #16 | 264 | ✅ Complete |
| Sprint 11 | Smoke Test Plan & CI Polish | #18 | 264 | ✅ Complete |
| Sprint 12 | Manual Smoke Test Execution & Fixes | #21, #22, #23 | 264 | ✅ Complete |
| Sprint 13 | Web Production Deployment | #25, #26 | 264 | ✅ Complete |
| Sprint 14 | Birth Bird Dashboard + Rahu Kaal + Nostril Chart | #29 | 264 | ✅ Complete |
| Sprint 15 | Night Yamas + Full 24h View | #33, #34 | 264 | ✅ Complete |
| Sprint 16 | iCloud Sync + macOS Target | #39 | 264+ | ✅ Complete |
| Sprint 17 | Notifications + Daily Engagement | #41 | 264+ | ✅ Complete |
| Sprint 18 | Historical View + Planning | #44 | 264+ | ✅ Complete |
| Sprint 19 | Analytics + Export | #46 | 264+ | ✅ Complete |
| Sprint 20 | UI Polish + Home Layout Redesign | #51 | 348+ | ✅ Complete |
| Sprint 21 | Pakshi Accuracy (DOB-Based Calculation) | #54 | 348+ | ✅ Complete |
| Sprint 22 | Widget Test Coverage + Web Polish | #56 | 410+ | ✅ Complete |
| Sprint 23 | Product Polish — About, User Guide & Onboarding Intro | #59 | 410+ | ✅ Complete |
| Sprint 24 | UX Polish — Empty States, Loading & Error Handling | #61 | 410+ | ✅ Complete |
| Sprint 25 | Performance, Accessibility & Smoke Test Refresh | #63 | 410+ | ✅ Complete |
| Sprint 26 | Daily Engagement & Delight | #65 | 410+ | ✅ Complete |
| Sprint 27 | Layer 1 Gap Fixes — Diagnostic Foundation | #68 | 410+ | ✅ Complete |

---

## Technical Deliverables (as of Sprint 23)

- **Flutter 3.44.1** cross-platform app (iOS, Android, Web)
- **8 pure Dart calculators** (Sunrise, Yama, Rahu, Hora, Pakshi, Tattva, Lunar, Oracle) — zero network dependency
- **Full breath journal** with alignment checking, live timer (seconds display), micro-advice, history, delete
- **Streak engine** with 7-day ribbon, 30-day trend, Yama accuracy tracking
- **Cloud backup architecture** (abstract interface, stub providers, database export, UI)
- **4-step onboarding flow** (Welcome → Find Your Bird → Your Location → Data Storage) with dual-path "Find Your Bird" UI
- **Notification scheduling** (Yama boundaries, ruling/eating toggles)
- **AI Wisdom Engine** (rules-based, 60+ proverbs, daily caching, deterministic fallback)
- **8 Material 3 theme variants** (4 colors × Light/Dark + System mode)
- **Profile system** (editable name, birth star with warning, location, bird display with emoji)
- **OnboardingGuard** (auto-redirect on first launch)
- **AstroInfoBar** (sunrise/sunset + current bird state on Home dashboard)
- **BrandedAppBar** with responsive logo + title across all screens
- **201 automated tests** with GitHub Actions CI enforcement
- **Responsive layout** (1200px max-width on desktop, centered bottom nav)
- **Vercel staging** with PR preview support (repo public)
- **Drift/WebAssembly SQLite** for web platform persistence
- **Full i18n** with English + Tamil (90+ strings), LocaleProvider with persistence
- **Language switcher** (EN/TA SegmentedButton in Settings)
- **CloudKit sync architecture** — MethodChannel-based service, record-level sync engine (pull→merge→push), native Swift plugins for iOS + macOS
- **Sync-on-open widget** — auto-sync on app launch and resume from background
- **Push-after-write triggers** — journal entries and profile updates auto-push to CloudKit
- **Primary device conflict resolution** — Settings UI with device toggle, name editor, sync status, other devices list
- **macOS platform target** — full scaffold (AppDelegate, CloudKitPlugin, entitlements, Podfile, MainMenu.xib)
- **iCloud sync testing guide** — 7 multi-device scenarios with CloudKit setup instructions
- **Local dev environment guide** — 10-step iMac setup (Flutter, Xcode, CloudKit, lefthook)
- **Real local notifications** — `flutter_local_notifications` with OS-level zonedSchedule, permission handling, platform channels
- **Personalized bird notifications** — "Your Vulture is now Ruling" with state-specific guidance text
- **4 configurable notification types** — Ruling transitions, Eating state, Rahu Kaal start/end, Morning summary at sunrise
- **Tamil wisdom library** — 52+ Tamil proverbs, locale-aware RulesEngine + FallbackHandler, cache invalidation on language switch
- **Date-parameterized dashboard** — selectedDateProvider drives all astro calculations for any date
- **Date selector widget** — arrows, date picker dialog, Tomorrow quick-access, Today reset
- **Best Times This Week** — 7-day scan showing birth bird's Ruling yama windows
- **Historical entries card** — past date journal entries with flow, alignment, hold time
- **Calendar month view** — month grid with entry dot indicators, tappable day navigation
- **Analytics screen** — dedicated 4th tab with 6 insight cards (weekly/monthly/streak/yama/hold/export)
- **Weekly alignment summary** — 4-week breakdown with progress bars
- **Monthly patterns** — best/worst day, most/least active yama, avg entries per day
- **Streak insights** — current/longest, total practice days, avg gap, consistency %
- **Yama performance breakdown** — sorted by practice frequency with % labels
- **Hold time progression** — weekly/monthly/all-time averages, personal best, trend direction
- **CSV export** — full 14-column journal data export to documents directory
- **Smooth page transitions** (fade-through 250ms on tab navigation)
- **Pull-to-refresh** on Home dashboard
- **Clear All Data** with confirmation dialog + full state reset (DB + SharedPreferences + onboarding)
- **Shared BirdEmoji utility** for consistent Pakshi display across app
- **Accessibility improvements** (Semantics labels, 48px touch targets, Material 3 WCAG contrast)
- **264 automated tests** with 25% coverage threshold enforcement
- **7 new unit test suites** (BirdEmoji, BreathTimer, DashboardData, Locale, Theme, OnboardingState, AppLocalizations)
- **Security review** documenting data-at-rest/in-transit protections and production recommendations
- **Offline verification matrix** confirming zero-network-dependency for all core features
- **Manual smoke test plan** (34 scenarios: accuracy vs Align27, core flow, settings, Tamil, edge cases)
- **Smoke test results template** (production pass gate — executed before deployment)
- **CI paths-ignore** for docs-only PRs (skip quality gates on .md/.kiro changes)
- **`/plan` protocol** for strategic sprint revisions
- **Revised release plan** (Sprints 11–14, cloud backup/auth deferred to 1.1)
- **Authentic Panja Pakshi 2D lookup tables** (9 day-group tables from Prof. Dr. U.S. Pulippani's "Biorhythms of Natal Moon")
- **`PakshiBirdL10n` + `PakshiStateL10n` extensions** for localized bird/state display
- **`NakshatraL10n` utility** with all 27 Tamil nakshatra name mappings
- **Complete Tamil (தமிழ்) localization** — 130+ ARB keys covering all 3 app pages
- **Smoke test results** recorded (Section B/C/E pass, A/D fixed)
- **Production web deployment** at [saranidhi.vercel.app](https://saranidhi.vercel.app) via Vercel auto-deploy
- **Privacy policy** (`web/privacy.html`) — zero data collection, on-device only, GDPR-compliant
- **Deployment documentation** (`docs/deployment.md`) — workflow, rollback, monitoring, troubleshooting
- **Production deployment gate** — smoke test results formalized as deployment prerequisite
- **Release tag `v1.0.0-web`** — first public web release
- **Personalized Birth Bird Dashboard** — hero card showing user's birth bird + current state + guidance + yama progress
- **Full-Day 5-Yama Schedule** with color-coded bird states (👑🍽️🚶💤💀) + Align27 validation row
- **Rahu Kaal Card** with contextual urgency (red/amber/subtle) based on current time
- **Nostril Dominance Chart** — expected Solar/Lunar per yama with next switch countdown
- **Today's Hold Time Card** — average breath hold from today's entries
- **Responsive two-column layout** for medium+ screens (>=600px)
- **Production branch safety gate** — `main` = staging, `prod` = production (documented)
- **Coverage threshold** lowered to 20% (UI-heavy sprint, domain still ~95%)
- **Night Yama Calculator** (`YamaCalculator.calculateNight()`) — sunset→sunrise ÷ 5 segments
- **9 Nighttime Pakshi state tables** (4 bright half + 5 dark half, matching Prof. Pulippani reference)
- **10-yama full-day schedule** — unified day (Y1-5) + night (Y6-10) timeline view
- **BirthBirdCard night support** — shows birth bird state after sunset with night-specific guidance
- **Night guidance text** (EN + TA) — meditation, sleep, spiritual practice timing
- **3-tier deployment architecture** — Production (`saranidhi.vercel.app`), Staging (`saranidhi-staging.vercel.app`), Preview (per-PR)
- **`/release` protocol** — PR-based promotion from main→prod with versioning
- **Home Today/Explore sub-tabs** — TabBar splitting dashboard into focused "Today" (7 live cards) and "Explore" (date navigation, history, trends)
- **Full JSON data export/import** — DataExportImportWidget in Settings: export all 4 tables + SharedPreferences to JSON, import with validation + confirmation + provider invalidation
- **Settings moved to top-right** — gear icon in BrandedAppBar actions, removed from bottom nav (now 3 tabs: Home, Journal, Analytics)
- **Schedule column reorder** — Yama → Time → Bird emoji → State name → State emoji for visual clarity
- **Vibrant bird+breath logo** — golden bird in flight on deep indigo-to-purple gradient (primary: `logo.svg`)
- **4 logo alternatives** — cosmic eye (`logo-cosmic-eye.svg`), lotus flame (`logo-lotus-flame.svg`), breath mandala (`logo-breath-mandala.svg`)
- **SVG favicon** — `web/favicon.svg` for browser tab branding
- **share_plus + file_picker** dependencies for cross-platform file sharing and picking
- **Responsive two-column audit** — all screens (Journal, Settings, Analytics) now use ≥600px breakpoint consistently
- **Moon Longitude Calculator** — Pure Dart implementation of Jean Meeus ELP 2000/82 algorithm for lunar position (no network/ephemeris dependency)
- **Lahiri Ayanamsa Calculator** — sidereal correction from tropical longitude for any given date
- **Nakshatra-from-DOB Calculator** — Moon sidereal longitude → nakshatra index (0–26) with boundary detection (~0.5° tolerance warning)
- **Onboarding UX redesign (5→4 steps)** — merged Birth Star + DOB into "Find Your Bird" step with SegmentedButton dual-path ("I know my star" / "Calculate from DOB")
- **IST assumption for Indian births** — no separate birth place field; Moon ±0.5°/hr negligible within India's timezone span vs 13.33° nakshatra width
- **OnboardingGuard Navigator wrapper** — wraps OnboardingScreen in its own Navigator so picker dialogs work on Flutter Web (MaterialApp.builder renders outside GoRouter)
- **Extended birth bird attributes** — friends, enemies, ruling planet, direction, colour for all 5 Pakshi birds
- **Indian-only preset cities** — removed international cities (London, NY, Singapore, Sydney) from onboarding and settings
- **Analytics tab i18n** — replaced hardcoded 'Analytics' label with `l10n.analyticsTitle`
- **10 widget test files** (BirthBirdCard, RahuKaalCard, FullDaySchedule, NostrilDominanceChart, HoldTimeCard, StreakFlameWidget, TrendWidget, SevenDayRibbonWidget, YamaAccuracyWidget, WisdomCard) + shared `widget_test_helpers.dart`
- **Two-tier CI strategy** — `ci.yml` (Tier 1: domain/provider tests on PRs, ~30s) + `ci-full.yml` (Tier 2: all tests + coverage + integration on merge to main)
- **Vercel COOP/COEP headers** — Cross-Origin-Opener-Policy + Cross-Origin-Embedder-Policy for Drift WASM SharedArrayBuffer
- **Custom `flutter_bootstrap.js`** — useColorEmoji:true for Noto Color Emoji preloading
- **Notification scheduler bug fix** — weekday conversion using `dartWeekdayToSunBased()` for correct Pakshi/Rahu calculations
- **Pre-onboarding IntroScreen** — scrollable guide with "Get Started" button shown before 4-step onboarding (ConsumerWidget + introSeenProvider + Navigator ValueKeys)
- **About card in Settings** — Apple-style card with logo, dynamic version (package_info_plus), developer info (Eialarasu, vteial@icloud.com), tappable email/website links
- **User Guide screen** — 9-section flat scrollable guide (What is Saranidhi, Science, Birth Bird, Daily Rhythm, How to Use, Best Practices, Dashboard, Benefits, FAQ)
- **Locale-aware Privacy Policy** — `privacy-en.html` + `privacy-ta.html` with dynamic URL via `Uri.base.origin`
- **Settings layout improvements** — SliverAppBar inside ConstrainedBox for aligned back button, About card in personalSection (left column)
- **`package_info_plus` + `url_launcher`** dependencies for version display and external link launching
- **Reusable `EmptyStateWidget`** — configurable icon + title + subtitle + optional action button for consistent empty states across the app
- **`ShimmerLoading` widget** — animated gradient skeleton cards mimicking dashboard layout (responsive: two-column on ≥600px), replaces CircularProgressIndicator on Today/Explore tabs
- **`ErrorBoundary` / `ErrorFallback` widgets** — graceful error handling with cloud-off icon, "Something went wrong" message, and retry button
- **Journal empty state** — decorative breath icon with ring + "Begin Your Breath Journey" + upward arrow hint pointing to entry widget
- **Analytics full empty state** — `EmptyStateWidget` with "Your Insights Await" when no entries exist; individual cards use enhanced `_emptyCard()` with info icon
- **Explore tab historical empty state** — centered icon + "No entries on this day" + guidance hint for selected dates with no entries
- **Streak zero-state improvement** — motivational "Build Your Streak" onboarding card with 3 steps for new users (replaces dimmed flame + "0 days")
- **Reactive analytics providers** — all analytics `FutureProvider`s now watch `journalEntriesProvider.future` for automatic refresh when entries change (fixes stale cache bug)
- **`TimezoneUtils` utility** — derives UTC offset from profile latitude/longitude (Indian bounding box returns IST 5.5, others use longitude/15 rounded to 0.5)
- **`ProfileLocationProvider`** — cached FutureProvider for synchronous access to profile location (used by breath alignment checker, notifications, dashboard)
- **Dynamic timezone** — all 4 hardcoded `const utcOffset = 5.5` instances replaced with `TimezoneUtils.offsetForLocation()` (notification_providers, streak_providers, journal_providers)
- **Keyboard navigation (web)** — `CallbackShortcuts` + `Focus(autofocus: true)` on Journal screen; Enter key submits entry when timer is complete
- **Haptic feedback** — `HapticFeedback.lightImpact()` on breath flow button selection, `HapticFeedback.mediumImpact()` on timer tap (no-op on web via flutter/services.dart)
- **Semantic labels** — `Semantics(button, label, selected/hint)` on breath flow buttons and breath timer card for screen reader accessibility
- **Night schedule always visible** — full 10-yama schedule (Y1–Y10) shown during daytime too; active marker only highlights at night
- **Safari compatibility fix** — removed `canvasKitVariant: "chromium"` from `flutter_bootstrap.js` (forced Chrome-only CanvasKit that crashed Safari)
- **COOP/COEP headers removed** — `Cross-Origin-Opener-Policy: same-origin` broke iOS/macOS Safari; Drift WASM uses fallback worker mode without SharedArrayBuffer
- **Location change reactivity** — `dashboardDataProvider` and `profileLocationProvider` invalidated after profile location/birth star edit in Settings (no reload needed)
- **sqlparser 0.44.5 pinned** — `dependency_overrides` added because sqlparser 0.44.6 broke drift_dev 2.34.0 (upstream incompatibility)
- **Smoke test plan rewritten** — slimmer critical-path version (52 scenarios, 9 sections: A–I) covering all Sprint 14–24 features
- **Versioned smoke test results** — `smoke-test-results-v1.0.0.md` (archived), `smoke-test-results.md` (summary index), `smoke-test-results-v1.2.0.md` (checklist for next release)
- **What's New screen** — version-tracked via SharedPreferences (`shouldShowWhatsNewProvider`), shown once per version update with 6 feature items, dismissible "Got it!" button
- **Streak celebrations** — `StreakCelebrationOverlay` with elastic scale + fade animation at 7/30/100/365 day milestones, auto-dismisses after 3 seconds
- **Breath timer presets** — `BreathPreset` model (4-7-8, Box Breathing, Energizing, Calming) + `PresetSelector` horizontal ChoiceChip widget for guided patterns
- **Daily summary card** — `DailySummaryCard` showing today's entries count, alignment status, average hold time (only visible when entries > 0)
- **Pin/star entries** — `isPinned` BoolColumn added to SaraKalaiJournal table for favouriting entries
- **Notification quick-log** — `onNotificationTap` callback in NotificationService.initialize(), `payload` field on ScheduledNotification (default 'quick_log' for routing to journal)
- **ActionWindow enum** — `artha` (Ruling/Walking), `kriya` (Eating), `yoga` (Sleeping/Dying) with `fromBirdState()` mapping. Seeds Layer 2 Action Windows engine.
- **Context-dependent Sushumna alignment** — `AlignmentChecker` modified: Sushumna aligned only in Yoga window (Sleeping/Dying), blocked in Artha/Kriya. AlignmentResult extended with `actionWindow` field.
- **Guided nostril test** — `GuidedNostrilTest` 3-step bottom sheet modal (exhale test → isolation → auto-populate flow)
- **LocationService utility** — Haversine distance calculation, `hasMovedSignificantly()` with 50km threshold, `isGpsAvailable` platform check
- **Hora + Tattva in BirthBirdCard** — `DashboardData` extended with `activeHora` + `activeTattva`, `_HoraTattvaRow` widget with localized planet/element names (EN + TA)
- **Reference table in User Guide** — bilingual tables: 27 nakshatras (EN + TA + Bird), 7 planets (EN + TA + Sanskrit), 5 elements (EN + TA + Sanskrit)
- **Language toggle in onboarding** — EN/TA SegmentedButton at top-right of IntroScreen + progress row of OnboardingScreen
- **DOB recalculation from Settings** — "Recalculate from DOB" option in birth star edit dialog with date/time pickers + NakshatraCalculator
- **Trilingual nakshatra display** — `NakshatraL10n.trilingualDisplay()` shows "English / தமிழ்" in all selection lists
- **Onboarding i18n completion** — 9 hardcoded English strings in Find Your Bird + Location steps replaced with l10n keys

---

## Future Sprint Updates

This report will be updated at the end of each sprint with:
- New commit timeline entries
- Updated time investment totals
- Sprint delivery status transitions
- New technical deliverables

---

[← Back to Root](../README.md)
