import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:saranidhi/core/router/app_router.dart';
import 'package:saranidhi/core/utils/responsive_wrapper.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';

/// The first-run onboarding flow.
///
/// Steps:
/// 0. Welcome (name)
/// 1. Birth Star (nakshatra → bird)
/// 2. Location (lat/lng for sunrise calculation)
/// 3. Storage Mode (local / icloud / gdrive)
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    return Scaffold(
      body: ResponsiveWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: (state.currentStep + 1) / state.totalSteps,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 24),

                // Step content
                Expanded(
                  child: switch (state.currentStep) {
                    0 => _WelcomeStep(state: state, notifier: notifier),
                    1 => _BirthStarStep(state: state, notifier: notifier),
                    2 => _LocationStep(state: state, notifier: notifier),
                    3 => _StorageModeStep(state: state, notifier: notifier),
                    _ => const SizedBox.shrink(),
                  },
                ),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state.currentStep > 0)
                      TextButton(
                        onPressed: notifier.previousStep,
                        child: const Text('Back'),
                      )
                    else
                      const SizedBox(width: 80),
                    if (state.currentStep < state.totalSteps - 1)
                      FilledButton(
                        onPressed: notifier.nextStep,
                        child: const Text('Next'),
                      )
                    else
                      FilledButton(
                        onPressed: state.isSaving
                            ? null
                            : () async {
                                await notifier.saveProfile();
                                if (context.mounted) {
                                  context.go(AppRoutes.home);
                                }
                              },
                        child: state.isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Complete Setup'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.state, required this.notifier});
  final OnboardingState state;
  final OnboardingNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          SvgPicture.asset('public/logo.svg', width: 80, height: 80),
          const SizedBox(height: 24),
          Text(
            'Welcome to Saranidhi',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The Treasure House of Breath',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Your Name (optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: notifier.setDisplayName,
          ),
        ],
      ),
    );
  }
}

class _BirthStarStep extends StatelessWidget {
  const _BirthStarStep({required this.state, required this.notifier});
  final OnboardingState state;
  final OnboardingNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Birth Star (Nakshatra)', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Your birth star determines your Panja Pakshi bird.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (state.birthBird != null) ...[
          const SizedBox(height: 12),
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.stars),
                  const SizedBox(width: 8),
                  Text(
                    'Your bird: ${state.birthBird!.displayName}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: allNakshatras.length,
            itemBuilder: (context, index) {
              final nakshatra = allNakshatras[index];
              final isSelected = state.selectedNakshatra == nakshatra;
              return ListTile(
                title: Text(nakshatra),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                    : null,
                selected: isSelected,
                onTap: () => notifier.setNakshatra(nakshatra),
                dense: true,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LocationStep extends StatelessWidget {
  const _LocationStep({required this.state, required this.notifier});
  final OnboardingState state;
  final OnboardingNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Location', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Used for accurate sunrise/sunset calculation. '
            'Your location stays on your device.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          // Preset cities for quick selection
          Text('Quick Select:', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetCities.map((city) {
              final isSelected = state.locationName == city.name;
              return ChoiceChip(
                label: Text(city.name),
                selected: isSelected,
                onSelected: (_) => notifier.setLocation(
                  latitude: city.lat,
                  longitude: city.lng,
                  name: city.name,
                ),
              );
            }).toList(),
          ),
          if (state.locationName != null) ...[
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 8),
                    Text(
                      '${state.locationName} '
                      '(${state.latitude?.toStringAsFixed(2)}, '
                      '${state.longitude?.toStringAsFixed(2)})',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StorageModeStep extends StatelessWidget {
  const _StorageModeStep({required this.state, required this.notifier});
  final OnboardingState state;
  final OnboardingNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data Storage', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Choose where to keep your breath journal data.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        _StorageOption(
          title: 'Local Only',
          subtitle: 'Data stays on this device only',
          icon: Icons.phone_android,
          isSelected: state.storageMode == 'local',
          onTap: () => notifier.setStorageMode('local'),
        ),
        _StorageOption(
          title: 'iCloud (iOS)',
          subtitle: 'Backup to your iCloud account',
          icon: Icons.cloud,
          isSelected: state.storageMode == 'icloud',
          onTap: () => notifier.setStorageMode('icloud'),
        ),
        _StorageOption(
          title: 'Google Drive',
          subtitle: 'Backup to your Google Drive',
          icon: Icons.cloud_outlined,
          isSelected: state.storageMode == 'gdrive',
          onTap: () => notifier.setStorageMode('gdrive'),
        ),
      ],
    );
  }
}

class _StorageOption extends StatelessWidget {
  const _StorageOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}

/// Preset cities for quick location selection.
class _PresetCity {
  const _PresetCity(this.name, this.lat, this.lng);
  final String name;
  final double lat;
  final double lng;
}

const _presetCities = [
  _PresetCity('Chennai', 13.08, 80.27),
  _PresetCity('Mumbai', 19.08, 72.88),
  _PresetCity('Delhi', 28.61, 77.21),
  _PresetCity('Bangalore', 12.97, 77.59),
  _PresetCity('Hyderabad', 17.39, 78.49),
  _PresetCity('Kolkata', 22.57, 88.36),
  _PresetCity('London', 51.51, -0.13),
  _PresetCity('New York', 40.71, -74.01),
  _PresetCity('Singapore', 1.35, 103.82),
  _PresetCity('Sydney', -33.87, 151.21),
];
