import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/game.dart';
import 'haptics.dart';

/// Bir modun son kullanılan kurulum ayarları.
class SetupMemory {
  const SetupMemory({this.names, required this.rounds, required this.seconds});

  /// Yalnızca kullanıcı varsayılan isimleri değiştirdiyse dolu olur.
  final List<String>? names;
  final int rounds;
  final int seconds;
}

/// Kalıcı uygulama ayarları: dil, titreşim ve son kurulum.
class AppSettings extends ChangeNotifier {
  AppSettings(this._prefs) {
    final code = _prefs.getString(_kLocale);
    _locale = (code == 'en' || code == 'tr') ? Locale(code!) : null;
    _haptics = _prefs.getBool(_kHaptics) ?? true;
    Haptics.enabled = _haptics;
  }

  static const _kLocale = 'locale';
  static const _kHaptics = 'haptics';

  static Future<AppSettings> load() async =>
      AppSettings(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;
  Locale? _locale;
  late bool _haptics;

  /// Elle seçilen dil; `null` cihaz dilini izler.
  Locale? get locale => _locale;
  bool get haptics => _haptics;

  Future<void> setLocale(Locale? value) async {
    _locale = value;
    if (value == null) {
      await _prefs.remove(_kLocale);
    } else {
      await _prefs.setString(_kLocale, value.languageCode);
    }
    notifyListeners();
  }

  Future<void> setHaptics(bool value) async {
    _haptics = value;
    Haptics.enabled = value;
    await _prefs.setBool(_kHaptics, value);
    notifyListeners();
  }

  String _key(GameMode mode, String field) => 'setup.${mode.name}.$field';

  SetupMemory? setupFor(GameMode mode) {
    final rounds = _prefs.getInt(_key(mode, 'rounds'));
    final seconds = _prefs.getInt(_key(mode, 'seconds'));
    if (rounds == null || seconds == null) return null;
    if (rounds < 1 || rounds > 10) return null;
    if (![30, 60, 90].contains(seconds)) return null;
    final names = _prefs.getStringList(_key(mode, 'names'));
    final validNames =
        names != null &&
            names.length >= 2 &&
            names.length <= 8 &&
            names.every((n) => n.trim().isNotEmpty)
        ? names
        : null;
    return SetupMemory(names: validNames, rounds: rounds, seconds: seconds);
  }

  Future<void> saveSetup(GameMode mode, SetupMemory memory) async {
    await _prefs.setInt(_key(mode, 'rounds'), memory.rounds);
    await _prefs.setInt(_key(mode, 'seconds'), memory.seconds);
    if (memory.names == null) {
      await _prefs.remove(_key(mode, 'names'));
    } else {
      await _prefs.setStringList(_key(mode, 'names'), memory.names!);
    }
  }
}

/// Ayarları ağaçtaki tüm ekranlara ulaştırır ve değişince yeniden çizdirir.
class SettingsScope extends InheritedNotifier<AppSettings> {
  const SettingsScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);

  static AppSettings of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SettingsScope>();
    assert(scope != null, 'SettingsScope bulunamadı');
    return scope!.notifier!;
  }
}
