import 'package:flutter/material.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_presets.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// A horizontal chip selector for breathing pattern presets.
///
/// Allows the user to choose a guided breathing pattern (4-7-8, box, etc.)
/// or use manual mode (free-form tap-to-advance).
class PresetSelector extends StatelessWidget {
  const PresetSelector({
    required this.selectedPreset,
    required this.onSelect,
    super.key,
  });

  /// Currently selected preset (null = manual/free mode).
  final BreathPreset? selectedPreset;

  /// Callback when a preset is selected (null = manual).
  final ValueChanged<BreathPreset?> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Manual mode chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(l10n.presetManual),
              selected: selectedPreset == null,
              onSelected: (_) => onSelect(null),
              labelStyle: theme.textTheme.labelMedium,
            ),
          ),
          // Preset chips
          ...breathPresets.map(
            (preset) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(_presetName(preset, l10n)),
                selected: selectedPreset?.id == preset.id,
                onSelected: (_) => onSelect(preset),
                labelStyle: theme.textTheme.labelMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _presetName(BreathPreset preset, AppLocalizations l10n) {
    return switch (preset.id) {
      'relaxing_478' => l10n.preset478,
      'box_breathing' => l10n.presetBox,
      'energizing' => l10n.presetEnergizing,
      'calming' => l10n.presetCalming,
      _ => preset.id,
    };
  }
}
