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

              // Section 10: Reference Tables (always bilingual)
              const _ReferenceSection(),

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

/// Reference section with bilingual tables (always shows both EN + TA).
///
/// Contains: 27 Nakshatras → Bird, 7 Planets (Hora), 5 Elements (Tattva).
/// Displayed regardless of app language for clarity.
class _ReferenceSection extends StatelessWidget {
  const _ReferenceSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reference / \u0B89\u0BB3\u0BCD\u0BA8\u0BBF\u0BB2\u0BC8',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Planets (Hora)
          Text(
            'Planetary Hours (Hora) / \u0B95\u0BBF\u0BB0\u0B95 \u0BA8\u0BC7\u0BB0\u0BAE\u0BCD (\u0BB9\u0BCB\u0BB0\u0BBE)',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildPlanetsTable(theme),
          const SizedBox(height: 16),

          // Elements (Tattva)
          Text(
            'Five Elements (Tattva) / \u0B90\u0BA8\u0BCD\u0BA4\u0BC1 \u0BAA\u0BC2\u0BA4\u0B99\u0BCD\u0B95\u0BB3\u0BCD (\u0BA4\u0BA4\u0BCD\u0BB5\u0BAE\u0BCD)',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildElementsTable(theme),
          const SizedBox(height: 16),

          // Nakshatras → Bird
          Text(
            'Nakshatras & Birds / \u0BA8\u0B9F\u0BCD\u0B9A\u0BA4\u0BCD\u0BA4\u0BBF\u0BB0\u0BAE\u0BCD & \u0BAA\u0BB1\u0BB5\u0BC8',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildNakshatraTable(theme),
        ],
      ),
    );
  }

  Widget _buildPlanetsTable(ThemeData theme) {
    const planets = [
      ['\u2600\uFE0F', 'Sun', '\u0B9A\u0BC2\u0BB0\u0BBF\u0BAF\u0BA9\u0BCD', 'Surya'],
      ['\uD83C\uDF19', 'Moon', '\u0B9A\u0BA8\u0BCD\u0BA4\u0BBF\u0BB0\u0BA9\u0BCD', 'Chandra'],
      ['\u2642\uFE0F', 'Mars', '\u0B9A\u0BC6\u0BB5\u0BCD\u0BB5\u0BBE\u0BAF\u0BCD', 'Mangala'],
      ['\u263F', 'Mercury', '\u0BAA\u0BC1\u0BA4\u0BA9\u0BCD', 'Budha'],
      ['\u2643', 'Jupiter', '\u0B95\u0BC1\u0BB0\u0BC1', 'Guru'],
      ['\u2640\uFE0F', 'Venus', '\u0B9A\u0BC1\u0B95\u0BCD\u0BB0\u0BA9\u0BCD', 'Shukra'],
      ['\u2644', 'Saturn', '\u0B9A\u0BA9\u0BBF', 'Shani'],
    ];

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(30),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          children: [
            _cell('', theme, bold: true),
            _cell('English', theme, bold: true),
            _cell('\u0BA4\u0BAE\u0BBF\u0BB4\u0BCD', theme, bold: true),
            _cell('Sanskrit', theme, bold: true),
          ],
        ),
        ...planets.map((p) => TableRow(
          children: [
            _cell(p[0], theme),
            _cell(p[1], theme),
            _cell(p[2], theme),
            _cell(p[3], theme),
          ],
        )),
      ],
    );
  }

  Widget _buildElementsTable(ThemeData theme) {
    const elements = [
      ['\uD83C\uDF0D', 'Earth', '\u0BA8\u0BBF\u0BB2\u0BAE\u0BCD', 'Prithvi'],
      ['\uD83D\uDCA7', 'Water', '\u0BA8\u0BC0\u0BB0\u0BCD', 'Apas'],
      ['\uD83D\uDD25', 'Fire', '\u0BA8\u0BC6\u0BB0\u0BC1\u0BAA\u0BCD\u0BAA\u0BC1', 'Tejas'],
      ['\uD83D\uDCA8', 'Air', '\u0B95\u0BBE\u0BB1\u0BCD\u0BB1\u0BC1', 'Vayu'],
      ['\u2728', 'Ether', '\u0B86\u0B95\u0BBE\u0BAF\u0BAE\u0BCD', 'Akasha'],
    ];

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(30),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          children: [
            _cell('', theme, bold: true),
            _cell('English', theme, bold: true),
            _cell('\u0BA4\u0BAE\u0BBF\u0BB4\u0BCD', theme, bold: true),
            _cell('Sanskrit', theme, bold: true),
          ],
        ),
        ...elements.map((e) => TableRow(
          children: [
            _cell(e[0], theme),
            _cell(e[1], theme),
            _cell(e[2], theme),
            _cell(e[3], theme),
          ],
        )),
      ],
    );
  }

  Widget _buildNakshatraTable(ThemeData theme) {
    const nakshatras = [
      ['Ashwini', '\u0B85\u0BB8\u0BCD\u0BB5\u0BBF\u0BA9\u0BBF', 'Vulture'],
      ['Bharani', '\u0BAA\u0BB0\u0BA3\u0BBF', 'Owl'],
      ['Krittika', '\u0B95\u0BBF\u0BB0\u0BC1\u0BA4\u0BCD\u0BA4\u0BBF\u0B95\u0BC8', 'Crow'],
      ['Rohini', '\u0BB0\u0BCB\u0B95\u0BBF\u0BA3\u0BBF', 'Rooster'],
      ['Mrigashira', '\u0BAE\u0BBF\u0BB0\u0BC1\u0B95\u0B9A\u0BC0\u0BB0\u0BBF\u0B9F\u0BAE\u0BCD', 'Peacock'],
      ['Ardra', '\u0BA4\u0BBF\u0BB0\u0BC1\u0BB5\u0BBE\u0BA4\u0BBF\u0BB0\u0BC8', 'Vulture'],
      ['Punarvasu', '\u0BAA\u0BC1\u0BA9\u0BB0\u0BCD\u0BAA\u0BC2\u0B9A\u0BAE\u0BCD', 'Owl'],
      ['Pushya', '\u0BAA\u0BC2\u0B9A\u0BAE\u0BCD', 'Crow'],
      ['Ashlesha', '\u0B86\u0BAF\u0BBF\u0BB2\u0BCD\u0BAF\u0BAE\u0BCD', 'Rooster'],
      ['Magha', '\u0BAE\u0B95\u0BAE\u0BCD', 'Peacock'],
      ['Purva Phalguni', '\u0BAA\u0BC2\u0BB0\u0BAE\u0BCD', 'Vulture'],
      ['Uttara Phalguni', '\u0B89\u0BA4\u0BCD\u0BA4\u0BBF\u0BB0\u0BAE\u0BCD', 'Owl'],
      ['Hasta', '\u0B85\u0BB8\u0BCD\u0BA4\u0BAE\u0BCD', 'Crow'],
      ['Chitra', '\u0B9A\u0BBF\u0BA4\u0BCD\u0BA4\u0BBF\u0BB0\u0BC8', 'Rooster'],
      ['Swati', '\u0B9A\u0BC1\u0BB5\u0BBE\u0BA4\u0BBF', 'Peacock'],
      ['Vishakha', '\u0BB5\u0BBF\u0B9A\u0BBE\u0B95\u0BAE\u0BCD', 'Vulture'],
      ['Anuradha', '\u0B85\u0BA9\u0BC1\u0B9A\u0BAE\u0BCD', 'Owl'],
      ['Jyeshtha', '\u0B95\u0BC7\u0B9F\u0BCD\u0B9F\u0BC8', 'Crow'],
      ['Mula', '\u0BAE\u0BC2\u0BB2\u0BAE\u0BCD', 'Rooster'],
      ['Purva Ashadha', '\u0BAA\u0BC2\u0BB0\u0BBE\u0B9F\u0BAE\u0BCD', 'Peacock'],
      ['Uttara Ashadha', '\u0B89\u0BA4\u0BCD\u0BA4\u0BBF\u0BB0\u0BBE\u0B9F\u0BAE\u0BCD', 'Vulture'],
      ['Shravana', '\u0BA4\u0BBF\u0BB0\u0BC1\u0BB5\u0BCB\u0BA3\u0BAE\u0BCD', 'Owl'],
      ['Dhanishta', '\u0B85\u0BB5\u0BBF\u0B9F\u0BCD\u0B9F\u0BAE\u0BCD', 'Crow'],
      ['Shatabhisha', '\u0B9A\u0BA4\u0BAF\u0BAE\u0BCD', 'Rooster'],
      ['Purva Bhadrapada', '\u0BAA\u0BC2\u0BB0\u0B9F\u0BCD\u0B9F\u0BBE\u0BA4\u0BBF', 'Peacock'],
      ['Uttara Bhadrapada', '\u0B89\u0BA4\u0BCD\u0BA4\u0BBF\u0BB0\u0B9F\u0BCD\u0B9F\u0BBE\u0BA4\u0BBF', 'Vulture'],
      ['Revati', '\u0BB0\u0BC7\u0BB5\u0BA4\u0BBF', 'Owl'],
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          children: [
            _cell('English', theme, bold: true),
            _cell('\u0BA4\u0BAE\u0BBF\u0BB4\u0BCD', theme, bold: true),
            _cell('Bird', theme, bold: true),
          ],
        ),
        ...nakshatras.map((n) => TableRow(
          children: [
            _cell(n[0], theme),
            _cell(n[1], theme),
            _cell(n[2], theme),
          ],
        )),
      ],
    );
  }

  Widget _cell(String text, ThemeData theme, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
