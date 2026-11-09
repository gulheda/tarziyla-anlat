import 'package:flutter/services.dart';

/// Titreşim geri bildirimi. Ayarlardan kapatılabilir; web'de sessizce atlanır.
class Haptics {
  static bool enabled = true;

  static void selection() {
    if (enabled) HapticFeedback.selectionClick();
  }

  static void medium() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  static void heavy() {
    if (enabled) HapticFeedback.heavyImpact();
  }
}
