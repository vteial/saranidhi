[← Back to Root](../../README.md)

# Saranidhi — Process Migration Baseline & Decision Record

> **Canonical self-path:** `docs/process/PROCESS_MIGRATION.md` in `vteial/saranidhi`.
> **Reviewed:** v1.13.0-web · **Status:** 🟡 In adoption (PR 0 of 5).
> **Purpose:** The anchor record for converging Saranidhi's development process onto
> the firm-wide **cetana-labs** vocabulary and the **Kiro Spec-driven** model, so the
> owner carries ONE process across every project. Every later migration PR (1–4) is a
> mechanical application of the maps in this document.

---

## 0. Why this migration (the problem)

_Last verified: 2026-10-03_

The owner runs a family of projects (`cetana-labs`, `nexus-pulse`, `rbac-platform`,
`saranidhi`, …). Each had drifted to its **own** process vocabulary and toolchain, so
jumping between projects spent attention on *re-learning the process* instead of the
product. The fix is **convergence on one firm-wide process**: identical commands,
identical role names, identical DX verbs — only the stack-specific innards differ.

**Decision of record:** adopt the **cetana-labs** methodology (vocabulary **and**
principle) as the firm standard, realized with the owner's machine toolchain
(`just`, not `make`), while **preserving** Saranidhi's doctrine-specific flows and its
heavier correctness/release gates.

---

## 1. The lineage (one methodology, three generations)

_Last verified: 2026-10-03_

These are not three unrelated processes — they are one evolving method:

| Repo | Role in the lineage |
| :--- | :--- |
| **nexus-pulse** (`LAB-003`) | **Origin.** 12+ sprints, real multi-dev team, the 5-verb pipeline, Tri-Registry lockstep, 4 quality gates, golden-fixture correctness gate (`NP-GOLDEN-001`). |
| **cetana-labs** (`LAB-000`) | **Refinement + control plane.** Took nexus-pulse's discipline and made it **Kiro-native**: Kiro Specs (EARS DoD) instead of `PROMPT.md`, RFCs + Decision Journal, a formal lifecycle state machine, phase-aware state guards, merge-first. **This is the target model.** |
| **rbac-platform** | **Newest DX pattern.** `justfile` written to be *reusable across POCs* (edit the variable block, copy the file + `scripts/`). The source of the firm `just` recipe family. |
| **saranidhi** | **This project.** Already runs a dialect of the same method (`/sprint-start`, `/delegate`, owner-gated merge). This migration catches it up to the latest generation. |

---

## 2. Locked parameters (owner-approved 2026-10-03)

| Parameter | Value |
| :--- | :--- |
| **Portfolio ID** | **`PRJ-001`** — Saranidhi is the first project in the owner's **personal** cetana-labs instance (a separate dashboard from the work `LAB-xxx` registry). |
| **Dev Environment** | `💻 Local` (Flutter on the owner's Mac — heavyweight native toolchain per cetana's `RFC-LAB-000-001` §4 heuristic). |
| **Health** | `🟢 On Track` · **Prod:** v1.13.0-web. |
| **Toolchain standard** | **`just`** (Homebrew `just` 1.58.0 per `~/my-works/PERSONAL_MACHINE_GUIDE.md`; one source of truth, D-01). pnpm@10.27.0 · Node ≥22 · Flutter 3.47.5 (brew cask) · `uv` for Python · Podman. |
| **Merge/tag authority** | **Human only.** Kiro (Operator) branches + opens PRs; never merges to `main`/`prod`, never tags. |

---

## 3. Role model — before → after

_Last verified: 2026-10-03_

Saranidhi's rich persona cast (BA / Architect / QA-Design / Dev) collapses to
cetana's **3-surface model**. The personas become *modes* of the Operator, not
separate seats — simpler to reason about, identical duties.

| cetana role | Surface (Saranidhi) | Duties | Gate |
| :--- | :--- | :--- | :--- |
| **Operator** | **Kiro** (Web/IDE — one seat) | Brainstorm, plan, author Kiro Specs, PR **review**, governance, `/sprint-update`, release workflow. **Never merges.** STOP-and-holds at the gate. | — |
| **Executor** | **Antigravity** (owner's Mac) | `/spec-run` → implement on `feat/`, run `flutter analyze`+`test` GREEN before the PR, fill the dossier, open the PR, emit Human Verification Plan, **STOP**. Also QA-Verify on the deployed preview. | self-validate |
| **Human** | The owner | Sets direction; **two gates** (approve Spec-merge; approve final squash-merge); sole merge + tag; doctrinal adjudicator (CONF). | both merges |

> Antigravity's two hats (implement + QA-Verify) are **Executor sub-modes**, not two roles.

---

## 4. Vocabulary map — Layer A (lifecycle)

_Last verified: 2026-10-03_

| Saranidhi today | cetana family (new) | Surface | Notes |
| :--- | :--- | :--- | :--- |
| `/plan` | `/plan-start` · `/plan-done` | Operator | `/plan-done` **merges the Spec to `main`** (merge-first) → state `READY_TO_BUILD`. |
| *(spec dossier inside `/delegate`)* | **Kiro Spec** `.kiro/specs/<id>/` | Operator authors | `requirements.md` (EARS DoD) · `design.md` · `tasks.md`. The contract. |
| `/sprint-start` | `/sprint-start` | Operator | Unchanged name — opens the sprint container (holds many plans). |
| `/delegate` → Antigravity | `/spec-run <id>` | Executor | One-liner: sync `main`, find the merged Spec, self-create the branch, run `tasks.md`, self-validate vs EARS DoD, open PR, emit Human Verification Plan, **STOP**. Never merges. |
| *(QA-Verify step)* | `/verification-done` | Executor | Records the Verification Log in the dossier → state `IN_REVIEW`. |
| *(owner reviews the PR)* | `/review-pr <PR>` | Operator surface, Human decides | Gate: CI + EARS DoD per-criterion + verification record. Recommends; never auto-merges. |
| `/sprint-finish` | `/sprint-done <id>` | Human merges | Merge lockstep + release-tag point; refuses undelivered work. |
| `/sprint-update` | `/sprint-update` | Operator | Unchanged — the docs lockstep (now also touches `STATUS.md`). |
| `/release-start` · `/release-finish` · `/release-update` | **kept, same names** | Operator + Human | Saranidhi's two-phase smoke-gated release is **richer** than cetana's "merge=live"; it is preserved, not downgraded. |

**State guards (new):** every lifecycle command is phase-aware — a redundant/already-done
command **skips + continues**; a missing prerequisite/gate **alerts + HOLDs**. A wrong-order
command can skip busywork but can **never** silently bypass a gate.

---

## 5. Vocabulary map — Layer B (environment / ops DX)

_Last verified: 2026-10-03_

Realized as **`just` recipes** (copied-and-adapted from `rbac-platform`'s reusable
template), each mirrored by a slash command where an agent runs it. Same verbs across
every repo; stack-specific bodies.

| Family verb | `just` recipe | Slash | Saranidhi body (Flutter, local-first, no backing services) |
| :--- | :--- | :--- | :--- |
| Onboard | `just setup-local` | `/setup-local` | `flutter pub get` + build_runner codegen; verify toolchain. |
| Audit machine | `just env-doctor` | `/env-doctor` | `flutter doctor`, pnpm/node, Chrome present, ports. |
| **Validate (gates)** | `just validate-local` | `/validate-local` | `dart analyze --fatal-infos` + `flutter test` + `flutter build web`. |
| Run | `just start-local` | `/start-local` | `flutter run -d chrome`. |
| Stop | `just stop-local` | `/stop-local` | terminate the dev server. |
| Status | `just status-local` | `/status-local` | is the dev server up? |
| Staging status | `just status-staging` | `/status-staging` | probe `saranidhi-staging` / prod Vercel URLs. |
| Docs audit | `just validate-docs` | `/validate-docs` | link/anchor/`> Reviewed:` freshness audit (the docs-audit gate). |
| Status broadcast | — | `/project-status` | 35-line `STATUS.md` → WhatsApp-ready exec summary (cetana two-phase: `/validate` pre-flight first). |

> **`just`, not `make`:** `make` is only the Xcode-shipped BSD make — not a machine-guide
> managed tool. `just` is Homebrew-managed and the owner's standard. cetana's `make` usage
> is a legacy artifact of its nexus-pulse origin and is a **future** `make→just` convergence.

---

## 6. The three-tier funnel (tracker convergence)

_Last verified: 2026-10-03_

Converge to cetana's `RFC-LAB-000-010` standard — distinct artifacts, one shared vocabulary:

```
BACKLOG.md            SPRINT_TRACKER.md              CHANGELOG.md
(ideas / the shelf)   (committed, in-flight work)    (shipped history)
```

| Today | New (root, cetana-standard) | How |
| :--- | :--- | :--- |
| `docs/process/sprint-tracker.md` | **`SPRINT_TRACKER.md`** (root) | `git mv` (preserve history) in PR 4. |
| `docs/process/sprint-backlog.md` | **`BACKLOG.md`** (root) | `git mv` in PR 4. |
| `CHANGELOG.md` (root) | `CHANGELOG.md` (root) | unchanged. |

Every doc/skill that references the old paths is updated in the **same PR** as the move.

---

## 7. The integration contract — `STATUS.md` → personal cetana dashboard

_Last verified: 2026-10-03_

The owner is standing up a **personal cetana-labs instance** whose dashboard renders
the live state of every personal project. For Saranidhi (`PRJ-001`) to appear, it needs
a **root `STATUS.md` in cetana's EXACT schema** — this is a cross-repo contract, not
cosmetic:

- **Location:** repo root `/STATUS.md` (cetana project-protocol §2 — "External Mini-Apps"
  keep `STATUS.md` in their own repo root; the registry reads/references it).
- **Schema:** cetana's authoritative 5-section template, **strictly ≤ 35 lines**, with the
  required metadata keys (`Project ID` = `PRJ-001`, `Current Health`, `Dev Environment`
  = `💻 Local`, `Owner / Lead`, `Last Updated`). The line budget is a hard scraper
  constraint — cetana's `validate_portfolio.py` fails a STATUS.md over 35 lines.
- **Freshness:** wired into `/sprint-update` **and** `/release-update` lockstep so the
  dashboard never goes stale (joins the existing clerical-docs checklist).
- **Added in PR 4.**

---

## 8. Preserve-list — Saranidhi-specific, MUST NOT be dropped

_Last verified: 2026-10-03_

cetana is a SvelteKit/PocketBase control plane; Saranidhi is a bilingual Flutter
spiritual app with doctrine. These gates have no cetana equivalent and are folded into
the new model (Spec DoD / steering), never discarded:

| Gate | Folds into |
| :--- | :--- |
| **Tamil bilingual gate** (every string EN + pure Tamil script) | A standing EARS acceptance criterion in every UI Spec + Executor steering. |
| **CONF provenance** (each rule cites corpus practice + resolved CONF/CONF-PP) | Spec `requirements.md` provenance section. |
| **Flows 1 & 2** (Knowledge Capture, CONF Resolution) | Kept as-is — doctrine-specific, outside the universal sprint lifecycle. |
| **Two-phase smoke-gated release** (pubspec bump first · QA-Verify on PR preview · `-web` tag) | `/release-*` kept intact (richer than cetana's model). |
| **2-tier CI + ≥19% coverage + Integration (Web) gate** | The required checks `/review-pr` reads. |
| **"green except the 4 known CloudKit macOS failures"** baseline | Executor steering. |

---

## 9. Migration PR sequence (all owner-merged; docs/config/scaffold only)

_Last verified: 2026-10-03_

| PR | Branch | Scope |
| :-- | :--- | :--- |
| **0** | `docs/process-migration-baseline` | **This document** — the anchor. |
| **1** | `docs/lifecycle-vocab-roles` | Rewrite `AI_COLLABORATION_FRAMEWORK.md` + `dev-workflow.md` + `collaboration-guardrails.md` to §3–§5 (roles, vocab, merge-first, state guards). |
| **2** | `chore/just-dx-surface` | `justfile` (from rbac template, Flutter block) + `scripts/` + mirror slash skills (§5). |
| **3** | `chore/kiro-spec-scaffold` | `.kiro/specs/` template with the §8 Tamil + CONF criteria baked into the EARS DoD. |
| **4** | `docs/executor-onboarding-status` | `ANTIGRAVITY_ONBOARDING.md` + Executor steering + root `STATUS.md` (§7) + tracker `git mv` to root (§6) + lockstep wiring. |

**Then:** the **golden-fixture CI correctness gate** — the first sprint run entirely on
the new rails (dogfood).

---

## 10. Guardrails honored by this migration

- All five PRs are docs/config/scaffold — **zero app-code risk**; each a reviewable PR the owner merges.
- Branches are `docs/*` / `chore/*` — `docs/*` is on the Vercel deny-list (zero deploy quota).
- Kiro (Operator) authors + reviews; **the owner is the sole merge & release authority**.
- No gate in the preserve-list (§8) is weakened; convergence happens only where it buys cross-project portability.

---

## Addendum — 2026-10-03: roles decoupled from tools (PR 5)

> **Last verified:** 2026-10-03 (v1.13.0-web).

PRs 1–4 encoded a two-role model that pinned tools into the role names ("Operator = Kiro",
"Executor = Antigravity") and recorded Google Jules as *retired*. The owner refined the model:
**roles are the stable abstraction; the tools that play them live in ONE mapping table.**

- **Roles (stable):** Operator · Executor · Human. The whole doctrine is written in these words.
- **Tool → role mapping (the single source — `collaboration-guardrails.md` §2):**

  | Role | Primary | Secondary / on-demand |
  | :--- | :--- | :--- |
  | Operator (orchestrator/coordinator) | **Kiro Crew** | Kiro Web |
  | Executor (build + verify) | **Antigravity IDE** | Kiro IDE; Kiro Web & Google Jules (special-case / autonomous runs) |

- **Kiro Crew** is now the primary Operator (orchestrator/coordinator) — it was absent before.
- **Google Jules** is **reinstated as an on-demand Executor** (special cases, scope TBD),
  superseding the earlier "retired, do not reopen" decision in `BACKLOG.md` (that record is
  **kept as history**, marked superseded — audit integrity). Its prior for-cause limits
  (hangs, SDK mismatch, no interactive visual QA) are retained as caveats on the mapping.
- **Why:** re-ranking or swapping a tool is now a one-line edit in §2, not a hunt across ~118
  mentions — so attention stays on the product, not on tooling. **Future convergence:** lift
  the §2 mapping block into the personal cetana control plane so every project shares it.

## Addendum — 2026-10-03: self-containment + framework retirement (PR 6)

> **Last verified:** 2026-10-03 (v1.13.0-web).

- **Self-containment is now the governing principle** (`collaboration-guardrails.md` §0):
  saranidhi vendors in the best firm/outside ideas and **owns the copy**; it never depends on
  an external repo (`../cetana-labs`, …) at runtime. cetana-labs & nexus-pulse are cited as
  **provenance / live proof**, not a dependency.
- **`AI_COLLABORATION_FRAMEWORK.md` retired** → a redirect stub. Its universal lifecycle was
  duplicated/stale against `dev-workflow.md` + guardrails; its saranidhi-only **Flows 1 & 2**
  (Knowledge Capture + CONF Resolution) were extracted to `docs/process/doctrine-flows.md`
  (owned here). The stub is kept (not `git rm`) so inbound links + audit trail survive.
- **Self-cleanup is a gate:** `just validate-docs` (→ `scripts/validate-docs.sh`) now **fails**
  on an external-repo pointer, and flags stale `Reviewed:` stamps + orphaned process docs.

---

[← Back to Root](../../README.md)
