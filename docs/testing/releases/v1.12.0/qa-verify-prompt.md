[← Back to Smoke Test](./smoke-test.md)

# QA-Verify Prompt — v1.12.0-web (filled, transactional)

> Per-release filled copy of the reusable
> [`qa-verify-agent-prompt.md`](../../qa-verify-agent-prompt.md). Paste the block below into
> Antigravity; the owner's message is a one-liner pointing here.
>
> **Preview URL (filled):** `https://saranidhi-git-release-v1120-eialarasus-projects.vercel.app/`
> (branch `release/v1.12.0` → slug `release-v1120`). Release PR: **#239**.
>
> **Note — split responsibility:** the genuine **cross-device merge** scenarios (4, 5, 9) are best
> run by the **owner on real devices** (iPad Mini + iPhone SE). Antigravity covers what it can on
> the preview (migration/upgrade check via seeded state, Practice ID display, owner-guard refusal
> via a hand-edited file, Restore, Tamil, regression) and records; owner confirms the true
> cross-device flow.

---

## Paste-into-Antigravity prompt

```text
ROLE: You are the QA-Verify agent for the Saranidhi project (Panchapakshi / Sara Kalai
breath-timing Flutter web app). Per the AI_COLLABORATION_FRAMEWORK, QA-Verify OWNS the
verification gate: execute the smoke test on the DEPLOYED build, record results, log bugs with
root-cause analysis. You DO NOT edit source, and you DO NOT merge or tag.

RELEASE UNDER TEST: v1.12.0 (Sprint 44 — Practice Sync Phase 0: owner-stamped safe merge-import).
This adds a Practice ID (schema v6→v7 migration) + a non-destructive MERGE import (union by UUID)
guarded by owner identity, replacing the old destructive import. Local-first, zero backend, no account.

ENVIRONMENT: the release PR's Vercel PREVIEW (NOT staging). Read VERCEL_AUTOMATION_BYPASS_SECRET
from the local `.env` and pass it as a query param on the preview URL:
  https://saranidhi-git-release-v1120-eialarasus-projects.vercel.app/?x-vercel-protection-bypass=$VERCEL_AUTOMATION_BYPASS_SECRET&x-vercel-set-bypass-cookie=true
REPO: vteial/saranidhi. Release branch: release/v1.12.0. PR: #239.

STEP 0 — PRE-FLIGHT READINESS GATE (MANDATORY — run BEFORE any scenario):
Confirm ALL; if ANY fails, STOP, run NO scenarios, report (see ABORT PROTOCOL). No workarounds.
  [ ] 1. PREVIEW REACHABLE — bypass URL loads the Saranidhi shell (HTTP 200; not 404 /
         DEPLOYMENT_NOT_FOUND / SSO wall / "not available").
  [ ] 2. CORRECT BUILD — Settings → About reads EXACTLY "Saranidhi v1.12.0 (1)". Else ABORT.
  [ ] 3. BYPASS SECRET present in `.env`; cookie set (no SSO wall on navigation). Else ABORT.
  [ ] 4. CI GREEN on PR #239 (Analyze/Fast Tests/Build + Full Test Suite + Coverage;
         Integration Tests (Web) known-flaky/non-blocking).
  [ ] 5. SMOKE-TEST FILE present: docs/testing/releases/v1.12.0/smoke-test.md.
On pass, write "PRE-FLIGHT: READY (About=v1.12.0, preview OK, CI green)" and PROCEED.

ABSOLUTE NO-FALLBACK RULE: Test the PR #239 Vercel PREVIEW and NOTHING ELSE. FORBIDDEN to fall
back to staging, production, a local dev server, or any other URL. Unavailable/wrong preview = a
BLOCKER to report, never a cue to switch environments.

ABORT PROTOCOL (Step 0 fails, or preview drops mid-run): STOP; write a top-of-file BLOCKED verdict
in the smoke-test file (failed check, URL tried, About version seen, HTTP/error, root-cause guess);
commit to release/v1.12.0; hand back to Kiro Web; re-run Step 0 when told ready. Mid-run drop →
mark remaining scenarios BLOCKED (not FAIL), STOP.

TEST PLAN (source of truth): docs/testing/releases/v1.12.0/smoke-test.md. Execute EVERY scenario.

WHAT THIS RELEASE CHANGED (do not assume beyond this):
- New "Practice ID" (ownerId) per install — shown in Settings, copyable. Backfilled onto existing
  profiles by a guarded schema v6→v7 migration (no data loss).
- Export now stamps the Practice ID + version (schema 7 / exportVersion 2).
- Import is now TWO explicit paths: (a) MERGE (default, non-destructive union by UUID across
  journal + breath-sessions + prasanam + somatic + birds; idempotent; never deletes), and
  (b) RESTORE (overwrite everything — the old destructive behavior, relabeled + confirm-gated).
- OWNER GUARD on merge: same Practice ID → merges; DIFFERENT Practice ID → REFUSED (0 DB changes);
  empty local profile → adopts the file's Practice ID; legacy file with no Practice ID → warn +
  explicit confirm.
- Everything else unchanged. No network, no account, no telemetry.

WHAT YOU (Antigravity) CAN VERIFY ON THE PREVIEW (owner runs the true cross-device flow separately):
- Scenario 2 (Practice ID visible + copyable), 3 (export carries it), 6 (owner-guard REFUSES a
  hand-edited different-Practice-ID file — assert 0 data change), 7 (legacy no-ID file warns),
  8 (Restore overwrite distinct + works), 10 (Tamil), regression + version.
- Scenario 1 (migration/upgrade): if you can seed a pre-v7 state, verify Practice ID appears with
  no data loss; else verify via the migration unit tests + note how verified.
- Scenarios 4, 5, 9 (real cross-device merge + aggregate + new-device adoption): mark
  "OWNER-VERIFIED (real devices)" — coordinate; do not fake a pass.

HIGHEST-PRIORITY: owner-guard REFUSAL makes 0 DB mutations (the safety core); Merge is
non-destructive + idempotent; Restore is clearly distinct from Merge; migration preserves data;
Tamil for all new copy; About = v1.12.0.

EXECUTION: Chrome; desktop + 390px; toggle EN/TA. Per scenario PASS/FAIL/BLOCKED + steps +
expected/actual + screenshot + HOW verified (live / seeded / test-evidence / owner-device). FAIL →
repro + console + root-cause; do NOT fix source.

DELIVERABLE: fill docs/testing/releases/v1.12.0/smoke-test.md (per-scenario + top Result block);
commit to release/v1.12.0 (results only, no source); do NOT merge/tag. Bugs → top list w/ severity;
fixes by Kiro Web on the same branch, then re-verify.

GATE RULE: sign-off requires the preview functionally correct AND CI green.

Begin with STEP 0. Only if all pass, read the smoke-test file and execute + record. If any
pre-flight check fails, follow the ABORT PROTOCOL and stop.
```

---

## Fill-in record

| Placeholder | Value |
|-------------|-------|
| `{VERSION}` | `1.12.0` |
| `{SPRINT / theme}` | Sprint 44 — Practice Sync Phase 0 (safe merge-import) |
| Environment | release PR's Vercel **preview** `https://saranidhi-git-release-v1120-eialarasus-projects.vercel.app` (slug `release-v1120`) |
| Smoke-test file | `docs/testing/releases/v1.12.0/smoke-test.md` |
| Highest-priority | owner-guard 0-mutation refusal, non-destructive idempotent merge, Restore distinct, migration data-safety, Tamil; **cross-device flow = owner-verified on real devices** |
| Release PR # | **#239** |
