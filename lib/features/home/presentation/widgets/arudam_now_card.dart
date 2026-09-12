import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/providers/profile_location_provider.dart';
import 'package:saranidhi/core/utils/pakshi_l10n.dart';
import 'package:saranidhi/core/utils/timezone_utils.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_swara_affinity.dart';
import 'package:saranidhi/features/astro_engine/domain/integrated_arudam_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/nakshatra_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/tara_category.dart';
import 'package:saranidhi/features/breath_journal/domain/alignment_checker.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/guided_nostril_test.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Always-on ambient "Aruḍam Now" verdict card on Home.
///
/// Fuses the astronomical engines with real-time breath alignment into ONE
/// answer: "is now a good moment, and what should I do?"
///
/// Formula: Moment (cosmic ceiling) x Readiness (personal alignment multiplier)
/// with 24h-correct inauspicious floor-lock.
class ArudamNowCard extends ConsumerWidget {
  const ArudamNowCard({required this.data, super.key});

  final DashboardData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    // 1. Bird State (day or night aware)
    final PakshiState birdState;
    if (data.isNight && data.activeNightYama != null) {
      birdState = data.birthBirdNightState ?? PakshiState.eating;
    } else {
      birdState = data.birthBirdState ?? PakshiState.eating;
    }

    // 2. Action Window & Category
    final window = data.activeActionWindow?.window ?? ActionWindow.artha;
    final category = switch (window) {
      ActionWindow.artha => QueryCategory.artha,
      ActionWindow.kriya => QueryCategory.kriya,
      ActionWindow.yoga => QueryCategory.yoga,
    };

    // 3. 24h-correct inauspicious checks via window containment (Task 38.3)
    final isRahuActive = data.rahuKaal?.isActive(now) ?? false;
    final isEmakandamActive = data.emakandam?.isActive(now) ?? false;

    // 4. Tarabala multiplier
    final double tarabalaMultiplier;
    if (data.birthStarNakshatra != null) {
      final birthIndex = Nakshatra.values.indexWhere(
        (n) => n.standardName == data.birthStarNakshatra!.toLowerCase(),
      );
      if (birthIndex >= 0) {
        final transit = NakshatraCalculator.calculate(now);
        tarabalaMultiplier = TaraCategory.resolve(
          birthIndex,
          transit.nakshatra.index,
        ).weight;
      } else {
        tarabalaMultiplier = 1;
      }
    } else {
      tarabalaMultiplier = 1;
    }

    // 5. Swara staleness check (within ~30 min)
    final latestEntryAsync = ref.watch(latestJournalEntryProvider);
    final latestEntry = latestEntryAsync.value;

    BreathFlow? actualSwara;
    var isStale = true;
    var isAligned = false;

    if (latestEntry != null) {
      final entryTime = DateTime.fromMillisecondsSinceEpoch(
        latestEntry.timestamp,
      );
      final minutesSince = now.difference(entryTime).inMinutes;
      if (minutesSince <= 30) {
        isStale = false;
        actualSwara =
            BreathFlow.values
                .where((f) => f.name == latestEntry.actualFlow)
                .firstOrNull ??
            BreathFlow.solar;

        final location =
            ref.watch(profileLocationProvider).value ?? const ProfileLocation();
        final utcOffset = TimezoneUtils.offsetForLocation(
          latitude: location.latitude,
          longitude: location.longitude,
        );

        final alignment = AlignmentChecker.check(
          actualFlow: actualSwara,
          time: now,
          latitude: location.latitude,
          longitude: location.longitude,
          utcOffset: utcOffset,
        );
        isAligned = alignment?.isAligned ?? false;
      }
    }

    // 6. Hora-Swara affinity
    final horaResult = data.activeHora;
    final double horaSwaraMultiplier;
    if (horaResult != null && actualSwara != null) {
      horaSwaraMultiplier = HoraSwaraAffinity.getMultiplier(
        horaResult.planet,
        actualSwara,
      );
    } else {
      horaSwaraMultiplier = 1;
    }

    // 7. Evaluate verdict
    final verdict = IntegratedArudamEngine.evaluate(
      birdState: birdState,
      window: window,
      category: category,
      tarabalaMultiplier: tarabalaMultiplier,
      horaSwaraMultiplier: horaSwaraMultiplier,
      isAligned: isAligned,
      actualSwara: actualSwara,
      isRahuActive: isRahuActive,
      isEmakandamActive: isEmakandamActive,
    );

    final bandColor = _bandColor(verdict.band);
    final bandLabel = _bandLabel(verdict.band, l10n);

    // Clock 1 Moment strength string
    final strengthLabel = _momentStrengthLabel(verdict.momentScore, l10n);
    final horaName = horaResult != null
        ? _localizedPlanet(horaResult.planet, l10n)
        : '';
    final birdStateName = birdState.localizedName(l10n);
    final momentText = l10n.arudamMomentBreakdown(
      birdStateName,
      horaName,
      strengthLabel,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: verdict.isFloorLocked
              ? theme.colorScheme.error.withValues(alpha: 0.4)
              : bandColor.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: 🦅 ARUḌAM NOW — <Band> (<score>)
            Row(
              children: [
                Text(
                  '🦅 ${l10n.arudamNowTitle.toUpperCase()}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '—',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$bandLabel (${verdict.score})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: bandColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Two-Clock Breakdown:
            // Clock 1: Moment
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: '${l10n.arudamClockMoment}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: momentText),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Clock 2: You
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isStale
                      ? Icons.help_outline
                      : (isAligned
                            ? Icons.check_circle_outline
                            : Icons.warning_amber_rounded),
                  size: 18,
                  color: isStale
                      ? theme.colorScheme.onSurfaceVariant
                      : (isAligned
                            ? Colors.green.shade700
                            : Colors.amber.shade800),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: '${l10n.arudamClockYou}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: isStale
                              ? l10n.arudamBreathUnknown
                              : (isAligned
                                    ? l10n.arudamAlignedNatural
                                    : l10n.arudamNotNaturallyAligned),
                          style: TextStyle(
                            color: isStale
                                ? theme.colorScheme.onSurfaceVariant
                                : (isAligned
                                      ? Colors.green.shade700
                                      : Colors.amber.shade900),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Guidance prose & contextual actions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isStale
                        ? l10n.arudamStaleGuidance
                        : (isAligned
                              ? l10n.arudamAlignedGuidance
                              : l10n.arudamMisalignedGuidance),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  if (isStale) ...[
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => _launchNostrilCheck(context, ref, l10n),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          l10n.arudamCheckBreath,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (!isStale && !isAligned) ...[
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => _showUrgentShiftSheet(context, ref, l10n),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          l10n.arudamUrgentAffordance,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchNostrilCheck(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showGuidedNostrilTest(
      context,
      onResult: (flow) async {
        final repo = ref.read(journalRepositoryProvider);
        final location =
            ref.read(profileLocationProvider).value ?? const ProfileLocation();
        final utcOffset = TimezoneUtils.offsetForLocation(
          latitude: location.latitude,
          longitude: location.longitude,
        );
        final now = DateTime.now();
        final alignment = AlignmentChecker.check(
          actualFlow: flow,
          time: now,
          latitude: location.latitude,
          longitude: location.longitude,
          utcOffset: utcOffset,
        );

        await repo.insertEntry(
          expectedFlow: alignment?.expectedFlow.name ?? 'lunar',
          actualFlow: flow.name,
          isAligned: alignment?.isAligned ?? false,
          nostril: flow.nostril,
          activeYama: alignment?.activeYama?.name,
          activeBird: alignment?.activeBird?.name,
          activeBirdState: alignment?.activeBirdState?.name,
        );
      },
    );
  }

  void _showUrgentShiftSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.arudamUrgentSheetTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Warning-toned callout container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.colorScheme.error.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 20,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.arudamUrgentWarning,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.arudamUrgentTechniqueTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.arudamUrgentTechniqueDesc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      _recordForcedShiftVerification(context, ref, l10n);
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.arudamUrgentRecheck),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _recordForcedShiftVerification(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showGuidedNostrilTest(
      context,
      onResult: (flow) async {
        final repo = ref.read(journalRepositoryProvider);
        final location =
            ref.read(profileLocationProvider).value ?? const ProfileLocation();
        final utcOffset = TimezoneUtils.offsetForLocation(
          latitude: location.latitude,
          longitude: location.longitude,
        );
        final now = DateTime.now();
        final alignment = AlignmentChecker.check(
          actualFlow: flow,
          time: now,
          latitude: location.latitude,
          longitude: location.longitude,
          utcOffset: utcOffset,
        );

        await repo.insertEntry(
          expectedFlow: alignment?.expectedFlow.name ?? 'lunar',
          actualFlow: flow.name,
          isAligned: alignment?.isAligned ?? false,
          nostril: flow.nostril,
          activeYama: alignment?.activeYama?.name,
          activeBird: alignment?.activeBird?.name,
          activeBirdState: alignment?.activeBirdState?.name,
          wasForcedShift: true,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.arudamShiftLoggedNotice),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  Color _bandColor(OracleBand band) {
    return switch (band) {
      OracleBand.siddha => Colors.green.shade700,
      OracleBand.vardhana => Colors.teal.shade600,
      OracleBand.mandha => Colors.orange.shade700,
      OracleBand.stambhana => Colors.deepOrange.shade700,
      OracleBand.sunya => Colors.red.shade800,
    };
  }

  String _bandLabel(OracleBand band, AppLocalizations l10n) {
    return switch (band) {
      OracleBand.siddha => l10n.prasanamBandSiddha,
      OracleBand.vardhana => l10n.prasanamBandVardhana,
      OracleBand.mandha => l10n.prasanamBandMandha,
      OracleBand.stambhana => l10n.prasanamBandStambhana,
      OracleBand.sunya => l10n.prasanamBandSunya,
    };
  }

  String _momentStrengthLabel(int momentScore, AppLocalizations l10n) {
    if (momentScore >= 70) return l10n.arudamStrengthStrong;
    if (momentScore >= 40) return l10n.arudamStrengthMild;
    return l10n.arudamStrengthWeak;
  }

  String _localizedPlanet(HoraPlanet planet, AppLocalizations l10n) {
    return switch (planet) {
      HoraPlanet.sun => l10n.planetSun,
      HoraPlanet.moon => l10n.planetMoon,
      HoraPlanet.mars => l10n.planetMars,
      HoraPlanet.mercury => l10n.planetMercury,
      HoraPlanet.jupiter => l10n.planetJupiter,
      HoraPlanet.venus => l10n.planetVenus,
      HoraPlanet.saturn => l10n.planetSaturn,
    };
  }
}
