import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// The three actionable lifestyle windows derived from the current bird state.
///
/// Maps the 5 Panja Pakshi states into 3 practical action categories:
/// - **Artha** (Material Action): Outbound worldly tasks, decisions, execution
/// - **Kriya** (Physical Nourishment): Food, exercise, learning, absorption
/// - **Yoga** (Spiritual Practice): Meditation, breath work, withdrawal
///
/// This mapping is the foundation for Layer 2 (Action Windows Engine).
enum ActionWindow {
  /// Material action window — negotiations, signatures, bold decisions.
  /// Active during Ruling and Walking bird states.
  artha,

  /// Physical nourishment window — eating, exercise, learning.
  /// Active during Eating bird state.
  kriya,

  /// Spiritual practice window — meditation, breath shifting, withdrawal.
  /// Active during Sleeping and Dying bird states.
  yoga;

  /// Derives the current action window from the active bird state.
  ///
  /// Mapping (confirmed via Sara Kalai planning session):
  /// - Ruling → Artha (peak power, bold action)
  /// - Walking → Artha (routine material work)
  /// - Eating → Kriya (nourishment, absorption)
  /// - Sleeping → Yoga (rest, meditation)
  /// - Dying → Yoga (withdrawal, deep spiritual practice)
  static ActionWindow fromBirdState(PakshiState state) {
    return switch (state) {
      PakshiState.ruling => ActionWindow.artha,
      PakshiState.walking => ActionWindow.artha,
      PakshiState.eating => ActionWindow.kriya,
      PakshiState.sleeping => ActionWindow.yoga,
      PakshiState.dying => ActionWindow.yoga,
    };
  }

  /// Whether Sushumna (universal/balanced) flow is aligned in this window.
  ///
  /// Sushumna indicates internal balance and withdrawal from external action.
  /// - Yoga window: Fully aligned (1.0) — Sushumna supports spiritual practice
  /// - Artha/Kriya: Blocked (0.0) — Sushumna opposes outward material/physical action
  bool get isSushumnaAligned => this == ActionWindow.yoga;
}
