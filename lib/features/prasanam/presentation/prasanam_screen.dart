import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/providers/profile_location_provider.dart';
import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/core/utils/timezone_utils.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_swara_affinity.dart';
import 'package:saranidhi/features/astro_engine/domain/nakshatra_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/oracle_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/tara_category.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/guided_nostril_test.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/prasanam/presentation/widgets/oracle_result_card.dart';
import 'package:saranidhi/features/prasanam/presentation/widgets/prasanam_history_card.dart';
import 'package:saranidhi/features/prasanam/providers/prasanam_providers.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// The Prasanam Oracle query screen.
///
/// Flow:
/// 1. Category selection (Artha/Kriya/Yoga)
/// 2. Free-text intention field
/// 3. Validation gate (30-min journal entry check → Guided Nostril Test if stale)
/// 4. Oracle evaluation → result card
class PrasanamScreen extends ConsumerStatefulWidget {
  const PrasanamScreen({super.key});

  @override
  ConsumerState<PrasanamScreen> createState() => _PrasanamScreenState();
}

class _PrasanamScreenState extends ConsumerState<PrasanamScreen>
    with SingleTickerProviderStateMixin {
  QueryCategory _selectedCategory = QueryCategory.artha;
  final _queryController = TextEditingController();
  bool _showResult = false;
  bool _isEvaluating = false;

  // Oracle result fields
  int _score = 0;
  OracleBand _band = OracleBand.sunya;
  String _guidanceEn = '';
  String _guidanceTa = '';
  bool _isFloorLocked = false;
  bool _isSaved = false;
  String _swaraUsed = '';
  String _birdStateUsed = '';
  String _actionWindowUsed = '';

  late final AnimationController _intentionAnimController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _intentionAnimController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _intentionAnimController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _intentionAnimController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: BrandedAppBar(title: l10n.prasanamTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_showResult) ...[
              // Current window status banner
              _buildWindowStatusBanner(theme, l10n),
              const SizedBox(height: 16),

              // Intention anchor animation
              _buildIntentionAnchor(theme, l10n),
              const SizedBox(height: 24),

              // Category selector
              _buildCategorySelector(theme, l10n),
              const SizedBox(height: 20),

              // Free-text query field
              _buildQueryField(theme, l10n),
              const SizedBox(height: 32),

              // Ask Oracle button
              _buildAskButton(theme, l10n),
            ] else ...[
              // Oracle result
              OracleResultCard(
                score: _score,
                band: _band,
                guidanceEn: _guidanceEn,
                guidanceTa: _guidanceTa,
                isFloorLocked: _isFloorLocked,
                category: _selectedCategory,
                queryText: _queryController.text,
              ),
              const SizedBox(height: 20),
              // Save to History button (Option C: user decides)
              if (!_isSaved)
                FilledButton.icon(
                  onPressed: _saveToHistory,
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: Text(l10n.prasanamSaveToHistory),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.prasanamSaved,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              // Ask Another button
              OutlinedButton.icon(
                onPressed: _resetForNewQuery,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.prasanamAskAnother),
              ),
            ],

            // History section — always visible below form/result
            const SizedBox(height: 24),
            const PrasanamHistoryCard(),
          ],
        ),
      ),
    );
  }

  /// Shows current Action Window status — good/bad timing indicator.
  Widget _buildWindowStatusBanner(ThemeData theme, AppLocalizations l10n) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return dashboardAsync.when(
      data: (data) {
        final activeWindow = data.activeActionWindow;
        final rahuKaal = data.rahuKaal;
        final now = DateTime.now();

        // Check if Rahu Kaal or Emakandam is active
        final isRahuActive = rahuKaal != null &&
            !now.isBefore(rahuKaal.start) &&
            now.isBefore(rahuKaal.end);
        final isEmakandamActive = data.emakandam != null &&
            !now.isBefore(data.emakandam!.start) &&
            now.isBefore(data.emakandam!.end);

        if (isRahuActive || isEmakandamActive) {
          final name = isRahuActive
              ? l10n.prasanamWindowRahu
              : l10n.prasanamWindowEmakandam;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 20,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Show current action window as favorable
        if (activeWindow != null) {
          final windowLabel = _windowLabel(activeWindow.window, l10n);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    windowLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _windowLabel(ActionWindow window, AppLocalizations l10n) {
    return switch (window) {
      ActionWindow.artha => l10n.prasanamWindowArtha,
      ActionWindow.kriya => l10n.prasanamWindowKriya,
      ActionWindow.yoga => l10n.prasanamWindowYoga,
    };
  }

  /// Animated intention anchor — helps user center before querying.
  Widget _buildIntentionAnchor(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        ),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.auto_awesome,
            size: 36,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  /// Category selector with 3 segmented buttons.
  Widget _buildCategorySelector(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.prasanamCategoryLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<QueryCategory>(
          segments: [
            ButtonSegment(
              value: QueryCategory.artha,
              label: Text(l10n.prasanamCategoryArtha),
              icon: const Icon(Icons.business_center_outlined, size: 18),
            ),
            ButtonSegment(
              value: QueryCategory.kriya,
              label: Text(l10n.prasanamCategoryKriya),
              icon: const Icon(Icons.handyman_outlined, size: 18),
            ),
            ButtonSegment(
              value: QueryCategory.yoga,
              label: Text(l10n.prasanamCategoryYoga),
              icon: const Icon(Icons.self_improvement_outlined, size: 18),
            ),
          ],
          selected: {_selectedCategory},
          onSelectionChanged: (selection) {
            HapticFeedback.selectionClick();
            setState(() => _selectedCategory = selection.first);
          },
        ),
        const SizedBox(height: 8),
        // Contextual meaning for selected category
        Text(
          _categoryDescription(_selectedCategory, l10n),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  String _categoryDescription(QueryCategory category, AppLocalizations l10n) {
    return switch (category) {
      QueryCategory.artha => l10n.prasanamCategoryArthaDesc,
      QueryCategory.kriya => l10n.prasanamCategoryKriyaDesc,
      QueryCategory.yoga => l10n.prasanamCategoryYogaDesc,
    };
  }

  /// Free-text query input field.
  Widget _buildQueryField(ThemeData theme, AppLocalizations l10n) {
    return TextField(
      controller: _queryController,
      maxLines: 3,
      maxLength: 200,
      decoration: InputDecoration(
        labelText: l10n.prasanamQueryLabel,
        hintText: l10n.prasanamQueryHint,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }

  /// The "Ask the Oracle" button with validation gate logic.
  Widget _buildAskButton(ThemeData theme, AppLocalizations l10n) {
    return FilledButton.icon(
      onPressed: _isEvaluating ? null : _onAskOracle,
      icon: _isEvaluating
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.auto_awesome),
      label: Text(
        _isEvaluating ? l10n.prasanamEvaluating : l10n.prasanamAskButton,
      ),
    );
  }

  /// Main oracle evaluation flow with validation gate.
  Future<void> _onAskOracle() async {
    setState(() => _isEvaluating = true);

    // Step 1: Check 30-minute validation gate
    final journalRepo = ref.read(journalRepositoryProvider);
    final recentEntries = await journalRepo.getRecentEntries(limit: 1);
    final now = DateTime.now();

    var needsNostrilTest = true;
    BreathFlow? lastSwara;

    if (recentEntries.isNotEmpty) {
      final lastEntry = recentEntries.first;
      final lastTime = DateTime.fromMillisecondsSinceEpoch(lastEntry.timestamp);
      final minutesSince = now.difference(lastTime).inMinutes;

      if (minutesSince <= 30) {
        // Recent enough — use the recorded swara
        needsNostrilTest = false;
        lastSwara = BreathFlow.values.firstWhere(
          (f) => f.name == lastEntry.actualFlow,
          orElse: () => BreathFlow.solar,
        );
      }
    }

    if (needsNostrilTest) {
      // Show guided nostril test
      setState(() => _isEvaluating = false);

      if (!mounted) return;
      showGuidedNostrilTest(
        context,
        onResult: _evaluateOracle,
      );
      return;
    }

    // We have a recent swara — proceed directly
    await _evaluateOracle(lastSwara!);
  }

  /// Evaluates the Oracle composite score.
  Future<void> _evaluateOracle(BreathFlow swara) async {
    setState(() => _isEvaluating = true);

    final locationAsync = ref.read(profileLocationProvider);
    final location = locationAsync.value ?? const ProfileLocation();
    final now = DateTime.now();

    final utcOffset = TimezoneUtils.offsetForLocation(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    // Get sunrise/sunset
    final sunriseResult = SunriseCalculator.calculate(
      latitude: location.latitude,
      longitude: location.longitude,
      date: now,
      utcOffset: utcOffset,
    );

    if (sunriseResult == null) {
      // Polar edge case — shouldn't happen for Indian locations
      setState(() => _isEvaluating = false);
      return;
    }

    final sunrise = sunriseResult.sunrise;
    final sunset = sunriseResult.sunset;
    // Oracle engine uses 0=Sunday..6=Saturday convention
    final weekday = now.weekday % 7; // Dart: 1=Mon..7=Sun → 0=Sun..6=Sat

    // Get dashboard data for bird state and action window
    final dashboardData = await ref.read(dashboardDataProvider.future);
    final currentBirdState = dashboardData.birthBirdState ?? PakshiState.eating;
    final activeWindow = dashboardData.activeActionWindow;
    final currentWindow = activeWindow?.window ?? ActionWindow.artha;

    // Get Tarabala multiplier — uses birth nakshatra vs current transit nakshatra
    final transitNakshatra = NakshatraCalculator.calculate(now);
    final birthNakshatraName = await _getProfileNakshatra(ref);
    final double tarabalaMultiplier;
    if (birthNakshatraName != null) {
      final birthIndex = Nakshatra.values.indexWhere(
        (n) => n.standardName == birthNakshatraName.toLowerCase(),
      );
      if (birthIndex >= 0) {
        tarabalaMultiplier = TaraCategory.resolve(
          birthIndex,
          transitNakshatra.nakshatra.index,
        ).weight;
      } else {
        tarabalaMultiplier = 1.0;
      }
    } else {
      tarabalaMultiplier = 1.0;
    }

    // Get Hora-Swara affinity
    final nextSunrise = sunrise.add(const Duration(hours: 24));
    final horaResult = HoraCalculator.activeHora(
      time: now,
      sunrise: sunrise,
      sunset: sunset,
      nextSunrise: nextSunrise,
      weekday: weekday,
    );
    final horaSwaraMultiplier = horaResult != null
        ? HoraSwaraAffinity.getMultiplier(horaResult.planet, swara)
        : 1.0;

    // Evaluate!
    final result = OracleCompositeEngine.evaluate(
      queryTime: now,
      sunrise: sunrise,
      sunset: sunset,
      weekday: weekday,
      currentBirdState: currentBirdState,
      currentWindow: currentWindow,
      tarabalaMultiplier: tarabalaMultiplier,
      horaSwaraMultiplier: horaSwaraMultiplier,
      category: _selectedCategory,
      actualSwara: swara.name,
    );

    // Store result — saving to history is user-initiated (Option C)
    setState(() {
      _score = result.score;
      _band = result.band;
      _guidanceEn = result.englishGuidance;
      _guidanceTa = result.tamilGuidance;
      _isFloorLocked = result.isFloorLocked;
      _swaraUsed = swara.name;
      _birdStateUsed = currentBirdState.name;
      _actionWindowUsed = currentWindow.name;
      _showResult = true;
      _isEvaluating = false;
      _isSaved = false;
    });
  }

  /// Saves the current reading to history (user-initiated).
  Future<void> _saveToHistory() async {
    final repo = ref.read(prasanamRepositoryProvider);
    await repo.insertQuery(
      category: _selectedCategory.name,
      queryText: _queryController.text,
      score: _score,
      band: _band.name,
      guidanceEn: _guidanceEn,
      guidanceTa: _guidanceTa,
      isFloorLocked: _isFloorLocked,
      swara: _swaraUsed,
      birdState: _birdStateUsed,
      actionWindow: _actionWindowUsed,
    );
    setState(() => _isSaved = true);
  }

  /// Gets the birth nakshatra name from the user's profile.
  Future<String?> _getProfileNakshatra(WidgetRef ref) async {
    final db = ref.read(appDatabaseProvider);
    final profiles = await db.select(db.profiles).get();
    if (profiles.isEmpty) return null;
    return profiles.first.birthStarNakshatra;
  }

  void _resetForNewQuery() {
    setState(() {
      _showResult = false;
      _isEvaluating = false;
      _isSaved = false;
      _queryController.clear();
    });
  }
}
