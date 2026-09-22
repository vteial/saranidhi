# Bug-Fix Note — `uuid` unique per-owner, not global (v1.13.0 release blocker #4)

**Type:** Backend schema fix (PocketBase migration). No app code change, no Dart PR.
**Branch:** `release/v1.13.0`
**Discovered:** during owner S5 (owner-guard) re-smoke — userB sync on a device holding userA's rows.

## Symptom

Signed in as **userB**, Sync Now failed:
```
POST /api/collections/journal/records → 400
{code: 400, message: Failed to create record.,
 data: {uuid: {code: validation_not_unique, message: Value must be unique.}}}
```
(No cross-owner data LEAK occurred — isolation held; this is a write-collision, not a read breach.)

## Root cause

The collections had a **GLOBAL** unique index on `uuid` alone
(`CREATE UNIQUE INDEX idx_journal_uuid ON journal (uuid)`), but the sync engine keys "does this row
already exist remotely?" on **`ownerId + uuid`** (it queries `filter: ownerId = '<me>'`). So when userB
pushes a row whose `uuid` already exists under userA:
- the engine finds no match under userB's ownerId → decides to **CREATE**;
- the global unique index rejects the create because userA already owns that uuid → `validation_not_unique`.

Two contributing factors:
1. **Test artifact:** userB was pushing rows that share userA's uuids (same install / same physical
   journal data synced under two accounts). Two genuinely separate users generate different random v4
   uuids (journal ids = `Uuid().v4()`), so real-world collisions are astronomically unlikely.
2. **Latent schema gap (the real fix):** a GLOBAL-unique `uuid` is wrong for a multi-owner collection.
   The correct constraint is **unique PER OWNER**, matching the engine's `ownerId+uuid` upsert logic.

## Fix

Replace the global-unique `uuid` index with a **composite unique index `(ownerId, uuid)`** on both
collections. Now two owners can independently hold the same uuid; each owner still can't duplicate a
uuid within their own data.

- `tool/dev/pb_migrations/1710000000_init_practice_sync.js` — updated so a FRESH deploy is correct
  (`idx_sessions_owner_uuid`, `idx_journal_owner_uuid` on `(ownerId, uuid)`).
- `tool/dev/pb_migrations/1710000002_uuid_unique_per_owner.js` — NEW forward-only migration that drops
  the old global-unique uuid index on the EXISTING collections and adds the composite one. Down-migration
  restores the global index.

## Deploy + re-verify (owner)

1. Redeploy PocketBase to Fly (`fly deploy --config deploy/pocketbase/fly.toml --dockerfile deploy/pocketbase/Dockerfile .` from repo root) — migration `1710000002` applies on boot.
2. **S5 owner-guard, done cleanly:** sign in as userB on a **fresh install / cleared local data** (userB's
   OWN journal, not userA's rows) → Sync Now succeeds, and userB sees NONE of userA's data.
3. (Optional) the artifact case now also succeeds: the same physical row synced under both accounts no
   longer collides — each owns its own copy.

## Note

Classic multi-tenant pitfall: a natural/business key that is unique per-tenant must be indexed as
`(tenantId, key)`, never globally. Ported this caution to the hosting runbook / project-blueprint.
