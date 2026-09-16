[← docs index](../README.md)

# PocketBase on Fly.io — Practice Sync backend runbook

> **What this is.** The step-by-step to stand up the **PocketBase** instance that backs **Practice
> Sync Phase 1** (Sprint 47, v1.13.0). PocketBase is the chosen sync transport (SQLite + auth +
> REST) — deliberately a **lean, reusable infra pattern**; this runbook doubles as a template for
> future mini-projects. Deployed on **Fly.io**; a local **Docker Compose** mirror is used for dev.
>
> **Source of truth for the schema:** the Sprint 47 spec
> [`docs/process/sprints/sprint-47-practice-sync-p1/spec.md`](../process/sprints/sprint-47-practice-sync-p1/spec.md) §0.
> The Fly instance **and** the `tool/dev/` Compose seed **must match** it exactly.
>
> **Sequencing note:** the Fly instance is **not** required to *start* Sprint 47 — the local Docker
> Compose PocketBase is enough for Antigravity to build + green the code. Fly is the **release-smoke
> gate** (needed before `/release-start v1.13.0`), so it can be stood up later.

---

## 0. Prerequisites

- A Fly.io account (owner signed up with GitHub).
- **Heads-up on cost:** Fly requires a payment card even on small allowances. A `shared-cpu-1x`
  machine + a 1 GB volume is roughly ~$2–3/mo (often within usage credits) and `auto_stop_machines`
  scales it to zero when idle. If you'd rather not add a card yet, defer this whole runbook — local
  Compose covers development.

## 1. Install & authenticate the Fly CLI

```bash
brew install flyctl          # or: curl -L https://fly.io/install.sh | sh
fly auth login               # opens the browser; use the GitHub-linked account
```

## 2. Create the app + persistent volume

PocketBase is a single binary; the persistent **volume** is what keeps the SQLite file across
restarts. Make a small deploy folder **outside** the `saranidhi` repo (this is infra, not app code):

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

```bash
fly launch --no-deploy --name saranidhi-pb        # pick a near region, e.g. Singapore (sin) / Mumbai (bom)
fly volumes create pb_data --size 1 --region <same-region>
```

**`fly.toml`** — mount the volume + set the internal port + scale-to-zero:
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
```

Instance base URL → **`https://saranidhi-pb.fly.dev`** (this is what Flutter config + the app's
`SyncTransport` point at).

## 3. Bootstrap admin & create collections

```bash
fly open /_/          # PocketBase Admin UI
```
First visit → **create the admin (superuser)** account. This is private ops-only — **never shipped
in the app, never committed.**

### 3a — App-user auth
The app signs in as a *regular user* (the consent surface), not the admin. Confirm the built-in
**`users`** auth collection exists with email/password enabled. Each device/person authenticates as
a `users` record.

### 3b — Collection `sessions` (Base) — fields per spec §0
`uuid` (Text, **Required + Unique**), `ownerId` (Text, Required), `timestamp` (Number),
`totalDurationMs` (Number), `nostril` (Text), `inhaleLengthMs` / `holdAfterInhaleMs` /
`exhaleLengthMs` / `holdAfterExhaleMs` (Number), `completedCycles` (Number), `mood` (Text, opt),
`consciousnessRating` (Number, opt), `notes` (Text, opt).

### 3c — Collection `journal` (Base) — fields per spec §0
`uuid` (Text, **Required + Unique**), `ownerId` (Text, Required), `timestamp` (Number),
`expectedFlow` / `actualFlow` / `nostril` (Text), `isAligned` (Bool), `inhaleDurationMs` /
`holdDurationMs` / `exhaleDurationMs` (Number, opt), `activeYama` / `activeBird` / `activeBirdState`
/ `activeElement` (Text, opt), `notes` (Text, opt), `isPinned` / `wasForcedShift` (Bool).

### 3d — Owner-scoped access rules (the server-side owner-guard) — **`user`-relation form (pinned)**
On **both** collections, add a **`user`** field = **relation → `users`, required**. Then set
**API Rules** so a signed-in user only ever touches their own rows:

| Rule | Value |
|---|---|
| List / Search | `user = @request.auth.id` |
| View | `user = @request.auth.id` |
| Create | `user = @request.auth.id` |
| Update | `user = @request.auth.id` |
| **Delete** | **empty / locked** (append-only — Phase 1 never deletes remotely) |

> **Why the `user` relation (not an `ownerId`-string match):** PocketBase enforces the relation to
> the authenticated `users.id` server-side, so a user physically cannot read or write another
> owner's rows even with a crafted request — this is the network half of the owner-guard. `ownerId`
> (the Practice ID) is still stored as the **cross-device grouping key** the app filters on, but the
> `user` relation is what the server *enforces*. The app must set `user` = the signed-in user's id
> on every create. *(This is the pinned decision; see spec §0.)*

## 4. Verify & hand off

- Health: `curl https://saranidhi-pb.fly.dev/api/health` → `{"code":200,...}`.
- Create one **test user** in the `users` collection (for sign-in tests + smoke).
- Feed Antigravity / Flutter config: base URL `https://saranidhi-pb.fly.dev`, plus the test creds.

## 5. Local dev mirror (Docker Compose)

Sprint 47 ships `tool/dev/docker-compose.yml` (PocketBase only) + a **seed** that recreates the
`sessions`/`journal` collections + the rules above so **local == Fly**. Local URL:
`http://localhost:8090`. Flutter runs native and points at local vs. Fly via config
(`--dart-define` or a settings field). See spec §6.

## 6. Ops notes

- **Backups:** the SQLite DB lives on the `pb_data` volume; `fly volumes snapshots` (or periodic
  `fly ssh` + copy of `pb_data`) for backup. Low urgency at 1–6 users, but note it.
- **Upgrades:** bump `PB_VERSION` in the Dockerfile → `fly deploy`.
- **Cost control:** `auto_stop_machines = true` idles the machine to zero; first request after idle
  has a cold-start (~1–2 s) — acceptable for on-demand sync.
- **Security-review:** this instance is assessed in the Sprint 47 **security-review redo** (network
  path, auth token at rest, owner-scoped rules, data egress) — see spec §8.
- **Reusability:** this Dockerfile + fly.toml + rule pattern is the template for future mini-project
  backends (the lean-infra intent behind choosing PocketBase).
