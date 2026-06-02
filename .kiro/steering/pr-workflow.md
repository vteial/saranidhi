---
inclusion: auto
---

# Workspace Automation Rules & Sprint Lifecycle Protocols

## 1. `/start-sprint` Command

**Trigger:** Operator issues this command to begin a new sprint.

**Execution Sequence:**

### Step 1: Branch Creation
- Create new branch: `feature/sprintX-topic` from `main`
- Verify clean working tree before branching

### Step 2: Sprint Tracker Update
- Open `docs/sprint-tracker.md`
- Add new sprint section with task checklist
- Mark sprint as `(Current Sprint)`

### Step 3: Context Orientation
- Review `docs/project-plan.md` for feature scope
- Review `docs/release-1.0-plan.md` for sprint objectives
- Confirm sprint deliverables with operator

---

## 2. `/finish-sprint` or `/complete-sprint` Command

**Trigger:** Operator issues this command when a sprint branch is ready for final merge.

**Execution Sequence:**

### Step 1: Validation Gates
```bash
dart analyze                    # Must exit 0
flutter test                    # Must exit 0
```

### Step 2: Sprint Tracker Update
- Open `docs/sprint-tracker.md`
- Flip the active sprint status to `✅ Complete (Merged PR #XX)`
- Activate the immediate subsequent sprint as `(Current Sprint)`
- Verify all task checkboxes in the completed sprint are marked `[x]`

### Step 3: Valuation Report Update
- Open `docs/project-valuation-report.md`
- Parse recent commit metadata and append new entries to the Commit Metadata Timeline
- Update the Active Coding Sessions table with session hours
- Update Total Engineering Investment totals
- Update Sprint Delivery Summary table (status transition)

### Step 4: Evaluation Scorecard Bumping
- Open `docs/project-evaluation.md`
- Transition completed feature domains to `✅ Complete (100%)` in the scorecard
- Update the cumulative test assertion count in Test Count Progression
- Update Test Execution Parameters (total assertions, pass rate)
- Append any new resolved defects to the Resolved Defects table
- Update Sprint Delivery Summary with new sprint row

### Step 5: Project Plan Alignment
- Audit `docs/project-plan.md`
- Cross-verify any newly introduced infrastructure or architecture is documented
- Add missing sections if new patterns were introduced during the sprint

### Step 6: Testing Synchronization
- Scan `docs/testing-plan.md`
- Verify documented scenarios match physical test file assertions
- Update scenario counts if new tests were added during the sprint

### Step 7: Commit & PR Preparation
- Stage all changes
- Commit with conventional message: `feat(sprintX): <summary>`
- Output PR Title + description
- Push via `github_push_to_remote` tool

### Step 8: PR Creation
- Create pull request targeting `main`
- PR body includes: sprint summary, tasks completed, tests added
- Await CI pass before merge

---

## 3. `/hotfix` or `/bugfix` Command

**Trigger:** Operator issues this command after a defect is patched.

**Execution Sequence:**

### Step 1: Validation Gates
```bash
dart analyze                    # Must exit 0
flutter test                    # Must exit 0
```

### Step 2: Forensic Defect Entry
- Append a row to the "Resolved Defects" table in `docs/project-evaluation.md` Section 3
- Row format: `| Issue/Symptom | Root Cause | Resolution | Sprint |`

### Step 3: Time Delta Recording
- Increment the matching session row in `docs/project-valuation-report.md`
- Update Total Project Investment cumulative hours if significant time was spent

### Step 4: Commit
- Stage the fix + any documentation updates
- Commit with `fix(sprintX): <description>`

---

## 4. Standard PR Preparation (on "prepare PR" or "commit")

### Validation Gates
```bash
dart analyze                    # Must exit 0
flutter test                    # Must exit 0
```

### Stage & Commit
```bash
git status --short
git add <specific files>
git commit -m "<type>(sprintX): <summary>"
```

### Commit Message Types
- `feat` — new feature or capability
- `fix` — bug fix
- `chore` — maintenance, config, docs
- `refactor` — code restructuring without behavior change
- `test` — adding or updating tests
- `docs` — documentation only changes

### Push & PR
- Push via `github_push_to_remote` tool (never raw `git push`)
- Create PR via `github_create_pull_request` tool
- PR Title (< 70 chars): `<type>(sprintX): <short description>`

---

## 5. Permanent Workspace Rules

### Git Discipline
- Never commit directly to `main` (except Sprint 0 initialization)
- Branch naming: `feature/sprintX-topic` or `fix/sprintX-topic` or `chore/sprintX-topic`
- All commits follow Conventional Commits specification
- Merges only after CI passes (analyze + test)

### Code Quality
- Zero `dynamic` usage outside framework boundaries
- All models use Freezed + json_serializable
- All state uses @riverpod code generation
- All routes defined in GoRouter configuration
- very_good_analysis linting enforced

### Architecture Boundaries
- Presentation layer NEVER imports data layer directly
- Domain layer has ZERO framework dependencies (pure Dart)
- Repository pattern mediates all data access
- Platform-specific code isolated behind abstract interfaces

### Sprint Cadence
- Each sprint = 1 focused feature module
- Sprint starts with branch creation + task definition
- Sprint ends with PR merge to `main`
- Documentation updated atomically with code

### File Organization (Feature-First)
```
lib/
├── core/                    # Shared utilities, theme, router, constants
│   ├── router/
│   ├── theme/
│   ├── utils/
│   └── constants/
├── features/
│   ├── auth/                # Sign-in (Apple/Google) for cloud access
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── breath_journal/      # Sara Kalai logging
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── astro_engine/        # Vedic calculations (pure Dart)
│   │   ├── data/
│   │   └── domain/
│   ├── streaks/             # Consistency tracking
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── notifications/       # Local push (mobile only)
│   │   ├── data/
│   │   └── domain/
│   ├── ai_wisdom/           # On-device AI + fallbacks
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── cloud_backup/        # iCloud / Google Drive
│   │   ├── data/
│   │   └── domain/
│   └── settings/            # Profile, theme, language, storage mode
│       ├── data/
│       ├── domain/
│       └── presentation/
├── database/                # Drift schema, DAOs, migrations
└── main.dart
```

---
