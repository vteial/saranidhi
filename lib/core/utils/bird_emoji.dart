import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// Shared utility for consistent Pakshi bird emoji display throughout the app.
///
/// Provides emoji mappings for all five Panja Pakshi birds and their states.
class BirdEmoji {
  const BirdEmoji._();

  /// Returns the emoji for a given [PakshiBird].
  static String forBird(PakshiBird bird) => switch (bird) {
    PakshiBird.vulture => '\u{1F985}', // eagle/vulture
    PakshiBird.owl => '\u{1F989}', // owl
    PakshiBird.crow => '\u{1F426}', // bird (crow)
    PakshiBird.rooster => '\u{1F413}', // rooster
    PakshiBird.peacock => '\u{1F99A}', // peacock
  };

  /// Returns the emoji for a bird name string (from database).
  static String forBirdName(String? birdName) => switch (birdName) {
    'vulture' => '\u{1F985}',
    'owl' => '\u{1F989}',
    'crow' => '\u{1F426}',
    'rooster' => '\u{1F413}',
    'peacock' => '\u{1F99A}',
    _ => '\u{1F426}', // default bird
  };

  /// Returns the emoji for a [PakshiState].
  static String forState(PakshiState state) => switch (state) {
    PakshiState.ruling => '\u{1F451}', // crown
    PakshiState.eating => '\u{1F37D}', // plate with cutlery
    PakshiState.walking => '\u{1F6B6}', // person walking
    PakshiState.sleeping => '\u{1F4A4}', // zzz
    PakshiState.dying => '\u{1F480}', // skull
  };

  /// Returns a display string combining bird emoji + name.
  static String displayLabel(PakshiBird bird) =>
      '${forBird(bird)} ${bird.displayName}';

  /// Returns combined bird + state display.
  static String fullDisplay(PakshiBird bird, PakshiState state) =>
      '${forBird(bird)} ${bird.displayName} — ${forState(state)} ${state.displayName}';
}
