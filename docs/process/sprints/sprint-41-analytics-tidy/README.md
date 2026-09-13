[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 41 — Analytics Tidy (CSV → Settings) + Tamil l10n fixes (v1.10.1)

> **Dossier index.** A deliberately **small, low-risk** sprint (no core-calc) — a clean quick
> patch (v1.10.1) before the correctness-critical Sprint 42. Scheduled via `/plan` (PR #210).

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) _(seeded — fill after coding)_ |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) _(seeded — fill after local run)_ |

## Goal

1. **Move the journal-CSV export** from the Analytics screen → **Settings**, beside the full JSON
   export/import. Keep the CSV (built + useful, just mis-placed; owner-decided option 2). Align it
   with the JSON export's `share_plus` share-sheet mechanism (so it works on web too).
2. **Fix Analytics-screen Tamil localization gaps** — the hardcoded "Y" yama prefix, English-only
   `DateFormat` month names, and the `d`/`s` unit suffixes.

## Shape of the work

- **Settings:** add a 3rd `OutlinedButton.icon` (CSV) to `DataExportImportWidget` → `_handleCsvExport`
  reading the existing global `csvExportProvider`, shared via `share_plus`.
- **Analytics:** remove `_ExportCard` + collapse Row 3 to full-width; drop dead imports.
- **L10n:** new ARB keys (`exportJournalCsv`, `yamaShortPrefix`, unit suffixes) in EN + pure Tamil;
  locale-aware `DateFormat`. Tamil values flagged for owner confirmation.
- **Tests:** `generateCsv` unit, Settings CSV-button widget, Analytics Tamil-locale, l10n parity.

## Regression gate

No core-calc change; CSV content byte-identical after the move; existing tests unchanged; Analytics
screen renders cleanly (Row 3 full-width, no overflow at 390px/1024px).

## Process

Spec → coding-setup → review (Kiro Web spec + review; Antigravity IDE implements + local green before
PR). Version **v1.10.1** (patch).
