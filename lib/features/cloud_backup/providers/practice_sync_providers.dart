import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/cloud_backup/data/pocketbase_sync_transport.dart';
import 'package:saranidhi/features/cloud_backup/domain/practice_sync_engine.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_transport.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/settings/domain/owner_identity_service.dart';
import 'package:saranidhi/features/settings/presentation/merge_import_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kSyncEnabledKey = 'sync_enabled';
const _kSyncScopeSessionsKey = 'sync_scope_sessions';
const _kSyncScopeJournalKey = 'sync_scope_journal';
const _kSyncServerUrlKey = 'sync_server_url';
const _kSyncUserEmailKey = 'sync_user_email';
const _kSyncLastSyncedEpochKey = 'sync_last_synced_epoch';

const kDefaultPocketBaseUrl = String.fromEnvironment(
  'POCKETBASE_URL',
  defaultValue: 'http://localhost:8090',
);

/// Persistent configuration for Practice Sync.
class PracticeSyncConfig {
  const PracticeSyncConfig({
    this.enabled = false,
    this.scopeSessions = true,
    this.scopeJournal = true,
    this.serverUrl = kDefaultPocketBaseUrl,
    this.userEmail,
    this.lastSyncedEpoch,
  });

  /// Master consent-gate opt-in toggle. Default false (zero network traffic when off).
  final bool enabled;

  /// Whether breath session events are included in sync.
  final bool scopeSessions;

  /// Whether breath journal events are included in sync.
  final bool scopeJournal;

  /// Base URL of the PocketBase backend instance (Fly.io or local Compose).
  final String serverUrl;

  /// The email address of the authenticated PocketBase user, if known.
  final String? userEmail;

  /// Epoch ms timestamp of the most recent successful sync.
  final int? lastSyncedEpoch;

  DateTime? get lastSyncedAt => lastSyncedEpoch != null
      ? DateTime.fromMillisecondsSinceEpoch(lastSyncedEpoch!)
      : null;

  Set<SyncScope> get activeScopes => {
    if (scopeSessions) SyncScope.sessions,
    if (scopeJournal) SyncScope.journal,
  };

  PracticeSyncConfig copyWith({
    bool? enabled,
    bool? scopeSessions,
    bool? scopeJournal,
    String? serverUrl,
    String? Function()? userEmail,
    int? Function()? lastSyncedEpoch,
  }) {
    return PracticeSyncConfig(
      enabled: enabled ?? this.enabled,
      scopeSessions: scopeSessions ?? this.scopeSessions,
      scopeJournal: scopeJournal ?? this.scopeJournal,
      serverUrl: serverUrl ?? this.serverUrl,
      userEmail: userEmail != null ? userEmail() : this.userEmail,
      lastSyncedEpoch: lastSyncedEpoch != null
          ? lastSyncedEpoch()
          : this.lastSyncedEpoch,
    );
  }
}

/// Provides and persists [PracticeSyncConfig] in SharedPreferences.
final practiceSyncConfigProvider =
    NotifierProvider<PracticeSyncConfigNotifier, PracticeSyncConfig>(
      PracticeSyncConfigNotifier.new,
    );

class PracticeSyncConfigNotifier extends Notifier<PracticeSyncConfig> {
  bool _isLoaded = false;

  @override
  PracticeSyncConfig build() {
    _load();
    return const PracticeSyncConfig();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (_isLoaded) return;
    _isLoaded = true;
    state = PracticeSyncConfig(
      enabled: prefs.getBool(_kSyncEnabledKey) ?? state.enabled,
      scopeSessions:
          prefs.getBool(_kSyncScopeSessionsKey) ?? state.scopeSessions,
      scopeJournal: prefs.getBool(_kSyncScopeJournalKey) ?? state.scopeJournal,
      serverUrl: prefs.getString(_kSyncServerUrlKey) ?? state.serverUrl,
      userEmail: prefs.getString(_kSyncUserEmailKey) ?? state.userEmail,
      lastSyncedEpoch:
          prefs.getInt(_kSyncLastSyncedEpochKey) ?? state.lastSyncedEpoch,
    );
  }

  Future<void> setEnabled({required bool enabled}) async {
    _isLoaded = true;
    state = state.copyWith(enabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSyncEnabledKey, enabled);
  }

  Future<void> setScopeSessions({required bool enabled}) async {
    _isLoaded = true;
    state = state.copyWith(scopeSessions: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSyncScopeSessionsKey, enabled);
  }

  Future<void> setScopeJournal({required bool enabled}) async {
    _isLoaded = true;
    state = state.copyWith(scopeJournal: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSyncScopeJournalKey, enabled);
  }

  Future<void> setServerUrl(String url) async {
    _isLoaded = true;
    final trimmed = url.trim();
    state = state.copyWith(serverUrl: trimmed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSyncServerUrlKey, trimmed);
  }

  Future<void> setUserEmail(String? email) async {
    _isLoaded = true;
    state = state.copyWith(userEmail: () => email);
    final prefs = await SharedPreferences.getInstance();
    if (email != null) {
      await prefs.setString(_kSyncUserEmailKey, email);
    } else {
      await prefs.remove(_kSyncUserEmailKey);
    }
  }

  Future<void> setLastSynced(DateTime dt) async {
    _isLoaded = true;
    final epoch = dt.millisecondsSinceEpoch;
    state = state.copyWith(lastSyncedEpoch: () => epoch);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kSyncLastSyncedEpochKey, epoch);
  }
}

/// Stable provider for the shared PocketBase `AuthStore`.
///
/// Hoisting ensures that recreating the transport does not discard
/// the in-memory or persisted auth state.
final practiceSyncAuthStoreProvider = Provider<AuthStore>((ref) {
  return SharedPreferencesAuthStore();
});

/// Provides the active `SyncTransport` implementation.
///
/// Only rebuilds when the server URL changes, preserving the transport instance
/// across scope, email, or timestamp config mutations.
final practiceSyncTransportProvider = Provider<SyncTransport>((ref) {
  final serverUrl = ref.watch(
    practiceSyncConfigProvider.select((c) => c.serverUrl),
  );
  final authStore = ref.watch(practiceSyncAuthStoreProvider);
  return PocketBaseSyncTransport(
    baseUrl: serverUrl,
    authStore: authStore,
  );
});

/// Provides the [PracticeSyncEngine].
final practiceSyncEngineProvider = Provider<PracticeSyncEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final transport = ref.watch(practiceSyncTransportProvider);
  final ownerIdentityService = ref.watch(ownerIdentityServiceProvider);
  final exporter = ref.watch(databaseExporterProvider);

  return PracticeSyncEngine(
    db: db,
    transport: transport,
    ownerIdentityService: ownerIdentityService,
    exporter: exporter,
  );
});

/// State for practice sync operations.
class PracticeSyncState {
  const PracticeSyncState({
    this.isSyncing = false,
    this.isSigningIn = false,
    this.isAuthenticated = false,
    this.lastOutcome,
    this.errorMessage,
  });

  final bool isSyncing;
  final bool isSigningIn;
  final bool isAuthenticated;
  final SyncOutcome? lastOutcome;
  final String? errorMessage;

  PracticeSyncState copyWith({
    bool? isSyncing,
    bool? isSigningIn,
    bool? isAuthenticated,
    SyncOutcome? Function()? lastOutcome,
    String? Function()? errorMessage,
  }) {
    return PracticeSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      isSigningIn: isSigningIn ?? this.isSigningIn,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      lastOutcome: lastOutcome != null ? lastOutcome() : this.lastOutcome,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

/// Notifier coordinating UI sync triggers, auth changes, and error reporting.
final practiceSyncNotifierProvider =
    NotifierProvider<PracticeSyncNotifier, PracticeSyncState>(
      PracticeSyncNotifier.new,
    );

class PracticeSyncNotifier extends Notifier<PracticeSyncState> {
  StreamSubscription<AuthStoreEvent>? _authSub;

  @override
  PracticeSyncState build() {
    final transport = ref.watch(practiceSyncTransportProvider);
    _initAuth(transport);
    return PracticeSyncState(isAuthenticated: transport.isAuthenticated);
  }

  void _initAuth(SyncTransport transport) {
    if (transport is PocketBaseSyncTransport) {
      _authSub?.cancel();
      _authSub = transport.authStore.onChange.listen((event) {
        final authed = transport.isAuthenticated;
        if (state.isAuthenticated != authed) {
          state = state.copyWith(isAuthenticated: authed);
        }
      });
      ref.onDispose(() => _authSub?.cancel());

      transport.rehydrateAuth().then((authed) {
        if (state.isAuthenticated != authed) {
          state = state.copyWith(isAuthenticated: authed);
        }
      });
    }
  }

  /// Performs an on-demand sync cycle if enabled.
  Future<SyncOutcome?> syncNow() async {
    final config = ref.read(practiceSyncConfigProvider);
    if (!config.enabled) {
      return null;
    }

    state = state.copyWith(isSyncing: true);

    final engine = ref.read(practiceSyncEngineProvider);
    final outcome = await engine.performSync(scopes: config.activeScopes);

    if (outcome.isSuccess) {
      if (outcome.syncedAt != null) {
        await ref
            .read(practiceSyncConfigProvider.notifier)
            .setLastSynced(outcome.syncedAt!);
      }
      // Refresh all dependent dashboard, journal, streak, and profile providers
      invalidateAllDataProvidersWithRef(ref);
    }

    final transport = ref.read(practiceSyncTransportProvider);
    state = state.copyWith(
      isSyncing: false,
      isAuthenticated: transport.isAuthenticated,
      lastOutcome: () => outcome,
      errorMessage: () => outcome.error,
    );

    return outcome;
  }

  /// Signs in to PocketBase with email and passphrase.
  Future<bool> signIn({
    required String email,
    required String passphrase,
  }) async {
    state = state.copyWith(
      isSigningIn: true,
      errorMessage: () => null,
    );

    try {
      final transport = ref.read(practiceSyncTransportProvider);
      await transport.signIn(email: email, passphrase: passphrase);
      await ref.read(practiceSyncConfigProvider.notifier).setUserEmail(email);

      final pbUserId = transport.authUserId;
      if (pbUserId != null && pbUserId.isNotEmpty) {
        await ref.read(ownerIdentityServiceProvider).bindOwnerId(pbUserId);
        ref.invalidate(ownerIdProvider);
      }

      state = state.copyWith(
        isSigningIn: false,
        isAuthenticated: transport.isAuthenticated,
        errorMessage: () => null,
      );
      return true;
    } on Object catch (e) {
      state = state.copyWith(
        isSigningIn: false,
        errorMessage: e.toString,
      );
      return false;
    }
  }

  /// Signs out of the current PocketBase account.
  Future<void> signOut() async {
    final transport = ref.read(practiceSyncTransportProvider);
    await transport.signOut();
    await ref.read(practiceSyncConfigProvider.notifier).setUserEmail(null);
    state = state.copyWith(
      isAuthenticated: false,
      errorMessage: () => null,
    );
  }
}
