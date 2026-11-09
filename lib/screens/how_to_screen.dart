import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

class HowToScreen extends StatelessWidget {
  const HowToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = [
      (
        '📱',
        l10n.howTo1Title,
        l10n.howTo1Body,
        [AppColors.pink, AppColors.orange],
      ),
      (
        '🃏',
        l10n.howTo2Title,
        l10n.howTo2Body,
        [AppColors.blue, AppColors.cyan],
      ),
      (
        '🎭',
        l10n.howTo3Title,
        l10n.howTo3Body,
        [const Color(0xFF9B5CFF), AppColors.pink],
      ),
      (
        '⭐',
        l10n.howTo4Title,
        l10n.howTo4Body,
        [AppColors.green, AppColors.greenDark],
      ),
      (
        '👆',
        l10n.howTo6Title,
        l10n.howTo6Body,
        [AppColors.cyan, AppColors.blue],
      ),
      (
        '🏆',
        l10n.howTo5Title,
        l10n.howTo5Body,
        [AppColors.yellow, AppColors.orange],
      ),
    ];
    return GradientScaffold(
      title: l10n.howToTitle,
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: steps.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final s = steps[i];
          return Semantics(
            container: true,
            label: '${i + 1}. ${s.$2}. ${s.$3}',
            excludeSemantics: true,
            child: GlassPanel(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: s.$4,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(s.$1, style: const TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${i + 1}. ${s.$2}', style: AppText.display(20)),
                        const SizedBox(height: 4),
                        Text(
                          s.$3,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
