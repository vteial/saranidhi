import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/onboarding/presentation/onboarding_screen.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';

/// Guards the main app — shows onboarding if profile not completed.
///
/// Wraps the [OnboardingScreen] in its own [Navigator] so that dialog-based
/// widgets (showDatePicker, showTimePicker) have a valid overlay to push onto.
/// Without this, the onboarding screen lives outside the GoRouter Navigator
/// (since it's rendered via MaterialApp.builder) and dialogs fail on web.
class OnboardingGuard extends ConsumerWidget {
  const OnboardingGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = ref.watch(onboardingCompleteProvider);

    if (!isComplete) {
      return Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    }

    return child;
  }
}
