[← Back to Root](../README.md)

# Saranidhi — Development Workflow

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
6. **CI gates:** Analyze + Test + Coverage (≥15% feature sprints) + Build Web + Integration Tests
7. **Review:** Owner verifies on Vercel preview + reviews PR on GitHub
8. **Merge:** Owner merges after visual QA + CI passes
9. **Vercel deploys:** `main` auto-deploys to [saranidhi.vercel.app](https://saranidhi.vercel.app/)
10. **Verify:** Owner confirms staging matches expectations

---

## Sprint Protocols

### `/start-sprint`

Lightweight entry point — creates the branch and marks the sprint active.

1. Create feature branch from `main` (`feature/sprintN-<topic>`)
2. Update `docs/sprint-tracker.md` — mark sprint as "(Current Sprint)"
3. Begin implementation

### `/finish-sprint`

Closes the sprint — delivers the code and merges.

1. Commit all remaining changes
2. Push branch to remote
3. Create PR targeting `main`
4. Update `docs/sprint-tracker.md` → ✅ Complete (PR #N)
5. Verify CI passes
6. **Merge PR** — sprint is officially closed
7. Ask: *"Run /project-update now or later?"*
8. Update `docs/testing-plan.md` — add test count entry for the sprint
9. Update `docs/manual-smoke-test.md` — add scenarios for new features (if any)

### `/project-update`

Runs **after merge** on a separate docs-only branch to avoid CI code failures.

1. Create branch from `main` (`docs/sprintN-update`)
2. Update all clerical docs:
   - `docs/project-valuation-report.md` — timeline, commit log, hours (estimate + 20%), deliverables, executive summary
   - `docs/project-evaluation.md` — feature scorecard, delivery table, resolved defects
   - `docs/project-plan.md` — new infrastructure/architecture patterns
   - `docs/testing-plan.md` — test count progression, scenarios awaiting coverage
   - `docs/dev-workflow.md` — any threshold/process changes
   - `.kiro/steering/saranidhi-spec.md` — tech stack updates
3. Commit, push, create docs-only PR
4. Merge docs PR (CI won't fail since no code changes)

**Hours estimation rule:** Use AI-estimated active time + 20% buffer (owner-approved).

### `/plan`

Strategic brainstorming and sprint plan revision — forward-looking.

1. Review current state (sprint tracker, release plan, what's done)
2. Discuss trade-offs, priorities, new features, scope cuts
3. Once aligned, update:
   - `docs/sprint-tracker.md` — redefine upcoming sprints
   - `docs/release-1.0-plan.md` — adjust milestones
4. Committed on a feature branch → PR (may include code if CI skip needed)

**Examples:**
- `/plan` "Re-scope remaining sprints for beta release"
- `/plan` "Add data export feature, push deployment back"
- `/plan` "Cut cloud backup from 1.0, move to 1.1"

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

Promotes `main` (staging) to `prod` (production) via a tracked PR.

1. Create PR from `main` → `prod`
2. PR title: `Release: vX.Y.Z — <summary>`
3. PR body: release notes structured as:
   - **What's New** — features added since last release
   - **Fixes** — bugs resolved
   - **Known Issues** — anything still pending
   - **Sprint(s)** — which sprints are included
4. **Verify manual smoke test passes** on staging (saranidhi-staging.vercel.app)
   - Execute `docs/manual-smoke-test.md` scenarios
   - Record results in `docs/smoke-test-results.md`
   - All sections must pass before merge
5. Review the PR (final sanity check)
6. Merge → Vercel auto-deploys `prod` to `saranidhi.vercel.app`
7. Tag the release on `prod`:
   ```bash
   git checkout prod && git pull
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```
8. (Optional) Create GitHub Release from the tag with the same notes

**Versioning:**
- `vX.Y.Z-web` where:
  - **X** = major (breaking changes, redesigns)
  - **Y** = minor (new sprint features)
  - **Z** = patch (hotfixes, minor tweaks)
- Examples:
  - `v1.1.0-web` — Sprint 14 features (birth bird dashboard)
  - `v1.1.1-web` — Hotfix after Sprint 14
  - `v1.2.0-web` — Sprint 15 features (night yamas)

**When to release:**
- After each sprint merge (or batch of sprints) when staging is verified
- Not every merge to `main` needs a production release
- Release when you're confident the staging version is stable

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

### On Every PR to `main`

| Step | Command | Gate |
|------|---------|------|
| Analyze | `dart analyze --fatal-infos` | Must pass (zero issues) |
| Unit & Widget Tests | `flutter test --coverage` | Must pass (all green) |
| Coverage Check | Parse `lcov.info` | Must be ≥ 80% |
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

- **Coverage gate:** Set to 20% (lowered from 25% in Sprint 14 — UI-heavy sprint). Domain layer is ~95% covered; UI/presentation layer brings blended average to ~24%. Will increase as widget test coverage improves.
- **UI verification:** Always verify on Vercel preview before merging UI changes. Never merge UI blind.

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
| Code Analysis | `dart analyze` — zero warnings/errors | CI (blocking) |
| Tests | `flutter test` — all pass | CI (blocking) |
| Coverage | ≥ 80% line coverage | CI (blocking) |
| Build | `flutter build web` compiles | CI (blocking) |
| Integration | `flutter drive` (headless Chrome) | CI (blocking) |
| Documentation | Sprint tracker updated | PR review |
| Review | PR reviewed by owner | GitHub branch protection |

---

## Verification Checklist (After Merge)

- [ ] CI passed on `main` branch
- [ ] Vercel deployment succeeded at saranidhi.vercel.app
- [ ] App navigates correctly (Home, Journal, Settings)
- [ ] No console errors in browser DevTools
- [ ] New features render as expected
- [ ] Sprint tracker updated with ✅

---

[← Back to Root](../README.md)

