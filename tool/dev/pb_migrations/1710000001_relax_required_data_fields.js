/// PocketBase migration (v1.13.0 fix): relax `required` on DATA fields.
///
/// The initial migration (1710000000) marked data fields `required: true`.
/// PocketBase's `required` validator rejects a field type's ZERO VALUE
/// (bool `false`, number `0`, empty text) with `validation_required`, which
/// blocks legitimate rows — e.g. a misaligned journal entry (isAligned:false)
/// or a session with holdAfterExhaleMs:0. This migration flips every DATA field
/// to `required: false`, keeping only the IDENTITY fields (uuid, ownerId) required.
///
/// Forward-only patch of the EXISTING collections (no data loss, no reset).
/// The initial migration file already ran once by filename, so its edited copy
/// will not re-run — this separate migration applies the schema change on deploy.
migrate((db) => {
  const dao = new Dao(db);

  // Identity fields that stay required; everything else becomes optional.
  const keepRequired = new Set(["uuid", "ownerId"]);

  for (const name of ["sessions", "journal"]) {
    const collection = dao.findCollectionByNameOrId(name);
    if (!collection) continue;

    for (const field of collection.schema.fields()) {
      if (!keepRequired.has(field.name) && field.required) {
        field.required = false;
      }
    }
    dao.saveCollection(collection);
  }
}, (db) => {
  // Down migration: restore the original `required: true` set.
  const dao = new Dao(db);

  const requiredByCollection = {
    sessions: [
      "timestamp",
      "totalDurationMs",
      "nostril",
      "inhaleLengthMs",
      "holdAfterInhaleMs",
      "exhaleLengthMs",
      "holdAfterExhaleMs",
      "completedCycles",
    ],
    journal: [
      "timestamp",
      "expectedFlow",
      "actualFlow",
      "nostril",
      "isAligned",
    ],
  };

  for (const name of Object.keys(requiredByCollection)) {
    const collection = dao.findCollectionByNameOrId(name);
    if (!collection) continue;

    const set = new Set(requiredByCollection[name]);
    for (const field of collection.schema.fields()) {
      if (set.has(field.name)) {
        field.required = true;
      }
    }
    dao.saveCollection(collection);
  }
});
