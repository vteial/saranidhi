[← Back to Root](../README.md)

# Saranidhi — Release 1.0 Plan

## Release Vision

Release 1.0 delivers a **fully functional, privacy-first spiritual breath-tracking app** across iOS, Android, and Web. The user can track their breath alignment with cosmic rhythms, build streaks, receive AI-powered guidance, and back up data to their own cloud account — all without any developer-owned server infrastructure.

---

## Release 1.0 Scope

### Included in 1.0

- Complete Astro-Logic Engine (Sunrise, Yama, Rahu, Hora, Pakshi, Tattva)
- Sara Kalai Breath Journal with two-click logging + optional duration timer
- Streak & Consistency Engine (streaks, 7-day ribbon, 30-day trends)
- Cloud backup/restore (iCloud on iOS, Google Drive on Android/Web)
- Local notifications (mobile: Yama state transitions)
- On-device AI wisdom (mobile) + rules-based wisdom (web)
- Material 3 theming (Light, Dark, Emerald, Gold)
- Localization (English + Tamil)
- Onboarding flow (birth star, location, storage mode selection)
- Production deployment (App Store, Play Store, Cloudflare Pages)

### Deferred to 1.1+

- Breath session guided programs (structured pranayama courses)
- Social sharing (streak cards, achievement badges)
- Widget support (iOS/Android home screen widgets)
- Apple Watch / Wear OS companion
- Advanced analytics (weekly/monthly PDF reports)
- Additional languages beyond EN/TA
- RevenueCat premium tier implementation

---

## Sprint-to-Release Mapping

| Sprint | Focus Area | Key Deliverables | Acceptance Criteria |
|--------|-----------|------------------|---------------------|
| **Sprint 0** | Pre-Development | Repo init, docs, steering files, logo | All docs committed to `main`, repo public |
| **Sprint 1** | Project Scaffold + Core Architecture | Flutter project, Drift DB, Riverpod providers, GoRouter shell, CI pipeline | App builds on iOS/Android/Web, empty shell navigates, CI passes |
| **Sprint 2** | Astro-Logic Engine (Pure Dart TDD) | Sunrise/Sunset, 5 Yamas, Rahu Kaal, Hora, Pakshi states, Tattva cycles | 100% unit test coverage on all calculation functions, zero network dependency |
| **Sprint 3** | Sara Kalai Breath Journal | Two-click entry UI, alignment check, breath timer, micro-advice, Quick Sync Pacer | User can log breath, see alignment, time breath — all persisted to local DB |
| **Sprint 4** | Streak & Consistency Engine | Streak calculation, 7-day ribbon, 30-day trend, Yama-level accuracy | Visual streak display, correct math on edge cases (gaps, timezone changes) |
| **Sprint 5** | Cloud Backup Integration | iCloud (iOS), Google Drive (Android/Web), storage mode selector, backup/restore | Full backup-restore cycle works on each platform, onboarding mode selection |
| **Sprint 6** | Notifications + Onboarding | Local push at Yama boundaries, first-run experience, profile setup, birth star input | Notifications fire at correct times, onboarding completes and persists profile |
| **Sprint 7** | AI Wisdom Engine | On-device model (mobile), rules-based engine (web), wisdom library, fallback proverbs | AI card renders insight, fallback works offline, context payload correct |
| **Sprint 8** | Theming, i18n & Polish | 4 Material 3 themes, EN/TA ARB files, animations, responsive layout finalization | Theme switch persists, all strings translated, smooth transitions |
| **Sprint 9** | Testing & Hardening | Unit tests (domain), widget tests (UI), integration tests, E2E smoke suite | Minimum 80% domain coverage, all smoke scenarios green |
| **Sprint 10** | Production Deployment | App Store submission, Play Store submission, Cloudflare Pages prod, CI/CD finalization | Apps approved and live, web accessible, CI green on `prod` branch |

---

## Milestone Gates

Each sprint must pass these gates before merge to `main`:

| Gate | Criteria |
|------|----------|
| **Code Quality** | `dart analyze` — zero warnings/errors |
| **Tests** | `flutter test` — all pass |
| **Build** | `flutter build web` compiles without error |
| **Documentation** | Sprint tracker updated, any new architecture documented |
| **Review** | PR created, reviewed, CI passes |

---

## Timeline Estimate

| Phase | Sprints | Estimated Duration |
|-------|---------|-------------------|
| Foundation (Scaffold + Engine) | Sprint 0–2 | 2–3 weeks |
| Core Features (Journal + Streaks) | Sprint 3–4 | 2 weeks |
| Platform Integration (Cloud + Notifications) | Sprint 5–6 | 2 weeks |
| Intelligence & Polish (AI + Theming) | Sprint 7–8 | 2 weeks |
| Hardening & Release (Tests + Deploy) | Sprint 9–10 | 2 weeks |
| **Total** | **11 sprints (0–10)** | **~10–12 weeks** |

*Note: Timeline assumes consistent development velocity. Sprints are sequential, not parallel.*

---

## Risk Register

| Risk | Impact | Mitigation |
|------|--------|------------|
| On-device LLM too large for older devices | AI feature degraded | Fallback to rules-based engine; make AI optional |
| Google Drive API changes/deprecation | Android/Web backup broken | Abstract behind repository interface; monitor API changelog |
| iCloud entitlement rejection (App Store) | iOS backup unavailable | Offer Google Drive as alternative on iOS |
| Sunrise calculation inaccuracy at extreme latitudes | Wrong Yama timing | Use well-tested astronomical algorithm (e.g., NOAA formula) |
| Drift/sql.js performance on web for large datasets | Slow queries | Paginate queries, index key columns, limit stored history |
| App Store rejection (spiritual content policies) | Launch delayed | Follow Apple guidelines, avoid medical claims |

---

## Success Metrics (Post-Launch)

| Metric | Target |
|--------|--------|
| Daily Active Users (DAU) | 100+ within first month |
| 7-day retention | > 40% |
| Average streak length | > 5 days |
| Crash-free rate | > 99.5% |
| App Store rating | > 4.5 stars |
| Cloud backup adoption | > 60% of users |

---

## Definition of Done — Release 1.0

- [ ] All 10 sprints merged to `main`
- [ ] `prod` branch created and deployed
- [ ] iOS app approved on App Store
- [ ] Android app approved on Play Store
- [ ] Web app live on Cloudflare Pages (custom domain)
- [ ] All smoke test scenarios passing
- [ ] Onboarding flow complete and tested
- [ ] Cloud backup/restore verified on all platforms
- [ ] Privacy policy published
- [ ] App listing assets prepared (screenshots, description, keywords)

---

[← Back to Root](../README.md)
