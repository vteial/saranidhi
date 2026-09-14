[← Back to Smoke Test Index](../../smoke-test-results.md) · [Sprint 43 dossier](../../../process/sprints/sprint-43-l10n-fixes/README.md)

# Smoke Test — v1.11.1-web (Sprint 43, Localization Defect Fixes)

**Release:** v1.11.1-web (Sprint 43 — Localization Defect Fixes)
**Date:** _pending_
**Tester:** Antigravity (QA-Verify Agent)
**Shipping Commit:** _pending_ on `release/v1.11.1` (PR #231)
**Device/Browser:** Chrome — Desktop + Mobile (390×844)
**Environment:** PR Vercel **preview** — `https://saranidhi-git-release-v1111-eialarasus-projects.vercel.app` (via `VERCEL_AUTOMATION_BYPASS_SECRET`) — **NOT** staging

## Result

- **Pre-flight readiness gate (Step 0):** ⏳ _pending_ — record `PRE-FLIGHT: READY (About=v1.11.1, preview OK, CI green)` before scenarios, or a `BLOCKED` reason (never fall back — see the QA-Verify prompt's ABORT PROTOCOL).
- **Status:** ⏳ _pending_
- **Build / Version Confirmed:** Settings → About should read **`Saranidhi v1.11.1 (1)`** _(confirm)_
- **CI Gate:** _(confirm green on the release PR)_
- **Bugs / Regressions:** _pending_

> **Scope note (SLIM gate — cosmetic l10n patch).** v1.11.1 is three Tamil-localization fixes +
> one internal citation. There is **no logic / schema / migration change**, and the fixes are
> covered by widget/unit tests + CI. The manual gate is intentionally slim: **switch to Tamil
> (தமிழ்) and eyeball the three fixed cards** render in pure Tamil script (no `Eialarasu`, no
> `Sunday`, no `Y1` leaking), plus a quick regression glance that nothing else moved. This mirrors
> the v1.10.1 light-patch gate.

---

## Scenario Plan

| # | Scenario | Status | What to verify (in **Tamil** mode) |
|---|----------|:------:|------------------------------------|
| 1 | **About card — Developer name localized** | ⏳ | Settings → About: the **Developer** row value shows **`இயலரசு`** (not `Eialarasu`), matching the copyright line `© 2026 இயலரசு`. Email + website stay literal (`vteial@icloud.com`, `saranidhi.vercel.app`). |
| 2 | **Analytics Monthly Patterns — day name localized** | ⏳ | Analytics → Monthly Patterns: the **Best Day** (and **Needs Attention**, if shown) **value** renders a Tamil weekday (e.g. **`ஞாயிறு`**, `செவ்வாய்`), not `Sunday`/`Tuesday`. Needs Attention still hidden when it equals Best Day. |
| 3 | **Yama badges localized (Best Times + Day/Night Schedule)** | ⏳ | Home → **Best Times This Week** badge reads **`யா1`** (not `Y1`); AND the **☀️ Day / 🌙 Night Schedule** card (on both **Today** and **Explore**) yama column reads **`யா1..யா5`** (not `Y1..Y5`). _(v1.11.1 fix scope widened during smoke — see note below.)_ |
| — | **Regression glance** | ⏳ | English mode still reads `Eialarasu` / `Sunday` / `Y1` correctly; no layout shift on the cards; nothing else changed. |
| — | **Version confirm** | ⏳ | Settings → About = `Saranidhi v1.11.1 (1)`. |

---

## Detailed Scenarios

### Scenario 1: About card Developer name (Tamil)
- [ ] Tamil mode → Settings → About → Developer row value = `இயலரசு`; matches copyright line.
- **Result:** ⏳
- **Evidence:**

### Scenario 2: Monthly Patterns day name (Tamil)
- [ ] Tamil mode → Analytics → Monthly Patterns → Best/Worst day value in Tamil script.
- **Result:** ⏳
- **Evidence:**

### Scenario 3: Yama badges (Tamil) — Best Times + Day/Night Schedule
- [ ] Tamil mode → Home → Best Times This Week → badge reads `யா1`.
- [ ] Tamil mode → Home **Today** tab → ☀️ Day Schedule / 🌙 Night Schedule → yama column reads `யா1..யா5` (not `Y1..Y5`).
- [ ] Tamil mode → **Explore** tab → same schedule card → `யா1..யா5`.
- **Result:** ⏳
- **Evidence:**

> **Fix-scope note (smoke feedback loop):** the owner's smoke run found the initial 43.5 fix
> only covered the **Best Times** card — the **Full Day Schedule** card (`full_day_schedule.dart`,
> shown on Today + Explore) still hardcoded `'Y$yamaNumber'`. Fixed on this release branch
> (`'${l10n.yamaShortPrefix}$yamaNumber'`) before merge. An exhaustive `lib/features/home` grep
> confirms no other `Y<n>` yama literals remain. *(Separate lower-severity follow-up logged: the
> `YamaSegment.label` getters `'Yama N'` still surface unlocalized in the **notification** title +
> AI-wisdom payload — out of this cosmetic-UI release's scope; backlogged.)*

### Regression glance + version
- [ ] EN mode unchanged; no layout shift; About = v1.11.1.
- **Result:** ⏳
- **Evidence:**

---

## Bugs / Regressions

_Pending execution._
