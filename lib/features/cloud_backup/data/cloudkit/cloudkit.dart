/// CloudKit sync module for iCloud integration.
///
/// This module provides record-level sync between the local Drift database
/// and Apple's CloudKit private database. It uses a MethodChannel to
/// communicate with native Swift code on iOS/macOS.
///
/// Architecture overview:
/// - `cloudkit_schema.dart` — Record type definitions and field name constants
/// - `cloudkit_record_mapper.dart` — Converts between Drift models and CloudKit fields
/// - `cloudkit_sync_service.dart` — Low-level CloudKit CRUD via MethodChannel
/// - `cloudkit_sync_engine.dart` — High-level sync orchestrator (pull, merge, push)
library;

export 'cloudkit_record_mapper.dart';
export 'cloudkit_schema.dart';
export 'cloudkit_sync_engine.dart';
export 'cloudkit_sync_service.dart';
