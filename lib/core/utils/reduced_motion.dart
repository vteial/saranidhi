import 'package:flutter/material.dart';

/// Extension on [BuildContext] for clean, consistent reduced-motion querying.
extension ReducedMotionContext on BuildContext {
  /// Returns `true` if the platform or user has requested reduced motion /
  /// disabled animations via [MediaQueryData.disableAnimations].
  bool get prefersReducedMotion =>
      MediaQuery.maybeOf(this)?.disableAnimations ?? false;
}

/// Helper utilities for configuring animation controllers in a
/// reduced-motion-safe way without altering visual behavior when reduced
/// motion is inactive.
class ReducedMotion {
  ReducedMotion._();

  /// Returns `true` if reduced motion is requested for the given [context].
  static bool of(BuildContext context) => context.prefersReducedMotion;

  /// Configures a repeating [AnimationController] according to the platform's
  /// reduced-motion preference.
  ///
  /// - When reduced motion is **active**: stops the controller and sets its
  ///   value to [staticValue] (default `1.0`).
  /// - When reduced motion is **inactive**: initiates or resumes the repeating
  ///   animation (using [reverse] or a custom [startAnimation] callback).
  static void configureRepeating({
    required BuildContext context,
    required AnimationController controller,
    bool reverse = false,
    double staticValue = 1.0,
    void Function()? startAnimation,
  }) {
    if (of(context)) {
      if (controller.isAnimating) {
        controller.stop();
      }
      controller.value = staticValue;
    } else {
      if (!controller.isAnimating) {
        if (startAnimation != null) {
          startAnimation();
        } else {
          controller.repeat(reverse: reverse);
        }
      }
    }
  }
}
