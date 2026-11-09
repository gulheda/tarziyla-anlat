import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../services/settings.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openSource(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ok = await launchUrl(
        Uri.parse(repoUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!ok) messenger.showSnackBar(const SnackBar(content: Text(repoUrl)));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(content: Text(repoUrl)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = SettingsScope.of(context);
    final selected = settings.locale?.languageCode ?? 'system';

    return GradientScaffold(
      title: l10n.settings,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🌍  ${l10n.settingsLanguage}',
                  style: AppText.display(20),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                        value: 'system',
                        label: Text(l10n.languageSystem),
                      ),
                      const ButtonSegment(value: 'tr', label: Text('Türkçe')),
                      const ButtonSegment(value: 'en', label: Text('English')),
                    ],
                    selected: {selected},
                    onSelectionChanged: (s) {
                      final v = s.first;
                      settings.setLocale(v == 'system' ? null : Locale(v));
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            // ListTile mürekkep efektleri için kendi Material'ine ihtiyaç duyar.
            child: Material(
              type: MaterialType.transparency,
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                activeThumbColor: AppColors.ink,
                activeTrackColor: AppColors.yellow,
                title: Text(
                  '📳  ${l10n.settingsVibration}',
                  style: AppText.display(18),
                ),
                subtitle: Text(
                  l10n.settingsVibrationDesc,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
                value: settings.haptics,
                onChanged: settings.setHaptics,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ℹ️  ${l10n.settingsAbout}', style: AppText.display(20)),
                const SizedBox(height: 8),
                Text(
                  l10n.settingsAboutBody,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settingsVersion(appVersion),
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _openSource(context),
                  icon: const Icon(Icons.code, color: AppColors.yellow),
                  label: Text(
                    l10n.settingsSource,
                    style: AppText.display(16, color: AppColors.yellow),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => showLicensePage(
                    context: context,
                    applicationName: l10n.appName,
                    applicationVersion: appVersion,
                    applicationLegalese: 'MIT License · © 2026 gulheda',
                  ),
                  icon: const Icon(
                    Icons.description_outlined,
                    color: AppColors.yellow,
                  ),
                  label: Text(
                    l10n.settingsLicenses,
                    style: AppText.display(16, color: AppColors.yellow),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
