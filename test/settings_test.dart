import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarziyla_anlat/logic/game.dart';
import 'package:tarziyla_anlat/main.dart';
import 'package:tarziyla_anlat/screens/setup_screen.dart';
import 'package:tarziyla_anlat/services/haptics.dart';
import 'package:tarziyla_anlat/services/settings.dart';

Future<AppSettings> _settings([Map<String, Object> initial = const {}]) async {
  SharedPreferences.setMockInitialValues(initial);
  return AppSettings.load();
}

void main() {
  test('varsayılanlar: cihaz dili, titreşim açık', () async {
    final s = await _settings();
    expect(s.locale, isNull);
    expect(s.haptics, isTrue);
    expect(Haptics.enabled, isTrue);
  });

  test('dil seçimi kalıcıdır ve temizlenebilir', () async {
    final s = await _settings();
    await s.setLocale(const Locale('tr'));
    expect(s.locale, const Locale('tr'));
    final reloaded = await AppSettings.load();
    expect(reloaded.locale?.languageCode, 'tr');
    await reloaded.setLocale(null);
    expect((await AppSettings.load()).locale, isNull);
  });

  test('desteklenmeyen kayıtlı dil yok sayılır', () async {
    final s = await _settings({'locale': 'de'});
    expect(s.locale, isNull);
  });

  test('titreşim ayarı kalıcıdır ve Haptics\'e yansır', () async {
    final s = await _settings();
    await s.setHaptics(false);
    expect(Haptics.enabled, isFalse);
    expect((await AppSettings.load()).haptics, isFalse);
    await s.setHaptics(true);
    expect(Haptics.enabled, isTrue);
  });

  test('kurulum hatırlanır', () async {
    final s = await _settings();
    expect(s.setupFor(GameMode.classic), isNull);
    await s.saveSetup(
      GameMode.classic,
      const SetupMemory(names: ['Ada', 'Bo', 'Cem'], rounds: 4, seconds: 60),
    );
    final m = (await AppSettings.load()).setupFor(GameMode.classic)!;
    expect(m.names, ['Ada', 'Bo', 'Cem']);
    expect(m.rounds, 4);
    expect(m.seconds, 60);
    // Diğer modu etkilemez.
    expect((await AppSettings.load()).setupFor(GameMode.competitive), isNull);
  });

  test('varsayılan isimler saklanmaz', () async {
    final s = await _settings();
    await s.saveSetup(
      GameMode.classic,
      const SetupMemory(names: null, rounds: 2, seconds: 30),
    );
    expect(
      (await AppSettings.load()).setupFor(GameMode.classic)!.names,
      isNull,
    );
  });

  test('bozuk kayıtlar yok sayılır', () async {
    final bad = await _settings({
      'setup.classic.rounds': 99,
      'setup.classic.seconds': 45,
    });
    expect(bad.setupFor(GameMode.classic), isNull);
    final badNames = await _settings({
      'setup.classic.rounds': 3,
      'setup.classic.seconds': 60,
      'setup.classic.names': ['Sadece bir'],
    });
    expect(badNames.setupFor(GameMode.classic)!.names, isNull);
    final blank = await _settings({
      'setup.classic.rounds': 3,
      'setup.classic.seconds': 60,
      'setup.classic.names': ['A', '  '],
    });
    expect(blank.setupFor(GameMode.classic)!.names, isNull);
  });

  group('sanitizeNames', () {
    const defaults = ['Kaptan', 'Şef', 'Profesör'];

    test('boşlukları kırpar ve birleştirir', () {
      expect(sanitizeNames(['  Ada   Su ', 'Bo'], defaults), ['Ada Su', 'Bo']);
    });

    test('boş isme varsayılan verir', () {
      expect(sanitizeNames(['', '   '], defaults), ['Kaptan', 'Şef']);
    });

    test('aynı isimleri ayırır (büyük/küçük harf fark etmez)', () {
      expect(sanitizeNames(['Ada', 'ada', 'ADA', 'Bo'], defaults), [
        'Ada',
        'ada 2',
        'ADA 3',
        'Bo',
      ]);
    });

    test('varsayılanla çakışan yazılan isim de ayrılır', () {
      expect(sanitizeNames(['', 'Kaptan'], defaults), ['Kaptan', 'Kaptan 2']);
    });
  });

  group('dil çözümleme', () {
    const supported = [Locale('en'), Locale('tr')];

    test('desteklenen ilk dili seçer', () {
      expect(
        resolveLocale(const [Locale('de'), Locale('tr', 'TR')], supported),
        const Locale('tr'),
      );
    });

    test('hiçbiri desteklenmiyorsa İngilizce', () {
      expect(
        resolveLocale(const [Locale('ja'), Locale('fr')], supported),
        const Locale('en'),
      );
      expect(resolveLocale(null, supported), const Locale('en'));
      expect(resolveLocale(const [], supported), const Locale('en'));
    });

    test('bölge kodu atılır', () {
      expect(
        resolveLocale(const [Locale('en', 'GB')], supported),
        const Locale('en'),
      );
    });
  });
}
