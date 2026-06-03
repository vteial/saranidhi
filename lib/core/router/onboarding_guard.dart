import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/onboarding/presentation/onboarding_screen.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';

/// Guards the main app — shows onboarding if profile not completed.
class OnboardingGuard extends ConsumerWidget {
  const OnboardingGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = ref.watch(onboardingCompleteProvider);

    if (!isComplete) {
      return const OnboardingScreen();
    }

    return child;
  }
}
