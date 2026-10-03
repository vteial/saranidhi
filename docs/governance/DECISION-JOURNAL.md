<!-- Canonical path: ~/dev-home/personal/saranidhi/docs/governance/DECISION-JOURNAL.md · Last verified: 2026-10-03 (v1.13.0-web) -->
> **Reviewed:** v1.13.0-web

# Decision Journal — Saranidhi (`PRJ-001`)

> **Purpose.** This journal records *how* key decisions were reached — the problem, the
> options weighed, the trade-offs, and the rationale — not just what shipped. `CHANGELOG.md`
> records *what*; the Kiro Specs record the *formal contract*; this journal records the
> ***thinking***. Entries are curated (signal, not transcript) — written to be read later by
> a future maintainer (and the owner's personal cetana portfolio).
>
> **Method.** Human-directed, AI-assisted: the **Human owner** sets direction, weighs options,
> and gates every merge; the **Operator** executes, validates, and surfaces trade-offs. The
> human makes the calls. **Append-only** — never edit or delete prior entries.
>
> **Provenance.** Pattern vendored from the cetana-labs family (`docs/governance/DECISION-JOURNAL.md`)
> and rbac-platform (`docs/design/DECISION_JOURNAL.md`); saranidhi owns this copy. Written
> (prompted, never auto-run) at `/plan-done` via the `brainstorm-save` skill.

---

## Entry 001 — Dev-process adoption: converge Saranidhi onto the cetana-labs family

**Date:** 2026-10-03 · **Contributor(s):** Eialarasu (`vteial`, human-directed), AI-assisted (Operator) · **Mode:** Operator (Kiro Crew) · **Outcome:** PRs #269–#276 (migration baseline → role/vocab → `just` DX → Kiro Spec scaffold + skills → Executor onboarding + STATUS.md → role↔tool mapping → framework retirement → doc signpost)

> _Decisions D1–D7 below were made by the owner (human-directed); the Operator executed/validated._

The session that moved saranidhi from its own dialect of the firm process onto the shared
**cetana-labs family methodology**, so the owner carries one process across every personal
project and spends attention on product, not on re-learning process per repo.

### D1 — Adopt the cetana-labs family vocabulary + roles wholesale (not just principles)
- **Trigger:** Jumping between projects cost context re-learning the dev process each time.
- **Options:** (A) keep saranidhi's command names, adopt only principles; (B) full parity — vocabulary + Spec-driven model.
- **Decision & rationale:** **(B).** Identical commands *and* locations across repos are the muscle-memory payoff; cetana already paid the design cost of translating nexus-pulse's discipline into a Kiro-native, Spec-driven form. _(Contributor: Eialarasu)_
- **Outcome:** PRs #269–#272 — `PROCESS_MIGRATION.md`, lifecycle vocab, `.kiro/specs/` + `.kiro/skills/`.

### D2 — `just` as the firm toolchain standard (over cetana's `make`)
- **Trigger:** cetana uses `make` only because adapted from older nexus-pulse; rbac-platform (newest) uses `just`, and `~/my-works/PERSONAL_MACHINE_GUIDE.md` standardizes Homebrew `just 1.58.0`.
- **Decision & rationale:** **`just`** — aligns with the machine doctrine; converge, don't inherit the legacy. _(Contributor: Eialarasu)_
- **Outcome:** PR #271 — `justfile` + `scripts/` + mirror skills.

### D3 — Portfolio ID `PRJ-001`; root `STATUS.md` as the dashboard integration contract
- **Trigger:** A personal cetana-labs instance will render all projects' state.
- **Decision & rationale:** saranidhi = **PRJ-001** (first personal project); root `STATUS.md` in cetana's exact 35-line schema so the portfolio scraper parses it. _(Contributor: Eialarasu)_
- **Outcome:** PR #273 — root `STATUS.md`, tracker `git mv` to root `SPRINT_TRACKER.md`/`BACKLOG.md`.

### D4 — Roles are stable; tools live in ONE mapping table
- **Trigger:** The initial two-role encoding pinned tools into role names and had retired Jules.
- **Decision & rationale:** Write doctrine in **roles** (Operator/Executor/Human); a single tool→role table (Operator primary = **Kiro Crew**; Executor primary = **Antigravity IDE**; Kiro Web + Jules on-demand) so re-ranking a tool is a one-line edit. Jules **reinstated** as on-demand. _(Contributor: Eialarasu)_
- **Outcome:** PR #274 — `collaboration-guardrails.md` §2.

### D5 — Saranidhi is self-contained (vendor-in, don't link)
- **Trigger:** Risk of making cetana-labs a runtime dependency.
- **Decision & rationale:** Adapt the best firm/outside ideas but **vendor them in and own the copy**; cite the source as provenance only; never depend on an external repo at runtime. `validate-docs` fails on external pointers so this is a gate, not an intention. _(Contributor: Eialarasu)_
- **Outcome:** PR #275 — guardrails §0, framework retired to a stub, `scripts/validate-docs.sh`.

### D6 — Verification-first; golden-fixture gate is the real next step
- **Trigger:** The ReqProof "Software Verification Engineer" article (2026-09) — when agents write code+tests, review intent/evidence, not lines; rules must be executable and un-explain-away-able.
- **Decision & rationale:** saranidhi's calc-correctness has no executable truth gate (coverage % only). A **golden-fixture reconcile** (frozen known-correct outputs, fail-closed) converts the prose DoD into a path-independent executable check. Verification evidence adopts the article's **4 questions**. _(Contributor: Eialarasu)_
- **Outcome:** PR #277 (this governance PR — 4-question evidence in the Spec template); the golden-fixture **Kiro Spec** follows (merge-first).

### D7 — Vendor the Decision Journal in
- **Trigger:** cetana + rbac both keep a Decision Journal; saranidhi had none — the "why" behind decisions was evaporating into chat.
- **Decision & rationale:** Add `docs/governance/DECISION-JOURNAL.md` (append-only, curated, attributed) + a `brainstorm-save` skill prompted at `/plan-done`. This Entry 001 is its own first entry. _(Contributor: Eialarasu)_
- **Outcome:** This file + `.kiro/skills/brainstorm-save/`.

> **Session meta.** Division of labor: owner set every direction + will gate every merge; Operator (Kiro Crew) authored all PRs and never merged. Course-correction: the "archive historical docs" ask was reconsidered to signposting after finding releases/sprints are live-linked (PR #276). Honest note: two safety-policy blocks (an `rm -rf`, a brace-fused `git push`) were hit and routed around correctly, not bypassed.
