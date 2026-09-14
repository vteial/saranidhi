[← Back to Sprint Dossier](./README.md) · [Sprint Tracker](../../sprint-tracker.md)

# Sprint 43 — Localization Defect Fixes (v1.11.1) — Implementation Spec

> **Authored by Kiro Web for the Antigravity IDE coding setup.** A small, tight **bug-fix
> patch** — three known localization/citation defects (the recurring "partially-localized
> widget / value-not-localized" miss, same class as the v1.8.1 notification-l10n hotfix and
> BUG-v1.10.1-01). Tasks 43.1 + 43.3 are trivial (additive ARB key / one-line doc-comment).
> **43.2 touches the analytics domain model + a widget**, so run local `flutter analyze` +
> full `flutter test` **GREEN before the PR** (not CI-only), with a new localized-weekday test.
> Kiro Web reviews the real diff. Ships as **v1.11.1-web** (patch). Bug-only — no new features.

## 0. Prerequisite — env + known-green baseline (do FIRST)

Per [`dev-setup.md`](../../dev-setup.md). Establish the baseline before touching code:
```bash
flutter pub get
flutter analyze            # expect: no issues
flutter test               # baseline: green EXCEPT the 4 known CloudKit-on-macOS failures
```
**Known macOS baseline (NOT a regression):** 4 expected failures in
`test/features/cloud_backup/backup_repository_test.dart` (CloudKit "on non-Apple platform"
cases; pass on CI Ubuntu). Gate = "green **except those same 4**." If `analyze` isn't clean, or
`test` shows any other failure, STOP and report before starting.

---

## Task 43.1 — BUG-v1.11.1-01: About-card Developer name not localized

**File:** `lib/features/settings/presentation/about_card.dart` (~line 87) + `lib/l10n/app_en.arb` + `lib/l10n/app_ta.arb`.

### The bug
In Tamil mode, the About card's **Developer** row renders the hardcoded Latin `Eialarasu`:
```dart
_InfoRow(
  icon: Icons.person_outline,
  label: l10n.aboutDeveloper,   // localized: "Developer" / "உருவாக்குநர்"
  value: 'Eialarasu',           // ← hardcoded, never localized
),
```
…while the **copyright** line already localizes the name — `aboutCopyright` renders
`© 2026 Eialarasu. …` (EN) / `© 2026 இயலரசு. …` (TA). So the same person's name appears two
ways in Tamil mode (`Eialarasu` in the Developer row, `இயலரசு` in the copyright). Inconsistent.

### The fix
1. Add a new ARB key `aboutDeveloperName` to **both** ARBs, matching the name form already used
   in `aboutCopyright`:
   - `app_en.arb`:
     ```json
     "aboutDeveloperName": "Eialarasu",
     "@aboutDeveloperName": { "description": "Developer's name (proper noun; transliterated in Tamil)" },
     ```
   - `app_ta.arb`:
     ```json
     "aboutDeveloperName": "இயலரசு",
     ```
2. Use it for the Developer row value:
   ```dart
   value: l10n.aboutDeveloperName,
   ```
3. **Leave the email + website values as literal identifiers** (`vteial@icloud.com`,
   `saranidhi.vercel.app`) — those are not localizable and are correctly hardcoded.
4. Run codegen (`flutter gen-l10n`, part of `pub get`); keep EN/TA key parity.

> **Consistency check:** in Tamil mode the Developer row and the copyright line must now show the
> **same** name form (`இயலரசு`).

---

## Task 43.2 — BUG-v1.10.1-01: Monthly-Patterns day-name value unlocalized

**Files:** `lib/features/analytics/domain/analytics_calculator.dart` +
`lib/features/analytics/presentation/analytics_screen.dart` (+ tests).

### The bug
`MonthlyPatterns.bestDay` / `worstDay` are **English day-name strings** produced by
`_weekdayName(int)` (l.434–443, Dart convention 1=Mon…7=Sun) and rendered **raw** in
`_MonthlyPatternsCard` (`analytics_screen.dart:226` `patterns.bestDay ?? '—'`, `:236`
`patterns.worstDay!`). In Tamil mode the *label* is localized (`சிறந்த நாள்`) but the *value*
shows `Sunday`, not `ஞாயிறு`.

### The fix — carry the integer weekday, localize in the widget
1. **Domain model** (`MonthlyPatterns`): replace the string day fields with **integer weekday**
   fields (nullable, Dart 1=Mon…7=Sun), e.g.:
   ```dart
   final int? bestDayWeekday;   // was: String? bestDay
   final int? worstDayWeekday;  // was: String? worstDay
   ```
   In `calculateMonthlyPatterns`, store the raw `weekday` int (the loop already iterates
   `dayTotal.keys`, which are `date.weekday`) instead of calling `_weekdayName(weekday)`:
   ```dart
   bestDayWeekday = weekday;   // was: bestDay = _weekdayName(weekday);
   worstDayWeekday = weekday;  // was: worstDay = _weekdayName(weekday);
   ```
   Update the `MonthlyPatterns` constructor + the empty/no-data path (`bestDayWeekday: null`,
   `worstDayWeekday: null`). **`_weekdayName()` can be deleted** (verify no other caller via
   `grep -rn "_weekdayName" lib`).
2. **Widget** (`analytics_screen.dart`): localize the int → day name at render, respecting the
   active locale:
   ```dart
   String _localizedWeekday(int weekday, BuildContext context) {
     // weekday: 1=Mon … 7=Sun (Dart). Build a reference date with that weekday.
     final locale = Localizations.localeOf(context).toString();
     // 2024-01-01 is a Monday; add (weekday-1) days to hit the target weekday.
     final ref = DateTime(2024, 1, 1).add(Duration(days: weekday - 1));
     return DateFormat.EEEE(locale).format(ref);
   }
   ```
   - Render best day: `value: patterns.bestDayWeekday == null ? '—' : _localizedWeekday(patterns.bestDayWeekday!, context)`.
   - **Fix the equality guard** (`analytics_screen.dart:231-232`): the "hide Needs Attention when
     same as Best Day" check must now compare the **int weekdays** (`worstDayWeekday != null &&
     worstDayWeekday != bestDayWeekday`), NOT the localized strings.
   - `DateFormat` comes from `package:intl` (already a dependency; used elsewhere). Import if
     needed. `DateFormat.EEEE(localeString)` yields the full localized weekday name (English
     "Sunday", Tamil "ஞாயிறு") — Flutter's intl carries `ta` symbols.
3. **No ARB key needed** — `DateFormat.EEEE` provides localized weekday names from `intl`.

> **Why store the int, not localize in the calculator:** the calculator is context-free (no
> `BuildContext`/locale) and unit-tested pure; localization belongs at the widget layer. This
> also keeps the domain model locale-agnostic.

### Tests (43.2)
- **Domain** (`test/features/analytics/analytics_calculator_test.dart` or equivalent): assert
  `calculateMonthlyPatterns` sets `bestDayWeekday` / `worstDayWeekday` to the correct **int**
  (e.g. a dataset where Sunday is best → `bestDayWeekday == 7`). Update any existing assertions
  that referenced the old string fields.
- **Widget** (analytics screen / monthly-patterns card): pump in **Tamil locale** with a known
  best/worst weekday and assert the rendered value is the **Tamil** day name (e.g. `ஞாயிறு`),
  not `Sunday`; and in English locale it reads `Sunday`. This is the regression lock for the bug.

---

## Task 43.3 — Citation fix: `readiness` factor → CONF-014

**File:** `lib/features/astro_engine/domain/integrated_arudam_engine.dart`.

The `readiness` `ArudamFactor` is cited `CONF-016 / CONF-017` (therapeutic occlusion / Kumbhaka
consistency). Since Sprint 42, readiness rides the **swara clock**, so re-key to **`CONF-014`**
(the 1-hour swara clock). Two spots:
1. The enum doc-comment block (the `/// - [readiness]: … — CONF-016 / CONF-017` line and the
   `/// Breath alignment multiplier — CONF-016 / CONF-017.` comment above `readiness,`).
2. The `ArudamReason(factor: ArudamFactor.readiness, … conf: 'CONF-016 / CONF-017')` construction
   → `conf: 'CONF-014'`.

**No logic change** — this only changes provenance strings shown in the "Why?" accordion. Confirm
the existing `integrated_arudam_engine_test.dart` still passes (update the assertion if any test
pins the `readiness` reason's `conf` string to the old value).

---

## Task 43.4 — DoD l10n sweep (About + Analytics cards)

While in these files, grep for any **other** hardcoded display strings that should be localized —
the recurring miss:
```bash
grep -n "value: '\|Text('" lib/features/settings/presentation/about_card.dart \
                            lib/features/analytics/presentation/analytics_screen.dart
```
For each hit: either localize it, or explicitly justify leaving it literal (email address, URL,
version number, proper-noun identifier). Note the outcome in the implementation summary. Known
OK-to-leave: `about_card.dart` email (`vteial@icloud.com`) + website (`saranidhi.vercel.app`).

---

## Task 43.5 — BUG-v1.11.1-02: Best Times card yama prefix not localized

**File:** `lib/features/home/presentation/widgets/best_times_card.dart` (~line 183).

### The bug
`_BestTimeRow` hardcodes the yama badge as `'Y${entry.yamaNumber}'` — a literal `Y`, ignoring
locale. In Tamil mode it shows `Y1` while the Analytics screen already renders the localized
`yamaShortPrefix` (`யா`) for the same concept (`analytics_screen.dart:510`). Same
"value/label-not-localized" class as 43.1 / 43.2. Owner-found (2026-09-14).

### The fix
`l10n` is already in scope in `_BestTimeRow.build` (`AppLocalizations.of(context)`), and the key
`yamaShortPrefix` already exists (`Y` / `யா`). Swap:
```dart
'${l10n.yamaShortPrefix}${entry.yamaNumber}'   // was: 'Y${entry.yamaNumber}'
```
Folded into Sprint 43 mid-flight (trivial, same theme). Add/extend a Tamil-locale widget
assertion for the Best Times card badge if practical (or cover via the Tamil-mode gate eyeball).

## Out of scope

- No new features; no schema change; no migration.
- Do NOT touch the swara-clock / bird / yama / oracle logic (43.3 is a comment/string-only edit).
- Broader Analytics rework (shareable/PDF report) stays backlogged.

## Definition of Done

See the Sprint 43 Delivery Checklist in [`sprint-tracker.md`](../../sprint-tracker.md). Key gates:
1. **Local `flutter analyze` clean + full `flutter test` green** (same 4 CloudKit only) BEFORE the
   PR — 43.2 changes domain + widget, so CI-only is not sufficient.
2. **EN/TA ARB key parity** maintained (43.1 adds `aboutDeveloperName` to both).
3. **Pre-PR Tamil-mode gate** — eyeball the About card (Developer row now `இயலரசு`, matching the
   copyright) and the Analytics Monthly-Patterns card (best/worst day in Tamil script) in Tamil
   mode. This is exactly the gate these bugs slipped past.
4. **User Guide = n/a** (cosmetic l10n only). Fill
   [`implementation-summary.md`](./implementation-summary.md) + [`test-summary.md`](./test-summary.md);
   Kiro Web reviews the real diff before owner merge.
