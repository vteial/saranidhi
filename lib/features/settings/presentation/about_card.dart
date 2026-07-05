import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:saranidhi/features/settings/presentation/user_guide_screen.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Provides app version info from package_info_plus.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return '${info.version} (${info.buildNumber})';
});

/// Apple-style About card displayed in Settings.
class AboutCard extends ConsumerWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final versionAsync = ref.watch(appVersionProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Logo
            SvgPicture.asset('public/logo.svg', width: 64, height: 64),
            const SizedBox(height: 12),

            // App name
            Text(
              l10n.appTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Version
            versionAsync.when(
              data: (version) => Text(
                'v$version',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              loading: () => const SizedBox(height: 14),
              error: (_, __) => Text(
                'v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Tagline
            Text(
              l10n.aboutTagline,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),

            const Divider(),
            const SizedBox(height: 8),

            // Developer info
            _InfoRow(
              icon: Icons.person_outline,
              label: l10n.aboutDeveloper,
              value: 'Eialarasu',
            ),
            _InfoRow(
              icon: Icons.email_outlined,
              label: l10n.aboutContact,
              value: 'vteial@icloud.com',
              onTap: _launchEmail,
            ),
            _InfoRow(
              icon: Icons.language,
              label: l10n.aboutWebsite,
              value: 'saranidhi.vercel.app',
              onTap: () => _launchUrl('https://saranidhi.vercel.app'),
            ),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            // Navigation links
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: Text(l10n.aboutUserGuide),
              trailing: const Icon(Icons.chevron_right),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const UserGuideScreen(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(l10n.aboutPrivacyPolicy),
              trailing: const Icon(Icons.open_in_new, size: 16),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () => _launchUrl('https://saranidhi.vercel.app/privacy.html'),
            ),

            const SizedBox(height: 16),

            // Footer
            Text(
              l10n.aboutBuiltIn,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.aboutCopyright,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final uri = Uri(scheme: 'mailto', path: 'vteial@icloud.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Text(label, style: theme.textTheme.bodySmall),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onTap != null ? theme.colorScheme.primary : null,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.open_in_new,
                size: 14,
                color: theme.colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
