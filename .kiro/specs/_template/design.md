<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/_template/design.md
  Saranidhi Kiro Spec — DESIGN template (the HOW; authored by the Operator).
  Last verified: 2026-10-03 (v1.13.0-web).
-->
# <Feature Title> — Design

| Property | Value |
| :--- | :--- |
| **Spec ID** | `<spec-id>` |
| **CONF** | `<CONF-nn>` / `n/a` |
| **Surface** | Executor (Antigravity) — build + local verify |

---

## 1. Approach
<Follow saranidhi's existing patterns — don't invent machinery. Name the feature folder
(`lib/features/<name>/{domain,data,presentation,providers}`), the Riverpod providers
(NotifierProvider / FutureProvider — never deprecated StateProvider), and the Freezed +
json_serializable models involved. State the single new idea, if any.>

## 2. Data / model
<Freezed entities, Drift tables + schema version bump, any migration. If a Drift column is
added, state the migration behavior for existing installs (e.g. default value) — a migration
is correctness-critical.>

## 3. Domain / calculation
<Pure-Dart logic. For doctrinal calcs cite the method (e.g. Jean Meeus ELP 2000/82 Moon
longitude + Lahiri ayanamsa) and the resolved CONF. Zero network dependency.>

## 4. Presentation
<Widgets, responsive two-column (>=600px) vs single-column, reusable UX widgets
(EmptyStateWidget / ShimmerLoading / ErrorBoundary — not raw CircularProgressIndicator).
Every string via l10n (RT). Haptics via HapticFeedback.* (no-op on web).>

## 5. Localization (RT)
<Which ARB keys are added (EN + TA). Confirm `flutter: generate: true` picks them up and
`lib/l10n/generated/` is regenerated.>

## 6. Analytics reactivity (if analytics touched)
<Any new analytics FutureProvider MUST watch journalEntriesProvider.future to auto-refresh.>

## 7. Open questions (resolve during build)
- **OQ-1** <lean + rationale>
