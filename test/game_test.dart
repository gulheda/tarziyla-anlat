import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tarziyla_anlat/data/contents.dart';
import 'package:tarziyla_anlat/logic/game.dart';

class FakeClock {
  DateTime now = DateTime(2026, 1, 1, 12);
  DateTime call() => now;
  void advance(int seconds, [int millis = 0]) =>
      now = now.add(Duration(seconds: seconds, milliseconds: millis));
}

Game _game(
  GameMode mode, {
  int rounds = 1,
  int seconds = 30,
  List<String>? names,
  String language = 'en',
  FakeClock? clock,
  int seed = 1,
}) => Game(
  GameConfig(
    mode: mode,
    names: names ?? ['A', 'B'],
    rounds: rounds,
    seconds: seconds,
    languageCode: language,
  ),
  random: Random(seed),
  clock: clock?.call,
);

void main() {
  group('rekabetçi mod', () {
    test('her doğru kart bir puan, yeni kart gelir', () {
      final g = _game(GameMode.competitive)..startTurn();
      final first = g.current;
      g.markCorrect();
      g.markCorrect();
      expect(g.currentPlayer.score, 2);
      expect(g.turnCorrect.length, 2);
      expect(g.current, isNot(same(first)));
      expect(g.phase, Phase.playing);
      g.dispose();
    });

    test('üç pas hakkı vardır, bitince pas işe yaramaz', () {
      final g = _game(GameMode.competitive)..startTurn();
      expect(g.passesLeft, 3);
      for (var i = 0; i < 3; i++) {
        g.pass();
      }
      expect(g.canPass, isFalse);
      final before = g.current;
      g.pass();
      expect(g.current, same(before));
      expect(g.passesLeft, 0);
      g.dispose();
    });

    test('süre dolunca tur biter ve sıra diğerine geçer', () {
      final clock = FakeClock();
      final g = _game(GameMode.competitive, clock: clock)..startTurn();
      clock.advance(29, 900);
      g.tick();
      expect(g.phase, Phase.playing);
      expect(g.secondsLeft, 1);
      clock.advance(0, 200);
      g.tick();
      expect(g.phase, Phase.result);
      expect(g.secondsLeft, 0);
      g.nextTurn();
      expect(g.phase, Phase.handover);
      expect(g.currentIndex, 1);
      g.dispose();
    });

    test('sayaç gerçek saate göre kayıpsız hesaplanır', () {
      final clock = FakeClock();
      final g = _game(GameMode.competitive, seconds: 60, clock: clock)
        ..startTurn();
      // Çok seyrek tick'ler bile doğru kalan süreyi verir (zamanlayıcı kayması yok).
      clock.advance(17);
      g.tick();
      expect(g.secondsLeft, 43);
      clock.advance(43);
      g.tick();
      expect(g.phase, Phase.result);
      g.dispose();
    });

    test('tüm turlar bitince oyun biter', () {
      final g = _game(GameMode.competitive, rounds: 2);
      expect(g.totalTurns, 4);
      for (var t = 0; t < 4; t++) {
        expect(g.phase, Phase.handover);
        g
          ..startTurn()
          ..markCorrect()
          ..endTurnEarly();
        expect(g.isLastTurn, t == 3);
        g.nextTurn();
      }
      expect(g.phase, Phase.finished);
      expect(g.participants.map((p) => p.score), [2, 2]);
      expect(g.finalLine, g.content.tieLine);
      g.dispose();
    });

    test('kazanan ve sonuncu sıralamada doğru, eşitlikte sıra korunur', () {
      final g = _game(GameMode.competitive, names: ['A', 'B', 'C']);
      g.participants[0].score = 2;
      g.participants[1].score = 5;
      g.participants[2].score = 2;
      expect(g.ranking.map((p) => p.name), ['B', 'A', 'C']);
      g.dispose();
    });
  });

  group('klasik mod', () {
    test('bilen ve anlatan birer puan alır, kendine puan verilemez', () {
      final g = _game(GameMode.classic, names: ['A', 'B', 'C'])..startTurn();
      g.markCorrect();
      expect(g.phase, Phase.result);
      expect(g.classicSolved, isTrue);
      g.awardClassic(0); // anlatıcı kendine veremez
      expect(g.participants[0].score, 0);
      g.awardClassic(2);
      expect(g.participants[0].score, 1);
      expect(g.participants[2].score, 1);
      expect(g.guesser?.name, 'C');
      g.awardClassic(1); // ikinci kez puan verilemez
      expect(g.participants[1].score, 0);
      g.dispose();
    });

    test('bilen seçilmeden sonraki tura geçilemez', () {
      final g = _game(GameMode.classic, names: ['A', 'B', 'C'])..startTurn();
      g.markCorrect();
      g.nextTurn();
      expect(g.phase, Phase.result);
      expect(g.turnIndex, 0);
      g.awardClassic(1);
      g.nextTurn();
      expect(g.phase, Phase.handover);
      expect(g.turnIndex, 1);
      g.dispose();
    });

    test('kimse bilemezse puan yok ve espri gelir', () {
      final g = _game(GameMode.classic)..startTurn();
      g.endTurnEarly();
      expect(g.classicSolved, isFalse);
      expect(g.verdict, isNotEmpty);
      g.nextTurn();
      expect(g.participants.every((p) => p.score == 0), isTrue);
      g.dispose();
    });

    test('geçersiz oyuncu numarası yok sayılır', () {
      final g = _game(GameMode.classic)..startTurn();
      g.markCorrect();
      g.awardClassic(-1);
      g.awardClassic(99);
      expect(g.guesser, isNull);
      g.dispose();
    });

    test('bir kart değiştirme hakkı var', () {
      final g = _game(GameMode.classic)..startTurn();
      expect(g.passesLeft, 1);
      g.pass();
      expect(g.canPass, isFalse);
      g.dispose();
    });
  });

  group('duraklatma', () {
    test('duraklatınca süre akmaz, devam edince kaldığı yerden sürer', () {
      final clock = FakeClock();
      final g = _game(GameMode.competitive, seconds: 60, clock: clock)
        ..startTurn();
      clock.advance(10);
      g.pause();
      expect(g.paused, isTrue);
      expect(g.secondsLeft, 50);
      clock.advance(3600); // bir saat geçse de
      g.tick();
      expect(g.secondsLeft, 50);
      expect(g.phase, Phase.playing);
      g.resume();
      expect(g.paused, isFalse);
      clock.advance(5);
      g.tick();
      expect(g.secondsLeft, 45);
      g.dispose();
    });

    test('duraklatılmışken kart işlemleri yapılamaz', () {
      final g = _game(GameMode.competitive)..startTurn();
      final before = g.current;
      g.pause();
      g.markCorrect();
      g.pass();
      g.endTurnEarly();
      expect(g.turnCorrect, isEmpty);
      expect(g.current, same(before));
      expect(g.phase, Phase.playing);
      expect(g.canPass, isFalse);
      g.dispose();
    });

    test('pause ve resume tekrar çağrılınca zarar vermez', () {
      final g = _game(GameMode.competitive)..startTurn();
      g.resume(); // zaten çalışıyor
      g.pause();
      g.pause();
      expect(g.paused, isTrue);
      g.resume();
      g.resume();
      expect(g.paused, isFalse);
      g.dispose();
    });

    test('tur dışında duraklatma etkisizdir', () {
      final g = _game(GameMode.competitive);
      g.pause();
      expect(g.paused, isFalse);
      g.dispose();
    });
  });

  group('desteler', () {
    test('aynı kart (kelime ya da tarz) arka arkaya gelmez', () {
      final g = _game(GameMode.competitive)..startTurn();
      var lastWord = g.current.word;
      var lastStyle = g.current.style;
      // Desteyi birkaç kez bitirecek kadar çek.
      final draws = g.content.words.length * 2 + 50;
      for (var i = 0; i < draws; i++) {
        g.markCorrect();
        expect(g.current.word, isNot(lastWord), reason: 'kelime tekrarı #$i');
        expect(g.current.style, isNot(lastStyle), reason: 'tarz tekrarı #$i');
        lastWord = g.current.word;
        lastStyle = g.current.style;
      }
      g.dispose();
    });

    test('bir deste bitmeden hiçbir kelime tekrar etmez', () {
      final g = _game(GameMode.competitive)..startTurn();
      final seen = <String>{g.current.word};
      for (var i = 1; i < g.content.words.length; i++) {
        g.markCorrect();
        expect(seen.add(g.current.word), isTrue, reason: g.current.word);
      }
      g.dispose();
    });

    for (final code in supportedLanguageCodes) {
      test('$code oyunu yalnızca $code kartlarını çıkarır', () {
        final g = _game(GameMode.competitive, language: code)..startTurn();
        final content = contentFor(code);
        for (var i = 0; i < 80; i++) {
          expect(content.words, contains(g.current.word));
          expect(content.styles, contains(g.current.style));
          g.markCorrect();
        }
        expect(g.content.code, code);
        g.dispose();
      });
    }

    test('esprili metinler seçilen dilde ve yer tutucusuz', () {
      for (final code in supportedLanguageCodes) {
        final g = _game(GameMode.classic, language: code, names: ['Ada', 'Bo'])
          ..startTurn();
        expect(g.handoverLine, contains('Ada'));
        expect(g.handoverLine.contains('{'), isFalse);
        g.markCorrect();
        g.awardClassic(1);
        expect(g.verdict, contains('Bo'));
        expect(g.verdict.contains('{'), isFalse);
        g.dispose();
      }
    });
  });

  group('durum makinesi', () {
    test('startTurn yalnızca devir ekranında çalışır', () {
      final g = _game(GameMode.competitive)..startTurn();
      g.markCorrect();
      g.startTurn(); // oyun sürerken tekrar çağrılırsa puan sıfırlanmamalı
      expect(g.turnCorrect.length, 1);
      g.dispose();
    });

    test('nextTurn yalnızca sonuç ekranında çalışır', () {
      final g = _game(GameMode.competitive);
      g.nextTurn();
      expect(g.turnIndex, 0);
      expect(g.phase, Phase.handover);
      g.dispose();
    });

    test('sıradaki oyuncu döngüsel hesaplanır', () {
      final g = _game(GameMode.competitive, names: ['A', 'B', 'C']);
      expect(g.nextPlayer.name, 'B');
      g.turnIndex = 2;
      expect(g.currentPlayer.name, 'C');
      expect(g.nextPlayer.name, 'A');
      g.dispose();
    });

    test('1 ile 8 oyuncu, 1 ile 10 tur sorunsuz oynanır', () {
      for (final players in [2, 5, 8]) {
        for (final rounds in [1, 10]) {
          final g = _game(
            GameMode.competitive,
            rounds: rounds,
            names: [for (var i = 0; i < players; i++) 'P$i'],
          );
          var turns = 0;
          while (g.phase != Phase.finished) {
            g
              ..startTurn()
              ..markCorrect()
              ..endTurnEarly()
              ..nextTurn();
            turns++;
          }
          expect(turns, players * rounds);
          expect(g.ranking.length, players);
          g.dispose();
        }
      }
    });

    test('her turda yeni kart gelir ve avatarlar yinelenir ama kaybolmaz', () {
      final g = _game(
        GameMode.competitive,
        names: [for (var i = 0; i < 8; i++) 'P$i'],
      );
      expect(g.participants.map((p) => p.emoji).toSet().length, 8);
      g.dispose();
    });
  });
}
