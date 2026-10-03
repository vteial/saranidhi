---
name: sprint-done
description: >-
  Closes out an active sprint in Saranidhi (PRJ-001), the Record phase on the Operator surface
  (Kiro Web). Archives completed tasks in root SPRINT_TRACKER.md, moves [Unreleased] CHANGELOG items,
  synchronizes STATUS.md wins + focus, and opens the closeout as an owner-merged docs PR. Pairs with
  /sprint-start. Use when the user runs /sprint-done or asks to wrap up the sprint.
---

# Skill: Sprint Closeout (`/sprint-done`)

## Objective
Close a sprint whose work has been **verified and merged**: archive completed items, update the
historical CHANGELOG, synchronize `STATUS.md`, and open the closeout as a docs PR the **owner
merges**. Runs on the **Operator** (Kiro Web). The counterpart to `/sprint-start`.

## Trigger Patterns
- `/sprint-done` · `/sprint-done <SPRINT-NN>` · "close out the current sprint", "wrap up the sprint"

## Steps
### 0. State guard (phase-aware)
- **Any sprint item still in review (open, unmerged PR) ⇒ ALERT + HOLD:** "PR #NN for `<task>` is still open — closing now would record undelivered work. Merge via `/review-pr` first, or confirm a carry-forward."
- **Items `✅ Done` with merged PRs ⇒ proceed.**
- **No active sprint / already closed (redundant) ⇒ skip + continue.**
- Never mark a sprint delivered for work that isn't merged to `main`.

### 1. Inspect root `SPRINT_TRACKER.md`
- Read the Current Sprint; identify `✅ Done` items and any carry-forwards (🔨/🔍/👀/📋).

### 2. Archive the sprint
- Move the finished sprint into the **Delivered Sprints Archive**. Seed the next sprint block (increment id, next window). Carry forward incomplete items.
- **Leave historical checkboxes with their original command names** — don't rewrite past audit history.

### 3. Update `CHANGELOG.md`
- Move `[Unreleased]` items under the sprint's entry; reset `[Unreleased]` with empty categories. (A version bump + tag is a `/release-*` step, not here.)

### 4. Synchronize `STATUS.md` (PRJ-001)
- Update root `STATUS.md`: `Last Updated` = today; `Latest Deliveries & Business Wins` = the closed sprint's achievements; `Current Focus & Next Milestone` = the newly planned goal. Keep the cetana 35-line schema.

### 5. Validate & open the closeout PR
```bash
just validate-docs
git checkout -b docs/closeout-<SPRINT-NN>
git add SPRINT_TRACKER.md CHANGELOG.md STATUS.md
git commit -m "docs(governance): closeout <SPRINT-NN>"
git push -u origin docs/closeout-<SPRINT-NN>
gh pr create --base main --head docs/closeout-<SPRINT-NN> --title "docs(governance): closeout <SPRINT-NN>" --body "<summary>"
```
- `docs/*` branch → **no Vercel deploy**. The **owner merges**.

## Rules
- **Operator / Kiro Web only** — closeout is docs; Operator never merges or tags.
- **Never mark undelivered work as done** — an open PR for a sprint item ⇒ HOLD.
- Keep `SPRINT_TRACKER.md` + `CHANGELOG.md` + `STATUS.md` in lockstep.
- STATUS.md edits here feed the owner's personal cetana portfolio dashboard (PRJ-001 row).
- **State-guard:** redundant ⇒ skip+continue; unmerged-item gate ⇒ alert+HOLD.
