import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/features/onboarding/presentation/intro_screen.dart';
import 'package:saranidhi/features/onboarding/presentation/onboarding_screen.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';

/// Whether the user has dismissed the intro screen and is in the onboarding flow.
final introSeenProvider = NotifierProvider<IntroSeenNotifier, bool>(
  IntroSeenNotifier.new,
);

class IntroSeenNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markSeen() => state = true;
}

/// Guards the main app — shows intro → onboarding if profile not completed.
///
/// Flow:
/// 1. If onboarding not complete AND intro not seen → show IntroScreen
/// 2. If onboarding not complete AND intro seen → show OnboardingScreen
/// 3. If onboarding complete → show main app (child)
///
/// Wraps screens in their own [Navigator] so that dialog-based widgets
/// (showDatePicker, showTimePicker) have a valid overlay to push onto.
class OnboardingGuard extends ConsumerWidget {
  const OnboardingGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = ref.watch(onboardingCompleteProvider);

    if (!isComplete) {
      final introSeen = ref.watch(introSeenProvider);

      if (!introSeen) {
        return Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => const IntroScreen(),
          ),
        );
      }

      return Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    }

    return child;
  }
}
