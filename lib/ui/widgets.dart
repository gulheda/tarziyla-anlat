import 'dart:math';

import 'package:flutter/material.dart';

import 'theme.dart';

/// Tüm ekranlarda ortak koyu mor gradyan zemin: kayan renk lekeleri ve parıldayan şekiller.
class GradientScaffold extends StatefulWidget {
  const GradientScaffold({super.key, required this.body, this.title});

  final Widget body;
  final String? title;

  @override
  State<GradientScaffold> createState() => _GradientScaffoldState();
}

class _GradientScaffoldState extends State<GradientScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void dispose() {
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    return Scaffold(
      backgroundColor: AppColors.bg1,
      extendBodyBehindAppBar: true,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title, style: AppText.display(24)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
            ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bg1, AppColors.bg2],
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _ambient,
              builder: (context, _) {
                final t = _ambient.value * 2 * pi;
                return Stack(
                  children: [
                    _blob(
                      top: -60 + sin(t) * 16,
                      right: -50 + cos(t) * 14,
                      size: 220,
                      color: AppColors.pink,
                    ),
                    _blob(
                      bottom: 80 + cos(t) * 18,
                      left: -80 + sin(t) * 14,
                      size: 240,
                      color: AppColors.cyan,
                    ),
                  ],
                );
              },
            ),
            Positioned.fill(
              child: RepaintBoundary(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _ambient,
                    builder: (context, _) =>
                        CustomPaint(painter: _SprinklePainter(_ambient.value)),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: title == null ? 0 : kToolbarHeight,
                ),
                child: widget.body,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.28),
                color.withValues(alpha: 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Sprinkle {
  const _Sprinkle(this.x, this.y, this.size, this.phase, this.type);

  final double x;
  final double y;
  final double size;
  final double phase;
  final int type;
}

final List<_Sprinkle> _sprinkles = () {
  final r = Random(11);
  return List.generate(
    46,
    (i) => _Sprinkle(
      r.nextDouble(),
      r.nextDouble(),
      4 + r.nextDouble() * 7,
      r.nextDouble(),
      i % 3,
    ),
  );
}();

/// Arka plana serpiştirilmiş; hafifçe parıldayıp süzülen artı, daire ve yıldız şekilleri.
class _SprinklePainter extends CustomPainter {
  const _SprinklePainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final fill = Paint();
    for (final sp in _sprinkles) {
      final wave = sin(2 * pi * (t + sp.phase));
      final glow = 0.5 + 0.5 * wave;
      final c = Offset(sp.x * size.width, sp.y * size.height + wave * 6);
      final s = sp.size;
      switch (sp.type) {
        case 0:
          fill.color = Colors.white.withValues(alpha: 0.04 + 0.07 * glow);
          canvas.drawCircle(c, s * 0.6, fill);
        case 1:
          line.color = Colors.white.withValues(alpha: 0.05 + 0.09 * glow);
          canvas.drawLine(c.translate(-s, 0), c.translate(s, 0), line);
          canvas.drawLine(c.translate(0, -s), c.translate(0, s), line);
        default:
          fill.color = Colors.white.withValues(alpha: 0.05 + 0.13 * glow);
          final k = s * (1.2 + 0.3 * glow);
          final path = Path()
            ..moveTo(c.dx, c.dy - k)
            ..quadraticBezierTo(c.dx, c.dy, c.dx + k, c.dy)
            ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + k)
            ..quadraticBezierTo(c.dx, c.dy, c.dx - k, c.dy)
            ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - k);
          canvas.drawPath(path, fill);
      }
    }
  }

  @override
  bool shouldRepaint(_SprinklePainter old) => old.t != t;
}

/// Camsı, yarı saydam içerik paneli.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: child,
    );
  }
}

/// Basıldığında hafifçe küçülen dokunma alanı.
class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap == null || _down == v) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.95 : 1,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Kalın, parlak ve "basılabilir" görünümlü gradyan buton.
class BigButton extends StatelessWidget {
  const BigButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.colors = const [AppColors.yellow, AppColors.orange],
    this.foreground = AppColors.ink,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final List<Color> colors;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final radius = BorderRadius.circular(22);
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: PressableScale(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.lerp(colors.last, Colors.black, 0.5)!,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: colors.first.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                // Üst yarıda parlaklık efekti.
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 26,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.38),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: foreground, size: 26),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: AppText.display(21, color: foreground),
                        ),
                      ),
                    ],
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

/// Yuvarlak avatar: emoji, isteğe bağlı vurgu halkasıyla.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.emoji,
    this.size = 40,
    this.glow = false,
  });

  final String emoji;
  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.28),
            Colors.white.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: glow ? AppColors.yellow : Colors.white.withValues(alpha: 0.25),
          width: glow ? 3 : 1.5,
        ),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: AppColors.yellow.withValues(alpha: 0.5),
                  blurRadius: size / 2.5,
                ),
              ]
            : null,
      ),
      child: Text(emoji, style: TextStyle(fontSize: size * 0.52)),
    );
  }
}

/// Geri sayım halkası; süre azalınca kırmızıya döner ve atar.
class TimerRing extends StatelessWidget {
  const TimerRing({
    super.key,
    required this.secondsLeft,
    required this.totalSeconds,
    this.size = 80,
  });

  final int secondsLeft;
  final int totalSeconds;
  final double size;

  @override
  Widget build(BuildContext context) {
    final urgent = secondsLeft <= 10;
    final colors = urgent
        ? const [Color(0xFFFF8A8A), Color(0xFFFF3D5A)]
        : const [AppColors.yellow, AppColors.orange];
    return TweenAnimationBuilder<double>(
      key: ValueKey(urgent ? secondsLeft : -1),
      tween: Tween(begin: urgent ? 1.2 : 1.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.25),
          boxShadow: [
            BoxShadow(
              color: colors.last.withValues(alpha: urgent ? 0.55 : 0.3),
              blurRadius: 18,
            ),
          ],
        ),
        child: CustomPaint(
          painter: _RingPainter(secondsLeft / totalSeconds, colors),
          child: Center(
            child: Text(
              '$secondsLeft',
              style: AppText.display(size * 0.42, color: colors.first),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress, this.colors);

  final double progress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.1;
    final area = (Offset.zero & size).deflate(stroke);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.white.withValues(alpha: 0.14);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: [colors.last, colors.first],
        transform: const GradientRotation(0),
      ).createShader(area);
    canvas.drawArc(area, 0, 2 * pi, false, base);
    canvas.drawArc(area, -pi / 2, 2 * pi * progress.clamp(0, 1), false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.colors != colors;
}

/// Gerçek oyun kartı gibi: desenli, iç çerçeveli, köşe etiketli kart.
class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.label,
    required this.text,
    required this.icon,
    required this.colors,
    this.tilt = 0,
    this.textSize = 36,
  });

  final String label;
  final String text;
  final IconData icon;
  final List<Color> colors;
  final double tilt;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    final corner = AppText.display(
      13,
      color: Colors.white.withValues(alpha: 0.9),
      letterSpacing: 3,
    );
    return Transform.rotate(
      angle: tilt,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.55),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.45),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(27),
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: _HalftonePainter()),
              ),
              // Dev, silik filigran simge.
              Positioned(
                right: -26,
                bottom: -30,
                child: Transform.rotate(
                  angle: -0.25,
                  child: Icon(
                    icon,
                    size: 170,
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
              ),
              // İç çerçeve.
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                      width: 1.6,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 22, 26, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(label, style: corner),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 270),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: AppText.display(
                                textSize,
                                height: 1.12,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(0, 3),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.rotate(
                        angle: pi,
                        child: Text(label, style: corner),
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

class _HalftonePainter extends CustomPainter {
  const _HalftonePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.07);
    const step = 22.0;
    var row = 0;
    for (var y = 0.0; y < size.height; y += step) {
      final offset = row.isEven ? 0.0 : step / 2;
      for (var x = -offset; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 3.2, paint);
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(_HalftonePainter old) => false;
}

/// Kazanan ekranı için basit konfeti yağmuru.
class Confetti extends StatefulWidget {
  const Confetti({super.key});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  final List<_Piece> _pieces = _generate();

  static List<_Piece> _generate() {
    final r = Random(7);
    const palette = [
      AppColors.pink,
      AppColors.yellow,
      AppColors.cyan,
      AppColors.green,
      AppColors.orange,
    ];
    return List.generate(
      48,
      (_) => _Piece(
        x: r.nextDouble(),
        phase: r.nextDouble(),
        size: 6 + r.nextDouble() * 8,
        spin: r.nextDouble() * 6,
        color: palette[r.nextInt(palette.length)],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _ConfettiPainter(_pieces, _controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _Piece {
  const _Piece({
    required this.x,
    required this.phase,
    required this.size,
    required this.spin,
    required this.color,
  });

  final double x;
  final double phase;
  final double size;
  final double spin;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.t);

  final List<_Piece> pieces;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final fall = (t + p.phase) % 1.0;
      final dx = p.x * size.width + sin((fall + p.phase) * 2 * pi * 2) * 18;
      final dy = fall * (size.height + 40) - 20;
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(fall * p.spin * 2 * pi);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.55,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = p.color,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
