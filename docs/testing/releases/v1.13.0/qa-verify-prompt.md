[← Back to Smoke Test](./smoke-test.md)

# QA-Verify Prompt — v1.13.0-web (filled, transactional)

> Per-release filled copy of the reusable
> [`qa-verify-agent-prompt.md`](../../qa-verify-agent-prompt.md). Paste the block below into
> Antigravity; the owner's message is a one-liner pointing here.
>
> **Preview URL (filled):** `https://saranidhi-git-release-v1130-eialarasus-projects.vercel.app/`
> (branch `release/v1.13.0` → slug `release-v1130`). Release PR: **#265**.
>
> **⚠️ New this release — a LIVE backend is part of the gate.** Unlike prior web releases, v1.13.0's
> sync scenarios hit a real network backend (**PocketBase on Fly**, `https://saranidhi-pb.fly.dev`).
> The preview build is compiled with `--dart-define=POCKETBASE_URL=https://saranidhi-pb.fly.dev`
> (via `scripts/vercel_build.sh`), so Sync in the preview points at the live instance. You'll need
> the **PocketBase test-user** email + passphrase to run S2–S5.

---

## Paste-into-Antigravity prompt

```text
ROLE: You are the QA-Verify agent for the Saranidhi project (Panchapakshi / Sara Kalai
breath-timing Flutter web app). QA-Verify OWNS the verification gate: execute the smoke test on the
DEPLOYED build, record results, log bugs with root-cause analysis. You DO NOT edit source, and you
DO NOT merge or tag.

RELEASE UNDER TEST: v1.13.0 (Sprint 47 — ★ Practice Sync Phase 1). Adds OPT-IN on-demand
cross-device sync (default OFF) of breath sessions + journal to a self-hosted PocketBase backend,
via pull → union-merge → push. Owner-guard on both server (PocketBase rule ownerId = auth id) and
client. Offline-first fully preserved. No local schema change.

ENVIRONMENT: the release PR's Vercel PREVIEW (NOT staging). Read VERCEL_AUTOMATION_BYPASS_SECRET
from the local `.env` and pass it on the preview URL:
  https://saranidhi-git-release-v1130-eialarasus-projects.vercel.app/?x-vercel-protection-bypass=$VERCEL_AUTOMATION_BYPASS_SECRET&x-vercel-set-bypass-cookie=true
The preview is built with --dart-define=POCKETBASE_URL=https://saranidhi-pb.fly.dev, so Sync points
at the LIVE PocketBase backend. You need the PocketBase TEST-USER credentials (ask the owner) for
sign-in scenarios.
REPO: vteial/saranidhi. Release branch: release/v1.13.0. PR: #265.

STEP 0 — PRE-FLIGHT READINESS GATE (MANDATORY — run BEFORE any scenario):
Confirm ALL; if ANY fails, STOP, run NO scenarios, report (see ABORT PROTOCOL). No workarounds.
  [ ] 1. PREVIEW REACHABLE — bypass URL loads the Saranidhi shell (HTTP 200; not 404 /
         DEPLOYMENT_NOT_FOUND / SSO wall / "not available").
  [ ] 2. CORRECT BUILD — Settings → About reads EXACTLY "Saranidhi v1.13.0 (1)". Else ABORT.
  [ ] 3. BYPASS SECRET present in `.env`; cookie set (no SSO wall on navigation). Else ABORT.
  [ ] 4. CI GREEN on the release PR (Analyze/Fast Tests/Build + Full Test Suite + Coverage;
         Integration Tests (Web) known-flaky/non-blocking).
  [ ] 5. BACKEND REACHABLE — `curl https://saranidhi-pb.fly.dev/api/health` returns {"code":200,...}
         (first hit may cold-start ~1–2s). Else the sync scenarios are BLOCKED — report.
  [ ] 6. SMOKE-TEST FILE present: docs/testing/releases/v1.13.0/smoke-test.md.
On pass, write "PRE-FLIGHT: READY (About=v1.13.0, preview OK, CI green, backend 200)" and PROCEED.

ABSOLUTE NO-FALLBACK RULE: Test the release PR's Vercel PREVIEW and NOTHING ELSE. FORBIDDEN to fall
back to staging, production, a local dev server, or any other URL. Unavailable/wrong preview = a
BLOCKER to report, never a cue to switch environments.

ABORT PROTOCOL (Step 0 fails, or preview/backend drops mid-run): STOP; write a top-of-file BLOCKED
verdict in the smoke-test file (failed check, URL tried, About version seen, HTTP/error, root-cause
guess); commit to release/v1.13.0; hand back to Kiro Web; re-run Step 0 when told ready. Mid-run
drop → mark remaining scenarios BLOCKED (not FAIL), STOP.

TEST PLAN (source of truth): docs/testing/releases/v1.13.0/smoke-test.md. Execute EVERY scenario
(S1–S8).

HIGHEST-PRIORITY: S3 — the CROSS-DEVICE SYNC ROUND-TRIP (device/window A pushes → B pulls → both
sets merged, idempotent on re-sync). Then S1 (opt-in OFF = zero network), S2 (sign in), S5
(owner-guard: no cross-owner data), S6 (offline-first preserved: toggle-off & backend-unreachable
both degrade gracefully with no data loss), S4 (scope checkboxes), S7 (Tamil), S8 (local regression).
NOTE the North-Star-adjacent safety points: sync is OPT-IN default-OFF, ADDITIVE (never deletes),
and must NEVER lose local data on a network error.

EXECUTION: Chrome; desktop + 390px; toggle EN/TA. For the cross-device round-trip, simulate two
devices with two browser profiles / an incognito window, BOTH signed in as the same PocketBase user.
Per scenario PASS/FAIL/BLOCKED + steps + expected/actual + screenshot. FAIL → repro + console +
root-cause; do NOT fix source.

DELIVERABLE: fill docs/testing/releases/v1.13.0/smoke-test.md (per-scenario + top Result block);
commit to release/v1.13.0 (results only, no source); do NOT merge/tag. Bugs → top list w/ severity;
fixes by Kiro Web on the same branch, then re-verify.

GATE RULE: sign-off requires the preview functionally correct (incl. a real sync round-trip) AND CI green.

Begin with STEP 0. Only if all pass, read the smoke-test file and execute + record. If any
pre-flight check fails, follow the ABORT PROTOCOL and stop.
```

---

## Fill-in record

| Placeholder | Value |
|-------------|-------|
| `{VERSION}` | `1.13.0` |
| `{SPRINT / theme}` | Sprint 47 — ★ Practice Sync Phase 1 (on-demand PocketBase sync) |
| Environment | release PR's Vercel **preview** `https://saranidhi-git-release-v1130-eialarasus-projects.vercel.app` (slug `release-v1130`) + live PocketBase `https://saranidhi-pb.fly.dev` |
| Smoke-test file | `docs/testing/releases/v1.13.0/smoke-test.md` |
| Highest-priority | S3 cross-device sync round-trip; S1 opt-in-off=zero-network; S5 owner-guard; S6 offline-first preserved; Tamil |
| Release PR # | **#265** |
| Backend | Fly PocketBase `https://saranidhi-pb.fly.dev` (test user required for S2–S5) |
