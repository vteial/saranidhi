import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:saranidhi/core/router/app_router.dart';
import 'package:saranidhi/core/utils/responsive_wrapper.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// The first-run onboarding flow.
///
/// Steps:
/// 0. Welcome (name)
/// 1. Birth Star (nakshatra → bird)
/// 2. Date of Birth (date + time + birth place)
/// 3. Location (lat/lng for sunrise calculation)
/// 4. Storage Mode (local / icloud / gdrive)
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: ResponsiveWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Progress indicator
                Semantics(
                  label: 'Step ${state.currentStep + 1} of ${state.totalSteps}',
                  child: LinearProgressIndicator(
                    value: (state.currentStep + 1) / state.totalSteps,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 24),

                // Step content
                Expanded(
                  child: switch (state.currentStep) {
                    0 => _WelcomeStep(state: state, notifier: notifier),
                    1 => _BirthStarStep(state: state, notifier: notifier),
                    2 => _DOBStep(state: state, notifier: notifier),
                    3 => _LocationStep(state: state, notifier: notifier),
                    4 => _StorageModeStep(state: state, notifier: notifier),
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
                        child: Text(l10n.back),
                      )
                    else
                      const SizedBox(width: 80),
                    if (state.currentStep < state.totalSteps - 1)
                      FilledButton(
                        onPressed: notifier.nextStep,
                        child: Text(l10n.next),
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
                            : Text(l10n.completeSetup),
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

class _WelcomeStep extends StatefulWidget {
  const _WelcomeStep({required this.state, required this.notifier});
  final OnboardingState state;
  final OnboardingNotifier notifier;

  @override
  State<_WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends State<_WelcomeStep> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.state.displayName);
  }

  @override
  void dispose() {
    // Ensure name is saved when navigating away from this step
    widget.notifier.setDisplayName(_controller.text);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Semantics(
            label: l10n.appTitle,
            child: SvgPicture.asset('public/logo.svg', width: 80, height: 80),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.onboardingWelcome,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingSubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: l10n.yourName,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            onChanged: widget.notifier.setDisplayName,
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
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.birthStarNakshatra, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          l10n.birthStarHint,
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
                    l10n.yourBird(state.birthBird!.displayName),
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

class _DOBStep extends StatelessWidget {
  const _DOBStep({required this.state, required this.notifier});
  final OnboardingState state;
  final OnboardingNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date of Birth', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Your birth date, time, and place are used to accurately '
            'calculate your birth nakshatra and Pakshi bird.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Date picker
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
              state.birthDate != null
                  ? '${state.birthDate!.day}/${state.birthDate!.month}/${state.birthDate!.year}'
                  : 'Select date',
            ),
            subtitle: const Text('Birth date'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickDate(context),
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),

          // Time picker
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(
              state.birthTimeOfDay != null
                  ? '${state.birthTimeOfDay!.hour.toString().padLeft(2, '0')}:'
                      '${state.birthTimeOfDay!.minute.toString().padLeft(2, '0')}'
                  : 'Select time (optional)',
            ),
            subtitle: const Text('Birth time (for precise nakshatra)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickTime(context),
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),

          // Birth place
          const SizedBox(height: 16),
          Text('Birth Place', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(
            'Optional — used for precise moon position at birth.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetCities.map((city) {
              final isSelected = state.birthPlaceName == city.name;
              return ChoiceChip(
                label: Text(city.name),
                selected: isSelected,
                onSelected: (_) => notifier.setBirthPlace(
                  latitude: city.lat,
                  longitude: city.lng,
                  name: city.name,
                ),
              );
            }).toList(),
          ),
          if (state.birthPlaceName != null) ...[
            const SizedBox(height: 12),
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.location_city),
                    const SizedBox(width: 8),
                    Text(state.birthPlaceName!),
                  ],
                ),
              ),
            ),
          ],

          // Info note about accuracy
          const SizedBox(height: 24),
          Card(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'If you know your birth nakshatra already, you can '
                      'skip this step. The previous step selection will be used.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Calculate from DOB button
          if (state.birthDate != null) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: notifier.calculateFromDOB,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Calculate Nakshatra from DOB'),
              ),
            ),
          ],

          // Calculated result display
          if (state.calculatedNakshatra != null) ...[
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Calculated: ${state.calculatedNakshatra!.displayName}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (state.birthBird != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Your bird: ${state.birthBird!.displayName}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Moon sidereal longitude: '
                      '${state.calculatedNakshatra!.siderealLongitude.toStringAsFixed(2)}\u00B0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (state.isNearBoundary) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            size: 16,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Near nakshatra boundary — birth time accuracy is '
                              'important. Verify with a panchangam if unsure.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: state.birthDate ?? DateTime(1990),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: 'Select your date of birth',
    );
    if (picked != null) {
      notifier.setBirthDate(picked);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: state.birthTimeOfDay ?? const TimeOfDay(hour: 6, minute: 0),
      helpText: 'Select your birth time',
    );
    if (picked != null) {
      notifier.setBirthTime(picked);
    }
  }
}

class _LocationStep extends StatelessWidget {
  const _LocationStep({required this.state, required this.notifier});
  final OnboardingState state;
  final OnboardingNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.yourLocation, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            l10n.locationHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          // Preset cities for quick selection
          Text(l10n.quickSelect, style: theme.textTheme.titleSmall),
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
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.dataStorage, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          l10n.dataStorageHint,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        _StorageOption(
          title: l10n.localOnly,
          subtitle: l10n.localOnlySubtitle,
          icon: Icons.phone_android,
          isSelected: state.storageMode == 'local',
          onTap: () => notifier.setStorageMode('local'),
        ),
        _StorageOption(
          title: l10n.icloud,
          subtitle: l10n.icloudSubtitle,
          icon: Icons.cloud,
          isSelected: state.storageMode == 'icloud',
          onTap: () => notifier.setStorageMode('icloud'),
        ),
        _StorageOption(
          title: l10n.googleDrive,
          subtitle: l10n.googleDriveSubtitle,
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
