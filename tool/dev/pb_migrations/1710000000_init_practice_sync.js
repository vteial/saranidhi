/// PocketBase migration initializing the Practice Sync schema (Sprint 47).
/// Matches Sprint 47 Spec §0 exactly for Fly.io and local Docker Compose.
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
        required: true,
      },
      {
        name: "totalDurationMs",
        type: "number",
        required: true,
      },
      {
        name: "nostril",
        type: "text",
        required: true,
      },
      {
        name: "inhaleLengthMs",
        type: "number",
        required: true,
      },
      {
        name: "holdAfterInhaleMs",
        type: "number",
        required: true,
      },
      {
        name: "exhaleLengthMs",
        type: "number",
        required: true,
      },
      {
        name: "holdAfterExhaleMs",
        type: "number",
        required: true,
      },
      {
        name: "completedCycles",
        type: "number",
        required: true,
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
      "CREATE UNIQUE INDEX idx_sessions_uuid ON sessions (uuid)",
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
        required: true,
      },
      {
        name: "expectedFlow",
        type: "text",
        required: true,
      },
      {
        name: "actualFlow",
        type: "text",
        required: true,
      },
      {
        name: "nostril",
        type: "text",
        required: true,
      },
      {
        name: "isAligned",
        type: "bool",
        required: true,
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
      "CREATE UNIQUE INDEX idx_journal_uuid ON journal (uuid)",
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
