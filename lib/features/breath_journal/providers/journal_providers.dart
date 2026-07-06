import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/providers/profile_location_provider.dart';
import 'package:saranidhi/core/utils/timezone_utils.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/breath_journal/data/journal_repository.dart';
import 'package:saranidhi/features/breath_journal/domain/alignment_checker.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_trigger_service.dart';

/// Provides the [JournalRepository] instance.
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return JournalRepository(db);
});

/// Watches all journal entries reactively.
final journalEntriesProvider = StreamProvider<List<SaraKalaiJournalData>>((
  ref,
) {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.watchAllEntries();
});

/// State for the breath entry flow.
class BreathEntryState {
  const BreathEntryState({
    this.selectedFlow,
    this.alignmentResult,
    this.isSubmitting = false,
    this.lastEntryId,
  });

  final BreathFlow? selectedFlow;
  final AlignmentResult? alignmentResult;
  final bool isSubmitting;
  final String? lastEntryId;

  BreathEntryState copyWith({
    BreathFlow? selectedFlow,
    AlignmentResult? alignmentResult,
    bool? isSubmitting,
    String? lastEntryId,
  }) {
    return BreathEntryState(
      selectedFlow: selectedFlow ?? this.selectedFlow,
      alignmentResult: alignmentResult ?? this.alignmentResult,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lastEntryId: lastEntryId ?? this.lastEntryId,
    );
  }
}

/// Manages the breath entry interaction state.
final breathEntryNotifierProvider =
    NotifierProvider<BreathEntryNotifier, BreathEntryState>(
      BreathEntryNotifier.new,
    );

class BreathEntryNotifier extends Notifier<BreathEntryState> {
  @override
  BreathEntryState build() => const BreathEntryState();

  /// Select a breath flow and check alignment.
  void selectFlow(BreathFlow flow) {
    // Read cached profile location (defaults to Chennai if not yet loaded)
    final locationAsync = ref.read(profileLocationProvider);
    final location = locationAsync.valueOrNull ?? const ProfileLocation();

    final utcOffset = TimezoneUtils.offsetForLocation(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    final alignment = AlignmentChecker.check(
      actualFlow: flow,
      time: DateTime.now(),
      latitude: location.latitude,
      longitude: location.longitude,
      utcOffset: utcOffset,
    );

    state = state.copyWith(selectedFlow: flow, alignmentResult: alignment);
  }

  /// Submit the current breath entry to the database.
  Future<void> submitEntry({
    int? inhaleDurationMs,
    int? holdDurationMs,
    int? exhaleDurationMs,
  }) async {
    final flow = state.selectedFlow;
    final alignment = state.alignmentResult;
    if (flow == null || alignment == null) return;

    state = state.copyWith(isSubmitting: true);

    final repo = ref.read(journalRepositoryProvider);
    final id = await repo.insertEntry(
      expectedFlow: alignment.expectedFlow.name,
      actualFlow: flow.name,
      isAligned: alignment.isAligned,
      nostril: flow.nostril,
      inhaleDurationMs: inhaleDurationMs,
      holdDurationMs: holdDurationMs,
      exhaleDurationMs: exhaleDurationMs,
      activeYama: alignment.activeYama?.name,
      activeBird: alignment.activeBird?.name,
      activeBirdState: alignment.activeBirdState?.name,
    );

    // Push to iCloud if sync is enabled
    final syncTrigger = ref.read(syncTriggerServiceProvider);
    final db = ref.read(appDatabaseProvider);
    final entry = await (db.select(db.saraKalaiJournal)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (entry != null) {
      await syncTrigger.onJournalEntryCreated(entry);
    }

    state = BreathEntryState(lastEntryId: id);
  }

  /// Reset the entry state for a new entry.
  void reset() {
    state = const BreathEntryState();
  }
}

/// Phases of the breath timer.
enum TimerPhase { idle, inhale, hold, exhale, complete }

/// State for the breath timer.
class BreathTimerState {
  const BreathTimerState({
    this.isRunning = false,
    this.phase = TimerPhase.idle,
    this.elapsedMs = 0,
    this.inhaleMs = 0,
    this.holdMs = 0,
    this.exhaleMs = 0,
  });

  final bool isRunning;
  final TimerPhase phase;
  final int elapsedMs;
  final int inhaleMs;
  final int holdMs;
  final int exhaleMs;

  int get totalMs => inhaleMs + holdMs + exhaleMs;
}

/// Manages the breath duration timer state.
final breathTimerNotifierProvider =
    NotifierProvider<BreathTimerNotifier, BreathTimerState>(
      BreathTimerNotifier.new,
    );

class BreathTimerNotifier extends Notifier<BreathTimerState> {
  @override
  BreathTimerState build() => const BreathTimerState();

  void startInhale() {
    state = const BreathTimerState(isRunning: true, phase: TimerPhase.inhale);
  }

  void finishInhale(int durationMs) {
    state = BreathTimerState(
      isRunning: true,
      phase: TimerPhase.hold,
      inhaleMs: durationMs,
    );
  }

  void finishHold(int durationMs) {
    state = BreathTimerState(
      isRunning: true,
      phase: TimerPhase.exhale,
      inhaleMs: state.inhaleMs,
      holdMs: durationMs,
    );
  }

  void finishExhale(int durationMs) {
    state = BreathTimerState(
      phase: TimerPhase.complete,
      inhaleMs: state.inhaleMs,
      holdMs: state.holdMs,
      exhaleMs: durationMs,
    );
  }

  void reset() {
    state = const BreathTimerState();
  }
}
