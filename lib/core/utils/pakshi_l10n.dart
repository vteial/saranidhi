import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Extension to get localized bird name from [PakshiBird] enum.
extension PakshiBirdL10n on PakshiBird {
  /// Returns the localized display name for this bird.
  String localizedName(AppLocalizations l10n) => switch (this) {
    PakshiBird.vulture => l10n.vulture,
    PakshiBird.owl => l10n.owl,
    PakshiBird.crow => l10n.crow,
    PakshiBird.rooster => l10n.rooster,
    PakshiBird.peacock => l10n.peacock,
  };
}

/// Extension to get localized state name from [PakshiState] enum.
extension PakshiStateL10n on PakshiState {
  /// Returns the localized display name for this state.
  String localizedName(AppLocalizations l10n) => switch (this) {
    PakshiState.ruling => l10n.ruling,
    PakshiState.eating => l10n.eating,
    PakshiState.walking => l10n.walking,
    PakshiState.sleeping => l10n.sleeping,
    PakshiState.dying => l10n.dying,
  };
}
