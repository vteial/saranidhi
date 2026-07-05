import 'package:flutter/material.dart';

/// A shimmer/skeleton loading widget that displays animated placeholder cards
/// while dashboard data is loading.
///
/// Used on the Today and Explore tabs to show content shape before data arrives,
/// providing better perceived performance especially on first web launch.
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({super.key});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Row 1: Two cards side by side on wide, stacked on narrow
              if (isWide)
                Row(
                  children: [
                    Expanded(
                      child: _ShimmerCard(
                        height: 120,
                        animation: _animation,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ShimmerCard(
                        height: 120,
                        animation: _animation,
                      ),
                    ),
                  ],
                )
              else ...[
                _ShimmerCard(height: 120, animation: _animation),
                const SizedBox(height: 12),
                _ShimmerCard(height: 120, animation: _animation),
              ],
              const SizedBox(height: 12),

              // Row 2: Full-width tall card (schedule)
              _ShimmerCard(height: 200, animation: _animation),
              const SizedBox(height: 12),

              // Row 3: Medium card (nostril/wisdom)
              _ShimmerCard(height: 100, animation: _animation),
              const SizedBox(height: 12),

              // Row 4: Two smaller cards on wide
              if (isWide)
                Row(
                  children: [
                    Expanded(
                      child: _ShimmerCard(
                        height: 80,
                        animation: _animation,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ShimmerCard(
                        height: 80,
                        animation: _animation,
                      ),
                    ),
                  ],
                )
              else ...[
                _ShimmerCard(height: 80, animation: _animation),
                const SizedBox(height: 12),
                _ShimmerCard(height: 80, animation: _animation),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({
    required this.height,
    required this.animation,
  });

  final double height;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surfaceContainerLow;
    final highlightColor = isDark
        ? theme.colorScheme.surfaceContainerLow
        : theme.colorScheme.surface;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [baseColor, highlightColor, baseColor],
          stops: [
            (animation.value - 0.3).clamp(0.0, 1.0),
            animation.value.clamp(0.0, 1.0),
            (animation.value + 0.3).clamp(0.0, 1.0),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title placeholder
            Container(
              width: 120,
              height: 14,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            // Content placeholder
            Container(
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            if (height > 100) ...[
              const SizedBox(height: 8),
              Container(
                width: 200,
                height: 10,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
