/// Predefined breathing patterns with specific durations per phase.
///
/// Each preset defines inhale, hold, and exhale durations in seconds.
/// The timer auto-advances through phases using these durations.
class BreathPreset {
  const BreathPreset({
    required this.id,
    required this.nameKey,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    this.holdAfterExhaleSeconds = 0,
    this.descriptionKey,
  });

  /// Unique identifier for the preset.
  final String id;

  /// Localization key for the preset name.
  final String nameKey;

  /// Localization key for the description (optional).
  final String? descriptionKey;

  /// Duration of inhale phase in seconds.
  final int inhaleSeconds;

  /// Duration of hold (after inhale) phase in seconds.
  final int holdSeconds;

  /// Duration of exhale phase in seconds.
  final int exhaleSeconds;

  /// Duration of hold after exhale (for box breathing) in seconds.
  final int holdAfterExhaleSeconds;

  /// Total cycle duration in seconds.
  int get totalSeconds =>
      inhaleSeconds + holdSeconds + exhaleSeconds + holdAfterExhaleSeconds;
}

/// Available breathing presets.
const breathPresets = [
  BreathPreset(
    id: 'relaxing_478',
    nameKey: 'preset478',
    inhaleSeconds: 4,
    holdSeconds: 7,
    exhaleSeconds: 8,
    descriptionKey: 'preset478Desc',
  ),
  BreathPreset(
    id: 'box_breathing',
    nameKey: 'presetBox',
    inhaleSeconds: 4,
    holdSeconds: 4,
    exhaleSeconds: 4,
    holdAfterExhaleSeconds: 4,
    descriptionKey: 'presetBoxDesc',
  ),
  BreathPreset(
    id: 'energizing',
    nameKey: 'presetEnergizing',
    inhaleSeconds: 6,
    holdSeconds: 2,
    exhaleSeconds: 4,
    descriptionKey: 'presetEnergizingDesc',
  ),
  BreathPreset(
    id: 'calming',
    nameKey: 'presetCalming',
    inhaleSeconds: 4,
    holdSeconds: 4,
    exhaleSeconds: 6,
    descriptionKey: 'presetCalmingDesc',
  ),
];
