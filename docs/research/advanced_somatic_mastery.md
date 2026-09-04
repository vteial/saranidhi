# Saranidhi — Advanced Somatic Mastery Specs (Post-v2.0 Backend Backlog)

**Architectural Scope:** Pure Dart Domain Core + Analytics Calculations

---

## 1. Somatic Intervention Engine

> **Status:** ✅ Implemented in Sprint 35 (v1.5.0). See `lib/features/somatic/`
> (`domain/somatic_intervention_session.dart`, `data/somatic_intervention_repository.dart`,
> `presentation/somatic_timer_room.dart` + widgets). The `[Clear Breath Channel]`
> action is wired into `AlignmentResultWidget` (shown on unaligned breath entries),
> and sessions are persisted to the `SomaticInterventionLogs` table (schema v5).

The Somatic Intervention Engine handles guided, time-bound physiological protocols to help the user actively shift their breath channel (nostril dominance) when the diagnostic layer flags them as unaligned (`OracleStatus.blocked`).

### 1.1 Cross-Lateral Physiological Mapping
Respiratory channels respond to contralateral pressure. The engine must serve the correct instructions based on the desired target channel (e.g., shifting to Left to match Lunar, or Right to match Solar):

| Target Channel | Posture Shift (Lateral Recumbency) | Axillary Pressure (Yoga Danda Mode) |
| :--- | :--- | :--- |
| **Ida (Left Nostril / Lunar)** | Lie on the **Right side** of the body | Apply pressure under the **Right armpit** |
| **Pingala (Right Nostril / Solar)** | Lie on the **Left side** of the body | Apply pressure under the **Left armpit** |

### 1.2 UX State Machine & Workflow
1. **The Intervention Prompt:** If a journal entry or real-time query returns `OracleStatus.blocked`, the UI flags a recommendation card with a `[Clear Breath Channel]` action.
2. **The Selector Modal:** Tapping the action opens a bottom sheet proposing the two options above.
3. **The Active Pacer Room:** Once a protocol is selected, the engine initializes a `SomaticInterventionSession` and displays:
   - Contralateral alignment instructions (e.g., "Lie on your Right side to clear the Left nostril").
   - A breathing pacer animation set to equal-ratio breathing (Sama Vritti: 4s inhale, 4s hold, 4s exhale, 4s hold).
   - High-contrast countdown timer: **180 seconds** for Posture Shift, **300 seconds** for Axillary Pressure.
4. **The Validation Loop:** Immediately upon timer completion, the engine launches a post-session verification flow (`GuidedNostrilTest`). The user logs their active nostril, and the engine evaluates the session's success.

### 1.3 Dart Domain representation

```dart
enum InterventionType { postureShift, axillaryPressure }

enum SomaticSessionStatus { active, completed, cancelled }

class SomaticInterventionSession {
  final String id;
  final DateTime startTime;
  final InterventionType type;
  final String targetFlow;  // 'left' or 'right'
  final String initialFlow; // 'left' or 'right'
  
  const SomaticInterventionSession({
    required this.id,
    required this.startTime,
    required this.type,
    required this.targetFlow,
    required this.initialFlow,
  });

  /// Evaluates whether the post-intervention flow matches the target.
  bool evaluateSuccess(String postInterventionFlow) {
    return postInterventionFlow == targetFlow;
  }
}
```

---

## 2. Chronobiology Analytics Engine

The Chronobiology Analytics Engine scans historical data logs to detect chronic nostril stagnancy, warning the user of potential metabolic or autonomic imbalances according to *Siva Swarodaya* principles (where prolonged single-nostril flow indicates excess heat or cold).

### 2.1 The Stagnancy Detection Algorithm
To prevent false positives from users logging multiple entries in rapid succession (e.g., logging three entries within 10 minutes), the engine utilizes a **Time-Weighted Chronological Sliding Window**.

#### Mathematical Criteria:
Let a sequence of $n$ journal entries logged within a rolling 24-hour window be sorted chronologically: $E_1, E_2, \dots, E_n$.
1. Identify a contiguous sub-sequence $S = [E_i, \dots, E_k]$ where the logged `actualFlow` is identical (all `left` or all `right`).
2. Calculate the locked duration:
   $$\text{Duration} = T(E_k) - T(E_i)$$
3. **Mild Stagnancy:** Triggered if $\text{Duration} \ge 6\text{ hours}$ AND count of entries $|S| \ge 3$.
4. **Chronic Stagnancy:** Triggered if $\text{Duration} \ge 8\text{ hours}$ AND count of entries $|S| \ge 4$.

### 2.2 Dart Analytical Logic Implementation

```dart
enum StagnancyLevel { none, mild, chronic }

class StagnancyAnalysisResult {
  final StagnancyLevel level;
  final String stuckFlow; // 'left' (excess cold) or 'right' (excess heat)
  final Duration continuousDuration;

  const StagnancyAnalysisResult({
    required this.level,
    required this.stuckFlow,
    required this.continuousDuration,
  });
}

class ChronobiologyAnalytics {
  static StagnancyAnalysisResult analyze(List<SaraKalaiJournalData> logs) {
    if (logs.length < 3) {
      return const StagnancyAnalysisResult(
        level: StagnancyLevel.none,
        stuckFlow: '',
        continuousDuration: Duration.zero,
      );
    }

    // Sort chronologically (oldest to newest)
    final sorted = List<SaraKalaiJournalData>.from(logs)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var currentStuckFlow = sorted.first.actualFlow;
    var sequenceStart = DateTime.fromMillisecondsSinceEpoch(sorted.first.timestamp);
    var sequenceCount = 1;
    
    var maxDuration = Duration.zero;
    var maxLevel = StagnancyLevel.none;
    var finalStuckFlow = '';

    for (var i = 1; i < sorted.length; i++) {
      final log = sorted[i];
      final logTime = DateTime.fromMillisecondsSinceEpoch(log.timestamp);
      
      if (log.actualFlow == currentStuckFlow) {
        sequenceCount++;
        final currentDuration = logTime.difference(sequenceStart);
        
        if (currentDuration > maxDuration) {
          maxDuration = currentDuration;
          finalStuckFlow = currentStuckFlow;
        }
      } else {
        // Evaluate completed sequence before resetting
        final completedDuration = DateTime.fromMillisecondsSinceEpoch(sorted[i - 1].timestamp)
            .difference(sequenceStart);
            
        final level = _evaluateLevel(sequenceCount, completedDuration);
        if (level.index > maxLevel.index) {
          maxLevel = level;
          maxDuration = completedDuration;
          finalStuckFlow = currentStuckFlow;
        }

        // Reset tracking sequence
        currentStuckFlow = log.actualFlow;
        sequenceStart = logTime;
        sequenceCount = 1;
      }
    }

    // Final evaluation check for the trailing sequence
    final trailingDuration = DateTime.fromMillisecondsSinceEpoch(sorted.last.timestamp)
        .difference(sequenceStart);
    final trailingLevel = _evaluateLevel(sequenceCount, trailingDuration);
    
    if (trailingLevel.index > maxLevel.index) {
      maxLevel = trailingLevel;
      maxDuration = trailingDuration;
      finalStuckFlow = currentStuckFlow;
    }

    return StagnancyAnalysisResult(
      level: maxLevel,
      stuckFlow: finalStuckFlow,
      continuousDuration: maxDuration,
    );
  }

  static StagnancyLevel _evaluateLevel(int count, Duration duration) {
    if (duration >= const Duration(hours: 8) && count >= 4) {
      return StagnancyLevel.chronic;
    }
    if (duration >= const Duration(hours: 6) && count >= 3) {
      return StagnancyLevel.mild;
    }
    return StagnancyLevel.none;
  }
}
```

### 2.3 Thermal Lifestyle Recommendations
Based on the derived stagnancy output, Saranidhi serves correction suggestions focused on thermal homeostasis:
* **Stuck Right Nostril (Pingala / Excess Surya / Hot):**
  - *Manifestation:* Elevated metabolic heat, dry skin, restlessness.
  - *Remedy:* cooling breathwork (Sheetali Pranayama), cold water splash, raw cooling fluids.
* **Stuck Left Nostril (Ida / Excess Chandra / Cold):**
  - *Manifestation:* Lethargy, slow digestion, sluggishness.
  - *Remedy:* Warming breathwork (Surya Bhedana), consuming ginger/black pepper tea, vigorous physical movement.

---

## 3. Database Schema Extension (Drift)

To trace somatic intervention effectiveness over time, Kiro Web will introduce a new table schema mapping details of the user's somatic attempts:

```dart
/// Tracks historical intervention sessions and their success rates.
class SomaticInterventionLogs extends Table {
  TextColumn get id => text()();
  IntColumn get timestamp => integer()();
  TextColumn get protocolType => text()(); // 'postureShift' or 'axillaryPressure'
  TextColumn get targetFlow => text()();    // 'left' or 'right'
  TextColumn get initialFlow => text()();   // 'left' or 'right'
  TextColumn get resolvedFlow => text().nullable()(); // Logged after verification
  BoolColumn get isSuccess => boolean().withDefault(const Constant(false))();
  IntColumn get durationSeconds => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
```