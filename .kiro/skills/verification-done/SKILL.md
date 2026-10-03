---
name: verification-done
description: >-
  Closes the human functional-verification loop for a Kiro Spec in Saranidhi (PRJ-001), the verify
  phase on the Executor (Antigravity). After the owner exercises the feature per the Spec's Human
  Verification Plan and any minor fixes are pushed to the SAME PR (Single-PR rule), this appends the
  verification record to .kiro/specs/<id>/REPORT.md, commits it to the same PR, and hands off to
  /review-pr. Use when the user runs /verification-done after verification passes.
---

# Skill: Verification Done (close the human-verify loop)

## Objective
Capture the outcome of **human functional verification** — where the owner exercises the feature
against the Spec's Human Verification Plan (§4b) and the Executor fixes any issues on the **same
open PR** until it passes. This records that loop into `.kiro/specs/<id>/REPORT.md` so the gate
(`/review-pr`) inherits the evidence instead of it evaporating in chat. Runs on the **Executor**.

### Where it sits
```
/spec-run → opens PR + emits Human Verification Plan → STOP
   ▼
IN VERIFICATION  ⇄  owner runs the plan; reports findings; Executor fixes on the SAME PR
   ▼
/verification-done → append Verification Log to REPORT.md (same PR) → ready for /review-pr
```

## Trigger Patterns
- `/verification-done`
- "verification passed, record it", "close the verification loop"

## Steps
### 1. State guard (phase-aware)
- **On the feature branch with an open PR, verification done ⇒ proceed.**
- **No open PR / not built (missing prerequisite) ⇒ ALERT + HOLD:** "Run `/spec-run <id>` first."
- **Plan steps unrun / still failing (missing gate) ⇒ ALERT + HOLD:** "Verification hasn't passed — steps N, M unrun/failing. Finish the loop first." Never record a pass that didn't happen.
- **Already recorded (redundant) ⇒ skip + continue:** "Verification already logged for PR #NN — proceed to `/review-pr`."

### 2. Gather the loop's outcome (honest)
- Reconstruct which §4b steps ran, pass/fail, findings, the fixes pushed (with fixup SHAs), and
  the final verdict. Record failures-then-fixes — a sanitized "all green" is worthless to the reviewer.
- Confirm **VT (Tamil mode)** was actually exercised.

### 3. Append the Verification Log to REPORT.md
- Target `.kiro/specs/<spec-id>/REPORT.md` (create it if absent). **Append** (never overwrite):
  ```markdown
  ### Verification Log — <YYYY-MM-DD> (PR #NN)
  | Plan step | Result | Finding / correction |
  | :--- | :---: | :--- |
  | V1 <step>      | ✅ / ❌→✅ | <what happened; fixup SHA> |
  | VT Tamil mode  | ✅        | pure Tamil script, no English leak |
  | VQ gates       | ✅        | just validate-local green; coverage ≥19%; integration green |
  - **Iterations:** <n> (fixups: <shas>)
  - **Verdict:** PASS — human functional verification complete.
  - **Verified by:** <name> · **Surface:** Executor (Antigravity)

  #### Evidence summary (the 4 questions — see requirements §4c), each tagged with build/config
  - **What am I accepting?** <capability + EARS criteria satisfied>
  - **What could it affect?** <blast radius; the §2 "unchanged" behaviors>
  - **Why believe it works?** <executable evidence: validate-local + golden-fixture (if calc) + V1../VT/VQ — each with the commit/preview it ran against>
  - **What remains unresolved?** <deferred/undemonstrated items, raised explicitly — never explained away>
  ```

### 4. Commit to the SAME PR (Single-PR rule)
```bash
git add .kiro/specs/<spec-id>/REPORT.md
git commit -m "docs(spec): verification log for <spec-id> (human-verify PASS)"
git push
```
- Optionally mirror a one-paragraph summary as a PR comment so the Operator's `/review-pr` surfaces it without a checkout.

### 5. Hand off
- Report: "Verification recorded in `REPORT.md` (PR #NN). Ready for the gate: `/review-pr <PR>` (Operator)."
- Do **not** merge, tag, or invoke the gate yourself — the owner authorizes at `/review-pr`.

## Rules
- **Record honestly** — findings + corrections, not a scrubbed pass. Never record a pass that didn't happen (§1).
- **Single-PR rule** — the log and all fixes ride the same open PR; never merge-then-hotfix.
- **Never merge, never tag**, never invoke `/review-pr` for the owner.
- **Append-only** to REPORT.md verification logs.
- **State-guard:** redundant ⇒ skip+continue; missing prerequisite/gate ⇒ alert+HOLD.
