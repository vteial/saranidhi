<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/l10n-polish-sweep/design.md
  Spec: l10n-polish-sweep — Design
  Authored: 2026-10-27 (Operator /plan-start).
-->
# l10n Polish Sweep — Design

## Real seams (grounded firsthand 2026-10-27)

| # | File:line | Current | Target |
| :--- | :--- | :--- | :--- |
| R1 | `lib/l10n/app_ta.arb:408` | `"unpinEntry": "நீக்கு"` | `"unpinEntry": "பின் அகற்று"` |
| R2 | `lib/features/notifications/domain/notification_scheduler.dart:203` | `return 'Saranidhi — ${yama.label}';` | compose via `l10n.yamaPrefix` + yama number |
| R3 | `test/features/performance_pass/performance_pass_invariants_test.dart` | 3 tests assert "renders + disposes" | add controller-state assertions |

## R1 — unpin/delete disambiguation
Pure ARB-value edit. `app_ta.arb` is the only file. `delete` (`நீக்கு`) and the
three other genuine-delete entries are left untouched. English side already says
"Unpin" (distinct from "Delete"), so only the Tamil mapping was colliding.
Regenerate `app_localizations*.dart` via the normal l10n build (committed
generated files per steering §3).

## R2 — yama notification title localization
The seam is a **`static`** title-builder in `notification_scheduler.dart` with no
`AppLocalizations` in scope. Two options considered:

- **(A) Thread `AppLocalizations` into the static builder** — resolve
  `l10n.yamaPrefix` at the call site (where the notification is scheduled, which
  has a `BuildContext` or a locale-resolved `l10n`) and pass the composed title
  in, OR pass `l10n` down. **Chosen** — keeps the prefix source the single l10n
  key, no new string.
- (B) Give `YamaSegment` a localized label — **rejected**: that would push l10n
  into `astro_engine/` (`yama_calculator.dart`), breaching the firewall. The
  engine stays presentation-free; localization belongs at the consumer.

The yama NUMBER still comes from the engine (`index + 6` / `index + 1`); only the
"Yama" word becomes `l10n.yamaPrefix`. Result in Tamil: the prefix renders in
Tamil, the number stays numeric — matching how `yamaProgress`/charts already do it.

### R2.4 — AI payload stays English (pinned decision)
`wisdom_context.dart:52` `'activeYama': activeYama?.label` feeds an **LLM prompt
map**, not UI. A stable English token (`'Yama 7'`) keeps prompt inputs
deterministic across locales and avoids a model seeing mixed-script fields. **Left
as-is by design.** Revisit only if the owner wants locale-aware prompting (own Spec).

## R3 — tighten animation tests
Current ON-path tests pump the widget and assert it renders + disposes. Tighten to
inspect the controller: under reduced motion the controller must be **not
animating** and pinned to its static end-value. For `QuickSyncPacer` the pacer must
be activated first (its controller is idle until `_togglePacer`). Use the widget's
state via `tester.state` or a `find`-based probe of the rendered static frame.
OFF-path assertions are untouched (regression guard).

## Open questions (resolve in T0)
- **OQ-1:** Confirm the notification-scheduling call site actually has an `l10n`/
  locale handle to resolve `yamaPrefix`; if it is a pure background/isolate path
  with no locale, fall back to resolving the prefix from the stored app locale.
- **OQ-2:** Confirm `yamaPrefix`/`yamaShortPrefix` Tamil values in `app_ta.arb`
  are pure Tamil (RT value-check).
- **OQ-3:** `பின் அகற்று` vs `பின் நீக்கு` for unpin — pick the one that reads most
  naturally as "un-pin" and is clearly distinct from `நீக்கு`.
