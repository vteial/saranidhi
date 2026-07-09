[← Back to Root](../README.md)

# Saranidhi — Session Handoff

> Living document for context continuity across Kiro Web sessions.
> When starting a new session, say: "Check `docs/session-handoff.md` for context."

---

## Current State (as of 2026-07-08)

| Item | Status |
|------|--------|
| **Production** | v1.2.0-web live at [saranidhi.vercel.app](https://saranidhi.vercel.app) |
| **Staging** | Latest main at [saranidhi-staging.vercel.app](https://saranidhi-staging.vercel.app) |
| **Sprints delivered** | 27 |
| **Total PRs** | 76 |
| **Engineering hours** | ~75h |
| **User mode** | 2-day prod testing (owner as daily user) |
| **Next sprint** | Sprint 27.5 (bugfix + minor features batch) |

---

## Open Backlog (Sprint 27.5)

| # | Item | Type | Effort |
|---|------|------|--------|
| 1 | DB migration — `isPinned` column needs ALTER TABLE | Bugfix | 20 min |
| 2 | Lunar phase hardcoded in AlignmentChecker (`LunarPhase.waxing`) | Bugfix | 5 min |
| 3 | Calendar month view not translated to Tamil | i18n | 15 min |
| 4 | DOB calculation result text needs translation | i18n | 10 min |
| 5 | Export: add app version + schema version to JSON | Feature | 20 min |
| 6 | Import: validate version before proceeding | Feature | 15 min |
| 7 | Kuligai Kaal calculation + display | Feature | 30 min |
| 8 | Enhanced Rahu card (sunrise/sunset + moon phase + Kuligai) | UX | 20 min |
| 9 | Remove Align27 references from app UI (full day schedule row) | Cleanup | 15 min |
| 10 | Create `docs/third-party-comparison.md` (bird state mapping) | Internal doc | 10 min |

**Estimated total:** ~2.5–3h

**Trigger:** User issues `/sprint-start` after 2-day prod testing completes.

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
- **v1.3.0:** Sprint 28–29 (Action Windows — 24h bar + Current Mode Focus Card)
- **v2.0.0:** Sprint 30–31 (Prasanam Oracle — FAB trigger, 3-vector calculation)
- **Oracle formula:** V1×0.35 + V2×0.40 + V3×0.25
- **Prasanam trigger:** FAB on Today tab
- **Output tiers:** Strong Yes (≥0.8) / Favorable (≥0.6) / Caution (≥0.4) / Delay (≥0.2) / Hard No (<0.2)

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

---

## Next Session: Start Here

1. Check if user has new issues from prod testing → append to Sprint 27.5 backlog
2. `/sprint-start` Sprint 27.5 → batch-fix all items
3. After merge: quick smoke test (re-test fixed items only) → v1.2.1-web release
4. Then: Sprint 28 (Layer 2 — Action Windows Engine)

---

[← Back to Root](../README.md)
