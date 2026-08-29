import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/utils/pakshi_l10n.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/onboarding/providers/bird_migration_provider.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Runs the birth-bird recalculation once on app load.
///
/// When the recalculation changes the stored bird (e.g., an existing
/// profile that was derived with the old Bright-Half-only logic), this
/// widget shows a one-time SnackBar notice and refreshes the dashboard.
///
/// Place near the top of the widget tree (below [ProviderScope]).
class BirdMigrationOnLoadWidget extends ConsumerStatefulWidget {
  const BirdMigrationOnLoadWidget({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<BirdMigrationOnLoadWidget> createState() =>
      _BirdMigrationOnLoadWidgetState();
}

class _BirdMigrationOnLoadWidgetState
    extends ConsumerState<BirdMigrationOnLoadWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runMigration();
    });
  }

  Future<void> _runMigration() async {
    final result = await ref.read(birdMigrationProvider.future);
    if (!result.changed || !mounted) return;

    // Refresh dashboard so the corrected bird shows immediately.
    ref.invalidate(dashboardDataProvider);

    final newBirdName = result.newBird;
    if (newBirdName == null || !mounted) return;

    final l10n = AppLocalizations.of(context);
    final bird = PakshiBird.values
        .where((b) => b.name == newBirdName)
        .firstOrNull;
    final localizedBird = bird?.localizedName(l10n) ?? newBirdName;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.birdUpdatedNotice(localizedBird)),
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
