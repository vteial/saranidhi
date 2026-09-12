[← Back to Smoke Test Index](../../smoke-test-results.md) · [Sprint 40 dossier](../../../process/sprints/sprint-40-chronobiology/README.md)

# Smoke Test — v1.10.0-web (Sprint 40, Chronobiology & Holistic Guidance)

**Release:** v1.10.0-web (Sprint 40 — Chronobiology & Holistic Guidance)
**Date:** _pending_
**Tester:** Antigravity (QA-Verify Agent)
**Shipping Commit:** _pending_ on `release/v1.10.0` (PR #___)
**Device/Browser:** Chrome — Desktop (1200×900) + Tablet (1024×768) + Mobile (390×844)
**Environment:** PR Vercel **preview** — `https://saranidhi-git-release-v1100-eialarasus-projects.vercel.app` (via `VERCEL_AUTOMATION_BYPASS_SECRET`) — **NOT** staging

## Result

- **Status:** ⏳ _pending — awaiting QA-Verify run on the PR preview_
- **Build / Version to confirm:** Settings → About must read **`Saranidhi v1.10.0 (1)`**.
- **CI Gate:** must be GREEN on the release PR (Analyze / Fast Tests / Build + Full Suite).

> **Scope note (what to focus on):** stagnancy detection depends on **journal history** (a
> stuck same-flow run over ~24h), which is hard to stage live in a single session. The
> stagnancy **thresholds/branching** are covered by unit + widget tests (14 + 6) and CI; the
> manual gate should focus on what CI can't catch: the **card's visual rendering + doctrinal
> copy** (warming vs cooling, mild vs chronic, gentle non-diagnostic tone), the **Swara-Ahara
> Focus-Card prompt** across flow states, the **bilingual morning-summary** Pada Gamana line,
> **Tamil** rendering, and the **regression eyeball** (dashboard/focus cards unchanged when
> no stagnancy). Where a live stuck-run can't be produced, verify via the widget-test
> evidence + a forced/seeded state and mark the scenario accordingly (honest-but-partial).

---

## Scenario Plan

| # | Scenario | Status | What to verify |
|---|----------|:------:|----------------|
| 1 | **Stagnancy card — hidden when healthy** | ⏳ | With normal/alternating (or no) breath history, **no** stagnancy card renders on Home (Today). No empty placeholder. |
| 2 | **Stagnancy card — cooling (stuck solar/right)** | ⏳ | With a stuck-right run (seed/force if needed), the card shows **cooling** copy (Sheetali, cool fluids), muted amber styling, gentle non-diagnostic tone; mild vs chronic severity phrasing differs. Verify via live state if reproducible, else widget-test evidence + note. |
| 3 | **Stagnancy card — warming (stuck lunar/left)** | ⏳ | Stuck-left run → **warming** copy (Surya Bhedana, warming spices, movement). |
| 4 | **Rebalance affordance → somatic timer** | ⏳ | The card's low-emphasis rebalance action opens the existing Sprint 35 `showInterventionSelector`, targeting the **opposite** flow. No new/duplicate timer UI. |
| 5 | **Swara-Ahara prompt on the Kriya Focus Card** | ⏳ | In a Kriya window: **right/solar** flow → affirming "digestive fire well-placed" line; **left/lunar** flow → gentle pre-meal reset nudge + action into the somatic selector (target right); **non-Kriya** windows unchanged. |
| 6 | **Tattva temperature tip** | ⏳ | When the active element agrees with the stuck flow (Fire+solar → cooling / Water+lunar → warming), the reinforcing tattva line appears; when they don't agree (or no stagnancy), it does **not**. |
| 7 | **Bilingual morning-summary Pada Gamana** | ⏳ | With morning-summary notifications on, the summary body includes the waking foot/nostril rule, and renders in the selected language (EN + தமிழ்). |
| 8 | **Tamil localization** | ⏳ | In Tamil mode: stagnancy card titles/descriptions, Swara-Ahara prompts, tattva tips, and the rebalance action all render in **pure Tamil script** (zero English leakage). |
| — | **Regression eyeball** | ⏳ | With no stagnancy, the Today dashboard + Focus Card render exactly as v1.9.x. No overflow at 390px / 1024px. |
| — | **Version confirm** | ⏳ | Settings → About = `Saranidhi v1.10.0 (1)`. |

---

## Detailed Scenarios

### Scenario 1: Stagnancy card hidden when healthy
- [ ] On Home (Today) with healthy/alternating (or empty) history, confirm no stagnancy card.
- **Result:** ⏳

### Scenario 2: Cooling (stuck solar/right)
- [ ] Produce/seed a stuck-right run (≥6h, ≥3 logs) → verify cooling copy, mild vs chronic tone, amber styling.
- **Result:** ⏳

### Scenario 3: Warming (stuck lunar/left)
- [ ] Produce/seed a stuck-left run → verify warming copy.
- **Result:** ⏳

### Scenario 4: Rebalance → somatic timer
- [ ] Tap the rebalance action → confirm the Sprint 35 intervention selector opens targeting the opposite flow.
- **Result:** ⏳

### Scenario 5: Swara-Ahara Kriya prompt
- [ ] Kriya window, right/solar flow → affirming line; left/lunar → reset nudge + action; non-Kriya → unchanged.
- **Result:** ⏳

### Scenario 6: Tattva temperature tip
- [ ] Verify the tip appears only when element agrees with stuck flow.
- **Result:** ⏳

### Scenario 7: Morning-summary Pada Gamana (bilingual)
- [ ] Enable morning summary → verify waking-rule line in EN and TA.
- **Result:** ⏳

### Scenario 8: Tamil localization
- [ ] Switch to தமிழ் → verify all new copy in pure Tamil script.
- **Result:** ⏳

### Regression eyeball
- [ ] No-stagnancy dashboard identical to v1.9.x; no overflow at 390px / 1024px; About = v1.10.0.
- **Result:** ⏳

---

## Bugs / Regressions

_None recorded yet — fill during the QA-Verify run. Any issue → fix on `release/v1.10.0`,
re-verify the specific scenario, then proceed._
