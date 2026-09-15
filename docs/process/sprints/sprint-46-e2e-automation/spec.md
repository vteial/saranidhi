[← Back to Dossier](./README.md)

# Sprint 46 Spec — Web E2E Smoke Automation (Playwright, `vteial/saranidhi-e2e`)

> **Author:** Kiro Web · **Implementer:** Antigravity (green run before PR) · **Reviewer:** Kiro Web
> **Target:** the **separate repo `vteial/saranidhi-e2e`** (Playwright/TS) · **Internal** — no
> `vteial/saranidhi` app change, no `pubspec` bump, no prod release.

Build a pre-scripted, deterministic Playwright harness that runs the current smoke matrix (S1–S6)
against the **deployed Vercel preview URL**, replacing the ad-hoc CDP scripting that made the
v1.12.1 manual run ~1h48m. All implementation lands in `vteial/saranidhi-e2e`.

---

## §0 — Prerequisite (gated first step): create the repo

**✅ RESOLVED at `/sprint-start`+1:** `vteial/saranidhi-e2e` now exists — owner created it
(**private**, `main` default branch, empty). §0 is satisfied; Antigravity may scaffold into it.

- **Private is fine for the harness.** The E2E *code* need not be public; what must be reachable is
  the **Vercel preview URL**, which is reached via `VERCEL_AUTOMATION_BYPASS_SECRET` (the same bypass
  the manual smoke uses). Repo visibility does not affect that. (Original spec said "public, to
  match" — corrected: private is acceptable.)
- Repo is **empty** → the scaffold is the first real commit.
- **Secret handling:** the Vercel bypass secret is read from an **env var / repo Actions secret**
  (`VERCEL_AUTOMATION_BYPASS_SECRET`), **never committed**. Add `.env` to `.gitignore` in the scaffold.
- **CI note for a private repo:** GitHub Actions minutes on a private repo are metered — keep the
  workflow `workflow_dispatch` (on-demand) as specced (not on every push), which also honors the
  "off the Flutter PR path" rule.

> Antigravity must scaffold into **`vteial/saranidhi-e2e`**, never into `vteial/saranidhi`.

---

## §1 — Repo scaffold (Task 46.1)

- **Stack:** Node LTS + Playwright + TypeScript. `@playwright/test` as the runner.
- **Layout (suggested):**
  ```
  saranidhi-e2e/
    package.json            # scripts: "test", "test:headed", "report"
    playwright.config.ts    # baseURL from env, chromium project, screenshot/trace on
    .gitignore              # .env, node_modules, test-results, playwright-report
    .github/workflows/e2e.yml
    tests/
      smoke.spec.ts         # S1–S6
    fixtures/
      backup_device_a.json  # seed backups (see §5)
      backup_device_b.json
      backup_device_c.json
    lib/
      env.ts                # reads PREVIEW_URL + BYPASS_SECRET, fails fast if missing
      app.ts                # helpers: reset state, seed state, enable semantics, waits
    README.md
  ```
- **Single-command entry:**
  `PREVIEW_URL=https://… BYPASS_SECRET=… npx playwright test` (and a `test:headed` variant).
- `env.ts` must **fail fast with a clear message** if `PREVIEW_URL` or `BYPASS_SECRET` is missing —
  never silently run against a default.

## §2 — Vercel bypass, set once at context level (Task 46.2)

- Configure the browser **context** so every page carries the bypass from the first navigation —
  no per-scenario SSO handling:
  - Preferred: set the bypass **cookie** on the context for the preview origin, OR send the
    `x-vercel-protection-bypass` header via `extraHTTPHeaders` + the
    `x-vercel-set-bypass-cookie=true` param on first load.
- **NEVER clear cookies during a reset.** State reset (§4) clears only `localStorage`/`sessionStorage`.
  (This is the exact v1.12.1 SSO-bounce root cause — do not reintroduce it.)
- A **pre-flight check** (mirrors the manual STEP 0): first test / global setup asserts the preview
  is reachable (HTTP 200, app shell) and — where feasible — that Settings→About reads the expected
  version. If unreachable/wrong, **fail the run with a clear BLOCKED message** (no fallback to
  staging/prod/local — same no-fallback rule as the manual gate).

## §3 — Event-driven waiting + Flutter-web semantics (Task 46.3)

- Use Playwright **web-first auto-waiting assertions** (`expect(locator).toBeVisible()`, etc.) and
  `locator.waitFor()` — **no fixed `sleep()`/`waitForTimeout` as a synchronization primitive**
  (a short settle is acceptable only where genuinely needed, documented inline).
- **Flutter web renders to CanvasKit**, so DOM text isn't directly present — the app exposes an
  **accessibility/semantics tree** (`flt-semantics`, `[aria-label]`, `[role]`) that must be enabled.
  Options, pick what proves reliable:
  - Enable semantics for the run (click the `flt-semantics-placeholder` once at start, or launch
    with semantics forced on), then locate via `getByRole` / `aria-label` / semantics text.
  - Prefer **stable, semantic locators** (role + accessible name) over pixel coordinates or brittle
    CSS — this is the #1 defense against the flakiness that quarantined the in-repo ChromeDriver job
    (see §7).

## §4 — State reset + §5 seeding (Tasks 46.2/46.4)

- **Reset helper** (`lib/app.ts`): `localStorage.clear(); sessionStorage.clear();` then reload —
  **cookies untouched**. Used between scenarios needing a fresh app (e.g. before S4).
- **Seed helper:** write initial app state (e.g. a profile row / Practice ID, `onboarding_complete`)
  directly into `localStorage` (or the app's IndexedDB/Drift store if that's where it lives —
  Antigravity confirms the actual persistence layer on the deployed build) + reload, to reach a
  precondition **without** walking onboarding/import. Targets the S2/S5 setup cost.
  > If direct seeding of the Drift/IndexedDB store proves impractical on the deployed build, fall
  > back to seeding **via the app's own import** (drive the Merge flow once) — document whichever is used.
- **Fixtures:** reuse the real backup shapes from the manual run —
  `backup_device_a.json` (Practice ID `e1a10001-…`), `…_b` (same-PID, for S5.1 union),
  `…_c` (foreign PID `e3c30003-…`, for S2 + S5.2 mismatch). Minimal valid export envelopes
  (schema v7, export v2) with 1–2 journal rows so "imported data present" is assertable.

## §6 — Automate S1–S6 (Task 46.5)

Port the [v1.12.1 smoke matrix](../../../testing/releases/v1.12.1/smoke-test.md) verbatim in intent.
Each test saves a **timestamped screenshot per meaningful step** (Playwright `testInfo.attach` or
`screenshot()` into `test-results/…`), so the run produces the same evidence the manual run did.

| Test | Asserts (green-path) |
|------|----------------------|
| **S1** import-before-onboarding | Fresh state → intro shows Import link → pick `backup_device_a.json` → "Merge Practice Data?" dialog says *adopting Practice ID* → confirm → lands on **dashboard** (not onboarding) → Settings Practice ID == `e1a10001-…` → imported journal entry present |
| **S2** in-place refresh | Seed Practice ID A → Merge/Restore `backup_device_c.json` → Settings profile card shows `e3c30003-…` **without a reload** (assert after the merge completes, no `page.reload()`) |
| **S3** filename prefix | Export → intercept the download → filename matches `^saranidhi_backup_[0-9a-f]{8}_\d{4}-\d{2}-\d{2}-\d{4}\.json$` |
| **S4** onboarding happy-path | Fresh state → **Get Started** (ignore Import) → complete wizard → dashboard; a Practice ID is minted (UUID v4 shape) |
| **S5** merge/owner-guard | S5.1 same-PID (`…_b`) → merge succeeds, no dup; S5.2 foreign (`…_c`) → **mismatch refused** (guard dialog) + Restore-overwrite fallback offered |
| **S6** bilingual | Toggle Tamil on intro → Import link == `மற்றொரு சாதனத்தில் ஏற்கனவே சரணிதி பயன்படுத்துகிறீர்களா? இறக்குமதி செய்யவும்`; merge dialog renders Tamil (`பயிற்சி தரவை இணைக்கவா?` etc.) |

> Assert **behavior + copy**, not pixels. S6 asserts the exact Tamil strings (matches the manual
> gate). Downloads (S3): use Playwright's `page.on('download')` / `waitForEvent('download')`.

## §7 — CI wiring + flakiness de-risk (Task 46.6)

- **`.github/workflows/e2e.yml`** in the e2e repo: `workflow_dispatch` (manual, with a `preview_url`
  input) **+** optionally a scheduled/nightly run against staging. Reads `BYPASS_SECRET` from repo
  Actions secrets. Uploads the Playwright HTML report + screenshots as artifacts.
- **Keep it OFF `vteial/saranidhi`'s PR path** — the whole point of a separate repo is to not slow
  Flutter PRs (the standing E2E-strategy rationale).
- **Flakiness de-risk (explicit DoD, not optional):** this must NOT become the next quarantined
  always-red gate (the in-repo `Integration Tests (Web)` ChromeDriver job is *still* non-blocking
  for exactly this reason). Requirements: stable role/semantics locators; auto-waiting only; retries
  capped (e.g. `retries: 1`) and any retry-masked flake investigated, not ignored; a scenario that
  can't be made reliable is documented as manual-only rather than shipped flaky.

---

## Tests / evidence
The suite **is** the test. Green-path S1–S6 must pass deterministically ≥2 consecutive runs against
a real deployed preview, with screenshot evidence attached.

## Definition of Done (Sprint 46)
- [ ] §0 satisfied — `vteial/saranidhi-e2e` exists; secret handled via env/Actions secret, never committed.
- [ ] Scaffold: Playwright/TS, single-command run, fail-fast env check, `.gitignore` covers `.env`.
- [ ] Bypass set at context level; **cookies never cleared on reset**; pre-flight reachability/version check with **no-fallback** abort.
- [ ] Event-driven waits only (no `sleep()` sync); Flutter-web semantics enabled; stable semantic locators.
- [ ] State seeding for S2/S5 preconditions (method documented).
- [ ] **S1–S6 automated and green** against a deployed preview, ≥2 consecutive clean runs, with per-step screenshot evidence.
- [ ] CI: `e2e.yml` runs on demand against a preview/staging URL; **off the Flutter PR path**; report artifacts uploaded.
- [ ] **Real measured runtime recorded** in `test-summary.md` (NOT the aspirational ~2 min) → update the [Release Effort Reference](../../../testing/smoke-test-results.md#release-effort-reference--the-smoke-gate-is-mostly-fixed-cost-per-release) baseline **only** once proven.
- [ ] **Scope-honesty note** in the e2e README: covers scripted scenarios; human visual/UX/Tamil eyeball still gates.
- [ ] **Flakiness de-risk** met (§7); not a new always-red gate.
- [ ] `saranidhi-e2e` README + a pointer added from this repo's `dev-workflow.md` /release-start (how automated smoke slots into the gate) — the dev-workflow edit is the ONLY change to `vteial/saranidhi` this sprint (docs-only, at `/sprint-finish`).

## Explicitly OUT of scope (named, to hold the boundary)
- Visual-regression snapshots (backlog 🟢 — separate item).
- Making E2E a **blocking** release gate (it stays on-demand until it proves stable; the human gate remains).
- Mobile/`integration_test` E2E (stays in `vteial/saranidhi` for the future App Store sprint).
- Replacing the manual smoke entirely — this automates the scripted portion only.
