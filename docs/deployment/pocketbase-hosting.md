[← docs index](../README.md)

# PocketBase hosting — Practice Sync backend runbook (host-agnostic)

> **What this is.** How to stand up the **PocketBase** instance that backs **Practice Sync Phase 1**
> (Sprint 47, v1.13.0). PocketBase is the chosen sync transport (SQLite + auth + REST) — deliberately
> a **lean, reusable infra pattern**; this runbook doubles as a template for future mini-projects.
>
> **Host-agnostic by design.** The app talks to PocketBase through a swappable **`SyncTransport`**
> interface, so **the host is just a base-URL config value** — you can start on one provider and move
> later by copying one SQLite file + changing `POCKETBASE_URL`. §1 covers the host-independent setup
> (collections/schema/rules), §2 gives per-provider deploy recipes (**Fly.io / Railway**), §3+ is
> local dev + ops.
>
> **Owner's current choice: Fly.io** (see §2A). Railway is documented as the swap-in alternative (§2B).
>
> **Source of truth for the schema:** the Sprint 47 spec
> [`sprint-47-practice-sync-p1/spec.md`](../process/sprints/sprint-47-practice-sync-p1/spec.md) §0.
> The deployed instance **and** the `tool/dev/` Compose seed **must match** it exactly.
>
> **Sequencing note:** a hosted instance is **not** required to *start* Sprint 47 — the local Docker
> Compose PocketBase (§3) is enough to build + green the code. A hosted instance is the
> **release-smoke gate** (needed before `/release-start v1.13.0`), so it can be stood up later.

---

## Provider comparison (why the runbook is host-agnostic)

For a single PocketBase binary + one SQLite file on a persistent disk, 1–6 users, on-demand sync:

| | **Fly.io** | **Railway** | **Render** |
|---|---|---|---|
| Persistent disk (required) | ✅ Volumes, first-class | ✅ Volumes | ⚠️ paid instances only |
| Free/cheap floor | pay-as-you-go ~$2–3/mo | ~$5/mo Hobby (usage credit) | free tier **can't persist** → must go paid (~$7/mo) |
| Idle behavior | **scale-to-zero** (cold start ~1–2s) | stays warm (no cold start) | free sleeps (30–60s cold start); paid always-on |
| DX / ops | most infra-flavored | slickest DX | middle |
| Fit for PocketBase | **cheapest real bill** | **least-headache** | weakest (free tier is a data-loss trap) |

**Verdict:** **Fly** = cheapest + scale-to-zero (owner's pick). **Railway** = smoothest DX, stays
warm, ~$5/mo. **Render** ruled out for PocketBase (free tier has no persistent disk → SQLite wiped on
restart; paid loses the cost edge). Because the host is a config URL, this is low-stakes and reversible.

---

## 1. Host-independent setup (same on every provider)

### 1a — App-user auth
The app signs in as a *regular user* (the consent surface), not the admin. Confirm the built-in
**`users`** auth collection exists with email/password enabled. Each device/person authenticates as a
`users` record. The **admin (superuser)** account is private ops-only — **never shipped, never committed.**

### 1b — Collection `sessions` (Base) — fields per spec §0
`uuid` (Text, **Required + Unique**), `ownerId` (Text, Required), `timestamp` (Number),
`totalDurationMs` (Number), `nostril` (Text), `inhaleLengthMs` / `holdAfterInhaleMs` /
`exhaleLengthMs` / `holdAfterExhaleMs` (Number), `completedCycles` (Number), `mood` (Text, opt),
`consciousnessRating` (Number, opt), `notes` (Text, opt).

### 1c — Collection `journal` (Base) — fields per spec §0
`uuid` (Text, **Required + Unique**), `ownerId` (Text, Required), `timestamp` (Number),
`expectedFlow` / `actualFlow` / `nostril` (Text), `isAligned` (Bool), `inhaleDurationMs` /
`holdDurationMs` / `exhaleDurationMs` (Number, opt), `activeYama` / `activeBird` / `activeBirdState`
/ `activeElement` (Text, opt), `notes` (Text, opt), `isPinned` / `wasForcedShift` (Bool).

### 1d — Owner-scoped access rules (the server-side owner-guard) — as shipped
On **both** collections, set the **API Rules** so a signed-in user only ever touches their own rows,
keyed off the record's `ownerId` bound to the authenticated user's id:

| Rule | Value |
|---|---|
| List / Search | `@request.auth.id != "" && ownerId = @request.auth.id` |
| View | `@request.auth.id != "" && ownerId = @request.auth.id` |
| Create | `@request.auth.id != "" && ownerId = @request.auth.id` |
| Update | `@request.auth.id != "" && ownerId = @request.auth.id` |
| **Delete** | **`null` / locked** (append-only — Phase 1 never deletes remotely) |

> **Why this form:** the **Create rule binds `ownerId` to the authenticated user's id**, so a user
> cannot create rows under a foreign `ownerId`; List/View/Update then scope every row to the caller —
> a user cannot read or write another owner's rows. `ownerId` (the Practice ID) is both the
> cross-device grouping key AND the server-enforced scope — no separate relation field needed.
> *(A `user`-relation form was originally pinned in PR #261; the simpler `ownerId`-bound form was
> shipped + owner-accepted at `/sprint-finish` for the 1–6-user trust model. Spec §0 + the migration
> in `tool/dev/pb_migrations/` reflect these exact rules.)*

### 1e — The Dockerfile (used by both providers)
PocketBase is a single binary; a **persistent disk/volume** keeps the SQLite file across restarts.
Make a small deploy folder **outside** the `saranidhi` repo (this is infra, not app code):

```bash
mkdir ~/saranidhi-pb && cd ~/saranidhi-pb
```
**`Dockerfile`:**
```dockerfile
FROM alpine:3.20
ARG PB_VERSION=0.22.21
RUN apk add --no-cache unzip ca-certificates
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/
EXPOSE 8080
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
```

---

## 2. Deploy — pick ONE provider

### 2A — Fly.io (owner's current choice)

```bash
brew install flyctl          # or: curl -L https://fly.io/install.sh | sh
fly auth login               # use the GitHub-linked account
```
```bash
fly launch --no-deploy --name saranidhi-pb        # near region, e.g. Singapore (sin) / Mumbai (bom)
fly volumes create pb_data --size 1 --region <same-region>
```
**`fly.toml`** — mount the volume + internal port + scale-to-zero:
```toml
[[mounts]]
  source = "pb_data"
  destination = "/pb/pb_data"

[http_service]
  internal_port = 8080
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 0
```
```bash
fly deploy
fly open /_/          # opens the PocketBase Admin UI → create the superuser
```
- Base URL → `https://saranidhi-pb.fly.dev`.
- **Cost:** ~$2–3/mo; a payment card is required even on small allowances.

### 2B — Railway (swap-in alternative)

- New project → **Deploy from Dockerfile** (the `~/saranidhi-pb` folder above, pushed to a repo) or
  the PocketBase template.
- Add a **Volume** mounted at `/pb/pb_data` (persists the SQLite file — required).
- Set the service **port to 8080**; Railway assigns a public `*.up.railway.app` domain.
- Open `<domain>/_/` → create the superuser.
- Base URL → `https://<your-app>.up.railway.app`.
- **Cost:** ~$5/mo Hobby (usage credit; a small idle PocketBase often fits within it); **stays warm**
  (no cold start).

> **Render note:** not recommended for PocketBase — its free tier has **no persistent disk** (SQLite
> wiped on restart). Only viable on a paid instance + disk (~$7/mo), which loses the cost advantage.

---

## 3. Local dev mirror (Docker Compose)

Sprint 47 ships `tool/dev/docker-compose.yml` (PocketBase only) + a **seed** that recreates the
`sessions`/`journal` collections + the §1d rules so **local == hosted**. Local URL:
`http://localhost:8090`. Flutter runs native and points at local vs. hosted via config
(`--dart-define POCKETBASE_URL=…` or a settings field). See spec §6.

## 4. Verify & hand off

- Health: `curl <base-url>/api/health` → `{"code":200,...}`.
- Create one **test user** in the `users` collection (for sign-in tests + smoke).
- Feed the release smoke / Flutter config: the base URL + the test creds.

## 5. Ops notes

- **Backups:** the SQLite DB lives on the persistent volume — Fly: `fly volumes snapshots` (or
  `fly ssh` + copy `pb_data`); Railway: volume backup / periodic export. Low urgency at 1–6 users.
- **Upgrades:** bump `PB_VERSION` in the Dockerfile → redeploy (`fly deploy` / Railway redeploy).
- **Cost control (Fly):** `auto_stop_machines = true` idles to zero; first request cold-starts ~1–2 s
  — acceptable for on-demand sync. (Railway stays warm, no cold start, small steady cost.)
- **Security-review:** the hosted instance is assessed in the Sprint 47 **security-review redo**
  (network path, auth token, owner-scoped rules, data egress) — see spec §8.
- **Reusability + host swap:** the Dockerfile + collection schema + rule pattern is the template for
  future mini-project backends. To move hosts: copy the `pb_data` SQLite file to the new volume,
  redeploy, and change `POCKETBASE_URL` — the app is unaffected (it only knows the URL).
