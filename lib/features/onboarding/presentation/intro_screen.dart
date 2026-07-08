import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:saranidhi/core/l10n/locale_provider.dart';
import 'package:saranidhi/core/router/onboarding_guard.dart';
import 'package:saranidhi/core/utils/responsive_wrapper.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Pre-onboarding intro screen shown before the 4-step onboarding flow.
///
/// Gives first-time users context about the app before asking them
/// to configure their profile. Shows app story, how it works, and
/// a "Get Started" button to proceed to onboarding.
class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      body: ResponsiveWrapper(
        child: SafeArea(
          child: Column(
            children: [
              // Language toggle at top-right
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: SegmentedButton<AppLocale>(
                    segments: const [
                      ButtonSegment(
                        value: AppLocale.english,
                        label: Text('EN'),
                      ),
                      ButtonSegment(
                        value: AppLocale.tamil,
                        label: Text('TA'),
                      ),
                    ],
                    selected: {currentLocale},
                    onSelectionChanged: (selection) {
                      ref
                          .read(localeProvider.notifier)
                          .setLocale(selection.first);
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),

                      // Logo + title centered
                      Center(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'public/logo.svg',
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.appTitle,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.introTagline,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // What is Saranidhi?
                      _SectionTitle(l10n.introWhatTitle),
                      const SizedBox(height: 8),
                      Text(
                        l10n.introWhatBody,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // How it works — 3 bullet points
                      _SectionTitle(l10n.introHowTitle),
                      const SizedBox(height: 12),
                      _BulletPoint(
                        emoji: '\u2728',
                        text: l10n.introHowBullet1,
                      ),
                      _BulletPoint(
                        emoji: '\uD83C\uDF05',
                        text: l10n.introHowBullet2,
                      ),
                      _BulletPoint(
                        emoji: '\uD83E\uDEE1',
                        text: l10n.introHowBullet3,
                      ),
                      const SizedBox(height: 24),

                      // What you'll need
                      _SectionTitle(l10n.introNeedTitle),
                      const SizedBox(height: 12),
                      _BulletPoint(
                        emoji: '\uD83C\uDF19',
                        text: l10n.introNeedBullet1,
                      ),
                      _BulletPoint(
                        emoji: '\uD83D\uDCCD',
                        text: l10n.introNeedBullet2,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Get Started button — fixed at bottom
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      ref.read(introSeenProvider.notifier).markSeen();
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(l10n.introGetStarted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.emoji, required this.text});
  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
