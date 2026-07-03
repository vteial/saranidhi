/// Tracks sync state for a device participating in iCloud sync.
///
/// Each device registers itself in CloudKit so the primary device
/// can be identified for conflict resolution.
class SyncDeviceInfo {
  const SyncDeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.isPrimary,
    required this.lastSyncTimestamp,
    required this.platform,
  });

  /// Unique identifier for this device (UUID generated on first sync).
  final String deviceId;

  /// Human-readable device name (e.g. "iPhone SE", "iMac").
  final String deviceName;

  /// Whether this device is the primary (wins conflicts).
  final bool isPrimary;

  /// Last time this device successfully synced.
  final DateTime lastSyncTimestamp;

  /// Platform identifier: "ios", "macos".
  final String platform;
}

/// State of the iCloud sync system.
enum SyncState {
  /// Not configured or disabled.
  disabled,

  /// Configured but not currently syncing.
  idle,

  /// Actively pulling remote changes.
  pulling,

  /// Actively pushing local changes.
  pushing,

  /// Sync completed successfully.
  synced,

  /// Sync failed (check error message).
  error,
}

/// Represents the current sync status with details.
class SyncStatus {
  const SyncStatus({
    required this.state,
    this.lastSyncTime,
    this.message,
    this.recordsPushed = 0,
    this.recordsPulled = 0,
  });

  final SyncState state;
  final DateTime? lastSyncTime;
  final String? message;
  final int recordsPushed;
  final int recordsPulled;

  SyncStatus copyWith({
    SyncState? state,
    DateTime? lastSyncTime,
    String? message,
    int? recordsPushed,
    int? recordsPulled,
  }) {
    return SyncStatus(
      state: state ?? this.state,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      message: message ?? this.message,
      recordsPushed: recordsPushed ?? this.recordsPushed,
      recordsPulled: recordsPulled ?? this.recordsPulled,
    );
  }
}
