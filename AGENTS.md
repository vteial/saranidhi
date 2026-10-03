# Repository Agent Guidelines — Saranidhi (PRJ-001)

> **Canonical path:** `~/dev-home/personal/saranidhi/AGENTS.md`
> **Who reads this:** agents that look for a root `AGENTS.md` / `GEMINI.md`
> (Antigravity, and other tools that honour the convention). Kiro agents read
> `.kiro/steering/*` instead — the same rules live there.
> **Last verified:** 2026-10-03.
>
> This file is the SHORT must-obey summary. The authoritative detail lives in:
> - Process / authority / roles → [`.kiro/steering/collaboration-guardrails.md`](.kiro/steering/collaboration-guardrails.md)
> - Executor contract (`/spec-run`) → [`.kiro/steering/executor-antigravity.md`](.kiro/steering/executor-antigravity.md)
> - Code / architecture rules → [`.kiro/steering/saranidhi-spec.md`](.kiro/steering/saranidhi-spec.md)
> - Test-authoring rules → [`.kiro/steering/test-authoring.md`](.kiro/steering/test-authoring.md)
> - Full onboarding → [`ANTIGRAVITY_ONBOARDING.md`](ANTIGRAVITY_ONBOARDING.md)
>
> The four rules below mirror the owner's cross-project discipline in
> `~/.kiro/steering/agent-discipline.md`. Where this file and a `.kiro/steering/`
> file disagree, the steering file wins — it is the project's source of truth.

---

## The non-negotiables (authority)

- **The Human owner is the SOLE merge & release authority.** Never run `git merge`,
  never push to `main`/`prod`, never create tags or GitHub Releases. Push feature
  branches and **open PRs** only. (Full rule: `collaboration-guardrails.md` §1.)

## The four load-bearing rules

1. **Every non-trivial prompt is a spec, not a chat message (ICCV).** State
   **Intent** (one sentence of "done"), **Context** (govern-by-`@path`, never paste
   walls of code), **Constraints** (what must NOT break), **Verification** (the
   literal command/test that proves done). If an anchor is missing, state the
   assumption rather than guessing.

2. **Work is atomic.** One feature / sub-system per task. For schema / core-interface
   / breaking-API changes, produce a plan FIRST and get it approved — no
   "code first, think later".

3. **Verify before declaring done.** "Done" means the named test/command passed —
   never visual plausibility. On this repo that means the EARS DoD: `just
   validate-local` green **except the 4 known CloudKit macOS failures**, coverage
   **≥ 19%**, integration gate green, Tamil (RT) + CONF (RC) standing criteria met.
   (Full contract: `executor-antigravity.md`.)

4. **Scope is a hard boundary; flag, don't fold.** Touch only files in the Spec's
   scope; the "Out of Scope" list is binding. If a scoped task surfaces an unrelated
   pre-existing bug, FLAG it to the owner as a separate finding — do not silently
   fold an out-of-scope change into the same edit/PR.
