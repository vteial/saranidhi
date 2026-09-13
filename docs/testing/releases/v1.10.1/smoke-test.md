[← Back to Smoke Test Index](../../smoke-test-results.md) · [Sprint 41 dossier](../../../process/sprints/sprint-41-analytics-tidy/README.md)

# Smoke Test — v1.10.1-web (Sprint 41, Analytics Tidy + Tamil l10n) — SLIM

**Release:** v1.10.1-web (Sprint 41 — Analytics tidy + Tamil l10n) · **Light patch**
**Date:** _pending_
**Tester:** Antigravity (QA-Verify Agent)
**Shipping Commit:** _pending_ on `release/v1.10.1` (PR #___)
**Device/Browser:** Chrome — Desktop (1024×768) + Mobile (390×844)
**Environment:** PR Vercel **preview** — `https://saranidhi-git-release-v1101-eialarasus-projects.vercel.app` (via `VERCEL_AUTOMATION_BYPASS_SECRET`) — **NOT** staging

## Result

- **Status:** ⏳ _pending — awaiting QA-Verify run on the PR preview_
- **Build / Version to confirm:** Settings → About must read **`Saranidhi v1.10.1 (1)`**.
- **CI Gate:** must be GREEN on the release PR (Analyze / Fast Tests / Build + Full Suite).

> **Why slim:** v1.10.1 is a widget-move + localization patch with **no core-calc / engine
> change** — the calc suite (615 tests) + CI already cover behavior. This smoke targets only what
> CI can't catch: the CSV export working from its **new Settings home** (incl. the web share path)
> and the **Analytics Tamil** rendering. Matches the light-release precedent (v1.8.1).

---

## Scenario Plan

| # | Scenario | Status | What to verify |
|---|----------|:------:|----------------|
| 1 | **CSV export from Settings** | ⏳ | Settings → Data Export/Import now shows **three** buttons: JSON export, Import, **Export journal as CSV**. Tapping "Export journal as CSV" produces the share sheet / download of `saranidhi_journal_<date>.csv`; the CSV opens with the expected journal columns. Test on **web** (the old path was mobile-only). |
| 2 | **CSV gone from Analytics** | ⏳ | The Analytics screen no longer shows the Export/CSV card; the Hold-Time Progression card renders **full-width** where Row 3 was; no empty gap / no layout overflow at 390px or 1024px. |
| 3 | **Analytics Tamil localization** | ⏳ | In தமிழ் mode, the Analytics screen renders the Yama badge as **`யா1`/`யா2`** (not `Y1`), the day/second suffixes as **`நா`/`வி`**, and dates in Tamil locale — zero English leakage; no overflow with the longer Tamil strings. |
| — | **Version confirm** | ⏳ | Settings → About = `Saranidhi v1.10.1 (1)`. |

---

## Detailed Scenarios

### Scenario 1: CSV export from Settings
- [ ] Settings → Data Export/Import → confirm the 3rd button "Export journal as CSV".
- [ ] Tap → share sheet / download of `saranidhi_journal_<yyyy-MM-dd>.csv`; verify columns.
- [ ] Confirm it works on **web** (previously unsupported).
- **Result:** ⏳

### Scenario 2: CSV gone from Analytics + layout
- [ ] Analytics screen: no CSV/Export card; Hold-Time card full-width; no overflow at 390px / 1024px.
- **Result:** ⏳

### Scenario 3: Analytics Tamil
- [ ] Switch to தமிழ் → Analytics shows `யா1`/`யா2`, `நா`/`வி` suffixes, Tamil-locale dates; no English leakage / overflow.
- **Result:** ⏳

### Version confirm
- [ ] Settings → About = `Saranidhi v1.10.1 (1)`.
- **Result:** ⏳

---

## Bugs / Regressions

_None recorded yet — fill during the QA-Verify run. Any issue → fix on `release/v1.10.1`,
re-verify the specific scenario, then proceed._
