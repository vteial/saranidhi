[← Back to Sprint Dossier](./README.md) · [Sprint Tracker](../../sprint-tracker.md)

# Sprint 40 — Chronobiology & Holistic Guidance (v1.10.0) — Implementation Spec

> **Authored by Kiro Web for the Antigravity IDE coding setup.** Implement with local
> `flutter analyze` + `flutter test` **GREEN before opening the PR**. This sprint adds a
> new analytics engine + a dashboard field + UI attachments + a bilingual morning-summary
> injection. It **reuses** the shipped Sprint 35 somatic engine — do not rebuild it.
> Kiro Web reviews the PR. Scope confirmed with the owner in this `/plan`; derives from the
> [Chronobiology & Holistic Guidance backlog epic](../../sprint-backlog.md#chronobiology--holistic-guidance).

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
**except those same 4**." If `analyze` isn't clean or any *other* test fails, **STOP and
report before starting.**

## 1. What this sprint is

Turns the app from "what is my rhythm right now" into "your rhythm has drifted — here is a
holistic correction," grounded in the chronobiology corpus. Five deliverables, all
bilingual EN/TA:

1. **`ChronobiologyAnalytics`** — time-weighted sliding-window nostril-**stagnancy**
   detection over the rolling-24h journal (mild ≥6h, chronic ≥8h).
2. **Dashboard stagnancy-warning card** — surfaces a mild/chronic warning with a
   heating/cooling lifestyle recommendation.
3. **Swara-Ahara dietary "fire" prompt** on the **Kriya** Focus Card.
4. **Tattva-somatic temperature-regulation tips** (Sheetali for excess fire, Surya Bhedana
   for cold) keyed off the active Tattva + stuck flow.
5. **Swara Pada Gamana waking advice** injected into the morning-summary notification.

**North Star fit:** all of this is *present-moment betterment via agency* — self-observable
correction, never prediction. Tone follows CONF-017 (reliability/comfort, never a forced
target); remedies are gentle nudges, not mandates.

## 2. Reality (what exists — from a codebase map this session)

- **Spec/doctrine:**
  - `docs/research/advanced_somatic_mastery.md` §2 (~lines 140–290) contains a nearly
    complete **reference `ChronobiologyAnalytics.analyze(...)`** + thresholds — implement to
    match it.
  - `docs/research/holistic_living_proposals.md` §1 (Swara Pada Gamana waking rule) and §2
    (Swara-Ahara dietary chronobiology, incl. the exact Kriya-window prompt copy in §2.3).
  - **Doctrine prose already localized** in ARB: `guidePadaGamanaTitle/Body`
    (`app_en.arb` ~606–614; `app_ta.arb` ~320–324), `guideSwaraAharaTitle/Body`, terms
    `termSwaraPadaGamana`/`termSwaraAhara`, `tattvaFireEnglish` etc. **Reuse these** where
    the message is the same; add new short-form keys only for the new surfaces.
- **Journal input:** Drift `SaraKalaiJournal` (`lib/database/tables.dart` ~31–52):
  `timestamp` (epoch ms), `actualFlow` (String), `nostril`, `isAligned`, `activeElement`
  (nullable). Repo `lib/features/breath_journal/data/journal_repository.dart` has
  `getAllEntries`/`getRecentEntries`/`watchAllEntries` but **no rolling-24h query** → add
  one (§3).
- **Dashboard:** `DashboardData` + `dashboardDataProvider` in
  `lib/features/streaks/providers/streak_providers.dart` (DashboardData ~26–160, provider
  ~190–470, self-invalidates every 30s on today). It **already queries `db.saraKalaiJournal`
  directly** for the day's hold-time average (~408–430) — mirror that pattern to feed
  stagnancy. `DashboardData.activeTattva` (`TattvaResult?`) already exists.
- **Tattva:** `lib/features/astro_engine/domain/tattva_calculator.dart` —
  `enum Tattva { earth, water, fire, air, ether }`. Displayed in the Birth Bird card
  `_HoraTattvaRow`.
- **Kriya card:** `lib/features/home/presentation/widgets/focus_card.dart` — a
  `StatelessWidget` taking an `ActionWindowSegment`; switches on `segment.window`; Kriya
  subtitle via `_subtitleForWindow` (~140–148). Placed in
  `lib/features/home/presentation/today_tab.dart` (~85–95).
- **Sprint 35 somatic engine (REUSE):** `lib/features/somatic/` is fully built —
  `InterventionType { postureShift(180s), axillaryPressure(300s) }`,
  `CrossLateralMapping.bodySideFor(BreathFlow)`, repository, providers,
  `presentation/somatic_timer_room.dart`. **The Swara-Ahara "flip to right nostril before
  eating" is exactly the existing left-side posture / left-axillary-pressure protocol
  (target = right/solar)** — route into it, don't build a new timed flow.
- **Morning summary:** `lib/features/notifications/domain/notification_scheduler.dart`
  `_generateMorningSummary(...)` (~260–300), scheduled at sunrise; **its `body` is
  hardcoded English.** The window path (`generateWindowNotifications`, ~337–420) already
  threads a `languageCode` and switches EN/TA — follow that to make Pada Gamana bilingual.
  Gated by the `notifyMorningSummary` pref (default false).

## 3. Task 40.1 — `ChronobiologyAnalytics` (stagnancy detection)

**New file:** `lib/features/chronobiology/domain/chronobiology_analytics.dart` (new
feature folder, mirrors `lib/features/somatic/` layout).

- Implement per `advanced_somatic_mastery.md` §2. Public API:

  ```dart
  enum StagnancyLevel { none, mild, chronic }

  class StagnancyAnalysisResult {
    const StagnancyAnalysisResult({
      required this.level,
      required this.stuckFlow,          // BreathFlow? — the flow stuck on (null if none)
      required this.continuousDuration, // Duration — length of the current stuck run
    });
    final StagnancyLevel level;
    final BreathFlow? stuckFlow;
    final Duration continuousDuration;
  }

  class ChronobiologyAnalytics {
    const ChronobiologyAnalytics._();

    /// Analyzes the most recent contiguous single-flow run within the supplied logs
    /// (caller passes the rolling-24h window, newest-first or oldest-first — normalize
    /// inside). Returns `none` when < 3 logs or the latest run is short.
    static StagnancyAnalysisResult analyze(List<SaraKalaiJournalData> logs);
  }
  ```

- **Thresholds (exact, from the spec):**
  - Consider the **most recent contiguous run** of identical `actualFlow` (`solar`/`right`
    or `lunar`/`left`; **Sushumna breaks a run** — it is neutral, not stagnancy).
  - `duration = timestamp(last) − timestamp(first)` of that run.
  - **Mild:** `duration ≥ 6h` AND run `count ≥ 3`.
  - **Chronic:** `duration ≥ 8h` AND run `count ≥ 4`.
  - Fewer than 3 logs in the run → `none` (`stuckFlow: null`).
- Pure Dart, no Flutter imports — fully unit-testable. Match the reference impl's structure;
  if you deviate, note why in the implementation summary.

## 4. Task 40.2 — Wire stagnancy into the dashboard

- **Repo:** add `Future<List<SaraKalaiJournalData>> getEntriesSince(DateTime cutoff)` to
  `journal_repository.dart` (a `db.select(...)..where(timestamp >= cutoff.ms)` ordered by
  timestamp). Add a repo test.
- **Provider:** in `dashboardDataProvider`, read the last 24h via `getEntriesSince(now - 24h)`
  (mirror the existing hold-time query pattern ~408–430), call
  `ChronobiologyAnalytics.analyze(...)`, and expose the result as a **new field**
  `final StagnancyAnalysisResult stagnancy;` on `DashboardData` (default
  `StagnancyLevel.none` when today isn't the viewed date or there's no data). Keep the 30s
  self-invalidation behavior.
- Behavior-preserving: adding a field to `DashboardData` — update its constructor + any
  `copyWith`/test factory (`createTestDashboardData`) with a sensible default
  (`level: none`). No existing field changes.

## 5. Task 40.3 — Dashboard stagnancy-warning card

**New widget:** `lib/features/home/presentation/widgets/stagnancy_card.dart`.

- Renders **only** when `data.stagnancy.level != StagnancyLevel.none` (no card when
  healthy — don't add clutter).
- **Content by stuck flow (doctrine, §2.3):**
  - stuck **RIGHT/solar** (excess Surya / hot) → **cooling** recommendation (Sheetali
    pranayama, cooling foods/fluids, calm).
  - stuck **LEFT/lunar** (excess Chandra / cold) → **warming** recommendation (Surya Bhedana,
    warming foods like ginger/pepper, movement).
- **Severity tone:** `mild` = gentle "you've been on one channel a while — consider a
  rebalancing"; `chronic` = firmer "your breath has been stuck ~8h+; a rebalancing is
  advised." Never alarmist; never medical-diagnostic (CONF-017 tone + the safety stance).
- Offer a single low-emphasis affordance routing into the **existing Sprint 35 somatic
  timer** (target flow = the *opposite* of `stuckFlow`) for the posture/pressure shift —
  reuse `somatic_timer_room.dart`; do not build a new flow. The thermal breathwork
  (Sheetali/Surya Bhedana) is **advisory text only** this sprint (no new timed protocol).
- **Placement:** in `today_tab.dart`, directly under the Aruḍam Now / Action-window row,
  above the rest — high enough to be seen, but after the primary verdict. Responsive
  (single column mobile / fits the two-column ≥600px grid like the other cards).

## 6. Task 40.4 — Swara-Ahara dietary "fire" prompt on the Kriya Focus Card

**File:** `focus_card.dart`.

- When `segment.window == ActionWindow.kriya`, render an extra sub-block under the existing
  Kriya subtitle: the Swara-Ahara digestion prompt (§2.3) — e.g. *"Eating soon? Favour a
  right-nostril (solar) flow to strengthen digestive fire."*
- To key it on the current flow, the card needs the current `actualFlow` (and optionally the
  stagnancy). **Widen `FocusCard`'s constructor** with an optional
  `BreathFlow? currentFlow` (and read `data.stagnancy` if useful), passed from `today_tab.dart`
  where the card is built. Keep the constructor backward-compatible (nullable, default null →
  render the generic prompt).
- If `currentFlow` is **left/lunar** at a Kriya/eating moment, add a one-line nudge with a
  low-emphasis affordance into the **existing somatic timer** (flip to right) — same reuse
  as §5. If already right/solar, show an affirming "digestive fire is well-placed" line.
- Reuse `guideSwaraAharaBody` where the full doctrine is wanted; add a **short-form** ARB key
  for the card (`focusCardSwaraAharaPrompt`, `focusCardSwaraAharaAligned`) — the guide body is
  too long for a card.

## 7. Task 40.5 — Tattva temperature-regulation tips

- Small helper (in `chronobiology` domain or a `SomaticAdvice` util): given
  `Tattva activeTattva` + `BreathFlow? stuckFlow`, return an optional temperature tip:
  - `Tattva.fire` (excess heat) → **Sheetali/Sitkari** cooling tip.
  - cold/`Tattva.water` (`apas`) or stuck-left → **Surya Bhedana** warming tip.
  - otherwise → none.
- **Surface** it as an optional line: either on the **stagnancy card** (when a stuck flow
  agrees with the tattva) or as a subtle line in the Birth Bird card `_HoraTattvaRow` next to
  the tattva. Prefer the stagnancy card to avoid cluttering the always-visible tattva row;
  the implementer may choose, and should note the choice. New ARB keys
  (`tattvaTipCooling`, `tattvaTipWarming`).

## 8. Task 40.6 — Swara Pada Gamana in the morning summary (bilingual)

**File:** `notification_scheduler.dart`.

- Thread a `String languageCode` param into `generateForToday(...)` /
  `_generateMorningSummary(...)` the same way `generateWindowNotifications` already does
  (~337–420), and switch EN/TA on it. Update `refreshSchedule(...)` and the caller in
  `notification_providers.dart` (`_refreshSchedule`) to pass the profile/app locale (the
  window path already resolves this — reuse the same source).
- Append the Pada Gamana waking advice to the morning-summary `body` (or add a second
  sunrise notification if cleaner): "On waking, check your dominant nostril — if right, place
  your right foot down first; if left, your left." Keep it short; the full doctrine already
  lives in `guidePadaGamanaBody` for the in-app guide.
- Because this is a pure-Dart domain layer (no `AppLocalizations`), keep the EN/TA strings as
  in-file constants like the existing window-notification EN/TA switch — do **not** try to
  import `l10n` here.
- Gated by the existing `notifyMorningSummary` pref (unchanged default false).

## 9. Out of scope (do not build)

- The remaining Chronobiology epic rows (Cognitive Energy Budgeting labels; the ≥6h/≥8h
  *notification* nudges as opposed to the dashboard card) — fast-follows.
- Any new **timed** breathwork protocol for Sheetali/Surya Bhedana — advisory text only this
  sprint.
- Analytics-screen changes (the CSV-export decision is a separate `/plan` item).
- Rewriting the Sprint 35 somatic engine — reuse it.

## 10. Tests (add; keep the suite green)

- **`test/features/chronobiology/chronobiology_analytics_test.dart`** (new): none (<3 logs);
  mild (≥6h, 3 logs, same flow); chronic (≥8h, 4 logs); a Sushumna entry **breaking** a run;
  a recent flip resetting the run to `none`; boundary cases at exactly 6h/8h.
- **`journal_repository` test** (extend): `getEntriesSince` returns only entries ≥ cutoff, in
  order.
- **Dashboard provider test** (extend `test/features/providers/dashboard_data_test.dart`):
  `DashboardData.stagnancy` populated from journal input; `none` default path.
- **`stagnancy_card` widget test** (new): renders nothing when `none`; renders cooling copy
  for stuck-right, warming copy for stuck-left; chronic vs mild tone; the somatic affordance
  present.
- **`focus_card` test** (extend): Kriya window shows the Swara-Ahara prompt; left-flow shows
  the flip nudge; right-flow shows the affirming line; non-Kriya windows unchanged.
- **`notification_scheduler` test** (extend
  `test/features/notifications/notification_scheduler_test.dart`): morning summary body
  includes Pada Gamana advice; EN vs TA switch produces the right language.
- **Tattva tip** unit test for the fire→cooling / cold→warming mapping.

## 11. Delivery constraints / regression gate

- **Behavior-preserving:** `DashboardData` and `FocusCard` gain optional/defaulted fields
  only; no existing field changes type/meaning. Existing dashboard/focus/notification tests
  pass **unchanged** (only additions). `createTestDashboardData` updated with a `none`
  default.
- **Reuse, don't duplicate** the Sprint 35 somatic engine.
- **No hardcoded English `Text()`** in any new widget — all bilingual ARB; morning-summary
  strings bilingual via the threaded `languageCode`. Pre-PR Tamil-mode eyeball.
- Tone: gentle/reliability-first (CONF-017); never medical-diagnostic; the stagnancy card is
  wellness guidance, not a health warning.
- Local `flutter analyze` clean + `flutter test` green (except 4 CloudKit) before the PR; web
  build clean.

## 12. Definition of Done

- [ ] `ChronobiologyAnalytics` + `StagnancyAnalysisResult` implemented to spec thresholds;
      pure-Dart, unit-tested.
- [ ] `getEntriesSince` repo method + `DashboardData.stagnancy` field wired; provider reads
      rolling-24h.
- [ ] Stagnancy card (heating/cooling by stuck flow, mild/chronic tone, somatic affordance)
      — hidden when healthy.
- [ ] Swara-Ahara prompt on the Kriya Focus Card (flow-aware, reuses somatic engine).
- [ ] Tattva temperature tip (fire→cooling / cold→warming).
- [ ] Pada Gamana waking advice in the morning summary, **bilingual** via threaded
      `languageCode`.
- [ ] All new copy bilingual (EN + pure-Tamil ARB), zero hardcoded `Text()`.
- [ ] New + extended tests; existing tests unchanged & green; `analyze` clean; web build
      clean.
- [ ] Implementation + test summaries filled; PR opened for Kiro Web review.

**Provenance:** Chronobiology & Holistic Guidance epic (`sprint-backlog.md`) ·
`advanced_somatic_mastery.md` §2 (stagnancy + thermal) · `holistic_living_proposals.md`
§1 (Pada Gamana) + §2 (Swara-Ahara) · CONF-002 (contralateral shift) · CONF-005 (left-side
sleep → Pingala) · CONF-012/015 (tattva contextual) · CONF-017 (reliability/comfort tone) ·
existing Sprint 35 somatic engine, `TattvaCalculator`, `dashboardDataProvider`, `FocusCard`,
`NotificationScheduler`.
