import 'package:drift/drift.dart';

/// User profile table — stores birth star, location, preferences.
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().withDefault(const Constant(''))();
  TextColumn get birthStarNakshatra => text().nullable()();
  TextColumn get birthBird => text().nullable()();
  RealColumn get locationLat => real().nullable()();
  RealColumn get locationLng => real().nullable()();
  // DOB fields for accurate nakshatra calculation (Sprint 21)
  IntColumn get birthDateEpoch => integer().nullable()();
  TextColumn get birthTime => text().nullable()();
  TextColumn get birthPlaceName => text().nullable()();
  RealColumn get birthPlaceLat => real().nullable()();
  RealColumn get birthPlaceLng => real().nullable()();
  TextColumn get theme => text().withDefault(const Constant('light'))();
  TextColumn get language => text().withDefault(const Constant('en'))();
  TextColumn get storageMode => text().withDefault(const Constant('local'))();
  BoolColumn get notifyRuling => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyEating => boolean().withDefault(const Constant(false))();
  TextColumn get lastAiNote => text().nullable()();
  TextColumn get lastAiNoteDate => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sara Kalai breath journal entries.
class SaraKalaiJournal extends Table {
  TextColumn get id => text()();
  IntColumn get timestamp => integer()();
  TextColumn get expectedFlow => text()();
  TextColumn get actualFlow => text()();
  BoolColumn get isAligned => boolean()();
  TextColumn get nostril => text()();
  IntColumn get inhaleDurationMs => integer().nullable()();
  IntColumn get holdDurationMs => integer().nullable()();
  IntColumn get exhaleDurationMs => integer().nullable()();
  TextColumn get activeYama => text().nullable()();
  TextColumn get activeBird => text().nullable()();
  TextColumn get activeBirdState => text().nullable()();
  TextColumn get activeElement => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Breath session recordings with detailed timing.
class BreathSessions extends Table {
  TextColumn get id => text()();
  IntColumn get timestamp => integer()();
  IntColumn get totalDurationMs => integer()();
  TextColumn get nostril => text()();
  IntColumn get inhaleLengthMs => integer()();
  IntColumn get holdAfterInhaleMs => integer()();
  IntColumn get exhaleLengthMs => integer()();
  IntColumn get holdAfterExhaleMs => integer()();
  IntColumn get completedCycles => integer()();
  TextColumn get mood => text().nullable()();
  IntColumn get consciousnessRating => integer().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Bird reference library for Panja Pakshi.
class BirdLibrary extends Table {
  TextColumn get id => text()();
  TextColumn get birdName => text()();
  TextColumn get nakshatraGroup => text()();
  BoolColumn get favorited => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
