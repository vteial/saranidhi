import 'package:saranidhi/features/astro_engine/domain/tattva_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

/// Type of thermal advice to apply for temperature regulation.
enum TemperatureTip { cooling, warming }

/// Advisory utility mapping active Tattva and stuck channel to thermal guidance.
class SomaticAdvice {
  const SomaticAdvice._();

  /// Given [activeTattva] and optional [stuckFlow], returns a temperature
  /// regulation tip if an elemental or pranic excess is present.
  ///
  /// - [Tattva.fire] (excess heat) or stuck-right → [TemperatureTip.cooling] (Sheetali / Sitkari)
  /// - cold / [Tattva.water] (apas) or stuck-left → [TemperatureTip.warming] (Surya Bhedana)
  /// - otherwise → `null`
  static TemperatureTip? getTemperatureTip({
    Tattva? activeTattva,
    BreathFlow? stuckFlow,
  }) {
    if (activeTattva == Tattva.fire || stuckFlow == BreathFlow.solar) {
      return TemperatureTip.cooling;
    }
    if (activeTattva == Tattva.water || stuckFlow == BreathFlow.lunar) {
      return TemperatureTip.warming;
    }
    return null;
  }
}
