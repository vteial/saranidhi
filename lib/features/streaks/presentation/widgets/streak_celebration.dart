import 'package:flutter/material.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Milestone thresholds that trigger celebrations.
const streakMilestones = [7, 30, 100, 365];

/// Checks if a streak value hits a milestone.
bool isStreakMilestone(int streak) => streakMilestones.contains(streak);

/// A celebration overlay shown when the user hits a streak milestone.
///
/// Displays a brief animated celebration with the milestone number,
/// confetti-style icon decorations, and a congratulations message.
/// Auto-dismisses after 3 seconds or on tap.
class StreakCelebrationOverlay extends StatefulWidget {
  const StreakCelebrationOverlay({
    required this.milestone,
    required this.onDismiss,
    super.key,
  });

  final int milestone;
  final VoidCallback onDismiss;

  @override
  State<StreakCelebrationOverlay> createState() =>
      _StreakCelebrationOverlayState();
}

class _StreakCelebrationOverlayState extends State<StreakCelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Celebration emojis
                      const Text(
                        '\uD83C\uDF89 \uD83D\uDD25 \uD83C\uDF89',
                        style: TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.celebrationTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.celebrationMilestone(widget.milestone),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _milestoneMessage(widget.milestone, l10n),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.celebrationTapToDismiss,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _milestoneMessage(int milestone, AppLocalizations l10n) {
    return switch (milestone) {
      7 => l10n.celebrationWeek,
      30 => l10n.celebrationMonth,
      100 => l10n.celebration100,
      365 => l10n.celebrationYear,
      _ => l10n.celebrationGeneric,
    };
  }
}

/// Shows the streak celebration overlay as a dialog.
void showStreakCelebration(BuildContext context, int milestone) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (ctx) => StreakCelebrationOverlay(
      milestone: milestone,
      onDismiss: () => Navigator.of(ctx).pop(),
    ),
  );
}
