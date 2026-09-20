import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/cloud_backup/providers/practice_sync_providers.dart';
import 'package:saranidhi/features/settings/presentation/merge_import_controller.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Settings card for Practice Sync (Sprint 47 — Practice Sync Phase 1).
///
/// Features:
/// - Master opt-in toggle (default OFF: consent gate, zero network traffic when disabled).
/// - Account row: sign-in with email & passphrase, signed-in state, sign-out.
/// - Scope checkboxes: Breath Sessions and Breath Journal (both default ON).
/// - Manual "Sync now" button with spinner.
/// - Quiet last-synced status and non-blocking error display.
class PracticeSyncCard extends ConsumerWidget {
  const PracticeSyncCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(practiceSyncConfigProvider);
    final syncState = ref.watch(practiceSyncNotifierProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Icon(
                  Icons.cloud_sync_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.practiceSyncTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.practiceSyncSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            // Master Opt-In Toggle
            SwitchListTile.adaptive(
              title: Text(l10n.syncEnableToggle),
              subtitle: Text(l10n.syncEnableToggleSubtitle),
              value: config.enabled,
              contentPadding: EdgeInsets.zero,
              dense: true,
              onChanged: (enabled) {
                ref
                    .read(practiceSyncConfigProvider.notifier)
                    .setEnabled(enabled: enabled);
              },
            ),

            if (!config.enabled) ...[
              const SizedBox(height: 4),
              Text(
                l10n.syncConsentNotice,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            // Detailed controls when enabled
            if (config.enabled) ...[
              const Divider(height: 24),

              // Account Row
              _AccountSection(
                isAuthenticated: syncState.isAuthenticated,
                userEmail: config.userEmail,
              ),

              const Divider(height: 24),

              // Scope Checkboxes
              CheckboxListTile(
                title: Text(l10n.syncScopeSessions),
                value: config.scopeSessions,
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (val) {
                  if (val != null) {
                    ref
                        .read(practiceSyncConfigProvider.notifier)
                        .setScopeSessions(enabled: val);
                  }
                },
              ),
              CheckboxListTile(
                title: Text(l10n.syncScopeJournal),
                subtitle: Text(
                  l10n.syncScopeJournalNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                value: config.scopeJournal,
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (val) {
                  if (val != null) {
                    ref
                        .read(practiceSyncConfigProvider.notifier)
                        .setScopeJournal(enabled: val);
                  }
                },
              ),

              const SizedBox(height: 12),

              // Sync Now Button + Quiet Status
              Row(
                children: [
                  FilledButton.icon(
                    onPressed:
                        (syncState.isSyncing || !syncState.isAuthenticated)
                        ? null
                        : () => ref
                              .read(practiceSyncNotifierProvider.notifier)
                              .syncNow(),
                    icon: syncState.isSyncing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.sync, size: 18),
                    label: Text(
                      syncState.isSyncing
                          ? l10n.syncingAction
                          : l10n.syncNowAction,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!syncState.isAuthenticated)
                    Expanded(
                      child: Text(
                        l10n.syncSignInRequired,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Quiet Status Display
              _SyncStatusDisplay(
                syncState: syncState,
                lastSyncedAt: config.lastSyncedAt,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AccountSection extends ConsumerWidget {
  const _AccountSection({
    required this.isAuthenticated,
    required this.userEmail,
  });

  final bool isAuthenticated;
  final String? userEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Icon(
          isAuthenticated
              ? Icons.account_circle
              : Icons.account_circle_outlined,
          size: 20,
          color: isAuthenticated
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            isAuthenticated
                ? l10n.syncSignedInAs(userEmail ?? 'User')
                : l10n.syncNotSignedIn,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        if (isAuthenticated)
          OutlinedButton(
            onPressed: () {
              ref.read(practiceSyncNotifierProvider.notifier).signOut();
            },
            child: Text(l10n.syncSignOutAction),
          )
        else
          FilledButton.tonal(
            onPressed: () => _showSignInDialog(context, ref),
            child: Text(l10n.syncSignInAction),
          ),
      ],
    );
  }

  void _showSignInDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(context: context, builder: (ctx) => const _SignInDialog());
  }
}

class _SignInDialog extends ConsumerStatefulWidget {
  const _SignInDialog();

  @override
  ConsumerState<_SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends ConsumerState<_SignInDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passphraseController;
  late final TextEditingController _serverUrlController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final config = ref.read(practiceSyncConfigProvider);
    _emailController = TextEditingController(text: config.userEmail ?? '');
    _passphraseController = TextEditingController();
    _serverUrlController = TextEditingController(text: config.serverUrl);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passphraseController.dispose();
    _serverUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final serverUrl = _serverUrlController.text.trim();
    if (serverUrl.isNotEmpty) {
      await ref
          .read(practiceSyncConfigProvider.notifier)
          .setServerUrl(serverUrl);
    }

    final success = await ref
        .read(practiceSyncNotifierProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          passphrase: _passphraseController.text,
        );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (!success) {
          _errorMessage =
              ref.read(practiceSyncNotifierProvider).errorMessage ??
              AppLocalizations.of(context).syncSignInFailed;
        }
      });
      if (success) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.syncSignInDialogTitle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.syncEmailField,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.syncEmailField
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passphraseController,
                decoration: InputDecoration(
                  labelText: l10n.syncPassphraseField,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? l10n.syncPassphraseField : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _serverUrlController,
                decoration: InputDecoration(
                  labelText: l10n.syncServerUrlField,
                  prefixIcon: const Icon(Icons.dns_outlined),
                ),
                keyboardType: TextInputType.url,
                autocorrect: false,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.syncCancel),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(l10n.syncSignInSubmit),
        ),
      ],
    );
  }
}

class _SyncStatusDisplay extends StatelessWidget {
  const _SyncStatusDisplay({
    required this.syncState,
    required this.lastSyncedAt,
  });

  final PracticeSyncState syncState;
  final DateTime? lastSyncedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (syncState.errorMessage != null) {
      return Text(
        l10n.syncFailedStatus(syncState.errorMessage!),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      );
    }

    final outcome = syncState.lastOutcome;
    if (outcome != null && outcome.isSuccess) {
      return Text(
        l10n.syncSuccessStatus(outcome.pulledInserted, outcome.pushed),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (lastSyncedAt != null) {
      return Text(
        l10n.syncLastSynced(formatBackupDate(lastSyncedAt!.toIso8601String())),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Text(
      l10n.syncNotYetSynced,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
