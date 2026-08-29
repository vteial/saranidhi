import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/guided_nostril_test.dart';
import 'package:saranidhi/features/somatic/domain/somatic_intervention_session.dart';
import 'package:saranidhi/features/somatic/presentation/widgets/cross_lateral_instruction_card.dart';
import 'package:saranidhi/features/somatic/presentation/widgets/sama_vritti_pacer.dart';
import 'package:saranidhi/features/somatic/providers/somatic_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Full-screen guided intervention room: shows the contralateral instruction,
/// the Sama Vritti breathing pacer, and a high-contrast countdown timer.
///
/// On timer completion it auto-launches the post-session [GuidedNostrilTest]
/// (Task 35.6), evaluates success, and writes a [SomaticInterventionLog].
///
/// See `docs/research/advanced_somatic_mastery.md` §1.2–1.3.
class SomaticTimerRoom extends ConsumerStatefulWidget {
  const SomaticTimerRoom({required this.session, super.key});

  final SomaticInterventionSession session;

  @override
  ConsumerState<SomaticTimerRoom> createState() => _SomaticTimerRoomState();
}

class _SomaticTimerRoomState extends ConsumerState<SomaticTimerRoom> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.session.duration.inSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        HapticFeedback.mediumImpact();
        setState(() => _remainingSeconds = 0);
        _onCompleted();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  Future<void> _onCompleted() async {
    if (_finished || !mounted) return;
    _finished = true;

    // Launch post-session verification (Task 35.6).
    showGuidedNostrilTest(
      context,
      onResult: (flow) => _recordOutcome(flow),
    );
  }

  Future<void> _recordOutcome(BreathFlow flow) async {
    final resolvedNostril = flow.nostril; // 'left' / 'right' / 'both'
    final success = widget.session.evaluateSuccess(resolvedNostril);

    final repo = ref.read(somaticInterventionRepositoryProvider);
    await repo.insertLog(
      protocolType: widget.session.type.storageValue,
      targetFlow: widget.session.targetFlow,
      initialFlow: widget.session.initialFlow,
      durationSeconds: widget.session.duration.inSeconds,
      resolvedFlow: resolvedNostril,
      isSuccess: success,
    );

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.somaticSuccessNotice : l10n.somaticRetryNotice,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
    Navigator.of(context).pop(success);
  }

  void _cancel() {
    _timer?.cancel();
    Navigator.of(context).pop(false);
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final session = widget.session;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Close / cancel
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: l10n.cancel,
                  onPressed: _cancel,
                ),
              ),
              Text(
                l10n.somaticRoomTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CrossLateralInstructionCard(
                type: session.type,
                bodySide: session.bodySide,
              ),
              const Spacer(),
              const SamaVrittiPacer(),
              const Spacer(),
              // High-contrast countdown
              Text(
                _formatTime(_remainingSeconds),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: theme.colorScheme.primary,
                ),
                // FontFeature comes from dart:ui, re-exported by material.dart.
              ),
              const SizedBox(height: 8),
              Text(
                l10n.somaticRoomHint,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
