import 'package:flutter/material.dart';

import '../ui/theme.dart';
import '../ui/widgets.dart';

class HowToScreen extends StatelessWidget {
  const HowToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      (
        '📱',
        'Telefonu al',
        'Sırası gelen oyuncu telefonu alır. Diğerleri ekrana bakmaz, bakarsa komik olmaz.',
        [AppColors.pink, AppColors.orange],
      ),
      (
        '🃏',
        'İki kart çek',
        'KELİME kartı ne anlatacağını, TARZ kartı nasıl anlatacağını söyler. '
            'Örneğin "Penguen" + "Nenen gibi konuş".',
        [AppColors.blue, AppColors.cyan],
      ),
      (
        '🎭',
        'Rezil ol',
        'Kelimeyi söylemeden, tarzına sadık kalarak anlat. Diğerleri tahmin eder.',
        [Color(0xFF9B5CFF), AppColors.pink],
      ),
      (
        '⭐',
        'Puanı topla',
        'Klasik modda bilen ve anlatan birer puan alır. '
            'Rekabetçi modda süre bitene kadar bildiğin kadar kart anlatırsın, '
            'her doğru bir puandır.',
        [AppColors.green, AppColors.greenDark],
      ),
      (
        '🏆',
        'Kazanan belli olur',
        'Tüm turlar bitince en çok puanlı kazanır. Sonuncu da sahne korkusu ödülünü alır.',
        [AppColors.yellow, AppColors.orange],
      ),
    ];
    return GradientScaffold(
      title: 'Nasıl oynanır?',
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: steps.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final s = steps[i];
          return GlassPanel(
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
          );
        },
      ),
    );
  }
}
