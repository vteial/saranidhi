import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// Severity levels for nostril stagnancy.
enum StagnancyLevel { none, mild, chronic }

/// Result of a nostril stagnancy analysis over a rolling window.
class StagnancyAnalysisResult {
  const StagnancyAnalysisResult({
    required this.level,
    required this.stuckFlow,
    required this.continuousDuration,
  });

  /// Severity level of the current stagnancy.
  final StagnancyLevel level;

  /// The flow the breath is stuck on (`null` if [level] is [StagnancyLevel.none]).
  final BreathFlow? stuckFlow;

  /// Length of the current stuck run (`Duration.zero` if none).
  final Duration continuousDuration;
}

/// Pure Dart analytics engine for detecting nostril flow stagnancy.
class ChronobiologyAnalytics {
  const ChronobiologyAnalytics._();

  /// Analyzes the most recent contiguous single-flow run within the supplied logs
  /// (caller passes the rolling-24h window, newest-first or oldest-first — normalize
  /// inside). Returns `none` when < 3 logs or the latest run is short.
  static StagnancyAnalysisResult analyze(List<SaraKalaiJournalData> logs) {
    if (logs.length < 3) {
      return const StagnancyAnalysisResult(
        level: StagnancyLevel.none,
        stuckFlow: null,
        continuousDuration: Duration.zero,
      );
    }

    // Sort chronologically (oldest to newest)
    final sorted = List<SaraKalaiJournalData>.from(logs)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // The most recent entry
    final latest = sorted.last;
    final latestFlow = _parseFlow(latest.actualFlow);

    // If latest is Sushumna or unrecognized, there is no stagnancy
    // (Sushumna breaks a run and is neutral).
    if (latestFlow == null || latestFlow == BreathFlow.sushumna) {
      return const StagnancyAnalysisResult(
        level: StagnancyLevel.none,
        stuckFlow: null,
        continuousDuration: Duration.zero,
      );
    }

    // Find the start of the contiguous run matching latestFlow backwards from the end
    var startIndex = sorted.length - 1;
    while (startIndex > 0) {
      final prevFlow = _parseFlow(sorted[startIndex - 1].actualFlow);
      if (prevFlow == latestFlow) {
        startIndex--;
      } else {
        break;
      }
    }

    final runCount = sorted.length - startIndex;
    if (runCount < 3) {
      return const StagnancyAnalysisResult(
        level: StagnancyLevel.none,
        stuckFlow: null,
        continuousDuration: Duration.zero,
      );
    }

    final firstTime = DateTime.fromMillisecondsSinceEpoch(
      sorted[startIndex].timestamp,
    );
    final lastTime = DateTime.fromMillisecondsSinceEpoch(latest.timestamp);
    final duration = lastTime.difference(firstTime);

    if (duration >= const Duration(hours: 8) && runCount >= 4) {
      return StagnancyAnalysisResult(
        level: StagnancyLevel.chronic,
        stuckFlow: latestFlow,
        continuousDuration: duration,
      );
    }

    if (duration >= const Duration(hours: 6) && runCount >= 3) {
      return StagnancyAnalysisResult(
        level: StagnancyLevel.mild,
        stuckFlow: latestFlow,
        continuousDuration: duration,
      );
    }

    return const StagnancyAnalysisResult(
      level: StagnancyLevel.none,
      stuckFlow: null,
      continuousDuration: Duration.zero,
    );
  }

  static BreathFlow? _parseFlow(String raw) {
    final normalized = raw.trim().toLowerCase();
    return switch (normalized) {
      'solar' || 'right' => BreathFlow.solar,
      'lunar' || 'left' => BreathFlow.lunar,
      'sushumna' || 'both' => BreathFlow.sushumna,
      _ => null,
    };
  }
}
