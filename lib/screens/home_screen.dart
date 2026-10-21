import 'dart:math';

import 'package:flutter/material.dart';

import '../data/cards.dart';
import '../data/funny.dart';
import '../logic/game.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import 'how_to_screen.dart';
import 'setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final String _tagline = taglines[Random().nextInt(taglines.length)];

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..forward();

  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _entrance.dispose();
    _bob.dispose();
    super.dispose();
  }

  void _open(GameMode mode) {
    Navigator.of(context).push(fadeSlideRoute(SetupScreen(mode: mode)));
  }

  /// Öğeyi belirtilen aralıkta aşağıdan kayarak ve solarak getirir.
  Widget _stagger(double begin, double end, Widget child) {
    final curved = CurvedAnimation(
      parent: _entrance,
      curve: Interval(begin, end, curve: Curves.easeOutBack),
    );
    final fade = CurvedAnimation(
      parent: _entrance,
      curve: Interval(begin, end, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.35),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _stagger(
                  0.0,
                  0.4,
                  AnimatedBuilder(
                    animation: _bob,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, sin(_bob.value * pi) * -8),
                      child: child,
                    ),
                    child: const _Emblem(),
                  ),
                ),
                const SizedBox(height: 18),
                _stagger(
                  0.12,
                  0.5,
                  Text(
                    appName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppText.display(
                      40,
                      letterSpacing: 1.5,
                      shadows: const [
                        Shadow(color: AppColors.pink, offset: Offset(0, 5)),
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(0, 9),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _stagger(
                  0.22,
                  0.6,
                  Column(
                    children: [
                      Text(
                        _tagline,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.yellow.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.yellow.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '🃏 $totalAnlatCount konu · ${tarzCards.length} tarz',
                          style: AppText.display(14, color: AppColors.yellow),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
                _stagger(
                  0.38,
                  0.75,
                  _ModeTile(
                    emoji: '🎉',
                    title: 'Klasik',
                    subtitle: 'Rahat parti modu.\nBilen ve anlatan puan alır.',
                    colors: const [AppColors.pink, AppColors.orange],
                    onTap: () => _open(GameMode.classic),
                  ),
                ),
                const SizedBox(height: 14),
                _stagger(
                  0.5,
                  0.87,
                  _ModeTile(
                    emoji: '⚡',
                    title: 'Rekabetçi',
                    subtitle: 'Takımlar sayaca karşı yarışır.\nBildikçe puan.',
                    colors: const [AppColors.blue, AppColors.cyan],
                    onTap: () => _open(GameMode.competitive),
                  ),
                ),
                const SizedBox(height: 18),
                _stagger(
                  0.7,
                  1.0,
                  TextButton.icon(
                    onPressed: () =>
                        Navigator.of(context)
                            .push(fadeSlideRoute(const HowToScreen())),
                    icon: const Icon(Icons.help_outline, color: Colors.white70),
                    label: Text(
                      'Nasıl oynanır?',
                      style: AppText.display(16, color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo: üst üste binmiş iki oyun kartı ve bir "!" rozeti.
class _Emblem extends StatelessWidget {
  const _Emblem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(-34, 8),
            child: Transform.rotate(
              angle: -0.24,
              child: const _MiniCard(
                colors: [AppColors.pink, AppColors.orange],
                icon: Icons.record_voice_over,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(34, -2),
            child: Transform.rotate(
              angle: 0.2,
              child: const _MiniCard(
                colors: [AppColors.blue, AppColors.cyan],
                icon: Icons.theater_comedy,
              ),
            ),
          ),
          Positioned(
            top: 4,
            child: Transform.translate(
              offset: const Offset(70, 0),
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.yellow,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.yellow.withValues(alpha: 0.6),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Text(
                  '!',
                  style: AppText.display(24, color: AppColors.ink),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.colors, required this.icon});

  final List<Color> colors;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 116,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.7),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.5),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, size: 44, color: Colors.white),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(26);
    return PressableScale(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.lerp(colors.first, Colors.black, 0.55)!,
              offset: const Offset(0, 7),
            ),
            BoxShadow(
              color: colors.last.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            children: [
              Positioned(
                right: -6,
                bottom: -16,
                child: Transform.rotate(
                  angle: 0.2,
                  child: Text(emoji, style: const TextStyle(fontSize: 92)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 96, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.display(28)),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
