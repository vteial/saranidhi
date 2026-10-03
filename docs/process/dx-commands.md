[← Back to Root](../../README.md)

# Saranidhi — Environment & Ops DX Commands (`just` family)

> **Canonical self-path:** `docs/process/dx-commands.md` in `vteial/saranidhi`.
> **Reviewed:** v1.13.0-web · **Status:** 🟢 live (PR 2 of the cetana-labs adoption).
> **See also:** lifecycle protocols in [`dev-workflow.md`](dev-workflow.md); the
> migration map in [`PROCESS_MIGRATION.md`](PROCESS_MIGRATION.md) §5.

The **Layer B** (environment / ops) half of the firm-wide
[cetana-labs vocabulary](PROCESS_MIGRATION.md). Realized as **`just` recipes** so
every project in the owner's portfolio answers the **same verbs** — type `just` in any
repo and see the same list; the bodies are stack-specific. Saranidhi is **local-first**
(no backing services), so `start-local` is just the Flutter web dev server.

> **Why `just`, not `make`:** the owner's machine standardizes on Homebrew-managed `just`
> (`~/my-works/PERSONAL_MACHINE_GUIDE.md` §3, D-01). `make` is only the Xcode-shipped BSD
> make — not a managed tool. (cetana-labs still uses `make`; that is a legacy artifact of
> its nexus-pulse origin and a future `make→just` convergence.)

---

## Command family

Run `just` (or `just --list`) any time for this list. Each recipe has a **slash mirror**
— the slash form is a cetana-style skill at `.kiro/skills/<name>/SKILL.md` that an agent
(Operator/Executor) follows; the `just` recipe is the executable surface it invokes. The
lifecycle slash commands (`/plan-start … /sprint-done`) are materialized the same way; see
[`.kiro/skills/README.md`](../../.kiro/skills/README.md) for the full family.

| Family verb | `just` recipe | Slash | What it does (Saranidhi / Flutter) |
| :--- | :--- | :--- | :--- |
| **Onboard** | `just setup-local` | `/setup-local` | `flutter pub get` + build_runner codegen; bootstrap `.env`; guide the toolchain; hand off to `env-doctor`. Idempotent. |
| **Audit machine** | `just env-doctor` | `/env-doctor` | `flutter doctor`, Dart, Chrome, node/pnpm (for the e2e sibling), dev-server port. Reports + suggests; installs nothing. |
| **Validate (gates)** | `just validate-local` | `/validate-local` | The pre-PR gates, mirroring CI: `dart analyze --fatal-infos` → `flutter test --coverage` (≥ 19%) → `flutter build web`. Local baseline = GREEN except the 4 known CloudKit macOS failures. **The Executor runs this GREEN before the PR.** |
| **Run** | `just start-local` | `/start-local` | `flutter run -d chrome --web-port 8787`. |
| **Stop** | `just stop-local` | `/stop-local` | Frees the web port. |
| **Status** | `just status-local` | `/status-local` | Is the dev server up? (`● ONLINE` / `○ OFFLINE`). |
| **Staging status** | `just status-staging` | `/status-staging` | Probes the live Vercel staging + prod edges (HTTP code + latency). |
| **Docs audit** | `just validate-docs` | `/validate-docs` | Flags durable docs missing a `> Reviewed:` stamp (full link/anchor audit is a scripted follow-up). |

> **Lifecycle commands** (`/plan-start`, `/spec-run`, `/review-pr`, `/sprint-done`, …) are
> **Layer A** and live in [`dev-workflow.md`](dev-workflow.md) — they are process protocols,
> not `just` recipes.

---

## Reusing this across projects (the family template)

The `justfile` + `scripts/{setup-local,env-doctor,validate-local}.sh` are written to be
**copyable** (the rbac-platform pattern):

1. Copy the `justfile` and the three `scripts/*.sh` into the new repo.
2. Edit the **variable block** at the top of the `justfile` (ports, pinned versions,
   coverage threshold, staging/prod URLs, the toolchain binary names).
3. Reshape the recipe **bodies** for the stack (e.g. a repo with backing services adds a
   `backing` var + a compose-based `start-local`, as rbac-platform does).

The **verb names never change** — that is the whole point: one muscle memory across every
project.

---

## Config

The `justfile` variable block (edit per project):

| Var | Value (Saranidhi) | Meaning |
| :--- | :--- | :--- |
| `web_port` | `8787` | local `flutter run -d chrome` port |
| `pnpm_version` | `10.27.0` | family pin (for the e2e sibling) |
| `node_min` | `22` | minimum Node (e2e sibling) |
| `coverage_min` | `19` | `ci-full.yml` coverage threshold (`THRESHOLD=19`) |
| `staging_url` | `https://saranidhi-staging.vercel.app` | `main` deploy |
| `prod_url` | `https://saranidhi.vercel.app` | `prod` deploy |

---

[← Back to Root](../../README.md)
