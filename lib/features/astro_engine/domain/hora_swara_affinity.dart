import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// Planetary energy classification for Hora-Swara alignment.
enum HoraEnergy {
  /// Sun, Mars — heating, kinetic, outward action.
  solar,

  /// Moon, Mercury, Venus, Jupiter — cooling, receptive, inward.
  lunar,

  /// Saturn — transitional, balanced, neutral.
  neutral,
}

/// Compares the current planetary hour (Hora) energy with the user's
/// physical breath flow (Swara) to produce an alignment multiplier.
///
/// Alignment rules (from Sankhya Sastra):
/// - Solar Hora (Sun/Mars) + Right Nostril (Pingala) = 1.5x (aligned)
/// - Lunar Hora (Moon/Mercury/Venus/Jupiter) + Left Nostril (Ida) = 1.5x
/// - Neutral Hora (Saturn) + Sushumna = 1.5x (perfect balance)
/// - Mismatched = 0.5x (friction)
/// - Saturn + non-Sushumna = 1.0x (neutral, no penalty)
class HoraSwaraAffinity {
  const HoraSwaraAffinity._();

  /// Returns the energy classification for a given planet.
  static HoraEnergy energyOf(HoraPlanet planet) {
    return switch (planet) {
      HoraPlanet.sun => HoraEnergy.solar,
      HoraPlanet.mars => HoraEnergy.solar,
      HoraPlanet.moon => HoraEnergy.lunar,
      HoraPlanet.mercury => HoraEnergy.lunar,
      HoraPlanet.venus => HoraEnergy.lunar,
      HoraPlanet.jupiter => HoraEnergy.lunar,
      HoraPlanet.saturn => HoraEnergy.neutral,
    };
  }

  /// Calculates the Hora-Swara alignment multiplier.
  ///
  /// [planet] is the ruling planet of the current hora.
  /// [actualFlow] is the user's current breath flow.
  ///
  /// Returns a multiplier (0.5 to 1.5) for the Oracle composite score.
  static double getMultiplier(HoraPlanet planet, BreathFlow actualFlow) {
    final energy = energyOf(planet);
    return switch (energy) {
      HoraEnergy.solar =>
        (actualFlow == BreathFlow.solar) ? 1.5 : 0.5,
      HoraEnergy.lunar =>
        (actualFlow == BreathFlow.lunar) ? 1.5 : 0.5,
      HoraEnergy.neutral =>
        (actualFlow == BreathFlow.sushumna) ? 1.5 : 1.0,
    };
  }
}
