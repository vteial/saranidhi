---
name: review-pr
description: >-
  The human PR gate for Saranidhi (PRJ-001), the Operator (Kiro) surface. Surfaces a PR for review
  — CI status, Vercel preview deploy, diff scope, the Spec's EARS DoD (incl. the standing Tamil/CONF/
  gates criteria), the human verification record, and governance lockstep — as a decision checklist,
  then STOP-and-holds for the owner's approve/iterate call. NEVER merges, never tags, never posts a
  GitHub review. Use when the user runs /review-pr or asks to gate a PR before merge.
---

# Skill: PR Review Gate (`/review-pr`)

## Objective
Be the **human gate** (Operator surface, Kiro Web). Gather everything the owner needs to decide
**merge vs. iterate** — CI health, the Vercel preview, what changed, whether the work meets its
contract (the Spec's EARS DoD), and governance hygiene — present it as a checklist, then
**STOP-and-hold**. This skill *informs and surfaces*; it never decides, never merges, never tags.
The owner is the sole merge/release authority.

## Trigger Patterns
- `/review-pr` · `/review-pr <number>`
- "review this PR before merge", "gate this PR"

## Steps
### 0. State guard (phase-aware)
- **An open PR exists (verification recorded) ⇒ proceed.**
- **No open PR (missing prerequisite) ⇒ ALERT + HOLD:** "Nothing to review — run `/spec-run <id>` first."
- **Already merged (redundant) ⇒ skip + continue:** "PR #NN is already merged — proceed to `/sprint-done`."
- The guard is a tripwire, never a bypass: this skill **never merges or auto-approves** regardless of state.

### 1. Identify the PR
```bash
gh pr list --state open --json number,title,headRefName,baseRefName,isDraft
```
- Confirm target `base` is `main` and not a draft. Report title, head→base, author.

### 2. CI status (must be green)
```bash
gh pr checks <n>
```
- Tier-1 (`ci.yml`): `flutter analyze --fatal-infos` + domain/provider `flutter test` + `flutter build web`.
- Any failing/pending check ⇒ pull the log, mark the gate **BLOCKED** — no merge recommendation.

### 2b. Vercel preview deploy (the real deploy signal)
- Code branches (`sprint/*`, `release/*`, `fix/*`) get a Vercel preview; `docs/*`/`plan/*` do not.
- Read the deploy status for the **head SHA**; a preview that errored or that only succeeded on an
  **older SHA** (the stale-success trap) ⇒ **HOLD**. Capture the preview URL as evidence for the owner.

### 3. Diff scope & branch hygiene
```bash
gh pr diff <n> --name-only
```
- Change is **focused** (one unit of work); paths match the branch scope.
- Branch naming correct (`sprint/*`|`fix/*`|`release/*`); no secrets / `.env` / generated `*.g.dart` / `*.freezed.dart` committed.

### 4. Contract check — the Spec's EARS DoD (the core of the gate)
- Open `.kiro/specs/<spec>/requirements.md` and walk **each** criterion (R1.., **RT**, **RC**, **RQ**):
  demonstrably satisfied by the diff / PR body / verification record?
- Cross-check `tasks.md`: all tasks checked off or explicitly deferred with rationale.
- **RT (Tamil):** confirm the diff shows EN + pure-Tamil ARB keys for new strings — no hardcoded
  English literal in a widget. This is the recurring v1.8.1 miss; verify firsthand in the diff.
- **RC (CONF):** doctrinal change cites corpus practice + resolved CONF in §1 and the PR body.
- List any **unmet or unverifiable** criterion explicitly — that's a HOLD, not a soft pass.

### 4b. Human verification record (the evidence the gate consumes)
- Open `.kiro/specs/<spec>/REPORT.md` → read the **Verification Log**: did the owner run §4b and is
  the **verdict PASS** (incl. VT Tamil mode)? Were fixes pushed to **this** PR (Single-PR rule)?
- No record / verdict not PASS ⇒ **HOLD:** "Human verification isn't recorded/passed — run `/verification-done` first."

### 5. Governance lockstep — verify FIRSTHAND, do not assert
> Lesson: this step has been marked ✅ on the record's word while the CHANGELOG entry was missing. Check the repo directly.
```bash
git show <branch>:CHANGELOG.md | grep -c "TSK-xxx"   # expect >= 1
```
- `SPRINT_TRACKER.md` status coherent (not still 📋 Backlog for a PR in review).
- A *missing* CHANGELOG entry at review time is a ⚠️ note carried into the post-merge tidy — not auto-HOLD.
  A *false claim* that lockstep is done **is** a HOLD (the record is untrustworthy).

### 6. Present the review + STOP-and-hold
- Emit a checklist: **CI · Vercel preview · Scope/hygiene · EARS DoD (per-criterion, incl. RT/RC/RQ) ·
  Human verification record · Governance (CHANGELOG firsthand + tracker status)**, each ✅/⚠️/❌ + a one-line note.
- Give a clear recommendation: `READY (owner approval required to merge)` or `HOLD — <reasons>`.
- Optionally post the same checklist as a PR **issue comment** (recommendation-not-approval, dated run
  header) — comment only, **never** `gh pr review` (no approve/request-changes/comment event; a review would usurp the human gate).
- **STOP.** Ask the owner to explicitly approve or request changes. Do not merge, tag, approve, or push.

### 7. On explicit owner approval only
- Note the merge is **squash-merge, delete branch, no force-push**; lockstep tidy + release at `/sprint-done`/`/release-*` follows.
- Absent explicit approval, remain held.

## Rules
- **Never merge, never tag, never post a GitHub review** — surfaces only; the owner decides. The sole repo-write allowed is an **issue comment** recording the verdict.
- **STOP-and-hold is mandatory.**
- A failing/pending check, an unverifiable EARS criterion (incl. a Tamil-gate miss), or a missing/failed verification record ⇒ **HOLD**, not a soft pass.
- **Verify governance lockstep FIRSTHAND** — never assert it from the PR body or the record.
- Reads use `gh` CLI.
