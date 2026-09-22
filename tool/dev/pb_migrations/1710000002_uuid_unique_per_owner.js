/// PocketBase migration (v1.13.0 fix #3): make `uuid` unique PER OWNER, not globally.
///
/// The initial migration created `UNIQUE INDEX (uuid)` on `sessions`/`journal` — a GLOBAL
/// uniqueness constraint. But the sync engine keys "does this row already exist?" on
/// `ownerId + uuid`. When a second account (userB) pushes a row whose `uuid` already exists
/// under another owner (userA) — e.g. the SAME physical row synced under two accounts — the
/// engine correctly finds no match under userB's ownerId and tries to CREATE, but the global
/// unique index rejects it with `uuid: validation_not_unique` (400). Two owners must be able
/// to hold the same uuid independently.
///
/// Fix: drop the global-unique uuid index and add a COMPOSITE unique index (ownerId, uuid).
/// This makes uuid unique per-owner and matches the engine's upsert logic exactly.
///
/// Forward-only patch of the EXISTING deployed collections (no data loss, no reset).
migrate((db) => {
  const dao = new Dao(db);

  const spec = {
    sessions: {
      drop: "idx_sessions_uuid",
      create:
        "CREATE UNIQUE INDEX idx_sessions_owner_uuid ON sessions (ownerId, uuid)",
    },
    journal: {
      drop: "idx_journal_uuid",
      create:
        "CREATE UNIQUE INDEX idx_journal_owner_uuid ON journal (ownerId, uuid)",
    },
  };

  for (const name of Object.keys(spec)) {
    const collection = dao.findCollectionByNameOrId(name);
    if (!collection) continue;

    const { drop, create } = spec[name];
    // Keep every index except the old global-unique uuid one; add the composite.
    const kept = (collection.indexes || []).filter(
      (idx) => !idx.includes(drop),
    );
    kept.push(create);
    collection.indexes = kept;

    dao.saveCollection(collection);
  }
}, (db) => {
  // Down migration: restore the original global-unique uuid index.
  const dao = new Dao(db);

  const spec = {
    sessions: {
      drop: "idx_sessions_owner_uuid",
      create: "CREATE UNIQUE INDEX idx_sessions_uuid ON sessions (uuid)",
    },
    journal: {
      drop: "idx_journal_owner_uuid",
      create: "CREATE UNIQUE INDEX idx_journal_uuid ON journal (uuid)",
    },
  };

  for (const name of Object.keys(spec)) {
    const collection = dao.findCollectionByNameOrId(name);
    if (!collection) continue;

    const { drop, create } = spec[name];
    const kept = (collection.indexes || []).filter(
      (idx) => !idx.includes(drop),
    );
    kept.push(create);
    collection.indexes = kept;

    dao.saveCollection(collection);
  }
});
