import 'package:flutter/material.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Animated breathing pacer to help shift dominant nostril.
///
/// Displays a pulsing circle that expands (inhale) and contracts (exhale)
/// at a steady rhythm to guide the user's breathing.
class QuickSyncPacer extends StatefulWidget {
  const QuickSyncPacer({super.key});

  @override
  State<QuickSyncPacer> createState() => _QuickSyncPacerState();
}

class _QuickSyncPacerState extends State<QuickSyncPacer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isActive = false;

  // 4-second inhale, 4-second exhale = 8-second cycle
  static const _cycleDuration = Duration(seconds: 8);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _cycleDuration);
    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePacer() {
    setState(() {
      _isActive = !_isActive;
      if (_isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller
          ..stop()
          ..reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(l10n.quickSyncPacer, style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              _isActive
                  ? l10n.breatheWithCircle
                  : l10n.quickSyncInstruction,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _togglePacer,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: Transform.scale(
                        scale: _isActive ? _scaleAnimation.value : 0.6,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primaryContainer,
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _isActive ? Icons.stop : Icons.play_arrow,
                              color: theme.colorScheme.primary,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isActive) ...[
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final isForward =
                      _controller.status == AnimationStatus.forward;
                  return Text(
                    isForward ? l10n.inhaling : l10n.exhaling,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
