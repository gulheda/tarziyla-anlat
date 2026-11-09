import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarziyla_anlat/l10n/app_localizations.dart';
import 'package:tarziyla_anlat/logic/game.dart';
import 'package:tarziyla_anlat/main.dart';
import 'package:tarziyla_anlat/screens/game_screen.dart';
import 'package:tarziyla_anlat/screens/home_screen.dart';
import 'package:tarziyla_anlat/screens/how_to_screen.dart';
import 'package:tarziyla_anlat/screens/settings_screen.dart';
import 'package:tarziyla_anlat/screens/setup_screen.dart';
import 'package:tarziyla_anlat/services/settings.dart';

/// Zamanı gerçek bir cihaz gibi küçük karelerle ilerletir (sayfa geçişleri ve
/// animasyonlar birkaç ayrı kare ister).
Future<void> frames(WidgetTester tester, {int ms = 1000}) async {
  final n = max(1, ms ~/ 100);
  for (var i = 0; i < n; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Testlerde de uygulamanın gerçek yazı tipini kullanır; böylece ölçüler gerçeğe yakın olur.
Future<void> _loadFonts() async {
  final loader = FontLoader('Paytone')
    ..addFont(rootBundle.load('assets/fonts/PaytoneOne-Regular.ttf'));
  await loader.load();
}

const _sizes = <String, Size>{
  'küçük telefon 320x568': Size(320, 568),
  'telefon 360x640': Size(360, 640),
  'büyük telefon 412x915': Size(412, 915),
  'tablet 768x1024': Size(768, 1024),
  'geniş masaüstü 1280x800': Size(1280, 800),
};

Future<AppSettings> _settings({String? language}) async {
  SharedPreferences.setMockInitialValues({'locale': ?language});
  return AppSettings.load();
}

/// Ekranı gerçek uygulama sarmalayıcılarıyla (dil, ayarlar) çizer.
Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(390, 844),
  double textScale = 1.0,
  String language = 'en',
}) async {
  tester.view.physicalSize = size * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final settings = await _settings(language: language);
  await tester.pumpWidget(
    SettingsScope(
      settings: settings,
      child: MaterialApp(
        locale: Locale(language),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: screen,
      ),
    ),
  );
  await frames(tester, ms: 100);
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

Game _game(
  GameMode mode, {
  int players = 3,
  String language = 'en',
  int rounds = 2,
}) => Game(
  GameConfig(
    mode: mode,
    names: [for (var i = 0; i < players; i++) 'Player ${i + 1}'],
    rounds: rounds,
    seconds: 60,
    languageCode: language,
  ),
  random: Random(2),
);

void main() {
  setUpAll(_loadFonts);

  group('düzen taşması yok (her ekran, her boyut, büyük yazı)', () {
    for (final entry in _sizes.entries) {
      for (final scale in [1.0, 1.3]) {
        for (final lang in ['en', 'tr']) {
          final name = '${entry.key} ×$scale $lang';

          testWidgets('ana ekran $name', (tester) async {
            await _pump(
              tester,
              const HomeScreen(),
              size: entry.value,
              textScale: scale,
              language: lang,
            );
            await frames(tester, ms: 2000);
            expect(tester.takeException(), isNull);
            await _dispose(tester);
          });

          testWidgets('nasıl oynanır / ayarlar $name', (tester) async {
            await _pump(
              tester,
              const HowToScreen(),
              size: entry.value,
              textScale: scale,
              language: lang,
            );
            expect(tester.takeException(), isNull);
            await _pump(
              tester,
              const SettingsScreen(),
              size: entry.value,
              textScale: scale,
              language: lang,
            );
            expect(tester.takeException(), isNull);
            await _dispose(tester);
          });

          for (final mode in GameMode.values) {
            testWidgets('kurulum ${mode.name} $name', (tester) async {
              await _pump(
                tester,
                SetupScreen(mode: mode),
                size: entry.value,
                textScale: scale,
                language: lang,
              );
              expect(tester.takeException(), isNull);
              await _dispose(tester);
            });
          }

          testWidgets('oyun: devir ekranı, 8 oyuncu $name', (tester) async {
            final g = _game(GameMode.competitive, players: 8, language: lang);
            await _pump(
              tester,
              GameScreen(game: g),
              size: entry.value,
              textScale: scale,
              language: lang,
            );
            await frames(tester, ms: 1000);
            expect(tester.takeException(), isNull);
            await _dispose(tester);
          });

          testWidgets('oyun: oynanış ve duraklatma $name', (tester) async {
            for (final mode in GameMode.values) {
              final g = _game(mode, players: 8, language: lang)..startTurn();
              await _pump(
                tester,
                GameScreen(game: g),
                size: entry.value,
                textScale: scale,
                language: lang,
              );
              expect(tester.takeException(), isNull, reason: mode.name);
              g.pause();
              await frames(tester, ms: 400);
              expect(
                tester.takeException(),
                isNull,
                reason: 'pause ${mode.name}',
              );
              await _dispose(tester);
            }
          });

          testWidgets('oyun: sonuç ekranları $name', (tester) async {
            // Rekabetçi: çok sayıda doğru kart.
            final comp = _game(GameMode.competitive, players: 8, language: lang)
              ..startTurn();
            for (var i = 0; i < 25; i++) {
              comp.markCorrect();
            }
            comp.endTurnEarly();
            await _pump(
              tester,
              GameScreen(game: comp),
              size: entry.value,
              textScale: scale,
              language: lang,
            );
            await frames(tester, ms: 1000);
            expect(tester.takeException(), isNull);
            await _dispose(tester);

            // Klasik: "kim bildi?" ve puan verildikten sonra.
            final classic = _game(GameMode.classic, players: 8, language: lang)
              ..startTurn()
              ..markCorrect();
            await _pump(
              tester,
              GameScreen(game: classic),
              size: entry.value,
              textScale: scale,
              language: lang,
            );
            await frames(tester, ms: 1000);
            expect(tester.takeException(), isNull);
            classic.awardClassic(3);
            await frames(tester, ms: 1000);
            expect(tester.takeException(), isNull);
            await _dispose(tester);
          });

          testWidgets('oyun: bitiş ekranı (2 ve 8 oyuncu) $name', (
            tester,
          ) async {
            for (final players in [2, 8]) {
              final g = _game(
                GameMode.competitive,
                players: players,
                rounds: 1,
                language: lang,
              );
              while (g.phase != Phase.finished) {
                g
                  ..startTurn()
                  ..markCorrect()
                  ..endTurnEarly()
                  ..nextTurn();
              }
              await _pump(
                tester,
                GameScreen(game: g),
                size: entry.value,
                textScale: scale,
                language: lang,
              );
              await frames(tester, ms: 2000);
              expect(tester.takeException(), isNull, reason: '$players oyuncu');
              await _dispose(tester);
            }
          });
        }
      }
    }
  });

  group('uçtan uca akış', () {
    Future<void> openApp(WidgetTester tester, {String? language}) async {
      tester.view.physicalSize = const Size(780, 1688);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      final settings = await _settings(language: language);
      await tester.pumpWidget(TarziylaAnlatApp(settings: settings));
      await frames(tester, ms: 2000);
    }

    testWidgets('klasik oyun: kurulum → geri sayım → oyun → sonuç → sıradaki', (
      tester,
    ) async {
      await openApp(tester, language: 'en');
      expect(find.text('Classic'), findsOneWidget);
      await tester.tap(find.text('Classic'));
      await frames(tester, ms: 1000);
      expect(find.text('Classic mode'), findsOneWidget);
      expect(find.text('Start the show!'), findsOneWidget);

      await tester.tap(find.text('Start the show!'));
      await frames(tester, ms: 600);
      // Geri sayım kendiliğinden başlar, ek dokunuş gerekmez.
      await frames(tester, ms: 3000);
      await frames(tester, ms: 500);
      expect(find.text('WORD'), findsWidgets);
      expect(find.text('STYLE'), findsWidgets);

      await tester.tap(find.text('Give up, nobody got it'));
      await frames(tester, ms: 1000);
      expect(find.text('Round over'), findsOneWidget);
      expect(find.textContaining('Next: '), findsOneWidget);

      await tester.tap(find.textContaining('Next: '));
      await frames(tester, ms: 1000);
      // İkinci oyuncunun geri sayımı da kendiliğinden başlar.
      await frames(tester, ms: 3000);
      await frames(tester, ms: 500);
      expect(find.text('WORD'), findsWidgets);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets('rekabetçi oyun Türkçe: puan ve podyum', (tester) async {
      await openApp(tester, language: 'tr');
      expect(find.text('Rekabetçi'), findsOneWidget);
      await tester.tap(find.text('Rekabetçi'));
      await frames(tester, ms: 1000);
      await tester.tap(find.text('Perde açılsın!'));
      await frames(tester, ms: 4000);
      await frames(tester, ms: 500);
      expect(find.text('KELİME'), findsWidgets);
      expect(find.text('TARZ'), findsWidgets);
      expect(find.text('Bildiler!'), findsOneWidget);

      await tester.tap(find.text('Bildiler!'));
      await frames(tester, ms: 300);
      await tester.tap(find.text('Bildiler!'));
      await frames(tester, ms: 300);
      // Duraklat ve devam et.
      expect(find.text('Duraklatıldı'), findsNothing);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets('dil ayarı arayüzü anında değiştirir ve kalıcıdır', (
      tester,
    ) async {
      await openApp(tester, language: 'en');
      expect(find.text('Competitive'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await frames(tester, ms: 1000);
      expect(find.textContaining('Language'), findsOneWidget);
      await tester.tap(find.text('Türkçe'));
      await frames(tester, ms: 1000);
      expect(find.textContaining('Dil'), findsOneWidget);
      final saved = await SharedPreferences.getInstance();
      expect(saved.getString('locale'), 'tr');
      await tester.tap(find.byType(BackButton));
      await frames(tester, ms: 1000);
      expect(find.text('Rekabetçi'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets('oyuncu ekle/çıkar sınırları: en az 2, en çok 8', (
      tester,
    ) async {
      // Liste tembel kurulduğu için tüm kutular görünsün diye çok uzun ekran.
      tester.view.physicalSize = const Size(780, 6000);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      final settings = await _settings(language: 'en');
      await tester.pumpWidget(TarziylaAnlatApp(settings: settings));
      await frames(tester, ms: 2000);
      await tester.tap(find.text('Classic'));
      await frames(tester, ms: 1000);

      expect(find.byType(TextField), findsNWidgets(3));
      for (var i = 0; i < 10; i++) {
        final add = find.text('Add player');
        if (add.evaluate().isEmpty) break;
        await tester.tap(add);
        await frames(tester, ms: 100);
      }
      expect(find.byType(TextField), findsNWidgets(8));
      expect(find.text('Add player'), findsNothing);

      for (var i = 0; i < 10; i++) {
        final buttons = find.widgetWithIcon(IconButton, Icons.close);
        final enabled = buttons.evaluate().where(
          (e) => (e.widget as IconButton).onPressed != null,
        );
        if (enabled.isEmpty) break;
        await tester.tap(buttons.first);
        await frames(tester, ms: 100);
      }
      expect(find.byType(TextField), findsNWidgets(2));
      // En az iki oyuncu kalır: kaldır düğmeleri pasif.
      for (final e in find.widgetWithIcon(IconButton, Icons.close).evaluate()) {
        expect((e.widget as IconButton).onPressed, isNull);
      }
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });
  });
  testWidgets('duraklatınca kartlar ekran okuyuculara da gizlenir', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final g = _game(GameMode.competitive)..startTurn();
    await _pump(tester, GameScreen(game: g));
    final word = g.current.word;
    expect(find.semantics.byLabel(RegExp('WORD: $word')), findsOneWidget);
    g.pause();
    await frames(tester, ms: 500);
    expect(find.semantics.byLabel(RegExp('WORD: $word')), findsNothing);
    expect(find.semantics.byLabel('Resume'), findsOneWidget);
    g.resume();
    await frames(tester, ms: 500);
    expect(find.semantics.byLabel(RegExp('WORD: $word')), findsOneWidget);
    await _dispose(tester);
    handle.dispose();
  });
}
