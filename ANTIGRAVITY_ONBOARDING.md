<!--
  Canonical path: ~/dev-home/personal/saranidhi/ANTIGRAVITY_ONBOARDING.md
  Last verified: 2026-10-03 (v1.13.0-web).
-->
# Onboarding the Executor (Antigravity) — Saranidhi (PRJ-001)

The reproducible setup that makes Antigravity able to run `/spec-run` on this repo. Follow it
on a fresh machine or after a rebuild. The behavioral contract lives in
[`.kiro/steering/executor-antigravity.md`](./.kiro/steering/executor-antigravity.md); this doc
is the **environment + checklist**.

## Why the Executor exists
Kiro Web (the **Operator**) authors Specs and reviews PRs but **cannot run `flutter analyze` /
`flutter test` / `flutter build web` locally**. Antigravity (the **Executor**) runs those gates
on the owner's Mac — that is the entire reason for the split. The **Human owner** is the sole
merge/release authority; the Executor never merges or tags.

## 1. Toolchain (Homebrew-managed — `~/my-works/PERSONAL_MACHINE_GUIDE.md`)
| Tool | Version | Install |
| :--- | :--- | :--- |
| Flutter | 3.47.5 (cask) | `brew install --cask flutter` |
| Dart SDK | bundled with Flutter | — |
| Chrome | latest | web build target |
| `just` | 1.58.0 | `brew install just` |
| pnpm | 10.27.0 | `brew install pnpm` (Node ≥ 22) |
| `uv` | latest | `brew install uv` (only if a Python script is touched) |

- **Git identity:** saranidhi is under `~/dev-home/personal/`, so the `includeIf` block auto-routes
  the **personal** identity (`vteial`). Confirm with `git -C ~/dev-home/personal/saranidhi config user.email`.

## 2. Clone + bootstrap
```bash
git clone git@github.com-personal:vteial/saranidhi.git ~/dev-home/personal/saranidhi
cd ~/dev-home/personal/saranidhi
just setup-local      # flutter pub get + build_runner codegen + l10n
```

## 3. Verify the environment, then the baseline
```bash
just env-doctor       # flutter doctor, Dart, Chrome, pnpm/node, just
just validate-local   # analyze --fatal-infos + test (--coverage ≥19%) + build web
```
- **Expected baseline:** GREEN **except the 4 known CloudKit macOS failures**. Any other red = stop and fix before any Spec work.

## 4. QA-Verify env (preview behind Vercel Deployment Protection)
- Create a gitignored `.env` with `VERCEL_AUTOMATION_BYPASS_SECRET=<secret>` (owner provides it).
- Reach a PR preview past the SSO wall:
  `<preview-url>?x-vercel-protection-bypass=<secret>&x-vercel-set-bypass-cookie=true`.

## 5. First `/spec-run`
```bash
# the Operator has already authored + MERGED the Spec to main (merge-first), so:
/spec-run <spec-id>
```
Antigravity then: syncs `main`, cuts `sprint/<id>`, executes `tasks.md`, self-validates the EARS
DoD (incl. **RT Tamil / RC CONF / RQ gates**), opens the PR via `gh pr create`, emits the Human
Verification Plan, and **STOPs**. It never merges.

## Checklist (tick on a fresh machine)
- [ ] Homebrew toolchain installed (table §1); `just env-doctor` all green
- [ ] Repo cloned under `~/dev-home/personal/` (personal git identity auto-routed)
- [ ] `just setup-local` run (deps + codegen + l10n)
- [ ] `just validate-local` green except the 4 CloudKit macOS failures
- [ ] `.env` with `VERCEL_AUTOMATION_BYPASS_SECRET` present (gitignored) for QA-Verify
- [ ] Read [`.kiro/steering/executor-antigravity.md`](./.kiro/steering/executor-antigravity.md) — the `/spec-run` contract + hard rules
