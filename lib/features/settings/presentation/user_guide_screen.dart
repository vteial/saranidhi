import 'package:flutter/material.dart';

import 'package:saranidhi/core/utils/responsive_wrapper.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// In-app User Guide screen — flat scrollable layout.
///
/// Accessible from Settings → About → User Guide.
/// Contains the same spiritual/practical content as the intro page
/// but expanded with full sections, best practices, and FAQ.
class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.guideTitle),
        leading: const BackButton(),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: What is Saranidhi?
              _Section(
                title: l10n.guideWhatTitle,
                body: l10n.guideWhatBody,
              ),

              // Section 2: The Science Behind It
              _Section(
                title: l10n.guideScienceTitle,
                body: l10n.guideScienceBody,
              ),

              // Section 3: Your Birth Bird
              _Section(
                title: l10n.guideBirdTitle,
                body: l10n.guideBirdBody,
              ),

              // Section 4: Daily Rhythm
              _Section(
                title: l10n.guideRhythmTitle,
                body: l10n.guideRhythmBody,
              ),

              // Section 5: How to Use the App
              _Section(
                title: l10n.guideHowToTitle,
                body: l10n.guideHowToBody,
              ),

              // Section 6: Best Practices
              _Section(
                title: l10n.guideBestTitle,
                body: l10n.guideBestBody,
              ),

              // Section 7: Understanding the Dashboard
              _Section(
                title: l10n.guideDashboardTitle,
                body: l10n.guideDashboardBody,
              ),

              // Section 8: Benefits
              _Section(
                title: l10n.guideBenefitsTitle,
                body: l10n.guideBenefitsBody,
              ),

              // Section 9: FAQ
              _Section(
                title: l10n.guideFaqTitle,
                body: l10n.guideFaqBody,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
