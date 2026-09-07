# AI Team Collaboration Framework — Saranidhi

This document describes the multi-agent operating model used to develop the
**Saranidhi** application: how a single human lead orchestrates specialized AI
personas to take a feature from idea to production, and the gates that keep the
process honest.

> **Status:** Working model, matured through the v1.5.0 release cycle. It is
> intentionally **Saranidhi-specific**; a stack-agnostic version will be
> extracted into a reusable template (`project-blueprint`) later, once this
> process has been evaluated in real use.

---

## 1. Team Topology & Tooling

```mermaid
flowchart TD
    User(["👤 Product Owner / Lead (Human)"])
    BA["📋 Business Analyst\n(Requirements, Scenarios, Rules)"]
    Arch["🏛️ Architect\n(System Design, Schemas, Contracts)"]
    QA["🧪 QA\n(Design: test matrix • Verify: execute + record)"]
    Dev["💻 Developer (Kiro Web)\n(Implementation, Tests, Branches/PRs)"]

    User -->|"Feature request & priorities"| BA
    BA -->|"User stories & acceptance criteria"| Arch
    Arch -->|"Technical specs & contracts"| Dev
    BA -->|"Acceptance criteria"| QA
    Arch -->|"System invariants"| QA
    QA -->|"Test matrix (in Feature Brief)"| Dev
    Dev -->|"Branch / PR / CI"| QA
    QA -->|"QA-Verify sign-off"| User
    Dev -->|"Working feature"| User
    User -->|"Sole merge & release authority"| Dev
```

### 1.1 Roles

| Role | Responsibilities |
| :--- | :--- |
| **Product Owner / Lead** — Human | Vision, prioritization, orchestrating prompts across windows, architectural approvals, and the **sole merge & release authority** (only the human merges PRs and creates tags). |
| **Business Analyst (BA)** | Requirements elicitation, user stories with acceptance criteria (Given-When-Then), domain business rules, personas, edge-case identification. |
| **Solution Architect** | System design, database schema, state-management architecture, service/API contracts, ADRs, non-functional requirements (security, offline-first, performance). |
| **Quality Assurance (QA)** | One role, **two phases**: **QA-Design** (authors the test matrix *before* code — happy/negative/boundary/regression — folded into the Feature Brief) and **QA-Verify** (executes tests on the deployed build, records results, logs bugs + root cause, owns the verification gate). **QA never edits source code.** |
| **Software Developer** | Feature implementation, refactoring, bug fixes, unit/widget test implementation, CI compatibility. Creates **branches and PRs but never merges to `main`/`prod` and never creates tags.** |

### 1.2 Tooling Map (how the roles are realized)

| Framework Role | Actual Tool |
| :--- | :--- |
| **Common / Strategy Window** (BA + Architect + QA-Design) | **IntelliJ IDEA + AI Assistant running Google Antigravity**, opened in **multiple windows**, each acting as a different persona. This multi-window approach is a deliberate **cost-cutting** choice — it provides the multi-persona round-table without additional paid tooling. |
| **QA Assistant** (QA-Verify) | **Google Antigravity** — performs the real testing on deployed builds and the clerical recording (results in `docs/smoke-test-*.md`), root-cause analysis, and bug logging. Does not edit source. |
| **Developer Agent** | **Kiro Web** (the human + Kiro) — planning, documentation, all code/PRs, and the release workflow on `vteial/saranidhi`. |

> **Bridge constraint:** the AI personas live in **separate tools and cannot talk
> to each other directly.** The Human is the bridge, and the standardized
> **Feature Brief** (§5) is the message passed between the Common Window and the
> Developer Agent.

---

## 2. Practical Human Operator Playbook

The human runs the project across two main workspaces:

1. **Common / Strategy Window** — IntelliJ + Antigravity multi-window (BA, Architect, QA-Design).
2. **Developer Agent (Kiro Web)** — execution: code, docs, builds, branches/PRs, release workflow.

*(Optional: a dedicated single-role window for large, isolated deep-dives — see §3.)*

```mermaid
flowchart LR
    subgraph Common ["🪟 1. Common Window (IntelliJ + Antigravity)"]
        direction TB
        Idea["Human idea"] --> Round["BA + Architect + QA-Design"]
        Round --> Brief["Feature Brief"]
    end
    subgraph KiroWeb ["💻 2. Kiro Web (Developer)"]
        direction TB
        Brief --> Paste["Paste Feature Brief"]
        Paste --> Code["Code + unit/widget tests"]
        Code --> PR["Branch / PR / CI"]
    end
    subgraph Verify ["🔍 3. QA-Verify (Antigravity)"]
        direction TB
        PR --> Test["Smoke test on deployed build"]
        Test --> Signoff["Record results + Human sign-off"]
    end
    Common --> KiroWeb
    KiroWeb --> Verify
```

### Step-by-Step

1. **Ideate (Common Window)** — give the raw idea/bug to the team; BA, Architect, and QA-Design draft the Feature Brief.
2. **Review & approve the Feature Brief** — adjust until it matches the vision. Output: a single finalized Markdown brief.
3. **Dispatch to Kiro Web** — paste the brief; Kiro implements the code + unit tests, then pushes a branch and opens a PR.
4. **Validate** — Kiro confirms CI is green; QA-Verify smoke-tests the deployed build and records results.
5. **Merge & close** — the **Human** merges (see §2.3). Feature is closed after merge.

### 2.1 Release Lifecycle

Beyond a single feature, releases follow a strict two-phase flow (protocol
commands live in `docs/dev-workflow.md`):

```mermaid
flowchart TD
    A["Sprint(s) merged to main = staging"] --> B["/release-start\nKiro: release/vX.Y.Z branch"]
    B --> B1["FIRST commit bumps pubspec.yaml version\n+ smoke-test-vX.Y.Z.md + CHANGELOG"]
    B1 --> C["QA-Verify on release-branch preview\n(correct version shown)"]
    C --> D["Human merges release PR -> main"]
    D --> E["/release-finish\nKiro: PR main -> prod (release notes)"]
    E --> F["Human merges prod PR -> Vercel deploys production"]
    F --> G["Human creates GitHub Release + tag vX.Y.Z-web"]
    G --> H["/release-update\nKiro: smoke-test index, CHANGELOG date, PR count"]
```

- **Deploy targets:** `main` → staging (saranidhi-staging.vercel.app); `prod` → production (saranidhi.vercel.app).
- **Version bump is the FIRST commit of `/release-start`** so the About card shows the correct version during staging smoke testing.
- CRITICAL gates (e.g., DB migration on fresh install *and* upgrade; core feature flows) must pass before promotion.

### 2.2 The QA Sign-off Gate — CI green, not just the preview

> **A green Vercel preview is NOT sign-off.** Before merging any release or
> promotion PR, confirm the required CI checks are green:
> - On PRs to `main`: **"Analyze, Fast Tests & Build"**.
> - On `main → prod`: **"Full Test Suite + Coverage"** (heavier `ci-full.yml`).
>
> **Known non-blocking checks may show red for information** and do not block the
> gate — currently **"Integration Tests (Web)"** is marked non-blocking
> (`continue-on-error`) because it is flaky/stale; its fate is a planning-session
> item. "CI green" therefore means *all **required** checks green*.
>
> *v1.5.0 proof: a literal `\n` syntax error and an 18%-vs-19% coverage shortfall
> both passed the Vercel preview but failed CI; stale integration tests only
> surfaced on the `main → prod` trigger. The preview alone would have shipped a
> broken build.*

### 2.3 Merge & Tag Authority — absolute rule

> The Developer Agent (Kiro) **pushes branches, opens PRs, and validates CI, but
> NEVER merges to `main`/`prod` and NEVER creates tags.** The **Human is the sole
> merge and release authority.** This applies to every protocol
> (`/sprint-finish`, `/plan`, `/release-start`, `/release-finish`,
> `/release-update`).

### 2.4 Bug Found During QA-Verify — feedback loop

When QA-Verify finds a bug during smoke testing:

1. **Log it** in `docs/smoke-test-vX.Y.Z.md` — scenario, expected vs. actual, and (if known) root cause.
2. **Kiro fixes it on the same branch** (the sprint or release/PR branch) as a **new commit — never `git --amend` after a CI failure.**
3. **QA re-verifies the specific failed scenario** (targeted, not a full re-run) on the updated build.
4. Only then proceed.

*v1.5.0 proof: the `rootNavigator` nav-bar fix was applied on the release branch and re-verified via a targeted J/M scenario pass on commit `969bb4f`.*

---

## 3. When to Use Dedicated vs. Common Windows

| Window | When | Advantage |
| :--- | :--- | :--- |
| **Common Window (default)** | Feature planning, multi-perspective review, triage, cross-discipline alignment. | Zero context switching; BA/Architect/QA challenge each other in real time. |
| **Dedicated BA Window** | Deep domain research, user-journey mapping, large spec/manual authoring. | Uncluttered business-modeling context. |
| **Dedicated Architect Window** | Deep refactor design, DB migration planning, complex state-machine/Riverpod work, ADRs. | Focused codebase-internals context. |
| **Dedicated QA Window** | Exhaustive test-matrix authoring, edge-case permutations. | Dedicated coverage-matrix context. |
| **Kiro Web (Developer)** | All coding, file edits, package changes, build runners, Git branches/PRs, releases. | Specialized code generation + tool execution. |

---

## 4. End-to-End Feature Lifecycle

```mermaid
sequenceDiagram
    autonumber
    actor User as Product Owner (Human)
    participant Common as Common Window (BA/Arch/QA-Design)
    participant Kiro as Developer (Kiro Web)
    participant AQA as QA-Verify (Antigravity)

    User->>Common: 1. Idea / feature request
    Common->>Common: 2. BA stories + Arch specs + QA test matrix
    Common-->>User: 3. Finalized Feature Brief
    User->>Kiro: 4. Paste Feature Brief
    Kiro->>Kiro: 5. Code + unit/widget tests
    Kiro-->>User: 6. Branch / PR created (CI green)
    User->>AQA: 7. Request QA-Verify on deployed build
    AQA-->>User: 8. Results recorded + sign-off (CI green, not just preview)
    User->>Kiro: 9. Human merges (Kiro never merges/tags)
```

---

## 5. Standard Handoff Template (Feature Brief)

Use this when transferring work from the Common Window to **Kiro Web**:

```markdown
# Feature: [Feature Name / ID]
**Target Release:** vX.Y.Z

## 📋 Business Context & User Stories (BA)
- **As a:** [user type]
- **I want to:** [action]
- **So that:** [benefit]

### Acceptance Criteria
- [ ] **AC-1:** Given [precondition], When [action], Then [expected outcome].
- [ ] **AC-2 (Edge Case):** Given [state], When [action], Then [error/fallback].

## 🏛️ Technical Specification (Architect)
- **Target Files / Directories:** `lib/...`, `test/...`
- **Data Models / Schema:** (note DB schema version bump + idempotent migration if any)
- **State Management / Providers:**
- **Service Interfaces / Contracts:**
- **Security / Offline Considerations:**

## 🧪 Test Matrix & Verification (QA)
### QA-Design (before code)
- **Unit tests:**
- **Widget / screen tests:**
- **Integration / flow tests:**
- **Negative / boundary scenarios:**
### QA-Verify (after build)
- **Smoke-test scenarios that gate this feature:**
- **CRITICAL gates:** (e.g., migration fresh + upgrade? core flow?)
- **Reminder:** CI green (named checks), not just the Vercel preview.
```

---

## 6. Best Practices for Human Orchestration

1. **You are the bridge.** AI personas in separate tools cannot talk directly; pass work via the standardized **Feature Brief**.
2. **Shift-left quality.** Never dispatch to Kiro Web without the **QA-Design test matrix** in the brief — it prevents shallow, untested code.
3. **Keep context clean.** Use the Common Window for alignment; let Kiro Web handle file-by-file churn.
4. **Iterative refinement.** If Kiro hits an architectural conflict, bring the error back to the Architect in the Common Window and adjust the design.
5. **Human is the sole merge & release authority.** Kiro branches/PRs and validates CI; only the human merges to `main`/`prod` and creates tags.
6. **CI green, not just the preview.** QA-Verify confirms the named required CI checks before any merge; known non-blocking checks may show red for information.
7. **Fix-on-same-branch loop.** A QA bug is fixed on the same PR branch as a new commit (never `--amend` after a CI failure), then the specific scenario is re-verified.
8. **Capture learnings at the moment of decision.** Record decisions, gotchas, and deferrals as durable learnings so the process compounds instead of repeating mistakes.

---

## 7. Learnings / Memory Layer

The reason this collaboration *matures* rather than repeating mistakes is a
persistent memory of decisions and lessons, kept outside of chat history.

**What to capture:**
- **Decisions & rationale** (e.g., "birth bird is permanent, derived from birth Paksha").
- **Protocol/process changes** (e.g., "version bump is the first commit of `/release-start`").
- **Gotchas & failure lessons** (e.g., "green Vercel preview ≠ green CI"; "drift `addColumn` needs an existence check").
- **Deferred items & reasons** (so they resurface in `/plan`).

**How (Saranidhi-specific mechanism):**
- **Cross-project preferences / decisions / gotchas** → **Kiro learnings** (durable, recalled every session).
- **Repository-specific conventions/rules** → `.kiro/steering/` in the repo, or the relevant `docs/` file.

**When:** at the moment a decision is confirmed or a lesson is learned — not batched later. The agent that surfaces it writes it; the Human confirms non-obvious ones.

---

## 8. Documentation Map & Freshness

This framework describes the **collaboration model**. It cross-links to — and does
**not** duplicate — the operational docs:

| Doc | Owns |
| :--- | :--- |
| `AI_COLLABORATION_FRAMEWORK.md` (this doc) | Roles, handoffs, lifecycle, gates |
| `docs/README.md` | Documentation index / map (all docs by context) |
| `docs/process/dev-workflow.md` | Protocol commands (`/plan`, `/sprint-*`, `/release-*`), branching, CI details, Lessons/Gotchas |
| `docs/process/sprint-tracker.md` | Delivered + in-progress sprints, overview table, Definition of Done |
| `docs/process/sprint-backlog.md` | Candidate/future work, epics, open decisions, ideas |
| `docs/testing/releases/smoke-test-*.md` + `docs/testing/smoke-test-results.md` | Per-release test plans + results index |
| `CHANGELOG.md` | Released version history |

> **Freshness rule:** when a protocol or gate changes, update
> `docs/process/dev-workflow.md` **and** this framework in the **same PR** so they
> never drift.
