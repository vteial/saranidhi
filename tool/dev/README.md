# Local Development Infrastructure — PocketBase (Practice Sync Phase 1)

This directory contains the local Docker Compose configuration for testing Saranidhi's **Practice Sync** feature against a local [PocketBase](https://pocketbase.io/) instance.

## Prerequisites
- Docker & Docker Compose installed.
- Flutter SDK 3.x+ (runs natively, not containerized).

## 1. Start PocketBase

From repository root:
```bash
cd tool/dev
docker compose up -d
```

PocketBase will start on port `8090`:
- **API URL:** `http://localhost:8090`
- **Admin Dashboard:** `http://localhost:8090/_/`
- **Health Check:** `http://localhost:8090/api/health`

Data is persisted locally in `tool/dev/pb_data/` (this folder is `.gitignore`d).

## 2. Admin & User Setup

1. Open `http://localhost:8090/_/` in your browser.
2. Follow the on-screen prompt to create your local admin credentials (e.g. `admin@saranidhi.local` / `passphrase12345`).
3. Under the **Collections** view, verify that `sessions` and `journal` collections were automatically provisioned by `pb_migrations/1710000000_init_practice_sync.js`.
4. In the `users` collection, create a test user (e.g. `practitioner@saranidhi.local` / `passphrase12345`).

## 3. Run Saranidhi against Local PocketBase

Flutter runs native on macOS / Chrome / iOS / Android. Point it at the local instance:

### Flutter Web / macOS Desktop
```bash
flutter run -d chrome --dart-define=POCKETBASE_URL=http://localhost:8090
```

### Android Emulator (Localhost mapping)
```bash
flutter run -d android --dart-define=POCKETBASE_URL=http://10.0.2.2:8090
```

Alternatively, enable **Practice Sync** in **Settings → Practice Sync**, tap **Sign In**, and enter `http://localhost:8090` in the Server URL field.

## 4. Stopping

```bash
cd tool/dev
docker compose down
```
To wipe local development data and start fresh:
```bash
cd tool/dev
docker compose down -v
rm -rf pb_data
```


---

**Hosted backend?** For the Fly.io production/preview instance (one-time setup + redeploy steps), see
the full runbook: [`docs/deployment/pocketbase-hosting.md`](../../docs/deployment/pocketbase-hosting.md).
Local and hosted share the SAME migrations in `pb_migrations/`, so schema never drifts.
