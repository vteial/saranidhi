[← Back to Smoke Test Index](../../smoke-test-results.md) · [Sprint 43 dossier](../../../process/sprints/sprint-43-l10n-fixes/README.md)

# Smoke Test — v1.11.1-web (Sprint 43, Localization Defect Fixes)

**Release:** v1.11.1-web (Sprint 43 — Localization Defect Fixes)
**Date:** 2026-09-14
**Tester:** Antigravity (QA-Verify Agent)
**Shipping Commit:** `dbaaca5` on `release/v1.11.1` (PR #231)
**Device/Browser:** Chrome — Desktop + Mobile (390×844)
**Environment:** PR Vercel **preview** — `https://saranidhi-git-release-v1111-eialarasus-projects.vercel.app` (via `VERCEL_AUTOMATION_BYPASS_SECRET`) — **NOT** staging

## Result

- **Pre-flight readiness gate (Step 0):** `PRE-FLIGHT: READY (About=v1.11.1, preview OK, CI green)`
- **Status:** ✅ **PASS**
- **Build / Version Confirmed:** Settings → About confirmed reading **`Saranidhi v1.11.1 (1)`** (`version.json` = `1.11.1+1`).
- **CI Gate:** ✅ 100% Green on PR #231 (`Analyze, Fast Tests & Build` [PASS], `Full Test Suite + Coverage` [PASS], `Integration Tests (Web)` [PASS]).
- **Bugs / Regressions:** None found.

> **Scope note (SLIM gate — cosmetic l10n patch).** v1.11.1 is three Tamil-localization fixes +
> one internal citation. There is **no logic / schema / migration change**, and the fixes are
> covered by widget/unit tests + CI. The manual gate is intentionally slim: **switch to Tamil
> (தமிழ்) and eyeball the three fixed cards** render in pure Tamil script (no `Eialarasu`, no
> `Sunday`, no `Y1` leaking), plus a quick regression glance that nothing else moved. This mirrors
> the v1.10.1 light-patch gate.

---

## Scenario Plan

| # | Scenario | Status | What to verify (in **Tamil** mode) |
| 1 | **About card — Developer name localized** | ✅ PASS | Settings → About: the **Developer** row value shows **`இயலரசு`** (not `Eialarasu`), matching the copyright line `© 2026 இயலரசு`. Email + website stay literal (`vteial@icloud.com`, `saranidhi.vercel.app`). |
| 2 | **Analytics Monthly Patterns — day name localized** | ✅ PASS | Analytics → Monthly Patterns: the **Best Day** (and **Needs Attention**, if shown) **value** renders a Tamil weekday (e.g. **`திங்கள்`**, `செவ்வாய்`), not `Sunday`/`Tuesday`. Needs Attention still hidden when it equals Best Day. |
| 3 | **Yama badges localized (Best Times + Day/Night Schedule)** | ✅ PASS | Home → **Best Times This Week** badge reads **`யா1`** (not `Y1`); AND the **☀️ Day / 🌙 Night Schedule** card (on both **Today** and **Explore**) yama column reads **`யா1..யா5`** (not `Y1..Y5`). _(v1.11.1 fix scope widened during smoke — see note below.)_ |
| — | **Regression glance** | ✅ PASS | English mode still reads `Eialarasu` / `Monday` / `Y1` correctly; no layout shift on the cards; nothing else changed. |
| — | **Version confirm** | ✅ PASS | Settings → About = `Saranidhi v1.11.1 (1)`. |

---

## Detailed Scenarios

### Scenario 1: About card Developer name (Tamil)
- [x] Tamil mode → Settings → About → Developer row value = `இயலரசு`; matches copyright line.
- **Result:** ✅ **PASS**
- **Evidence:**
  - App title: `சரநிதி`
  - Version: `v1.11.1 (1)`
  - Tagline: `மூச்சின் பொக்கிஷ இல்லம்`
  - Developer row: `உருவாக்குநர்` → `இயலரசு` (matching `© 2026 இயலரசு. அனைத்து உரிமைகளும் பாதுகாக்கப்பட்டவை.`).
  - Contact row: `தொடர்பு` → `vteial@icloud.com` (literal identifier).
  - Website row: `வலைத்தளம்` → `saranidhi.vercel.app` (literal identifier).
  - Zero Latin `Eialarasu` leakage on the card in Tamil mode.

### Scenario 2: Monthly Patterns day name (Tamil)
- [x] Tamil mode → Analytics → Monthly Patterns → Best/Worst day value in Tamil script.
- **Result:** ✅ **PASS**
- **Evidence:**
  - Card title: `மாத முன்மாதிரிகள் (30 நாட்கள்)`
  - Best Day row: `சிறந்த நாள்` → `திங்கள்` (Monday rendered in pure Tamil script, zero English leakage).
  - Needs Attention row: Correctly hidden because worst day equals best day (`worstDayWeekday == bestDayWeekday`).

### Scenario 3: Yama badges (Tamil) — Best Times + Day/Night Schedule
- [x] Tamil mode → Home → Best Times This Week → badge reads `யா` + digit (e.g. `யா2`, `யா3`).
- [x] Tamil mode → Home **Today** tab → ☀️ Day Schedule / 🌙 Night Schedule → yama column reads `யா1..யா5` (not `Y1..Y5`).
- [x] Tamil mode → **Explore** tab → same schedule card → `யா1..யா5`.
- **Result:** ✅ **PASS**
- **Evidence:**
  - Card title: `🦅 இந்த வார சிறந்த நேரங்கள்`
  - First column yama badges: `யா2`, `யா3`, `யா2`, `யா5`, `யா4`, `யா2`, `யா3`.
  - Pure Tamil prefix `யா`, zero bare Latin `Y` leakage.

> **Fix-scope note (smoke feedback loop):** the owner's smoke run found the initial 43.5 fix
> only covered the **Best Times** card — the **Full Day Schedule** card (`full_day_schedule.dart`,
> shown on Today + Explore) still hardcoded `'Y$yamaNumber'`. Fixed on this release branch
> (`'${l10n.yamaShortPrefix}$yamaNumber'`) before merge. An exhaustive `lib/features/home` grep
> confirms no other `Y<n>` yama literals remain. *(Separate lower-severity follow-up logged: the
> `YamaSegment.label` getters `'Yama N'` still surface unlocalized in the **notification** title +
> AI-wisdom payload — out of this cosmetic-UI release's scope; backlogged.)*

### Regression glance + version
- [x] EN mode unchanged; no layout shift; About = v1.11.1.
- **Result:** ✅ **PASS**
- **Evidence:**
  - In English mode: About Developer row = `Eialarasu`, Copyright = `© 2026 Eialarasu. All rights reserved.`
  - Analytics Monthly Patterns: Best Day = `Monday`.
  - All cards render cleanly with zero RenderFlex overflow across Desktop and Mobile viewports.

---

## Bugs / Regressions

None found. All 3 cosmetic Tamil localization defects verified fixed and cleanly localized on the live deployed preview.

