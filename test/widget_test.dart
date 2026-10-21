import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tarziyla_anlat/data/cards.dart';
import 'package:tarziyla_anlat/logic/game.dart';
import 'package:tarziyla_anlat/main.dart';

Game _game(GameMode mode, {int rounds = 1, List<String>? names}) => Game(
  GameConfig(
    mode: mode,
    names: names ?? ['A', 'B'],
    rounds: rounds,
    seconds: 30,
  ),
  random: Random(1),
);

void main() {
  test('kartlar: boş, çok uzun ya da tekrar eden kart yok', () {
    final all = [for (final c in anlatCategories) ...c.cards];
    expect(all.toSet().length, all.length, reason: _dupes(all));
    expect(
      tarzCards.toSet().length,
      tarzCards.length,
      reason: _dupes(tarzCards),
    );
    for (final card in [...all, ...tarzCards]) {
      expect(card.trim(), isNotEmpty);
      expect(card.length, lessThanOrEqualTo(80), reason: card);
    }
    for (final card in all) {
      expect(
        card.contains(RegExp(r'\s')),
        isFalse,
        reason: 'tek kelime olmalı: $card',
      );
    }
    for (final c in anlatCategories) {
      expect(c.cards.length, greaterThanOrEqualTo(25), reason: c.id);
    }
  });

  test('paket seçimi yalnızca seçilen temanın kartlarını çıkarır', () {
    final pool = anlatPool(['hayvan']);
    final genz = anlatCategories.firstWhere((c) => c.id == 'hayvan').cards;
    expect(pool, genz);
    final g =
        Game(
            GameConfig(
              mode: GameMode.competitive,
              names: ['A', 'B'],
              rounds: 1,
              seconds: 30,
              categoryIds: ['hayvan'],
            ),
          )
          ..confirmHandover()
          ..startTurn();
    for (var i = 0; i < 100; i++) {
      expect(genz, contains(g.current.konu));
      g.markCorrect();
    }
    g.dispose();
  });

  test('rekabetçi: her doğru bir puan, pas hakkı biter', () {
    final g = _game(GameMode.competitive)
      ..confirmHandover()
      ..startTurn();
    g.markCorrect();
    g.markCorrect();
    expect(g.currentPlayer.score, 2);

    for (var i = 0; i < 3; i++) {
      g.pass();
    }
    expect(g.canPass, isFalse);
    final before = g.current;
    g.pass();
    expect(g.current, same(before));
    g.dispose();
  });

  test('süre dolunca tur sonuca geçer ve oyun biter', () {
    final g = _game(GameMode.competitive)
      ..confirmHandover()
      ..startTurn();
    for (var i = 0; i < 30; i++) {
      g.tick();
    }
    expect(g.phase, Phase.result);
    g.nextTurn();
    expect(g.phase, Phase.handover);
    expect(g.currentIndex, 1);
    g
      ..confirmHandover()
      ..startTurn()
      ..endTurnEarly()
      ..nextTurn();
    expect(g.phase, Phase.finished);
    g.dispose();
  });

  test('klasik: bilen ve anlatıcı birer puan alır, kendine puan verilemez', () {
    final g = _game(GameMode.classic, names: ['A', 'B', 'C'])
      ..confirmHandover()
      ..startTurn();
    g.markCorrect();
    expect(g.phase, Phase.result);
    g.awardClassic(0);
    expect(g.participants[0].score, 0);
    g.awardClassic(2);
    expect(g.participants[0].score, 1);
    expect(g.participants[2].score, 1);
    g.awardClassic(1);
    expect(g.participants[1].score, 0);
    g.dispose();
  });

  testWidgets('ana ekran açılır', (tester) async {
    await tester.pumpWidget(const TarziyleAnlatApp());
    expect(find.text('Klasik'), findsOneWidget);
    expect(find.text('Rekabetçi'), findsOneWidget);
  });
}

String _dupes(List<String> cards) {
  final seen = <String>{};
  return cards.where((c) => !seen.add(c)).join(' | ');
}
