[← Back to Sprint Dossier](./README.md) · [Sprint Tracker](../../sprint-tracker.md)

# Sprint 41 — Analytics Tidy (CSV → Settings) + Tamil l10n fixes (v1.10.1) — Implementation Spec

> **Authored by Kiro Web for the Antigravity IDE coding setup.** Implement with local
> `flutter analyze` + `flutter test` **GREEN before opening the PR**. This is a **small,
> low-risk** sprint — a widget move + ARB additions, **no core-calc / engine logic**. Kiro Web
> reviews the diff. Owner-decided in `/plan` (PR #210): keep the journal CSV (built + useful),
> **move it from Analytics to Settings**; and fix the Analytics-page Tamil l10n gaps. Ships as
> **v1.10.1** (patch).

## 0. Prerequisite — environment + known-GREEN baseline (do FIRST)

Per [`docs/process/dev-setup.md`](../../dev-setup.md):

```bash
flutter --version      # stable ≥3.44 / Dart ≥3.12.1
flutter pub get
flutter analyze        # expect: no issues
flutter test           # baseline: green EXCEPT the 4 known CloudKit failures
```

**Known macOS baseline (NOT a regression):** 4 expected CloudKit failures in
`test/features/cloud_backup/backup_repository_test.dart` (pass on CI Ubuntu). Gate = "green
**except those same 4**." If `analyze` isn't clean or any *other* test fails, **STOP and report.**

## 1. What this sprint is

Two independent, low-risk tasks:
- **A — Move the journal-CSV export** from the Analytics screen to Settings, beside the full
  JSON export/import. Keep the CSV (human-readable / spreadsheet path); it's just mis-placed.
- **B — Fix Analytics-screen Tamil localization gaps** (the recurring partially-localized-widget
  miss).

Everything below is grounded in a codebase map this session.

## 2. Reality (what exists — file:line)

- **`_ExportCard`** — `lib/features/analytics/presentation/analytics_screen.dart` **lines 655–743**
  (`ConsumerWidget`). Title `l10n.exportData`, subtitle `l10n.exportDataSubtitle`, button
  `l10n.exportAsCsv` → `_exportCsv(context, ref)` (lines 694–732). Rendered in **Row 3**
  ("Hold Time + Export"): wide layout `Expanded(child: _ExportCard())` **line 95**, narrow
  **line 102** (with a `SizedBox(height: 12)` at 101).
- **`_exportCsv`** currently: reads `csvExportProvider.future`; **if `kIsWeb` → SnackBar
  `l10n.csvExportWebOnly` + return (web unsupported today)**; else
  `getApplicationDocumentsDirectory()` + `File(...).writeAsString(csv)` named
  `saranidhi_journal_<yyyy-MM-dd>.csv` + SnackBar `l10n.exportedTo(path)`; on error SnackBar
  `l10n.exportFailed`. **It writes to the docs dir + SnackBars a path — it does NOT open a share
  sheet** (unlike the Settings JSON export).
- **`csvExportProvider`** — `lib/features/analytics/providers/analytics_providers.dart`
  **lines 60–65**: `FutureProvider<String>` → `journalRepositoryProvider.getAllEntries()` →
  `AnalyticsCalculator.generateCsv(entries)`. **Global provider, no scoping** — fully available
  in Settings. Journal-only.
- **`AnalyticsCalculator.generateCsv`** — `lib/features/analytics/domain/analytics_calculator.dart`
  **lines 404–431**, pure `static String generateCsv(List<SaraKalaiJournalData>)`; header
  `Date,Time,Expected Flow,Actual Flow,Aligned,Nostril,Inhale (ms),Hold (ms),Exhale (ms),Yama,Bird,Bird State,Element,Notes`.
- **Destination — `DataExportImportWidget`** — `lib/features/settings/presentation/data_export_import_widget.dart`
  (`ConsumerStatefulWidget`). Card with header (`Icons.swap_vert` + `l10n.dataExportImportTitle`),
  **JSON export** button `_handleExport` (lines 115–159 — `databaseExporterProvider` →
  `exportToJsonString()` → `Share.shareXFiles`, from `share_plus`), **Import** button
  `_handleImport` (to ~line 110). Mounted in `settings_screen.dart` line 137. Already imports
  `journal_providers.dart`.
- **Tests:** **none** exist for the analytics screen / CSV export / `generateCsv` / the Settings
  export widget. Only l10n test = `test/features/l10n/app_localizations_test.dart` (asserts
  getters non-empty).

## 3. Task 41.1 — Move CSV export Analytics → Settings

**Add to `data_export_import_widget.dart`:**
- Import `package:saranidhi/features/analytics/providers/analytics_providers.dart` (for
  `csvExportProvider`).
- Add a **third `OutlinedButton.icon`** in the same Card, after the Import button (after ~line
  110), label e.g. `l10n.exportJournalCsv` ("Export journal as CSV"), `Icons.table_chart` (or
  `Icons.download`), `onPressed: _handleCsvExport`, with the same disabled-while-busy pattern the
  JSON export uses.
- Add `_handleCsvExport()`: `final csv = await ref.read(csvExportProvider.future);` then **share
  it via `share_plus` the same way `_handleExport` shares JSON** — `Share.shareXFiles([
  XFile.fromData(utf8-encoded csv, name: 'saranidhi_journal_<yyyy-MM-dd>.csv',
  mimeType: 'text/csv')])`. **This aligns the CSV with the JSON export's share-sheet mechanism
  and makes it work on web too** (drop the old docs-dir-write + `kIsWeb`-unsupported path).
  Guard with the same try/catch → SnackBar `l10n.exportFailed` on error.

**Remove from `analytics_screen.dart`:**
- Both `_ExportCard()` usages (lines 95 wide, 102 narrow) and the `_ExportCard` class (655–743).
- **Collapse Row 3:** `_HoldTimeProgressionCard` was paired with `_ExportCard` in a two-column
  `IntrinsicHeight`/`Row` on wide screens — after removal it must render **full-width**, not
  stranded in a half-width `Expanded`. Make it a normal full-width card in both layouts.
- Remove now-dead imports from `analytics_screen.dart`: `dart:io`, `package:path_provider/...`,
  `package:flutter/foundation.dart` (`kIsWeb`), and the `AnalyticsCalculator` import — **only if**
  nothing else in the file uses them (verify; the map says nothing does).

**L10n for the moved card:**
- The keys `exportData` / `exportDataSubtitle` / `exportAsCsv` / `csvExportWebOnly` / `exportedTo`
  / `exportFailed` already exist. Reuse what still applies. Add `exportJournalCsv` (button label in
  Settings) to **both** ARBs. Drop `csvExportWebOnly` usage (web now supported via Share) — leave
  the key or remove it, implementer's call; if removed, remove from both ARBs + the l10n test.

## 4. Task 41.2 — Analytics Tamil l10n fixes

Fix the hardcoded / non-localized strings on the Analytics screen. All new keys go in **both**
`lib/l10n/app_en.arb` + `lib/l10n/app_ta.arb` (pure Tamil script), then `flutter gen-l10n`.

1. **`analytics_screen.dart:459` (`_YamaPerformanceCard`)** — `Text('Y$yamaNum')`: the "Y" prefix
   is hardcoded English. Add `yamaShortPrefix` ("Y" / an appropriate Tamil short form — owner may
   prefer keeping "Y" as a universal glyph; if so, still route it through a key so it's a
   deliberate choice, or use `l10n.yamaPrefix` full word). **Flag the chosen Tamil value in the
   implementation summary for owner confirmation.**
2. **English `DateFormat` (no locale)** — `_WeekRow` ~line 160 `DateFormat('MMM d')` and
   `_HoldTimeProgressionCard` ~line 571 `DateFormat('MMM d, yyyy')` always render English month
   names. Pass the current locale: `DateFormat('MMM d', Localizations.localeOf(context).toString())`
   (ensure `intl` date symbols for `ta` are initialized — they are via `flutter_localizations`).
   This is the **real** Tamil gap.
3. **Unit suffixes** — `'…d'` (days) and `'…s'` (seconds) hardcoded in interpolation (~lines 377,
   381, 522, 527, 532, 558). Localize via `daysSuffixShort` / `secondsSuffixShort` keys (or a
   parameterized `l10n.daysShort(n)` / `l10n.secondsShort(n)`). **Owner-confirm the Tamil forms.**
4. **Not gaps** (do not touch): `'$pct%'`, `'—'` — locale-neutral.

## 5. Out of scope (do not build)

- Any change to `generateCsv`'s content/columns (move only).
- The shareable-summary/PDF report (separate backlog item).
- Any Analytics chart/logic change beyond localization.
- The Settings JSON export/import behavior (leave `_handleExport`/`_handleImport` untouched).

## 6. Tests (add; keep the suite green)

- **`AnalyticsCalculator.generateCsv`** unit test (new) — header row exact; one entry → correct
  columns; notes with commas/quotes are CSV-escaped (verify current escaping behavior and pin it).
- **`DataExportImportWidget`** widget test (new) — the CSV button renders; tapping triggers the
  export path (mock `csvExportProvider` / journal repo); JSON export + import buttons still present.
- **Analytics Tamil-locale** widget test (new or extend) — under `Locale('ta')`, the Yama label and
  a date render without hardcoded English (assert the localized prefix; assert no bare `'Y'` if the
  key resolves to Tamil).
- **`test/features/l10n/app_localizations_test.dart`** — add the new getters; add an EN↔TA
  key-parity assertion for the new keys.

## 7. Delivery constraints / regression gate

- **No core-calc / engine change.** CSV content byte-identical after the move (same `generateCsv`).
- Existing analytics/settings tests pass unchanged; the Analytics screen still renders all its
  other cards (only `_ExportCard` removed, Row 3 collapsed cleanly, no overflow at 390px/1024px).
- All new/changed copy bilingual (EN + pure-Tamil ARB); zero hardcoded `Text()` on the Analytics
  screen after this. Pre-PR Tamil-mode eyeball.
- Local `flutter analyze` clean + `flutter test` green (except the 4 CloudKit) + `flutter build
  web` clean before the PR.

## 8. Definition of Done

- [ ] CSV export moved to Settings (`DataExportImportWidget`), shares via `share_plus` (web works);
      `_ExportCard` removed from Analytics; Row 3 collapsed full-width; dead imports removed.
- [ ] Analytics Tamil gaps fixed (Yama "Y" prefix, locale-aware `DateFormat`, unit suffixes);
      new ARB keys in EN + TA; Tamil values flagged for owner confirmation.
- [ ] Tests: `generateCsv` unit, Settings CSV-button widget, Analytics Tamil-locale, l10n
      getters + EN/TA parity; existing tests unchanged & green.
- [ ] `flutter analyze` clean; `flutter test` green (except 4 CloudKit); web build clean; Tamil eyeball.
- [ ] Implementation + test summaries filled; PR opened for Kiro Web review.

**Provenance:** owner `/plan` decision (PR #210 — CSV option 2 "move to Settings") · the recurring
Pre-PR Tamil-mode gate lesson (v1.8.1 hardcoded-English-in-partially-localized-widget) ·
`analytics_screen.dart`, `data_export_import_widget.dart`, `analytics_providers.dart`,
`analytics_calculator.dart`.
