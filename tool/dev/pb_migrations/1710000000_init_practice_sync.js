/// PocketBase migration initializing the Practice Sync schema (Sprint 47).
/// Matches Sprint 47 Spec §0 exactly for Fly.io and local Docker Compose.
///
/// v1.13.0 SCHEMA FIX: Only the IDENTITY fields (uuid, ownerId) are `required`.
/// All DATA fields are `required: false` because PocketBase's `required` validator
/// rejects a field type's ZERO VALUE (bool `false`, number `0`, empty text) with
/// `validation_required` — which would reject legitimate rows such as a misaligned
/// journal entry (isAligned:false) or a session with holdAfterExhaleMs:0. The app
/// always sends these fields (mappers apply defaults), so DB-level `required` adds
/// no safety and only breaks sync on falsy data. Identity fields keep min:1 so they
/// must be present and non-empty (ownerId isolation is also enforced by createRule).
migrate((db) => {
  const dao = new Dao(db);

  // 1. Collection: sessions (mirrors Drift BreathSessions)
  const sessions = new Collection({
    name: "sessions",
    type: "base",
    listRule: '@request.auth.id != "" && ownerId = @request.auth.id',
    viewRule: '@request.auth.id != "" && ownerId = @request.auth.id',
    createRule: '@request.auth.id != "" && ownerId = @request.auth.id',
    updateRule: '@request.auth.id != "" && ownerId = @request.auth.id',
    deleteRule: null, // append-only: deletes disabled via API
    schema: [
      {
        name: "uuid",
        type: "text",
        required: true,
        options: { min: 1, max: 100 },
      },
      {
        name: "ownerId",
        type: "text",
        required: true,
        options: { min: 1, max: 100 },
      },
      {
        name: "timestamp",
        type: "number",
        required: false,
      },
      {
        name: "totalDurationMs",
        type: "number",
        required: false,
      },
      {
        name: "nostril",
        type: "text",
        required: false,
      },
      {
        name: "inhaleLengthMs",
        type: "number",
        required: false,
      },
      {
        name: "holdAfterInhaleMs",
        type: "number",
        required: false,
      },
      {
        name: "exhaleLengthMs",
        type: "number",
        required: false,
      },
      {
        name: "holdAfterExhaleMs",
        type: "number",
        required: false,
      },
      {
        name: "completedCycles",
        type: "number",
        required: false,
      },
      {
        name: "mood",
        type: "text",
        required: false,
      },
      {
        name: "consciousnessRating",
        type: "number",
        required: false,
      },
      {
        name: "notes",
        type: "text",
        required: false,
      },
    ],
    indexes: [
      // uuid is unique PER OWNER (not globally) — two owners may hold the same
      // uuid (e.g. the same physical row synced under two accounts) without a
      // collision. Matches the engine's ownerId+uuid upsert logic.
      "CREATE UNIQUE INDEX idx_sessions_owner_uuid ON sessions (ownerId, uuid)",
      "CREATE INDEX idx_sessions_ownerId ON sessions (ownerId)",
    ],
  });
  dao.saveCollection(sessions);

  // 2. Collection: journal (mirrors Drift SaraKalaiJournal)
  const journal = new Collection({
    name: "journal",
    type: "base",
    listRule: '@request.auth.id != "" && ownerId = @request.auth.id',
    viewRule: '@request.auth.id != "" && ownerId = @request.auth.id',
    createRule: '@request.auth.id != "" && ownerId = @request.auth.id',
    updateRule: '@request.auth.id != "" && ownerId = @request.auth.id',
    deleteRule: null, // append-only: deletes disabled via API
    schema: [
      {
        name: "uuid",
        type: "text",
        required: true,
        options: { min: 1, max: 100 },
      },
      {
        name: "ownerId",
        type: "text",
        required: true,
        options: { min: 1, max: 100 },
      },
      {
        name: "timestamp",
        type: "number",
        required: false,
      },
      {
        name: "expectedFlow",
        type: "text",
        required: false,
      },
      {
        name: "actualFlow",
        type: "text",
        required: false,
      },
      {
        name: "nostril",
        type: "text",
        required: false,
      },
      {
        name: "isAligned",
        type: "bool",
        required: false,
      },
      {
        name: "inhaleDurationMs",
        type: "number",
        required: false,
      },
      {
        name: "holdDurationMs",
        type: "number",
        required: false,
      },
      {
        name: "exhaleDurationMs",
        type: "number",
        required: false,
      },
      {
        name: "activeYama",
        type: "text",
        required: false,
      },
      {
        name: "activeBird",
        type: "text",
        required: false,
      },
      {
        name: "activeBirdState",
        type: "text",
        required: false,
      },
      {
        name: "activeElement",
        type: "text",
        required: false,
      },
      {
        name: "notes",
        type: "text",
        required: false,
      },
      {
        name: "isPinned",
        type: "bool",
        required: false,
      },
      {
        name: "wasForcedShift",
        type: "bool",
        required: false,
      },
    ],
    indexes: [
      // uuid is unique PER OWNER (not globally) — see sessions note above.
      "CREATE UNIQUE INDEX idx_journal_owner_uuid ON journal (ownerId, uuid)",
      "CREATE INDEX idx_journal_ownerId ON journal (ownerId)",
    ],
  });
  dao.saveCollection(journal);
}, (db) => {
  const dao = new Dao(db);
  try {
    const s = dao.findCollectionByNameOrId("sessions");
    dao.deleteCollection(s);
  } catch (_) {}
  try {
    const j = dao.findCollectionByNameOrId("journal");
    dao.deleteCollection(j);
  } catch (_) {}
});
