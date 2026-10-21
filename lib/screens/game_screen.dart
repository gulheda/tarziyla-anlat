import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/game.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.game});

  final Game game;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Game get game => widget.game;
  int _lastBuzz = -1;

  @override
  void initState() {
    super.initState();
    game.addListener(_buzzNearEnd);
  }

  @override
  void dispose() {
    game.removeListener(_buzzNearEnd);
    game.dispose();
    super.dispose();
  }

  /// Son beş saniyede her saniye titreşim verir.
  void _buzzNearEnd() {
    if (game.phase == Phase.playing &&
        game.secondsLeft <= 5 &&
        game.secondsLeft != _lastBuzz) {
      _lastBuzz = game.secondsLeft;
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Perde mi iniyor?'),
        content: const Text('Çıkarsan skorlar kaybolur.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Devam',
              style: AppText.display(16, color: AppColors.yellow),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Çık',
              style: AppText.display(16, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: GradientScaffold(
        body: ListenableBuilder(
          listenable: game,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.all(20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: 0.96, end: 1.0).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(game.phase),
                child: switch (game.phase) {
                  Phase.handover => _Handover(game: game),
                  Phase.playing => _Playing(game: game),
                  Phase.result => _Result(game: game),
                  Phase.finished => _Finished(game: game),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreStrip extends StatelessWidget {
  const _ScoreStrip({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        for (final p in game.participants)
          Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 14, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: identical(p, game.currentPlayer)
                  ? const LinearGradient(
                      colors: [AppColors.yellow, AppColors.orange],
                    )
                  : null,
              color: identical(p, game.currentPlayer)
                  ? null
                  : Colors.white.withValues(alpha: 0.12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Avatar(emoji: p.emoji, size: 30),
                const SizedBox(width: 8),
                Text(
                  '${p.name}  ${p.score}',
                  style: AppText.display(
                    15,
                    color: identical(p, game.currentPlayer)
                        ? AppColors.ink
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Handover extends StatefulWidget {
  const _Handover({required this.game});

  final Game game;

  @override
  State<_Handover> createState() => _HandoverState();
}

class _HandoverState extends State<_Handover> {
  int? _count;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Önceki ekranda zaten bastın; geri sayım ek dokunuş istemeden başlar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _begin();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// "3, 2, 1" geri sayımı yapar, ardından turu başlatır.
  void _begin() {
    if (_count != null) return;
    HapticFeedback.mediumImpact();
    setState(() => _count = 3);
    _timer = Timer.periodic(const Duration(milliseconds: 800), (t) {
      final next = _count! - 1;
      if (next <= 0) {
        t.cancel();
        widget.game.startTurn();
      } else {
        HapticFeedback.selectionClick();
        setState(() => _count = next);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: 0.35,
          duration: const Duration(milliseconds: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'TUR ${game.round} / ${game.config.rounds}',
                    style: AppText.display(
                      14,
                      letterSpacing: 3,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _ScoreStrip(game: game),
              const Spacer(),
              Center(
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(game.turnIndex),
                  tween: Tween(begin: 0.6, end: 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Avatar(
                    emoji: game.currentPlayer.emoji,
                    size: 130,
                    glow: true,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                game.currentPlayer.name,
                textAlign: TextAlign.center,
                style: AppText.display(
                  46,
                  shadows: const [
                    Shadow(color: AppColors.pink, offset: Offset(0, 4)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                game.handoverLine,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 17,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.yellow.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '⏱️ ${game.config.seconds} saniyen var',
                    style: AppText.display(16, color: AppColors.yellow),
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 56),
            ],
          ),
        ),
        if (_count != null)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(_count),
                  tween: Tween(begin: 1.9, end: 1),
                  duration: const Duration(milliseconds: 520),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Text(
                    '$_count',
                    style: AppText.display(
                      190,
                      color: AppColors.yellow,
                      shadows: const [
                        Shadow(color: AppColors.orange, offset: Offset(0, 10)),
                        Shadow(color: Colors.black45, blurRadius: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Playing extends StatelessWidget {
  const _Playing({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final competitive = game.config.mode == GameMode.competitive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Avatar(emoji: game.currentPlayer.emoji, size: 42),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      game.currentPlayer.name,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.display(17),
                    ),
                  ),
                ],
              ),
            ),
            TimerRing(
              secondsLeft: game.secondsLeft,
              totalSeconds: game.config.seconds,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: competitive
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.green.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${game.turnCorrect.length}',
                              style: AppText.display(
                                20,
                                color: AppColors.green,
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Stack(
            children: [
              _SwipeArea(
                canPass: game.canPass,
                onCorrect: () {
                  HapticFeedback.mediumImpact();
                  game.markCorrect();
                },
                onPass: () {
                  HapticFeedback.selectionClick();
                  game.pass();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: _FlipSwitcher(
                        id: game.current.konu,
                        child: GameCard(
                          label: 'KELİME',
                          text: game.current.konu,
                          icon: Icons.record_voice_over,
                          colors: pickGradient(
                            konuGradients,
                            game.current.konu,
                          ),
                          tilt: -0.012,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: _FlipSwitcher(
                        id: game.current.tarz,
                        child: GameCard(
                          label: 'TARZ',
                          text: game.current.tarz,
                          icon: Icons.theater_comedy,
                          colors: pickGradient(
                            tarzGradients,
                            game.current.tarz,
                          ),
                          tilt: 0.012,
                          textSize: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(child: _Burst(count: game.turnCorrect.length)),
              Positioned.fill(
                child: Center(child: _PlusOne(count: game.turnCorrect.length)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: BigButton(
                label: competitive
                    ? 'Pas (${game.passesLeft})'
                    : 'Değiştir (${game.passesLeft})',
                icon: Icons.skip_next_rounded,
                colors: const [Color(0xFFFFC46B), AppColors.orange],
                onPressed: game.canPass
                    ? () {
                        HapticFeedback.selectionClick();
                        game.pass();
                      }
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BigButton(
                label: 'Bildiler!',
                icon: Icons.check_rounded,
                colors: const [AppColors.green, AppColors.greenDark],
                foreground: Colors.white,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  game.markCorrect();
                },
              ),
            ),
          ],
        ),
        if (!competitive)
          TextButton(
            onPressed: game.endTurnEarly,
            child: Text(
              'Vazgeç, kimse bilemedi',
              style: AppText.display(15, color: Colors.white70),
            ),
          ),
      ],
    );
  }
}

/// Kart çiftini sağa kaydırınca "Bildiler", sola kaydırınca "Pas" sayılır.
class _SwipeArea extends StatefulWidget {
  const _SwipeArea({
    required this.child,
    required this.onCorrect,
    required this.onPass,
    required this.canPass,
  });

  final Widget child;
  final VoidCallback onCorrect;
  final VoidCallback onPass;
  final bool canPass;

  @override
  State<_SwipeArea> createState() => _SwipeAreaState();
}

class _SwipeAreaState extends State<_SwipeArea>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );

  double _dx = 0;
  double _from = 0;
  double _to = 0;
  VoidCallback? _after;

  @override
  void initState() {
    super.initState();
    _anim.addListener(() {
      setState(() {
        _dx = _from + (_to - _from) * Curves.easeOut.transform(_anim.value);
      });
    });
    _anim.addStatusListener((status) {
      if (status != AnimationStatus.completed) return;
      final after = _after;
      _after = null;
      if (after != null) {
        setState(() => _dx = 0);
        after();
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _animateTo(double target, [VoidCallback? after]) {
    _from = _dx;
    _to = target;
    _after = after;
    _anim.forward(from: 0);
  }

  void _release(DragEndDetails d, double width) {
    final v = d.primaryVelocity ?? 0;
    final far = width * 0.26;
    if (_dx > far || v > 900) {
      _animateTo(width * 1.3, widget.onCorrect);
    } else if ((_dx < -far || v < -900) && widget.canPass) {
      _animateTo(-width * 1.3, widget.onPass);
    } else {
      _animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final p = (_dx / w).clamp(-1.0, 1.0);
        final right = p > 0;
        final hintOpacity = (p.abs() * 2.4).clamp(0.0, 1.0);
        final canShowPass = widget.canPass || right;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (d) {
            if (_anim.isAnimating) return;
            setState(() => _dx += d.delta.dx);
          },
          onHorizontalDragEnd: (d) => _release(d, w),
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(_dx, 0),
                child: Transform.rotate(angle: p * 0.16, child: widget.child),
              ),
              if (hintOpacity > 0.02 && canShowPass)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Align(
                      alignment: right
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Opacity(
                        opacity: hintOpacity,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: right ? AppColors.green : AppColors.orange,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 14),
                            ],
                          ),
                          child: Text(
                            right ? 'BİLDİLER!' : 'PAS',
                            style: AppText.display(
                              22,
                              color: right ? Colors.white : AppColors.ink,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Her doğru bildirimde ekranın ortasından saçılan renkli konfeti.
class _Burst extends StatelessWidget {
  const _Burst({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        key: ValueKey(count),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) =>
            CustomPaint(painter: _BurstPainter(t), size: Size.infinite),
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter(this.t);

  final double t;

  static const _colors = [
    AppColors.yellow,
    AppColors.pink,
    AppColors.cyan,
    AppColors.green,
    AppColors.orange,
    Colors.white,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    for (var i = 0; i < 30; i++) {
      final angle = i / 30 * 2 * pi + (i % 3) * 0.17;
      final reach = 90 + (i % 6) * 34;
      final pos =
          center +
          Offset(cos(angle) * reach * t, sin(angle) * reach * t + 140 * t * t);
      final fade = (1 - t * t).clamp(0.0, 1.0);
      final side = 7.0 + (i % 4) * 2;
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(t * (i.isEven ? 7 : -7));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: side,
            height: side * 0.55,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = _colors[i % _colors.length].withValues(alpha: fade),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.t != t;
}

/// Her doğru bildirimde yukarı süzülüp kaybolan "+1".
class _PlusOne extends StatelessWidget {
  const _PlusOne({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        key: ValueKey(count),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOut,
        builder: (context, t, _) => Opacity(
          opacity: (1 - t * t).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, -110 * t),
            child: Transform.scale(
              scale: 0.7 + 0.6 * sin(min(t * 1.6, 1) * pi / 2),
              child: Text(
                '+1',
                style: AppText.display(
                  96,
                  color: AppColors.green,
                  shadows: const [
                    Shadow(color: Colors.white, blurRadius: 14),
                    Shadow(color: Colors.black45, offset: Offset(0, 5)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kart değiştiğinde eski kartı döndürüp yenisini getirir.
class _FlipSwitcher extends StatelessWidget {
  const _FlipSwitcher({required this.id, required this.child});

  final String id;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutBack,
      layoutBuilder: (current, previous) =>
          Stack(fit: StackFit.expand, children: [...previous, ?current]),
      transitionBuilder: (child, animation) => AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          final v = animation.value.clamp(0.0, 1.0);
          return Opacity(
            opacity: v,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateX((1 - v) * 1.1),
              child: child,
            ),
          );
        },
      ),
      child: KeyedSubtree(key: ValueKey(id), child: child),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final competitive = game.config.mode == GameMode.competitive;
    final waitingForGuesser =
        !competitive && game.classicSolved && game.guesser == null;
    final title = game.secondsLeft == 0
        ? 'Süre doldu!'
        : (game.classicSolved ? 'Bildiler!' : 'Tur bitti');

    final children = <Widget>[
      Text(title, textAlign: TextAlign.center, style: AppText.display(34)),
      const SizedBox(height: 10),
    ];

    if (competitive) {
      children.addAll([
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: game.turnCorrect.length),
          duration: const Duration(milliseconds: 900),
          builder: (context, value, _) => Text(
            '$value',
            textAlign: TextAlign.center,
            style: AppText.display(
              104,
              color: AppColors.yellow,
              height: 1.05,
              shadows: const [
                Shadow(color: AppColors.orange, offset: Offset(0, 6)),
              ],
            ),
          ),
        ),
        Text(
          'kart bildirdin',
          textAlign: TextAlign.center,
          style: AppText.display(18, color: Colors.white70),
        ),
        const SizedBox(height: 14),
        _Bubble(text: game.verdict),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: [
              for (final c in game.turnCorrect)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.konu, style: AppText.display(16)),
                            Text(
                              c.tarz,
                              style: const TextStyle(color: Colors.white60),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ]);
    } else if (waitingForGuesser) {
      children.addAll([
        Text(
          'Kim bildi?',
          textAlign: TextAlign.center,
          style: AppText.display(22, color: Colors.white70),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 14,
              children: [
                for (var i = 0; i < game.participants.length; i++)
                  if (i != game.currentIndex)
                    PressableScale(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        game.awardClassic(i);
                      },
                      child: Container(
                        width: 124,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.18),
                              Colors.white.withValues(alpha: 0.06),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Avatar(emoji: game.participants[i].emoji, size: 66),
                            const SizedBox(height: 10),
                            Text(
                              game.participants[i].name,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.display(16),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ]);
    } else {
      children.addAll([
        const Spacer(),
        Text(
          game.guesser != null ? '🎉' : '🙈',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 84),
        ),
        const SizedBox(height: 14),
        _Bubble(text: game.verdict),
        const Spacer(),
      ]);
    }

    if (competitive || !waitingForGuesser) {
      children.addAll([
        const SizedBox(height: 8),
        _ScoreStrip(game: game),
        const SizedBox(height: 16),
        BigButton(
          label: game.turnIndex + 1 >= game.totalTurns
              ? 'Sonuçları gör'
              : 'Sıradaki: ${game.participants[(game.turnIndex + 1) % game.participants.length].name}',
          icon: Icons.arrow_forward_rounded,
          onPressed: game.nextTurn,
        ),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Finished extends StatelessWidget {
  const _Finished({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final ranking = game.ranking;
    final top = ranking.first.score;
    final winners = ranking.where((p) => p.score == top).toList();
    final tie = winners.length > 1;
    final rest = ranking.skip(3).toList();

    return Stack(
      children: [
        const Positioned.fill(child: Confetti()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 6),
            Text(
              tie ? 'Berabere!' : '${winners.first.name} kazandı!',
              textAlign: TextAlign.center,
              style: AppText.display(
                36,
                color: AppColors.yellow,
                shadows: const [
                  Shadow(color: AppColors.orange, offset: Offset(0, 4)),
                ],
              ),
            ),
            if (tie)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  winners.map((w) => w.name).join(' · '),
                  textAlign: TextAlign.center,
                  style: AppText.display(18),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              game.finalLine,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 22),
                child: Column(
                  children: [
                    _Podium(top: ranking.take(3).toList()),
                    const SizedBox(height: 14),
                    for (var i = 0; i < rest.length; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${i + 4}',
                              style: AppText.display(18, color: Colors.white54),
                            ),
                            const SizedBox(width: 12),
                            Avatar(emoji: rest[i].emoji, size: 36),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                rest[i].name,
                                style: AppText.display(17),
                              ),
                            ),
                            Text(
                              '${rest[i].score}',
                              style: AppText.display(
                                20,
                                color: AppColors.yellow,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            BigButton(
              label: 'Tekrar oyna',
              icon: Icons.replay_rounded,
              onPressed: () => Navigator.of(context).pushReplacement(
                fadeSlideRoute(GameScreen(game: Game(game.config))),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Ana menü',
                style: AppText.display(16, color: Colors.white70),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// İlk üç oyuncu için basamaklı podyum (2. - 1. - 3. sırasıyla).
class _Podium extends StatelessWidget {
  const _Podium({required this.top});

  final List<Participant> top;

  static const _heights = [150.0, 112.0, 84.0];
  static const _medals = [AppColors.gold, AppColors.silver, AppColors.bronze];
  static const _durations = [1100, 800, 550];

  @override
  Widget build(BuildContext context) {
    final order = switch (top.length) {
      >= 3 => [1, 0, 2],
      2 => [1, 0],
      _ => [0],
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final rank in order) Expanded(child: _step(top[rank], rank)),
      ],
    );
  }

  Widget _step(Participant p, int rank) {
    final medal = _medals[rank];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (rank == 0) const Text('👑', style: TextStyle(fontSize: 34)),
        Avatar(emoji: p.emoji, size: rank == 0 ? 76 : 60, glow: rank == 0),
        const SizedBox(height: 6),
        Text(
          p.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.display(15),
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: _heights[rank]),
          duration: Duration(milliseconds: _durations[rank]),
          curve: Curves.easeOutBack,
          builder: (context, h, _) => Container(
            height: max(h, 0),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [medal, Color.lerp(medal, Colors.black, 0.35)!],
              ),
              boxShadow: [
                BoxShadow(color: medal.withValues(alpha: 0.35), blurRadius: 16),
              ],
            ),
            child: h < 80
                ? null
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${rank + 1}',
                        style: AppText.display(34, color: AppColors.ink),
                      ),
                      Text(
                        '${p.score} puan',
                        style: AppText.display(13, color: AppColors.ink),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
