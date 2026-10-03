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

---

## Entry 002 — Personal portfolio dashboard: where it lives, how it refreshes, how it's served

**Date:** 2026-10-03 · **Contributor(s):** Eialarasu (human-directed) · **Mode:** Operator (Kiro Crew) · **Outcome:** PR #282 (Saranidhi wiring); `~/my-works/portfolio` + `~/my-works/caddy` (personal tooling, not git-tracked yet)

### D1 — The portfolio generator lives in `~/my-works`, not inside any project repo
- **Trigger:** A cross-project dashboard needs to read every project's `STATUS.md`. Putting the generator inside Saranidhi would force Saranidhi to know sibling-repo paths — a self-containment violation (Entry 001 D5).
- **Options:** (a) generator inside Saranidhi reading sibling paths; (b) each repo refreshes only its own card; (c) generator in the shared `~/my-works` common area, triggered from each repo via a gitignored `_my_works` symlink so the call is a *relative in-repo path*.
- **Decision & rationale:** (c). The cross-repo concern lives in the one place that is legitimately cross-repo; each project stays self-contained — it only publishes its own `STATUS.md` contract and triggers "refresh" via `_my_works/portfolio/generate.py` (relative), while the generator (not the project) knows where the siblings are. Carries over unchanged when the personal cetana instance becomes the real home. _(Contributor: Eialarasu)_
- **Outcome:** `~/my-works/portfolio/{generate.py,projects.json}`; `_my_works` symlink gitignored in Saranidhi (PR #282).

### D2 — Dashboard refresh is event-driven (a `/sprint-done` step), not a timed cron
- **Trigger:** First instinct was a daily cron to refresh the dashboard. But `STATUS.md` only changes at discrete lifecycle events.
- **Decision & rationale:** The thing that mutates `STATUS.md` (`/sprint-done`, later `/release-update`) refreshes the view **in the same step**, so it can't go stale. A low-frequency cron is only a backstop for out-of-band manual edits, not the primary mechanism. _(Contributor: Eialarasu — matches the saved lesson on event-driven vs. timed view refresh.)_
- **Outcome:** PR #282 — `/sprint-done` step 4.5 (non-fatal if the symlink is absent).

### D3 — Serve locally with Caddy via a tiny registry-driven service manager
- **Trigger:** `python -m http.server` works but gives no path to protect/manage the site later.
- **Options:** keep the zero-dep python server; adopt Caddy with a per-site config; a small multi-service manager over Caddy.
- **Decision & rationale:** A 4-script manager (`start`/`stop`/`add`/`remove`) over Caddy driven by a `services.json` registry. Caddy's `basic_auth`, local HTTPS (`tls internal`), and `reverse_proxy` make "protect/manage later" one-directive upgrades (the future cetana backend reverse-proxies through the same registry). Bind pinned to `127.0.0.1`; `python` server kept as the zero-dep fallback. _(Contributor: Eialarasu)_
- **Outcome:** `~/my-works/caddy/` (manager + README).

### D4 — Local-first now; defer the iMac-hosted remote instance (Tailscale, never public exposure)
- **Trigger:** Idea to self-host the cetana runtime on the iMac for the rare "need it when away" case.
- **Decision & rationale:** Sequence, don't parallelize. The localhost site covers ~95% of use (owner is at the machine); a 24/7 remote-reachable service for a *rare* need is effort ahead of evidence. When built: **Tailscale** (private mesh, nothing exposed to the public internet) — never port-forwarding/public DNS; plus always-on (launchd) + bind cautions. Captured as a deferred note, not built. _(Contributor: Eialarasu — matches the saved lesson on Tailscale over public exposure for personal/local-first setups.)_
- **Outcome:** `~/my-works/caddy/cetana-self-hosting-notes.md` (deferred plan).

> **Session meta.** Division of labor: owner set every direction and gated every merge; Operator (Kiro Crew) built the `~/my-works` tooling and the Saranidhi wiring PR, never merged. Course-correction: the initial "daily refresh cron" was reconsidered to an event-driven lifecycle step before building (D2). Discovery: rbac-platform's `STATUS.md` (PRJ-002) landed mid-session, so the dashboard renders both projects. Scope discipline: a pre-existing untracked `ios/Podfile` with no gitignore rule was flagged, not silently committed or ignored (left for an owner decision).
