[← docs index](../README.md)

# PocketBase — Practice Sync backend runbook

> **What this backs.** The **PocketBase** instance behind **Practice Sync** (Sprint 47, v1.13.0):
> SQLite + auth + REST, reached through a swappable **`SyncTransport`** — so **the host is just a
> base-URL config value**. Everything you need is **in this repo** (no files in your home folder).
>
> **How to read this doc** — it is split by *how often you do it*:
> - **[Part A — Local dev](#part-a--local-dev-everyday)** — run PocketBase on your machine so a locally-run front-end syncs to it. **Everyday.**
> - **[Part B — Hosted, one-time setup](#part-b--hosted-backend-one-time-setup)** — stand up the Fly.io instance. **Once per environment.**
> - **[Part C — Hosted, repeated](#part-c--hosted-repeated-operations)** — redeploy, check health, view logs. **Every release / schema change.**
> - **[Part D — Reference](#part-d--reference)** — schema, rules, provider choice, ops, host-swap.
>
> **Files in the repo (single source of truth):**
> | Path | Purpose |
> |---|---|
> | `tool/dev/docker-compose.yml` | Local PocketBase (Part A) — run with **Podman** (preferred) or Docker |
> | `tool/dev/pb_migrations/*.js` | Collections + rules — used by **both** local and hosted |
> | `deploy/pocketbase/Dockerfile` | Hosted image (bakes the same migrations) |
> | `deploy/pocketbase/fly.toml` | Fly.io app config (name, region, volume, port) |
>
> **Schema source of truth:** the migrations in `tool/dev/pb_migrations/`. Local and hosted run the
> *same* files, so they cannot drift.

---

## Part A — Local dev (everyday)

Goal: a PocketBase on `http://localhost:8090`, and a locally-run Saranidhi that syncs to it.

### A1. Start PocketBase (one command)

**Podman (preferred):**
```bash
cd tool/dev
podman compose up -d
```
> If `podman compose` isn't wired up on your machine, use the drop-in: `podman-compose up -d`
> (`pip install podman-compose` / `brew install podman-compose`). The `docker-compose.yml` is
> unchanged — Podman reads the same file.

**Docker (secondary / fallback):**
```bash
cd tool/dev
docker compose up -d
```

- API: `http://localhost:8090` · Admin: `http://localhost:8090/_/` · Health: `http://localhost:8090/api/health`
- Data persists in `tool/dev/pb_data/` (git-ignored). The `sessions`/`journal` collections + rules are
  auto-provisioned from `tool/dev/pb_migrations/` on first boot.

### A2. One-time local admin + test user
1. Open `http://localhost:8090/_/`, create a local admin (e.g. `admin@saranidhi.local` / `passphrase12345`).
2. Confirm `sessions` + `journal` exist under **Collections**.
3. In the `users` collection, add a test user (e.g. `practitioner@saranidhi.local` / `passphrase12345`).

### A3. Run the front-end against local PocketBase
```bash
# Web / macOS desktop
flutter run -d chrome --dart-define=POCKETBASE_URL=http://localhost:8090

# Android emulator (localhost maps to 10.0.2.2)
flutter run -d android --dart-define=POCKETBASE_URL=http://10.0.2.2:8090
```
Or leave the default and just type `http://localhost:8090` into **Settings → Practice Sync → Server URL**
at sign-in. Then enable sync, sign in with the A2 test user, and Sync Now hits your local instance.

### A4. Stop / reset
```bash
cd tool/dev
podman compose down            # stop   (Docker: docker compose down)
podman compose down -v && rm -rf pb_data   # wipe local data, start fresh
```

---

## Part B — Hosted backend (one-time setup)

Do this **once** to create the Fly.io instance. Owner's chosen host is **Fly.io** (see [§D3](#d3-provider-choice) for why / alternatives).

### B1. Install + log in (once per machine)
```bash
brew install flyctl            # or: curl -L https://fly.io/install.sh | sh
fly auth login                 # GitHub-linked account
```

### B2. Create the app + persistent volume (once per environment)
The app config already exists at `deploy/pocketbase/fly.toml` (`app = "saranidhi-pb"`, region `sin`).
Create the app record and the volume that holds the SQLite file:
```bash
# from the repo root
fly apps create saranidhi-pb                       # skip if it already exists
fly volumes create pb_data --size 1 --region sin   # must match primary_region in fly.toml
```

### B3. First deploy
```bash
# from the repo root — context MUST be repo root so the image can COPY tool/dev/pb_migrations
fly deploy --config deploy/pocketbase/fly.toml --dockerfile deploy/pocketbase/Dockerfile .
```

### B4. Create the hosted admin + test users (once)
```bash
fly open /_/                   # opens the PocketBase Admin UI
```
- Create the **superuser** (private ops account — never commit it).
- In `users`, create the test accounts for smoke (e.g. `usera@…`, `userb@…`). Creds stay out-of-band.
- Base URL is `https://saranidhi-pb.fly.dev` (already wired into the app build via
  `scripts/vercel_build.sh` `--dart-define POCKETBASE_URL=…`).

---

## Part C — Hosted (repeated operations)

### C1. Redeploy (after any schema/migration or PocketBase-version change)
```bash
# from the repo root — same canonical command as B3
fly deploy --config deploy/pocketbase/fly.toml --dockerfile deploy/pocketbase/Dockerfile .
```
> New migration files in `tool/dev/pb_migrations/` are baked into the image and applied on boot.
> Migrations run **once per filename** — to change already-applied schema, ADD a new migration file
> (do not edit an applied one). Example: `1710000001_relax_required_data_fields.js`.

### C2. Health / status / logs
```bash
curl https://saranidhi-pb.fly.dev/api/health     # {"code":200,...}
fly status                                        # machine running/stopped/crashed
fly logs                                          # boot + migration errors
```

### C3. Common gotchas
- **`Error: the config for your app is missing an app name`** — you ran `fly deploy` without pointing
  at the config. Use the full canonical command in C1 (or `cd` to the folder holding a `fly.toml` that
  has `app = "..."`). Our `deploy/pocketbase/fly.toml` has the app name.
- **`COPY tool/dev/pb_migrations` fails / migrations missing** — the build context wasn't the repo
  root. The trailing `.` in the canonical command sets context = repo root. Always deploy from there.
- **Schema edit didn't take** — you edited an already-applied migration. Add a NEW numbered migration
  instead, then redeploy (C1).

---

## Part D — Reference

### D1. Collections & fields (provisioned by the migrations)
- **`sessions`** (Base): `uuid`*, `ownerId`*, `timestamp`, `totalDurationMs`, `nostril`,
  `inhaleLengthMs`, `holdAfterInhaleMs`, `exhaleLengthMs`, `holdAfterExhaleMs`, `completedCycles`,
  `mood`, `consciousnessRating`, `notes`.
- **`journal`** (Base): `uuid`*, `ownerId`*, `timestamp`, `expectedFlow`, `actualFlow`, `nostril`,
  `isAligned`, `inhaleDurationMs`, `holdDurationMs`, `exhaleDurationMs`, `activeYama`, `activeBird`,
  `activeBirdState`, `activeElement`, `notes`, `isPinned`, `wasForcedShift`.

> \* **Only `uuid` + `ownerId` are `required`** (identity fields, `min:1`). **All other fields are
> `required: false`** — this is deliberate: PocketBase's `required` validator rejects a type's ZERO
> VALUE (`bool false`, `number 0`, empty text) with `validation_required`, which would block valid
> rows like a misaligned journal entry (`isAligned:false`) or `holdAfterExhaleMs:0`. The app always
> sends every field, so DB-level `required` adds no safety and only breaks on falsy data.
> **Rule of thumb: never mark a `bool` required; mark a `number` required only if `0` is truly invalid.**
> (Fixed in `1710000001_relax_required_data_fields.js` after the v1.13.0 smoke caught it.)

### D2. Owner-scoped access rules (server-side owner-guard)
On **both** collections:

| Rule | Value |
|---|---|
| List / View / Create / Update | `@request.auth.id != "" && ownerId = @request.auth.id` |
| Delete | `null` / locked (append-only) |

The **Create** rule binds each row's `ownerId` to the authenticated user's id → a user can't write
under a foreign `ownerId`; List/View/Update scope every row to the caller. So `ownerId` (the app's
Practice ID, bound to the PocketBase user id on sign-in) is both the cross-device grouping key AND the
server-enforced isolation boundary. No separate relation field needed.

### D3. Provider choice
For one PocketBase binary + one SQLite file on a persistent disk, 1–6 users, on-demand sync:

| | **Fly.io** (chosen) | **Railway** | **Render** |
|---|---|---|---|
| Persistent disk | ✅ Volumes | ✅ Volumes | ⚠️ paid only |
| Cheap floor | ~$2–3/mo | ~$5/mo Hobby | free can't persist → ~$7/mo paid |
| Idle | scale-to-zero (~1–2s cold) | stays warm | free sleeps; paid always-on |
| Verdict | cheapest + scale-to-zero | smoothest DX, warm | free tier is a data-loss trap |

Because the host is a config URL, switching is low-stakes (see D5).

### D4. Ops
- **Backups:** SQLite lives on the `pb_data` volume — `fly volumes snapshots list`, or `fly ssh console`
  + copy `pb_data`. Low urgency at 1–6 users.
- **Upgrade PocketBase:** bump `PB_VERSION` in `deploy/pocketbase/Dockerfile` → redeploy (C1).
- **Cost control:** `auto_stop_machines` idles to zero; first request cold-starts ~1–2s.
- **Security-review:** the hosted instance (network path, auth token, owner-scoped rules, egress) is
  covered in the Sprint 47 security-review redo.

### D5. Host swap (Fly → Railway/other)
1. Copy the `pb_data` SQLite file to the new host's volume.
2. Deploy the same `deploy/pocketbase/Dockerfile` there (Railway: Deploy-from-Dockerfile + a volume at
   `/pb/pb_data`, port 8080).
3. Change `POCKETBASE_URL` (in `scripts/vercel_build.sh` / the app config). The app is otherwise
   unaffected — it only knows the URL.
