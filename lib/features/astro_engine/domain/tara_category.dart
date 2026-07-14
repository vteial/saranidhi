/// The 9 Navatara categories with auspiciousness weights.
///
/// The Navatara system assesses daily compatibility based on the numerical
/// distance between the user's birth Nakshatra and the transit Nakshatra.
///
/// Formula: TaraIndex = ((transitIndex - birthIndex + 27) % 9)
/// Result maps to one of 9 categories with multiplier weights (0.2x to 1.5x).
enum TaraCategory {
  /// Focus on physical body, maintenance, self-reflection.
  janma(weight: 1.0, isAuspicious: true),

  /// Material gain, positive energy, transaction success.
  sampat(weight: 1.5, isAuspicious: true),

  /// High chance of obstacles, accidental delays.
  vipat(weight: 0.4, isAuspicious: false),

  /// Safety, protection, comfort, domestic actions.
  kshema(weight: 1.3, isAuspicious: true),

  /// Opposition, conflicts, arguments.
  pratyak(weight: 0.5, isAuspicious: false),

  /// Success in research, spiritual practices, realizations.
  sadhana(weight: 1.5, isAuspicious: true),

  /// Danger, vital energy depletion, complete containment.
  naidhana(weight: 0.2, isAuspicious: false),

  /// Friendly meetings, collaborative tasks.
  mitra(weight: 1.2, isAuspicious: true),

  /// Ease of workflow, great alliance harmony.
  adhimitra(weight: 1.3, isAuspicious: true);

  /// The multiplier weight applied to the Oracle score.
  final double weight;

  /// Whether this Tara is generally auspicious.
  final bool isAuspicious;

  const TaraCategory({required this.weight, required this.isAuspicious});

  /// Resolves the TaraCategory from birth and transit nakshatra indices.
  ///
  /// Both indices are 0-based (0 = Ashwini, 26 = Revati).
  static TaraCategory resolve(int birthIndex, int transitIndex) {
    final diff = ((transitIndex - birthIndex + 27) % 9);
    return TaraCategory.values[diff];
  }

  /// Resolves from 1-based indices (1 = Ashwini, 27 = Revati).
  static TaraCategory resolveOneBased(int birthIndex, int transitIndex) {
    return resolve(birthIndex - 1, transitIndex - 1);
  }
}
