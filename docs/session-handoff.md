[← Back to Root](../README.md)

# Saranidhi — Session Handoff

> Living document for context continuity across Kiro Web sessions.
> When starting a new session, say: "Check `docs/session-handoff.md` for context."

---

## Current State (as of 2026-07-11)

| Item | Status |
|------|--------|
| **Production** | v1.2.2-web live at [saranidhi.vercel.app](https://saranidhi.vercel.app) |
| **Staging** | Latest main (Sprint 29 merged) |
| **Sprints delivered** | 29 |
| **Total PRs** | 102 |
| **Engineering hours** | ~86h |
| **User mode** | Daily use — production stable |
| **Next sprint** | Sprint 30 (Action Windows Engine + UI) |

---

## Open Backlog (Sprint 27.5)

| # | Item | Type | Priority |
|---|------|------|----------|
| 1 | DB migration — `isPinned` column needs ALTER TABLE | Bugfix | Medium |
| 2 | Lunar phase hardcoded in AlignmentChecker (`LunarPhase.waxing`) | Bugfix | **HIGH** |
| 3 | Calendar month view not translated to Tamil | i18n | Low |
| 4 | DOB calculation result text needs translation | i18n | Low |
| 5 | Export: add app version + schema version to JSON | Feature | Medium |
| 6 | Import: validate version before proceeding | Feature | Medium |
| 7 | Kuligai Kaal calculation + display | Feature | Medium |
| 8 | Enhanced Rahu card (sunrise/sunset + moon phase + Kuligai) | UX | Medium |
| 9 | Remove Align27 references from app UI (full day schedule row) | Cleanup | Medium |
| 10 | Create `docs/third-party-comparison.md` (bird state mapping + sources) | Internal doc | Low |
| 11 | "Best Times This Week" card not translated | i18n | Low |
| 12 | User Guide back button alignment (match Settings pattern) | UX | Low |
| 13 | Monthly Patterns: hide "Needs Attention" if same as "Best Day" | Bugfix | Low |
| 14 | `AppConstants` class — centralize global app data (name, version, dev, contact) | Refactor | Medium |
| 15 | Birth bird swaps with lunar phase (waxing↔waning) — Vulture↔Peacock, Owl↔Rooster, Crow stays | Bugfix | **HIGH** |
| 16 | Timer reset/cancel button during active phases | UX | Medium |
| 17 | Reorder nostril buttons: Lunar (Left) → Sushumna (Both) → Solar (Right) | UX | Medium |
| 18 | Sushumna: disable timer, show meditation advice, log as moment (duration tracking) | Feature | Medium |
| 19 | Tattva display: show "English / Sanskrit" format (e.g., "Air / Vayu", "காற்று / Vayu") | UX | Low |

**Sources:**
- #15: https://suzhimunai.wordpress.com/category/பஞ்ச-பட்சி-சாஸ்திரம்/
- #18: Owner's Sara Kalai workshop knowledge + Siva Swarodaya references (dasarpai.com, swarayoga.org)

**Estimated total:** ~5–6h

**Trigger:** User issues `/sprint-start` when ready.

---

## Decisions Made (Key Reference)

### Protocols (Naming Convention)
```
/sprint-start    → create branch, mark in progress
/sprint-finish   → push PR, mark complete, user merges
/sprint-update   → docs refresh (valuation, eval, smoke test, user guide)
/release-start   → smoke test branch + PR
/release-finish  → main→prod PR with release notes
/release-update  → post-release docs closure
/plan            → brainstorm + formalize sprint definitions
/hotfix          → quick bug fix
```

### E2E Testing Strategy
- **Hybrid approach:**
  - Unit + Widget tests → same repo (`test/`) — Dart/Flutter
  - Web E2E → **separate repo** (`vteial/saranidhi-e2e`) — Playwright (TypeScript)
  - Mobile E2E → same repo (`integration_test/`) — Flutter integration_test (future)
- **Rationale:** Playwright is purpose-built for web, tests deployed URLs, independent CI, fast, visual regression built-in

### v2.0 Roadmap (Layers 2 & 3)
- **v1.3.0:** Sprint 29–30 (Foundation + Action Windows Engine & UI)
- **v1.4.0:** Sprint 31–32 (Numerology + Prasanam Oracle)
- **v1.5.0:** Sprint 33–34 (Somatic Mastery + Chronobiology Analytics)
- **v2.0.0:** Sprint 35 (Integration Polish + App Store Prep)

### Architecture Decisions
- **ActionWindow enum:** Ruling/Walking→Artha, Eating→Kriya, Sleeping/Dying→Yoga
- **Sushumna:** Aligned only in Yoga window, blocked in Artha/Kriya
- **Timezone:** Derived from profile lat/lng (Indian bounding box → IST, others → longitude/15)
- **Safari compatibility:** No canvasKitVariant, no COOP/COEP headers
- **Keyboard shortcuts:** Use `CallbackShortcuts` + `Focus(autofocus: true)`, NOT `KeyboardListener`
- **Night schedule:** Always computed and displayed regardless of current time

### Smoke Test
- Single file per release: `docs/smoke-test-v{X.Y.Z}.md` (plan + results combined)
- `docs/smoke-test-results.md` = tiny index linking versions
- 62 scenarios in v1.2.0 (9 sections)

### Sprint 26 Widgets (Built, Not Wired)
These exist as code but aren't connected to the app UI yet:
- `WhatsNewScreen` — needs startup wiring
- `PresetSelector` — needs adding to Journal screen
- `StreakCelebrationOverlay` — needs trigger from dashboard
- `isPinned` column — needs star icon in journal history list

---

## Unresolved / Future Discussions

| Topic | Status | Notes |
|-------|--------|-------|
| Wire Sprint 26 widgets | Deferred | Do after Sprint 27.5 bugfixes or as part of Layer 2 UI sprint |
| Ayanamsa variants (Raman, KP, Vakya) | Deferred to v2.0 | Lahiri sufficient for 99% |
| GPS auto-location (geolocator package) | Deferred to App Store sprint | LocationService math exists, native GPS not added |
| Google Drive sync | Deferred to v1.1+ | Architecture stub exists |
| On-device LLM | Removed from plan | Rules-based engine sufficient |
| Kuligai segment offsets | Confirmed | Sun=7, Mon=6, Tue=5, Wed=4, Thu=3, Fri=2, Sat=1 |
| Birth bird phase swap mapping | Confirmed | Waxing: V-O-C-R-P, Waning: P-R-C-O-V (mirror 1↔5, 2↔4, 3 stays) |
| Sushumna = sacred observation | Confirmed | No breath holding, only meditation. Brief state (~4 min max). Log duration, not timer data. |

---

## Next Session: Start Here

1. `/release-start` v1.3.0-web (Sprint 29 + 30 combined)  
   OR `/sprint-start` Sprint 30 (Action Windows Engine + UI)
2. After Sprint 30 merge: v1.3.0-web release
3. Then: Sprint 31 (Numerology + NameBirdParser)

---

[← Back to Root](../README.md)
