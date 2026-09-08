[← Back to Root](../../README.md)

# Saranidhi — Development Workflow

> **See also:** [`AI_COLLABORATION_FRAMEWORK.md`](../../AI_COLLABORATION_FRAMEWORK.md)
> — the AI team collaboration model (roles, handoffs, release lifecycle, and
> CI/merge gates) that this workflow operates within. When a protocol or gate
> changes, update **both** docs in the same PR so they never drift.

---

## Sprint Development Flow

```
main ──────────────────────────────────────────────►
       \                          /
        ├── feature/sprintX-topic ┤  ← PR reviewed → merge
```

### Per Sprint

1. **Branch:** `feature/sprintX-topic` from `main`
2. **Develop:** Implement all sprint tasks
3. **Validate locally:**
   - `dart analyze` — zero issues
   - `flutter test` — all pass
   - `flutter build web` — compiles
4. **Push & PR:** One PR per sprint targeting `main`
5. **Vercel Preview:** Verify UI visually on the preview URL (auto-generated for each PR)
6. **CI gates:** Analyze + Test + Coverage (≥19% feature sprints) + Build Web + Integration Tests
7. **Review:** Owner verifies on Vercel preview + reviews PR on GitHub
8. **Merge:** Owner merges after visual QA + CI passes
9. **Vercel deploys:** `main` auto-deploys to [saranidhi.vercel.app](https://saranidhi.vercel.app/)
10. **Verify:** Owner confirms staging matches expectations

---

## Pre-PR Quality Gate (v1.3.0 Retrospective)

> Added after the v1.3.0 release required 3 hotfix PRs due to preventable issues.
> These checks MUST be performed before pushing any PR that adds/modifies UI widgets.

### 1. Tamil Mode Verification

**Why:** 6 of 11 hotfix issues in v1.3.0 were hardcoded English strings missed in Tamil mode.

**Rule:** Before pushing, Kiro must mentally verify (or user must visually confirm on preview):
- [ ] All `Text()` widgets in new/modified files use `l10n.*` keys (not literal strings)
- [ ] Run grep check: `grep -n "Text(" <new_file>.dart | grep -v "l10n\.\|style:\|const \|TextStyle\|emoji"` — any matches with English text > 3 chars = bug
- [ ] Duration/unit suffixes use l10n keys (e.g., `l10n.durationMinutes(n)` not `'${n}min'`)
- [ ] Paksha/state/window names use l10n keys (not hardcoded 'Ruling', 'Artha', 'Krishna')

### 2. Visual QA Before Sprint Finish

**Why:** Card styling, alignment, empty space issues only surface when a human looks at the app.

**Rule:** Before issuing `/sprint-finish`:
- [ ] User checks Vercel preview on narrow screen (mobile viewport)
- [ ] User checks Vercel preview on wide screen (tablet/desktop)
- [ ] User opens any new bottom sheets/dialogs/modals
- [ ] User switches to Tamil and repeats all above
- [ ] New cards visually match the weight/style of existing cards

**Process:** Issues found → fixes go into the SAME PR branch (not a separate hotfix). Only issue `/sprint-finish` after preview testing passes.

### 3. l10n Completeness Check

**Why:** New ARB keys were added to English but Tamil equivalents were incomplete or had wrong Unicode characters.

**Rule:** For every new key added to `app_en.arb`:
- [ ] Corresponding key exists in `app_ta.arb` with proper Tamil text
- [ ] No mixed-script characters (e.g., Kannada `ಮ` in Tamil text)
- [ ] Placeholders (`{count}`, `{name}`) match between EN and TA files

### 4. flutter analyze Clean

**Why:** Multiple CI failures from redundant arguments, unused imports, comment_references.

**Rule:** Before committing new widget files:
- [ ] No `width: 1` or `expand: false` or `initialChildSize: 0.5` (default values)
- [ ] Doc comments use backticks (`` `ClassName` ``) for cross-file references, not `[ClassName]`
- [ ] All imports are actually used; extension imports included (e.g., `pakshi_l10n.dart`)
- [ ] No `@override` on non-overridden methods

### 5. Known Flaky Tests

**Why:** Widget navigation test was un-skipped without fixing the root cause, causing CI failure.

**Rule:** A skipped test can only be un-skipped when:
- [ ] The **root cause** is resolved (not just the symptom)
- [ ] The test passes 3 consecutive CI runs on a feature branch
- [ ] If root cause is architectural → defer to dedicated test infrastructure sprint

---

## Sprint Protocols

### `/sprint-start`

Lightweight entry point — creates the branch and marks the sprint active.

1. Create feature branch from `main` (`feature/sprintN-<topic>`)
2. Update `docs/sprint-tracker.md` — mark sprint as "🚧 In Progress"
3. Begin implementation

### `/sprint-finish`

Closes the sprint — delivers the code for user to merge.

1. Commit all remaining changes
2. Push branch to remote
3. Create PR targeting `main`
4. Update `docs/sprint-tracker.md` → ✅ Complete (PR #N)
5. Push tracker update to PR branch
6. **Tell user PR is ready for merge** — Kiro NEVER merges directly
7. User reviews + merges (sprint officially closed)
8. Ask: *"Run /sprint-update now or later?"*

### `/sprint-update`

Runs **after sprint merge** on a separate docs-only branch to avoid CI code failures.

1. Create branch from `main` (`docs/sprintN-update`)
2. Update all clerical docs:
   - `docs/project-valuation-report.md` — timeline, commit log, hours (estimate + 20%), deliverables, executive summary
   - `docs/project-evaluation.md` — feature scorecard, delivery table, resolved defects
   - `docs/project-plan.md` — new infrastructure/architecture patterns
   - `docs/testing-plan.md` — test count progression, scenarios awaiting coverage
   - `docs/dev-workflow.md` — any threshold/process changes
   - `.kiro/steering/saranidhi-spec.md` — tech stack updates
   - **`docs/smoke-test-vX.Y.Z.md`** — add scenarios for new features (mandatory)
   - **User Guide content** — refresh guide sections affected by sprint changes (mandatory)
3. Commit, push, create docs-only PR
4. **User reviews and merges**

**Hours estimation rule:** Use AI-estimated active time + 20% buffer (owner-approved).

**Mandatory additions:** Every /sprint-update MUST include User Guide refresh + smoke test plan update. These are not optional.

### `/plan`

Strategic brainstorming and sprint plan revision — forward-looking.

1. Brainstorm with user (conversation in Kiro Web)
2. Confirm scope and decisions
3. Create branch from `main` (e.g., `plan/sprint-N` or `plan/v2-roadmap`)
4. Update:
   - `docs/sprint-tracker.md` — define upcoming sprints
   - `docs/roadmap.md` — adjust milestones
   - `.kiro/design.md`, `.kiro/product.md`, `.kiro/structure.md` — if architecture changes
5. Commit, push, create PR
6. **User reviews and merges** (Kiro never pushes directly to main)

**Protocol:** All write operations go through PRs. Only the user merges to main.

---

### `/delegate`

**(Paused)** — Previously used for delegating to Google Jules. Currently all work handled directly by Kiro.

Delegation rules remain available for future use if needed:
1. Delegated tasks operate on separate branches
2. Only modify files in assigned scope
3. Sprint PRs take merge priority

---

### `/hotfix`

Quick-fix protocol for defects found after merge.

1. Create branch from `main` (`fix/sprintN-<topic>`)
2. Implement fix
3. Validate: `flutter analyze --fatal-infos` + `flutter test`
4. Commit with `fix(sprintN): <description>`
5. Push, create PR, merge
6. Append a row to "Resolved Defects" table in `docs/project-evaluation.md`
7. Increment hours in `docs/project-valuation-report.md` if significant time spent

---

### `/release`

Three-phase production promotion with smoke test quality gate.

#### Phase 1: `/release-start`

Prepares the smoke test execution.

1. Kiro creates branch `release/vX.Y.Z` from `main`
2. **Bumps `version:` in `pubspec.yaml`** to match the release (e.g., `1.3.0+1`)
   - This ensures the About card (via `package_info_plus`) shows the correct version during smoke testing AND in production
3. Ensures `docs/smoke-test-vX.Y.Z.md` exists (plan + results template)
4. Creates PR targeting `main`
5. User executes smoke test on staging (`saranidhi-staging.vercel.app`)
6. User commits results (Pass/Fail + Notes) to the same branch
7. User reviews and merges PR → smoke test results + version bump now on `main`

#### Phase 2: `/release-finish`

Promotes to production after smoke test passes.

1. Kiro validates the smoke test PR is merged to `main`
2. Kiro creates PR from `main` → `prod` with release notes:
   - **What's New** — features added since last release
   - **Fixes** — bugs resolved
   - **Known Issues** — anything still pending
   - **Sprint(s)** — which sprints are included
3. User reviews the release PR (final sanity check)
4. User merges → Vercel auto-deploys `prod` to `saranidhi.vercel.app`
5. User creates **GitHub Release** from UI:
   - Tag: `vX.Y.Z-web`
   - Target: `prod` branch
   - Release notes: same as PR body
   - Publish

#### Phase 3: `/release-update`

Post-release documentation closure (light touch-up).

1. Kiro creates branch from `main` (`docs/release-vX.Y.Z-update`)
2. Update:
   - `docs/smoke-test-results.md` — mark version as ✅ PASS with date
   - `CHANGELOG.md` — set release date (remove "Pending")
   - `docs/project-valuation-report.md` — update PR count + release tag entry
   - `docs/release-1.0-plan.md` — mark release milestone as ✅ Complete
3. Commit, push, create docs-only PR
4. **User reviews and merges**

**Rules:**
- Kiro NEVER pushes to `main` or `prod` directly
- Kiro NEVER creates tags — user does via GitHub Release UI
- If smoke test has failures → hotfix PR first → re-test → then `/release-finish`
- All smoke test results must show PASS before `/release-finish` is issued

**Versioning:**
- `vX.Y.Z-web` where:
  - **X** = major (breaking changes, new layers)
  - **Y** = minor (new sprint features)
  - **Z** = patch (hotfixes, minor tweaks)

---

## Rollback Strategies

### If Issues Found After Merge

| Severity | Strategy | How |
|----------|----------|-----|
| **Minor bug** | Fix Forward | New branch → fix → PR → merge (fastest) |
| **Broken build / app crash** | Revert PR | GitHub PR page → "Revert" button → merge revert PR |
| **Data issue / schema problem** | Revert + Hotfix | Revert first, then fix in separate branch |

### Revert PR (GitHub UI — One Click)

1. Go to the merged PR on GitHub
2. Scroll to bottom → click **"Revert"**
3. GitHub creates a new PR that undoes all changes
4. Merge the revert PR → `main` returns to pre-merge state
5. Vercel auto-deploys the reverted `main`

### Revert via CLI

```bash
git revert <merge-commit-sha> -m 1
git push origin main
```

### Rules

- **Never force-push `main`** — keep history clean and traceable
- **Never use `git reset --hard` on `main`** — use revert instead
- Reverts are safe: they create a new commit, preserving full history

---

## CI/CD Pipeline

### Two-Tier Test Strategy

| Tier | Trigger | Tests | Goal | Time |
|------|---------|-------|------|------|
| **Tier 1 (Fast)** | Every PR to `main` | Domain + providers (pure Dart) | Catch logic regressions fast | ~30s |
| **Tier 2 (Full)** | PR to `main` + merge to `main` | All tests + widget + integration + coverage | Full confidence before staging | ~90s |

**Tier 1 directories (ci.yml — PR builds):**
- `test/features/astro_engine/` — All Vedic calculators
- `test/features/breath_journal/` — Alignment, micro-advice
- `test/features/cloud_backup/` — Sync, mapper, metadata
- `test/features/streaks/` — Streak, trend, ribbon calculators
- `test/features/ai_wisdom/` — Wisdom engine, rules, fallback
- `test/features/notifications/` — Notification scheduler
- `test/features/onboarding/` — Onboarding state, nakshatra mapping
- `test/features/providers/` — Dashboard data, locale, theme, timer

**Tier 2 additions (ci-full.yml — PRs to main + merge to main):**
- `test/features/widgets/` — All widget render tests (BirthBirdCard, RahuKaalCard, etc.)
- `test/widget_test.dart` — Full app navigation test
- `integration_test/` — End-to-end user flows (headless Chrome)
- Coverage threshold enforcement (≥ 19%)

### On Every PR to `main` (ci.yml)

| Step | Command | Gate |
|------|---------|------|
| Analyze | `dart analyze --fatal-infos` | Must pass (zero issues) |
| Tier 1 Tests | `flutter test test/features/{domain dirs}` | Must pass (all green) |
| Build Web | `flutter build web` | Must compile |

### On PRs to `main` + Merge to `main` (ci-full.yml)

Runs on pull requests targeting `main` (pre-merge gate) as well as on merge to `main`.

| Step | Command | Gate |
|------|---------|------|
| Analyze | `dart analyze --fatal-infos` | Must pass (zero issues) |
| All Tests | `flutter test --coverage` | Must pass (all green) |
| Coverage Check | Parse `lcov.info` | Must be ≥ 19% |
| Build Web | `flutter build web` | Must compile |
| Integration Tests | `flutter drive` (headless Chrome) | Must pass |

### On Merge to `main`

- Vercel auto-deploys to [saranidhi.vercel.app](https://saranidhi.vercel.app/)

### On Merge to `prod` (Future — Sprint 10)

- Cloudflare Pages production deployment
- App Store / Play Store builds (manual trigger)

---

## Deployment Architecture

| Environment | Branch | Platform | URL | Auto-Deploy | Data |
|-------------|--------|----------|-----|-------------|------|
| Production | `prod` | Vercel | [saranidhi.vercel.app](https://saranidhi.vercel.app) | On `/release` PR merge | Existing |
| Staging | `main` | Vercel (2nd project) | [saranidhi-staging.vercel.app](https://saranidhi-staging.vercel.app) | On merge to main | Existing |
| Preview | PR branches | Vercel | Auto-generated per PR | On PR open/update | Fresh |
| Production iOS | `main` | App Store | — | Manual |
| Production Android | `main` | Play Store | — | Manual |

### Known Limitations (Current)

- **Coverage gate:** Set to 19% (lowered from 25% to 20% in Sprint 14 — UI-heavy sprint — then raised 18→19 in Sprint 36). Domain layer is ~95% covered; UI/presentation layer brings blended average to ~24%. Will increase as widget test coverage improves.
- **UI verification:** Always verify on Vercel preview before merging UI changes. Never merge UI blind.
- **Settings navigation:** Settings is a pushed route (gear icon in top-right), not a bottom nav tab. Bottom nav has 4 tabs: Home, Journal, Oracle, Analytics.

---

## Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Sprint feature | `feature/sprintX-topic` | `feature/sprint2-astro-engine` |
| Bug fix | `fix/sprintX-topic` | `fix/sprint2-sunrise-edge-case` |
| Maintenance | `chore/sprintX-topic` | `chore/sprint1-update-deps` |

---

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(scope): <short description>

[optional body]
```

| Type | Use For |
|------|---------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `chore` | Maintenance, config, dependencies |
| `refactor` | Code restructuring (no behavior change) |
| `test` | Adding or updating tests |
| `docs` | Documentation only |
| `ci` | CI/CD configuration changes |

---

## Quality Gates (Must Pass Before Merge)

| Gate | Criteria | Enforcement |
|------|----------|-------------|
| Code Analysis | `dart analyze` — zero warnings/errors | CI Fast (blocking) |
| Tier 1 Tests | Domain + provider tests — all pass | CI Fast (blocking) |
| Build | `flutter build web` compiles | CI Fast (blocking) |
| Tier 2 Tests | Widget + integration tests — all pass | CI Full (PR to main + on merge) |
| Coverage | ≥ 19% line coverage | CI Full (PR to main + on merge) |
| Documentation | Sprint tracker updated | PR review |
| Review | PR reviewed by owner | GitHub branch protection |

---

## Verification Checklist (After Merge)

- [ ] CI passed on `main` branch
- [ ] Vercel deployment succeeded at saranidhi.vercel.app
- [ ] App navigates correctly (Home, Journal, Analytics — Settings via gear icon)
- [ ] No console errors in browser DevTools (source map 404s are acceptable)
- [ ] New features render as expected
- [ ] Sprint tracker updated with ✅

---

## Lessons Learned / Gotchas

> Captured from production incidents and CI failures. Refer to these before making similar changes.

### DB Migrations (v1.2.1 hotfix — PR #81)

**Problem:** `Drift.m.addColumn()` throws "duplicate column name" if the column was already in the table definition before the schema version was bumped.

**Rule:** Always wrap `addColumn()` in try-catch, OR use `PRAGMA table_info()` to check column existence before ALTER TABLE. Never add a column to the schema definition without simultaneously bumping the schema version in the same PR.

### CI Scope Expansion (PRs #81–#93)

**Problem:** Adding `pull_request: [prod]` to `ci-full.yml` exposed 3 pre-existing test failures (widget test, integration test) that were never caught.

**Rule:** Before expanding CI triggers, run the full test suite via `workflow_dispatch` and confirm green. Fix failures FIRST, then add new triggers.

### Flutter Widget Tests + Stream Providers

**Problem:** `pumpAndSettle()` times out (10s default) when providers are overridden with `Stream.value(...)` because streams keep the Flutter scheduler permanently active.

**Rule:** Use `pump()` + `pump(Duration(seconds: 1))` for navigation steps in tests that use stream-based provider overrides. Only use `pumpAndSettle()` for the initial app load. Skip navigation tests if the stream issue can't be resolved (deferred to Sprint 29).

### Integration Tests Must Match UI

**Problem:** IntroScreen was added in Sprint 23 but integration_test/app_test.dart still expected OnboardingScreen text.

**Rule:** Every sprint that changes onboarding, navigation flow, or screen titles MUST update `integration_test/app_test.dart` and `test/widget_test.dart` in the same PR.

### Release Protocol — Never Skip main→prod

**Problem:** During v1.2.1 release, the `main→prod` PR was incorrectly skipped because `prod` branch wasn't visible in a shallow clone.

**Rule:** The `prod` branch ALWAYS exists. Vercel production deploys from `prod`, staging from `main`. The `/release-finish` protocol MUST create a PR from `main` → `prod`. Never assume it doesn't exist.

### Release Protocol — Always Bump pubspec.yaml Version (v1.3.0 — PR #111)

**Problem:** v1.3.0 was deployed to production but the About card showed `v1.2.1 (1)` because `pubspec.yaml` version was never bumped during the release cycle.

**Rule:** The `/release-start` protocol MUST bump `version:` in `pubspec.yaml` as the **first step** on the release branch (before smoke test). This ensures the version is correct in staging preview testing AND production. Never ship a release where `pubspec.yaml` doesn't match the release tag.

### DB Migration Existence-Check Helper (Sprint 36)

**Problem:** Each `onUpgrade` step hand-rolled its own existence check (a raw `PRAGMA table_info()` loop for columns, a `sqlite_master` query for tables) before running `addColumn`/`createTable`. The checks drifted apart in style, were easy to omit, and an omitted guard re-introduces the v1.2.1 "duplicate column name" failure class whenever a migration re-runs on a DB that already has the object.

**Rule:** Use the shared helpers in `lib/database/migration_helpers.dart` - `tableExists(db, name)` (backed by `sqlite_master`) and `columnExists(db, table, column)` (backed by `PRAGMA table_info`), where `db` is the `GeneratedDatabase` (pass `this` from inside `onUpgrade`) - for every existence check in `onUpgrade`. The `from < 3` (is_pinned column), `from < 4` (prasanam_history table), and `from < 5` (somatic_intervention_logs table) steps in `app_database.dart` are refactored onto them; new migrations MUST guard through the same helpers rather than adding ad-hoc `PRAGMA`/`sqlite_master` code. The helpers are unit-tested against an in-memory Drift DB (`test/database/migration_helpers_test.dart`), so the guard behavior itself is covered.

### CI Fast ≠ CI Full — Run the Full Suite Pre-Merge (v1.6.0)

**Problem:** `ci-full.yml` only ran at merge-to-main, so PRs green on CI Fast (which omits widget tests + coverage) still reddened `main` after merge — a real About-card `RenderFlex` overflow and a real-DB widget-test crash surfaced only in the full suite.

**Rule:** `ci-full` now also runs on PRs into `main`, so the full gate (widget tests + coverage + integration tests) runs pre-merge. The pre-merge gate must run the same suite that runs at merge, or green PRs can still break `main`.

### Integration Test Fix + Re-gate (Sprint 36)

**Problem:** The web integration job (`ci-full.yml`) started ChromeDriver on `:4444` with a bare `sleep 2` before running `flutter drive`, and the intermittent `ConnectionClosedException` on onboarding launch was a ChromeDriver startup/readiness race, not a real app failure. The job carried `continue-on-error: true`, so `Integration Tests (Web)` was not actually gating. Test assertions had also drifted from the current UI (asserting async card content such as `"Last 7 Days"` / `"3 days"` that only appears after a provider resolves).

**Rules:**
- Replace the bare `sleep` with a bounded ChromeDriver readiness poll: `curl` `localhost:4444/status` in a short loop (up to ~30s) and only proceed once it reports ready. This removes the startup race behind `ConnectionClosedException`.
- Keep integration/widget assertions in sync with the current UI, and assert on **stable app-shell elements** that are always present (`"Saranidhi"`, `"Today"`, `"Explore"`) rather than async card content that depends on a provider having resolved.
- **NEVER** use `pumpAndSettle()` with stream-based provider overrides - it times out because the stream keeps the scheduler active. Use `pump()` + `pump(Duration(seconds: 1))` for navigation steps (see the widget-test gotcha above).
- `continue-on-error` was removed from the integration-test job, so `Integration Tests (Web)` is a real, trustworthy gate again. Do not re-add it to paper over a flake; fix the underlying readiness/assertion issue instead.

### Alignment Tests Must Derive Expected Flow From NostrilPattern (Sprint 36)

**Problem:** Three `alignment_checker_test.dart` tests hardcoded a Solar/Lunar `expectedFlow` for a fixed date (April 2, 2025) and were date-dependent flaky. `AlignmentChecker.check` computes `expectedFlow` via `NostrilPattern.expectedFlowForYama(yama)` with NO date argument, so `NostrilPattern` falls back to `DateTime.now()`. The test's `time` argument only selects sunrise/sunset and which yama the clock lands in; it does not drive `expectedFlow`. The hardcoded expectations only held when the CI run date's tithi started Solar, so the suite failed on runs whose current tithi started Lunar. Choosing a different fixed date does not help because the fixed date has zero effect on `expectedFlow`.

**Rule:** Alignment tests MUST derive their expected flow from `NostrilPattern.expectedFlowForYama(...)` called the same way production does (no date argument), then assert the relationship (aligned when actual matches, mis-aligned when actual is the opposite, and Yama 2 always the opposite of Yama 1). Never hardcode `BreathFlow.solar`/`BreathFlow.lunar` as the expected value for a fixed calendar date.

---

[← Back to Root](../../README.md)

