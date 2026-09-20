# Bug-Fix Note — PocketBase `required` rejects falsy values (v1.13.0 release blocker #3)

**Type:** Backend schema fix (PocketBase migration). No app code change, no Dart PR.
**Branch:** `release/v1.13.0`
**Discovered:** during owner cross-browser (Edge) re-smoke of Practice Sync on the PR #265 preview.

## Symptom

After the sign-in-state fix (#2) and owner-binding fix (#2b) both landed and worked (Edge payload confirmed `ownerId` = PocketBase user id `o65kj6h45ozjjou`, NOT the old device UUID — binding is correct), Sync Now still returned:
```
Sync failed: ClientException ... POST /api/collections/journal/records
statusCode: 400, {code: 400, message: Failed to create record.,
data: {isAligned: {code: validation_required, message: Missing required value}}}
```
The journal payload had `isAligned: false`.

## Root cause (reproduced against live Fly)

PocketBase's `required: true` validator treats a field type's **zero value as "missing"**:
- `bool` `false` → `validation_required`
- `number` `0` → `validation_required`
- empty text → `validation_required`

Verified live against `https://saranidhi-pb.fly.dev`:
| Body | Result |
|---|---|
| `isAligned: false` | `400 {isAligned: validation_required}` ← the owner's error |
| `isAligned: true`  | `400 data:{}` (field OK; only the unauth createRule denies) |
| `timestamp: 0`     | `400 {timestamp: validation_required}` |

So EVERY field marked `required: true` that can legitimately hold `false`/`0`/`""` breaks sync on that data. The initial migration (`1710000000`) marked all data fields `required: true`. Affected: `journal.isAligned` (very common — misaligned breath), `sessions.holdAfterExhaleMs` / `completedCycles` / other `*Ms` numbers (commonly `0`), and both `timestamp`s.

The app ALWAYS sends these fields (the `_*MapToRecordBody` mappers apply defaults), so DB-level `required` added no safety — it only rejected valid falsy data.

## Fix

Only the IDENTITY fields (`uuid`, `ownerId`) stay `required: true` (with `min:1`, so present + non-empty; `ownerId` isolation is also enforced by the createRule). All DATA fields → `required: false`.

- `tool/dev/pb_migrations/1710000000_init_practice_sync.js` — updated so a FRESH deploy is correct from the start.
- `tool/dev/pb_migrations/1710000001_relax_required_data_fields.js` — NEW forward-only migration that patches the EXISTING deployed collections (the initial migration already ran once by filename and will not re-run), flipping all non-identity fields to `required: false`. Down-migration restores the original required set.

## Deploy + re-verify (owner)

1. Redeploy the PocketBase app to Fly (`fly deploy`) — the new migration `1710000001` applies on boot.
2. Re-run Sync Now on the preview with a misaligned (`isAligned:false`) journal entry present → expect success (pull + push, no 400).
3. Cross-device round-trip (S3) + owner-guard (S5) as before.

## Note

This is the classic PocketBase pitfall: never mark a `bool` `required`, and only mark a `number` `required` if `0` is genuinely invalid for that field. Ported this caution to the hosting runbook / project-blueprint as a follow-up.
