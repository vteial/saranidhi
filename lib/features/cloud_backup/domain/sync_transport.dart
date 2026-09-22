/// Scopes for practice data synchronization.
enum SyncScope { sessions, journal }

/// In-memory representation of practice data records for sync transport operations.
class RemoteSyncData {
  const RemoteSyncData({this.sessions = const [], this.journal = const []});

  /// Breath session records as list of maps mirroring database columns.
  final List<Map<String, dynamic>> sessions;

  /// Sara Kalai journal records as list of maps mirroring database columns.
  final List<Map<String, dynamic>> journal;

  bool get isEmpty => sessions.isEmpty && journal.isEmpty;
  bool get isNotEmpty => !isEmpty;
}

/// Abstract transport contract for remote sync backends.
///
/// Designed to be transport-agnostic (e.g. PocketBase, future custom backends),
/// isolating the sync engine from network and SDK specifics.
abstract interface class SyncTransport {
  /// Whether the transport has valid configuration (e.g. non-empty server URL).
  bool get isConfigured;

  /// Whether an authenticated session is currently active.
  bool get isAuthenticated;

  /// The unique record ID of the authenticated user on the backend, or null if unauthenticated.
  String? get authUserId;

  /// Authenticates with the remote backend using email and passphrase.
  Future<void> signIn({required String email, required String passphrase});

  /// Ends the current authenticated session and clears stored tokens.
  Future<void> signOut();

  /// Pulls all remote rows belonging to [ownerId] for the requested [scopes].
  Future<RemoteSyncData> pull({
    required String ownerId,
    required Set<SyncScope> scopes,
  });

  /// Pushes [local] rows belonging to [ownerId] for the requested [scopes].
  ///
  /// Implementations must guarantee idempotent upsert by UUID.
  Future<void> push({
    required String ownerId,
    required RemoteSyncData local,
    required Set<SyncScope> scopes,
  });
}
