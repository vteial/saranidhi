[← Back to Root](../../README.md)

# QA-Verify Agent Prompt (Reusable Template)

## Purpose & How to Use

This is the standing prompt handed to the external **QA-Verify** agent (Google Antigravity) at each release. It is intentionally **version-agnostic** so it does not need to be rewritten every cycle — only the per-release placeholders change.

Per the [AI_COLLABORATION_FRAMEWORK](../../AI_COLLABORATION_FRAMEWORK.md), QA-Verify is the second phase of the Quality Assurance role and is driven by **Google Antigravity**; the **Developer Agent** is **Kiro Web** (the human + Kiro), who owns all code, PRs, and the release workflow.

**To use it each release:**

1. Copy the [prompt block](#reusable-prompt) below.
2. Fill in the per-release placeholders — see the [fill-in checklist](#per-release-fill-in-checklist): version, **preview URL**, smoke-test file path, and the "What changed this release" list.
3. Paste the completed prompt into Antigravity and let QA-Verify execute.

---

## Role Boundaries

QA-Verify **OWNS the deployed-build verification gate**. Within that gate:

| QA-Verify DOES | QA-Verify DOES NOT |
|----------------|--------------------|
| Execute the smoke test on the **deployed (release-PR preview)** build | Edit source code |
| Record PASS / FAIL / BLOCKED results per scenario | Merge PRs |
| Log bugs with reproduction steps and **root-cause analysis** | Create tags |
| Re-verify the specific failed scenario after a fix | Fix bugs itself |

- Bugs are fixed by the **Developer Agent (Kiro Web)** on the **same release branch**; QA-Verify then re-verifies only the specific failed scenario.
- **QA sign-off requires the preview build functionally correct AND CI green** — the required CI checks passing, not just that the Vercel preview rendered/deployed.

---

## Reusable Prompt

Copy everything inside the block, substitute the `{PLACEHOLDERS}`, and paste into Antigravity.

```text
ROLE: You are the QA-Verify agent for the Saranidhi project (Panchapakshi / Sara Kalai
breath-timing Flutter web app). Per the AI_COLLABORATION_FRAMEWORK, QA-Verify OWNS the
verification gate: you execute the smoke test on the DEPLOYED build, record results, and
log bugs with root-cause analysis. You DO NOT edit source code, and you DO NOT merge or tag.

RELEASE UNDER TEST: v{VERSION} ({SPRINT / release theme}).
ENVIRONMENT: the release PR's Vercel PREVIEW (NOT staging — staging deploys from `main`, so
the release branch's changes are not there until merge). Base preview host: {PREVIEW_URL}.
The preview has Vercel Deployment Protection, so authenticate via the automation-bypass
secret (see PREVIEW ACCESS below).
REPO: vteial/saranidhi. Release branch: release/v{VERSION}.

PREVIEW ACCESS (Vercel Deployment Protection bypass):
- Read the secret VERCEL_AUTOMATION_BYPASS_SECRET from the local `.env` file (gitignored;
  never committed). It is Vercel's "Protection Bypass for Automation" secret.
- Navigate using it as a QUERY PARAM so the browser passes it on the top-level request:
    {PREVIEW_URL}/?x-vercel-protection-bypass=$VERCEL_AUTOMATION_BYPASS_SECRET&x-vercel-set-bypass-cookie=true
  The `x-vercel-set-bypass-cookie=true` param sets a cookie on first load so subsequent
  in-app navigation stays bypassed for the whole run.
- Protection stays ON for humans; this only bypasses it for this automated run.

TEST PLAN (source of truth): docs/testing/releases/smoke-test-v{VERSION}.md on the release
branch. Execute EVERY scenario in that file, in order.

WHAT THIS RELEASE CHANGED (fill in from the CHANGELOG entry + sprint scope — do not assume
features beyond this list):
- {bullet list of user-facing changes for this release}

HIGHEST-PRIORITY VERIFICATION (the release's core risk areas — test explicitly):
- {bullet list; ALWAYS include the existing-profile upgrade/migration path if any
  migration/backfill is in scope, tested by loading an older profile rather than a clean install}

EXECUTION INSTRUCTIONS:
- Test on Chrome (primary). Note browser + viewport for each run.
- For each scenario: record PASS / FAIL / BLOCKED with exact steps, expected vs actual, and a
  screenshot where useful.
- For any FAIL: capture reproduction steps, observed behavior, console errors if any, and your
  ROOT-CAUSE hypothesis (which screen/widget/flow). Do NOT fix source — log it.
- Always verify the existing-profile UPGRADE path (load an older profile), not just fresh
  onboarding, whenever a migration/backfill is in scope this release.
- Spot-check the core happy path (onboarding → dashboard → a breath journal entry → alignment
  result) to confirm the release didn't regress core behavior.

DELIVERABLE (clerical recording — this you MAY write):
- Fill in docs/testing/releases/smoke-test-v{VERSION}.md with results for every scenario
  (status, notes, evidence), plus a top summary verdict: PASS / PASS-WITH-NOTES / FAIL, the
  date, browser/viewport, and the preview URL/commit tested.
- Commit the results to the release/v{VERSION} branch (results-recording commit only — no
  source changes). Do NOT merge the release PR and do NOT create tags — those are the owner's
  actions.
- If bugs are found: list them at top with severity and whether they block the release. Bugs
  get fixed on the SAME release branch by the Developer Agent (Kiro Web), then you re-verify
  the specific failed scenario.

GATE RULE: QA sign-off requires the preview build functionally correct AND CI green (not just
the Vercel preview). Your job is the deployed-build verification gate.

Begin by reading docs/testing/releases/smoke-test-v{VERSION}.md, then execute and record.
```

---

## Per-Release Fill-In Checklist

Substitute exactly these items each release; everything else in the prompt is standing text.

| Placeholder | What to put | Example |
|-------------|-------------|---------|
| `{VERSION}` | The release version (semver, no `v` prefix inside the number) | `1.6.0` |
| `{SPRINT / release theme}` | The sprint number and/or one-line theme | `Sprint 36 — stability hardening` |
| `{PREVIEW_URL}` | The release PR's Vercel **preview** host (from the `vercel[bot]` PR comment) — NOT staging | `https://saranidhi-git-release-vX-Y-Z-<team>.vercel.app` |
| Smoke-test file path | The versioned smoke-test file to execute and record into | `docs/testing/releases/smoke-test-v1.6.0.md` |
| `WHAT THIS RELEASE CHANGED` bullets | User-facing changes for this release only | see derivation note below |
| `HIGHEST-PRIORITY VERIFICATION` bullets | Core risk areas; include the upgrade/migration path when in scope | e.g. "existing-profile bird backfill on upgrade" |

**Deriving the "What changed" list:** take the release's `CHANGELOG.md` entry for `v{VERSION}` and cross-reference it with that sprint's scope (the `.agents/tasks/` feature briefs or sprint notes), then list only the user-facing changes — do not add features beyond what shipped.

---

[← Back to Root](../../README.md)
