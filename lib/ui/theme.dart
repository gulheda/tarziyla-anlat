import 'package:flutter/material.dart';

class AppColors {
  static const bg1 = Color(0xFF1A0B3F);
  static const bg2 = Color(0xFF4B1D8F);
  static const pink = Color(0xFFFF4D8D);
  static const orange = Color(0xFFFF9A3D);
  static const cyan = Color(0xFF22D3EE);
  static const blue = Color(0xFF4F6BFF);
  static const green = Color(0xFF2FD07A);
  static const greenDark = Color(0xFF14A85A);
  static const yellow = Color(0xFFFFD84D);
  static const ink = Color(0xFF2B1055);
  static const gold = Color(0xFFFFD84D);
  static const silver = Color(0xFFC9D1DC);
  static const bronze = Color(0xFFD9904F);
}

/// Konu kartları için sıcak, tarz kartları için soğuk renk çiftleri.
/// Her kart metnine göre sabit bir çift seçilir, böylece kartlar tek tip durmaz.
const List<List<Color>> konuGradients = [
  [AppColors.pink, AppColors.orange],
  [Color(0xFFFF5C8A), Color(0xFFB14CFF)],
  [Color(0xFFFF7A1A), Color(0xFFFFB02E)],
  [Color(0xFFFF4D6D), Color(0xFFFF9A3D)],
];

const List<List<Color>> tarzGradients = [
  [AppColors.blue, AppColors.cyan],
  [Color(0xFF7B5CFF), AppColors.blue],
  [Color(0xFF14B8A6), AppColors.cyan],
  [Color(0xFF2FD07A), Color(0xFF22D3EE)],
];

List<Color> pickGradient(List<List<Color>> options, String key) =>
    options[key.hashCode.abs() % options.length];

/// Başlık, buton ve kart yazıları için oyunsu font (tek ağırlıklı, Türkçe destekli).
class AppText {
  static TextStyle display(
    double size, {
    Color color = Colors.white,
    double? height,
    double letterSpacing = 0,
    List<Shadow>? shadows,
  }) {
    return TextStyle(
      fontFamily: 'Paytone',
      fontSize: size,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      shadows: shadows,
      fontWeight: FontWeight.w400,
    );
  }
}

ThemeData buildTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.bg2,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.yellow,
        onPrimary: AppColors.ink,
        secondary: AppColors.pink,
        surface: AppColors.bg1,
        error: const Color(0xFFFF5C6C),
      );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: Brightness.dark,
  );
  TextStyle? paytone(TextStyle? s) =>
      s?.copyWith(fontFamily: 'Paytone', fontWeight: FontWeight.w400);
  final t = base.textTheme;

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg1,
    textTheme: t.copyWith(
      displayLarge: paytone(t.displayLarge),
      displayMedium: paytone(t.displayMedium),
      displaySmall: paytone(t.displaySmall),
      headlineLarge: paytone(t.headlineLarge),
      headlineMedium: paytone(t.headlineMedium),
      headlineSmall: paytone(t.headlineSmall),
      titleLarge: paytone(t.titleLarge),
      titleMedium: paytone(t.titleMedium),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.yellow, width: 2),
      ),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.yellow,
      thumbColor: AppColors.yellow,
      inactiveTrackColor: Colors.white24,
      trackHeight: 8,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        foregroundColor: Colors.white,
        selectedForegroundColor: AppColors.ink,
        selectedBackgroundColor: AppColors.yellow,
        side: const BorderSide(color: Colors.white24),
        textStyle: const TextStyle(fontFamily: 'Paytone', fontSize: 15),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.bg2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: AppText.display(22),
    ),
  );
}

/// Sayfa geçişi: hafif kayarak ve solarak gelir.
Route<T> fadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, _, _) => page,
    transitionsBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
