/// Represents the expected or actual breath flow direction.
enum BreathFlow {
  /// Left nostril dominant — Lunar / Ida channel.
  lunar,

  /// Both nostrils equally active — Sushumna channel.
  sushumna,

  /// Right nostril dominant — Solar / Pingala channel.
  solar;

  /// Display name for UI.
  String get displayName => switch (this) {
    BreathFlow.solar => 'Solar (Right)',
    BreathFlow.lunar => 'Lunar (Left)',
    BreathFlow.sushumna => 'Sushumna (Both)',
  };

  /// Short label for compact display.
  String get shortLabel => switch (this) {
    BreathFlow.solar => 'Solar',
    BreathFlow.lunar => 'Lunar',
    BreathFlow.sushumna => 'Both',
  };

  /// Maps to nostril string for DB storage.
  String get nostril => switch (this) {
    BreathFlow.solar => 'right',
    BreathFlow.lunar => 'left',
    BreathFlow.sushumna => 'both',
  };
}
