/// Schema-introspection helpers for Drift migrations.
///
/// These utilities make [MigrationStrategy.onUpgrade] steps idempotent by
/// checking the live SQLite schema before adding a column or creating a
/// table. This guards against the "duplicate column name" / "table already
/// exists" failure class that can occur when a database was created fresh at
/// a later schema version and then walks through the same `onUpgrade` steps.
///
/// Both helpers accept any [GeneratedDatabase] (such as `AppDatabase`) and use
/// its `customSelect` to introspect the schema, so they can be called directly
/// from within `onUpgrade` and unit-tested against an in-memory database.
library;

import 'package:drift/drift.dart';

/// Returns whether [tableName] contains a column named [columnName].
///
/// Uses `PRAGMA table_info('<table>')` and inspects the `name` field of each
/// returned row. Call before [Migrator.addColumn] to avoid a "duplicate column
/// name" error on databases already created at the newer schema.
Future<bool> columnExists(
  GeneratedDatabase db,
  String tableName,
  String columnName,
) async {
  final rows = await db.customSelect("PRAGMA table_info('$tableName')").get();
  return rows.any((row) => row.read<String>('name') == columnName);
}

/// Returns whether a table named [tableName] exists in the database.
///
/// Queries `sqlite_master` for a `type='table'` entry matching [tableName].
/// Call before [Migrator.createTable] to avoid recreating a table that a
/// fresh-at-newer-version database already has.
Future<bool> tableExists(GeneratedDatabase db, String tableName) async {
  final rows = await db.customSelect(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
  ).get();
  return rows.isNotEmpty;
}
