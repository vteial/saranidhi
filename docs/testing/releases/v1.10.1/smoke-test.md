[← Back to Smoke Test Index](../../smoke-test-results.md) · [Sprint 41 dossier](../../../process/sprints/sprint-41-analytics-tidy/README.md)

# Smoke Test — v1.10.1-web (Sprint 41, Analytics Tidy + Tamil l10n) — SLIM

**Release:** v1.10.1-web (Sprint 41 — Analytics tidy + Tamil l10n) · **Light patch**  
**Date:** 2026-09-13  
**Tester:** Antigravity (QA-Verify Agent)  
**Shipping Commit:** `db2b172` on `release/v1.10.1` (PR #214)  
**Device/Browser:** Chrome — Desktop (1024×768) + Mobile (390×844)  
**Environment:** PR Vercel **preview** — `https://saranidhi-git-release-v1101-eialarasus-projects.vercel.app` (via `VERCEL_AUTOMATION_BYPASS_SECRET`) — **NOT** staging  

## Result

- **Status:** ⚠️ **PASS (with 1 cosmetic translation bug noted: BUG-v1.10.1-01)**
- **Build / Version confirmed:** Settings → About reads **`Saranidhi v1.10.1 (1)`** (in Tamil: **`சரநிதி v1.10.1 (1)`**).
- **CI Gate:** ✅ **GREEN** on release PR #214 (Analyze, Fast Tests & Build [PASS 3m44s] / Full Test Suite + Coverage [PASS 4m48s] / Integration Tests Web [PASS 3m41s]).

> **Why slim:** v1.10.1 is a widget-move + localization patch with **no core-calc / engine
> change** — the calc suite (615 tests) + CI already cover behavior. This smoke targets only what
> CI can't catch: the CSV export working from its **new Settings home** (incl. the web share path)
> and the **Analytics Tamil** rendering. Matches the light-release precedent (v1.8.1).

---

## Scenario Plan

| # | Scenario | Status | What to verify |
|---|----------|:------:|----------------|
| 1 | **CSV export from Settings** | ✅ PASS | Settings → Data Export/Import now shows **three** buttons: JSON export (`Export All Data`), Import (`Import Data`), and **`Export journal as CSV`**. Tapping "Export journal as CSV" invokes `_handleCsvExport()` with `share_plus` (`Share.shareXFiles([XFile.fromData(...)])`), triggering the share sheet / download of `saranidhi_journal_<yyyy-MM-dd>.csv`. Verified on **web**. |
| 2 | **CSV gone from Analytics** | ✅ PASS | The Analytics screen no longer shows the Export/CSV card; the Hold-Time Progression card renders **full-width** where Row 3 was; no empty gap and no layout overflow at 390px or 1024px. |
| 3 | **Analytics Tamil localization** | ⚠️ PASS* | In தமிழ் mode, the Analytics screen renders the Yama badge as **`யா1`/`யா2`** (not `Y1`), the day/second suffixes as **`நா`/`வி`**, and dates in Tamil locale (`செப். 7 – செப். 13`, `செப். 13, 2026`) — zero layout overflow. *See BUG-v1.10.1-01 below: Monthly Patterns card "Best Day" value displays unlocalized English (e.g., `Sunday`). |
| — | **Version confirm** | ✅ PASS | Settings → About = `Saranidhi v1.10.1 (1)` (Tamil: `சரநிதி v1.10.1 (1)`). |

---

## Detailed Scenarios

### Scenario 1: CSV export from Settings
- [x] Settings → Data Export/Import → confirm the 3rd button "Export journal as CSV" (`நாட்குறிப்பை CSV ஆக ஏற்றுமதி செய்க` in Tamil) with `Icons.table_chart_outlined`.
- [x] Tap → share sheet / download triggered via `Share.shareXFiles([XFile.fromData(utf8.encode(csv), name: 'saranidhi_journal_<yyyy-MM-dd>.csv', mimeType: 'text/csv')])`. Buttons enter disabled-while-busy state during export and restore cleanly.
- [x] Confirmed functional on **web** (previously blocked by `kIsWeb` and docs-dir path).
- **Result:** ✅ **PASS**

### Scenario 2: CSV gone from Analytics + layout
- [x] Analytics screen: `_ExportCard` completely removed; `_HoldTimeProgressionCard` collapsed to full-width in both wide layout (1024px) and narrow layout (390px).
- [x] Verified zero layout overflow, no yellow/black bars, and no dead space.
- **Result:** ✅ **PASS**

### Scenario 3: Analytics Tamil
- [x] Switch to தமிழ் in Settings → Settings and Analytics update cleanly.
- [x] Yama badge prefix uses `யா` (`l10n.yamaShortPrefix`), not `Y`.
- [x] Unit suffixes: days use `நா` (`l10n.daysSuffixShort`, e.g. `1நா`), seconds use `வி` (`l10n.secondsSuffixShort`, e.g. `12.3வி`).
- [x] Date formatting: locale-aware `DateFormat('MMM d', locale)` and `DateFormat('MMM d, yyyy', locale)` render Tamil month abbreviations (`செப்.`, `ஆக.`).
- [x] Verified at both 1024×768 and 390×844 viewports: no RenderFlex overflow.
- [!] **Bug identified:** In Monthly Patterns card, "Best Day" value renders English day name (`Sunday`).
- **Result:** ⚠️ **PASS (with cosmetic bug BUG-v1.10.1-01 noted)**

### Version confirm
- [x] Settings → About reads `Saranidhi v1.10.1 (1)` in English, and `சரநிதி v1.10.1 (1)` in Tamil.
- **Result:** ✅ **PASS**

---

## Bugs / Regressions

### BUG-v1.10.1-01: Monthly Patterns "Best Day" / "Worst Day" value unlocalized (English)
- **Component:** Analytics → Monthly Patterns (`_MonthlyPatternsCard` in `lib/features/analytics/presentation/analytics_screen.dart:225-226`)
- **Observed:** When app is set to தமிழ் mode, the label is translated (`சிறந்த நாள்`), but the value displays in English (e.g. `Sunday` instead of `ஞாயிறு`).
- **Root Cause:** `patterns.bestDay` is populated in `AnalyticsCalculator.calculateMonthlyPatterns()` (`lib/features/analytics/domain/analytics_calculator.dart:196, 434–443`) via `_weekdayName(weekday)`, which returns hardcoded English day strings (`'Monday'`, `'Tuesday'`, ... `'Sunday'`). The presentation widget renders `patterns.bestDay ?? '—'` directly without mapping through localization or `DateFormat.EEEE(locale)`. The same applies to `worstDay`.
- **Severity:** Minor / Cosmetic (residual pre-existing l10n debt outside Sprint 41 spec scope; no layout breakage or data failure).
- **Remediation Recommendation:** Pass integer weekday on domain model or map weekday name dynamically using `DateFormat.EEEE(Localizations.localeOf(context).toString())` in `_MonthlyPatternsCard`.

