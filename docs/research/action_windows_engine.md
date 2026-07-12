# Saranidhi Research: Layer 2 — Action Windows Engine Spec

This document details the design, algorithms, and Dart blueprint for the **Action Windows Engine** (Layer 2). 

This engine is responsible for converting raw chronobiological data (Yama durations and Panja Pakshi states) into three actionable lifestyle windows, consolidating them to prevent notification noise, and scheduling local notification alarms in a local-first, privacy-respecting offline environment.

---

## 1. Architectural Overview & State Consolidation

To prevent overwhelming the user with notification spam at every Yama change (which occurs every 2 hours and 24 minutes), the engine consolidates consecutive Yamas that map to the same `ActionWindow`.

### 1.1 The Mapping Logic
The five Panja Pakshi states map to three lifestyle windows:
* **Artha (Material Action):** Active during `Ruling` and `Walking` states. Focuses on execution, meetings, and major decisions.
* **Kriya (Physical Nourishment):** Active during the `Eating` state. Focuses on meals, exercise, reading, and sensory input.
* **Yoga (Spiritual Practice):** Active during `Sleeping` and `Dying` states. Focuses on breath realignment, meditation, rest, and inward reflection.

### 1.2 Consolidation Algorithm
If a user’s bird state progresses from `Walking` in Yama 1 to `Ruling` in Yama 2, both map to the `Artha` window. The engine combines these into a single contiguous `ActionWindowSegment` to avoid sending a notification alert at the Yama boundary.

```
Raw Yamas:      | Yama 1 (Walking) | Yama 2 (Ruling) | Yama 3 (Eating) | Yama 4 (Sleeping) |
Action Windows: | ----- Artha -----| ----- Artha ----| ---- Kriya ---- | ----- Yoga ------ |
Consolidated:   | ------------- Artha ------------- | ---- Kriya ---- | ----- Yoga ------ |
Notification:   [Alert: Artha Begins]                [Alert: Kriya]    [Alert: Yoga]
```

---

## 2. Dart Domain Model: Action Window Segment

The consolidated segment represents a distinct temporal block with localized metadata:

```dart
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';

class ActionWindowSegment {
  final ActionWindow window;
  final DateTime start;
  final DateTime end;
  final String birdStateName;

  const ActionWindowSegment({
    required this.window,
    required this.start,
    required this.end,
    required this.birdStateName,
  });

  Duration get duration => end.difference(start);

  bool contains(DateTime time) {
    return !time.isBefore(start) && time.isBefore(end);
  }
}
```

---

## 3. The Consolidation & Scheduling Algorithm

This engine takes raw day and night Yamas for a 24-hour cycle, resolves the bird states, maps them to Action Windows, and groups consecutive matching windows.

```dart
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

class ActionWindowsEngine {
  /// Aggregates a list of continuous Yamas and their corresponding bird states 
  /// into consolidated Action Window segments.
  static List<ActionWindowSegment> consolidateSegments({
    required List<YamaSegment> dayYamas,
    required List<NightYamaSegment> nightYamas,
    required PakshiDayResult dayPakshi,
    required PakshiDayResult nightPakshi,
    required PakshiBird userBird,
  }) {
    final segments = <ActionWindowSegment>[];

    // Combine Day and Night segments chronologically
    final rawList = <_RawYamaMapping>[];

    for (final yama in dayYamas) {
      final state = dayPakshi.stateForBird(userBird, yama.index);
      rawList.add(_RawYamaMapping(
        start: yama.start,
        end: yama.end,
        state: state,
        window: ActionWindow.fromBirdState(state),
      ));
    }

    for (final yama in nightYamas) {
      // Map Night YamaIndex to corresponding index or lookup (Yama 6 to 10)
      final state = nightPakshi.stateForBird(userBird, YamaIndex.values[yama.index.index]);
      rawList.add(_RawYamaMapping(
        start: yama.start,
        end: yama.end,
        state: state,
        window: ActionWindow.fromBirdState(state),
      ));
    }

    // Sort chronologically to handle seasonal midnight overlaps
    rawList.sort((a, b) => a.start.compareTo(b.start));

    if (rawList.isEmpty) return [];

    var currentWindow = rawList.first.window;
    var segmentStart = rawList.first.start;
    var currentBirdStates = [rawList.first.state.displayName];

    for (var i = 1; i < rawList.length; i++) {
      final current = rawList[i];
      
      if (current.window == currentWindow) {
        // Consolidate: extend the end boundary
        currentBirdStates.add(current.state.displayName);
      } else {
        // Close current segment and push
        segments.add(ActionWindowSegment(
          window: currentWindow,
          start: segmentStart,
          end: rawList[i - 1].end,
          birdStateName: currentBirdStates.toSet().join('/'),
        ));

        // Start new segment
        currentWindow = current.window;
        segmentStart = current.start;
        currentBirdStates = [current.state.displayName];
      }
    }

    // Add trailing segment
    segments.add(ActionWindowSegment(
      window: currentWindow,
      start: segmentStart,
      end: rawList.last.end,
      birdStateName: currentBirdStates.toSet().join('/'),
    ));

    return segments;
  }
}

class _RawYamaMapping {
  final DateTime start;
  final DateTime end;
  final PakshiState state;
  final ActionWindow window;

  const _RawYamaMapping({
    required this.start,
    required this.end,
    required this.state,
    required this.window,
  });
}
```

---

## 4. Local Notification Scheduling (Privacy & Offline First)

Since Saranidhi runs local-first and does not rely on a backend notification server, Kiro Web will schedule alarms directly on the device using `flutter_local_notifications` (or native alarm managers).

### 4.1 Scheduling Window Policy
1. **Trigger Event:** Notification scheduling is triggered on:
   - App startup.
   - Successful logging of a daily breath check.
   - A silent background task running once every 24 hours.
2. **Buffer Horizon:** The engine schedules consolidated windows for the **next 48 hours**. 
3. **Limit Handling:** Operating systems (especially iOS) limit local notifications to **64 active alarms**. Consolidating Yamas guarantees we consume only 4 to 6 notification slots per day, well within OS constraints.

### 4.2 Notification Content Strategy (Bilingual)

To keep notifications engaging, the copy includes the active bird states and the Sanskrit/Tamil traditional context.

```dart
class ActionWindowNotificationBuilder {
  static String getTitle(ActionWindow window, String languageCode) {
    if (languageCode == 'ta') {
      return switch (window) {
        ActionWindow.artha => 'செயல் வடிவம் (அர்த்த ஜன்னல்)',
        ActionWindow.kriya => 'உடல் நலம் (கிரியா ஜன்னல்)',
        ActionWindow.yoga  => 'ஆன்மீகத் தருணம் (யோகா ஜன்னல்)',
      };
    }
    return switch (window) {
      ActionWindow.artha => 'Artha Window Active (Action & Focus)',
      ActionWindow.kriya => 'Kriya Window Active (Nourishment & Rest)',
      ActionWindow.yoga  => 'Yoga Window Active (Realignment & Peace)',
    };
  }

  static String getBody(ActionWindow window, String birdState, String languageCode) {
    if (languageCode == 'ta') {
      return switch (window) {
        ActionWindow.artha => 'உங்கள் பறவை தற்போது $birdState நிலையில் உள்ளது. உலகியல் சார்ந்த முக்கிய முடிவுகளை எடுக்கவும், காரியங்களை ஆரம்பிக்கவும் உகந்த நேரம்.',
        ActionWindow.kriya => 'உங்கள் பறவை தற்போது $birdState நிலையில் உள்ளது. உணவு உட்கொள்ள, கற்க அல்லது உடற்பயிற்சி செய்ய உகந்த நேரம்.',
        ActionWindow.yoga  => 'உங்கள் பறவை தற்போது $birdState நிலையில் உள்ளது. மூச்சை சீரமைக்கவும், தியானம் அல்லது ஓய்வெடுக்கவும் ஏற்ற அமைதியான நேரம்.',
      };
    }
    return switch (window) {
      ActionWindow.artha => 'Your bird is in a $birdState state. Ideal time for strategic decisions, execution, and negotiations.',
      ActionWindow.kriya => 'Your bird is in an $birdState state. Perfect for meals, physical recovery, studying, and rest.',
      ActionWindow.yoga  => 'Your bird is in a $birdState state. Optimal for breathing practices, turning inward, and clearing blockages.',
    };
  }
}
```

---

## 5. Background Sync Sync-up Logic

Kiro Web will implement a Riverpod provider to orchestrate notification scheduling. 

```dart
// Conceptual Provider workflow for Kiro Web
final notificationSchedulerProvider = Provider((ref) {
  return NotificationScheduler(
    localNotificationsPlugin: ref.read(localNotificationsPluginProvider),
    astroEngine: ref.read(astroEngineProvider),
    profileRepository: ref.read(profileRepositoryProvider),
  );
});

class NotificationScheduler {
  final LocalNotificationsPlugin localNotificationsPlugin;
  final AstroEngine astroEngine;
  final ProfileRepository profileRepository;

  NotificationScheduler({
    required this.localNotificationsPlugin,
    required this.astroEngine,
    required this.profileRepository,
  });

  Future<void> scheduleNext48Hours() async {
    final profile = await profileRepository.getProfile();
    if (profile == null) return;

    // 1. Cancel previous scheduled notifications to clear old queue.
    await localNotificationsPlugin.cancelAll();

    // 2. Compute Yamas and Bird States for Today and Tomorrow (48-hour range).
    final segments = _compute48HourSegments(profile);

    // 3. Queue local notifications at the start boundary of each segment.
    var idCounter = 0;
    for (final segment in segments) {
      if (segment.start.isBefore(DateTime.now())) continue;

      final title = ActionWindowNotificationBuilder.getTitle(segment.window, profile.language);
      final body = ActionWindowNotificationBuilder.getBody(segment.window, segment.birdStateName, profile.language);

      await localNotificationsPlugin.schedule(
        idCounter++,
        title,
        body,
        segment.start,
      );
    }
  }

  List<ActionWindowSegment> _compute48HourSegments(ProfileData profile) {
    // Math wrappers calling ActionWindowsEngine.consolidateSegments...
    // Returns chronological segment blocks spanning T_now to T_now + 48h
    return [];
  }
}
```
