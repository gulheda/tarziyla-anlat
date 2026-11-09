import 'package:flutter_test/flutter_test.dart';
import 'package:tarziyla_anlat/data/contents.dart';

String _dupes(List<String> cards) {
  final seen = <String>{};
  return cards.where((c) => !seen.add(c.toLowerCase())).join(' | ');
}

void main() {
  for (final code in supportedLanguageCodes) {
    group('içerik ($code)', () {
      final c = contentFor(code);

      test('kelimeler: tek kelime, tekrarsız, boş değil', () {
        final words = c.words;
        expect(words.length, greaterThanOrEqualTo(550));
        expect(
          words.map((w) => w.toLowerCase()).toSet().length,
          words.length,
          reason: _dupes(words),
        );
        for (final w in words) {
          expect(w.trim(), w, reason: 'baş/son boşluk: "$w"');
          expect(w, isNotEmpty);
          expect(w.contains(RegExp(r'\s')), isFalse, reason: 'tek kelime: $w');
          expect(w.length, lessThanOrEqualTo(20), reason: w);
        }
      });

      test('tarzlar: tekrarsız, makul uzunlukta', () {
        expect(c.styles.length, greaterThanOrEqualTo(180));
        expect(
          c.styles.map((s) => s.toLowerCase()).toSet().length,
          c.styles.length,
          reason: _dupes(c.styles),
        );
        for (final s in c.styles) {
          expect(s.trim(), s);
          expect(s.length, inInclusiveRange(8, 80), reason: s);
        }
      });

      test('kategoriler: en az 25 kelime, benzersiz id', () {
        final ids = c.categories.map((e) => e.id).toList();
        expect(ids.toSet().length, ids.length);
        for (final cat in c.categories) {
          expect(cat.cards.length, greaterThanOrEqualTo(25), reason: cat.id);
        }
      });

      test('esprili metinler: boş değil, yer tutucular doğru', () {
        for (final list in [
          c.taglines,
          c.verdictsZero,
          c.verdictsLow,
          c.verdictsMid,
          c.verdictsHigh,
          c.nobodyLines,
          c.winnerLines,
        ]) {
          expect(list, isNotEmpty);
          for (final line in list) {
            expect(line.trim(), isNotEmpty);
            expect(line.contains('{'), isFalse, reason: line);
          }
        }
        for (final line in c.handoverLines) {
          expect(line, contains('{n}'));
        }
        for (final line in c.guessedLines) {
          expect(line, contains('{g}'), reason: line);
        }
        expect(c.guessedLines.any((l) => l.contains('{d}')), isTrue);
        for (final line in c.loserLines) {
          expect(line, contains('{n}'));
        }
        expect(c.tieLine.trim(), isNotEmpty);
      });

      test('takma adlar: en az sekiz, tekrarsız', () {
        expect(c.playerNicknames.length, greaterThanOrEqualTo(8));
        expect(c.teamNicknames.length, greaterThanOrEqualTo(8));
        expect(c.playerNicknames.toSet().length, c.playerNicknames.length);
        expect(c.teamNicknames.toSet().length, c.teamNicknames.length);
      });
    });
  }

  test('iki dil birbirinden farklı içerik taşıyor', () {
    expect(contentFor('tr').words, isNot(contentFor('en').words));
    expect(contentFor('tr').styles, isNot(contentFor('en').styles));
    expect(contentFor('tr').code, 'tr');
    expect(contentFor('en').code, 'en');
  });

  test('bilinmeyen dil İngilizce\'ye düşer', () {
    expect(contentFor('de').code, 'en');
    expect(resolveLanguageCode('fr'), 'en');
    expect(resolveLanguageCode(null), 'en');
    expect(resolveLanguageCode('tr'), 'tr');
  });
}
