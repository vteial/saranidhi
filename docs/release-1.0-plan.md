[← Back to Root](../README.md)

# Saranidhi — Release 1.0 Plan (Revised)

## Release Vision

Release 1.0 delivers a **fully functional, privacy-first spiritual breath-tracking app** across iOS, Android, and Web. Quality over quantity — every feature that ships must work accurately and feel right for daily spiritual practice.

---

## Release 1.0 Scope

### Included in 1.0

- Complete Astro-Logic Engine (Sunrise, Yama, Rahu, Hora, Pakshi, Tattva)
- Sara Kalai Breath Journal with two-click logging + optional duration timer
- Streak & Consistency Engine (streaks, 7-day ribbon, 30-day trends)
- Local notifications (mobile: Yama state transitions)
- Rules-based AI wisdom (web) + deterministic fallback (60+ proverbs)
- Material 3 theming (4 colors × Light/Dark + System)
- Localization (English + Tamil — spiritual terms verified)
- Onboarding flow (birth star, location, storage mode)
- Manual smoke test verified against Align27 (accuracy gate)
- Production deployment: Web (Cloudflare Pages) + iOS (App Store) + Android (Play Store)

### Deferred to Release 1.1

- Cloud backup/restore (iCloud on iOS, Google Drive on Android/Web)
- Apple Sign-In / Google Sign-In (for cloud access)
- On-device LLM integration (mobile — currently rules-based fallback)
- Database export/encryption for backup
- Restore flow (detect backup on sign-in, offer import)

### Deferred to Release 1.2+

- Breath session guided programs (structured pranayama courses)
- Social sharing (streak cards, achievement badges)
- Widget support (iOS/Android home screen widgets)
- Apple Watch / Wear OS companion
- Advanced analytics (weekly/monthly PDF reports)
- Additional languages beyond EN/TA
- RevenueCat premium tier implementation
- Derive nakshatra/pakshi from DOB + Time + precise location

---

## Sprint-to-Release Mapping

| Sprint | Focus Area | Key Deliverables | Status |
|--------|-----------|------------------|--------|
| **Sprint 0** | Pre-Development | Repo init, docs, steering files, logo | ✅ Complete |
| **Sprint 1** | Project Scaffold + Core Architecture | Flutter project, Drift DB, Riverpod, GoRouter, CI | ✅ Complete (PR #1) |
| **Sprint 2** | Astro-Logic Engine (Pure Dart TDD) | Sunrise, Yama, Rahu, Hora, Pakshi, Tattva, Lunar | ✅ Complete (PR #2) |
| **Sprint 3** | Sara Kalai Breath Journal | Entry UI, alignment check, timer, micro-advice, Quick Sync Pacer | ✅ Complete (PR #3) |
| **Sprint 4** | Streak & Consistency Engine | Streak calc, 7-day ribbon, 30-day trend, Yama accuracy | ✅ Complete (PR #5) |
| **Sprint 5** | Cloud Backup Integration | Abstract interface, stub providers, storage selector, backup UI | ✅ Complete (PR #10) |
| **Sprint 6** | Notifications + Onboarding | Local push, onboarding flow, birth star, location | ✅ Complete (PR #11) |
| **Sprint 7** | AI Wisdom Engine | Rules engine, wisdom library, fallback, daily caching | ✅ Complete (PR #12) |
| **Sprint 8** | Theming, Profile & Core UX | 8 theme variants, profile system, sunrise/bird on Home | ✅ Complete (PR #13) |
| **Sprint 9** | i18n, Animations & Polish | EN/TA translations, language switcher, transitions, pull-to-refresh, clear data | ✅ Complete (PR #14) |
| **Sprint 10** | Testing & Hardening | 264 tests, security review, offline verification, coverage gate | ✅ Complete (PR #16) |
| **Sprint 11** | Smoke Test Plan & CI Polish | Manual test plan, results template, CI paths-ignore, plan protocol, Tamil polish | ✅ In Progress |
| **Sprint 12** | Manual Smoke Execution & Fixes | Execute tests vs Align27, fix accuracy/Tamil/UX issues | 🔲 Next |
| **Sprint 13** | Web Production Deployment | Cloudflare Pages, prod branch, privacy policy, smoke results as gate | 🔲 Planned |
| **Sprint 14** | Mobile App Store Deployment | iOS (iPhone SE/iPad Mini focus), Android, store listings | 🔲 Planned |

---

## Quality Gate: Manual Smoke Test

**Before production deployment (Sprint 13), the following must pass:**

| Section | Scenarios | Required |
|---------|-----------|----------|
| A: Calculation Accuracy | 7 checks vs Align27 | All pass (±2 min tolerance) |
| B: Core User Flow | 8 scenarios | All pass |
| C: Settings & Data | 9 scenarios | All pass |
| D: Tamil Quality | 5 checks | 4 of 5 pass |
| E: Edge Cases | 5 scenarios | All pass |

Results recorded in `docs/smoke-test-results.md` and included in production PR.

---

## Milestone Gates (per sprint)

| Gate | Criteria |
|------|----------|
| **Code Quality** | `flutter analyze --fatal-infos` — zero issues |
| **Tests** | `flutter test` — all pass |
| **Coverage** | ≥ 25% (enforced in CI) |
| **Build** | `flutter build web` compiles |
| **Documentation** | Sprint tracker updated |
| **Review** | PR created, CI passes, owner approves |

---

## Definition of Done — Release 1.0

- [x] All feature sprints (1–10) merged to `main`
- [ ] Manual smoke test passes (all sections)
- [ ] `prod` branch created and deployed
- [ ] Web app live on Cloudflare Pages
- [ ] iOS app approved on App Store (iPhone SE / iPad Mini verified)
- [ ] Android app approved on Play Store
- [ ] Privacy policy published
- [ ] App listing assets prepared (screenshots, description, keywords)
- [ ] Tag release `v1.0.0`

---

## Risk Register

| Risk | Impact | Mitigation |
|------|--------|------------|
| Sunrise calculation inaccuracy at user's location | Wrong Yama/Pakshi timing | Verified against Align27 in smoke test |
| App Store rejection (spiritual content policies) | Launch delayed | Follow Apple guidelines, avoid medical claims |
| Tamil translation errors for spiritual terms | User confusion | Manual verification in smoke test Section D |
| Drift/sql.js performance on web for large datasets | Slow queries | Paginate queries, index key columns |
| iPhone SE viewport too small for dashboard | UI overflow | Test on actual device in Sprint 14 |

---

[← Back to Root](../README.md)
