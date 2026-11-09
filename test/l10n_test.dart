import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String name) =>
    jsonDecode(File('lib/l10n/$name').readAsStringSync())
        as Map<String, dynamic>;

Set<String> _placeholders(String message) {
  // {n}, {name} gibi yer tutucular; ICU plural/select gövdelerindeki değişken
  // adlarını da yakalar.
  final names = <String>{};
  final simple = RegExp(r'\{(\w+)(?:,[^{}]*)?\}');
  for (final m in simple.allMatches(message)) {
    names.add(m.group(1)!);
  }
  final plural = RegExp(r'\{(\w+),\s*(plural|select)');
  for (final m in plural.allMatches(message)) {
    names.add(m.group(1)!);
  }
  // plural dalları ({one}, {other}, =1) değişken değildir.
  names.removeAll(['one', 'other', 'few', 'many', 'two', 'zero']);
  return names;
}

void main() {
  final en = _arb('app_en.arb');
  final tr = _arb('app_tr.arb');
  final enKeys = en.keys.where((k) => !k.startsWith('@')).toSet();
  final trKeys = tr.keys.where((k) => !k.startsWith('@')).toSet();

  test('iki dilde de aynı anahtarlar var', () {
    expect(trKeys.difference(enKeys), isEmpty, reason: 'sadece Türkçede');
    expect(enKeys.difference(trKeys), isEmpty, reason: 'Türkçede eksik');
  });

  test('hiçbir metin boş değil', () {
    for (final k in enKeys) {
      expect((en[k] as String).trim(), isNotEmpty, reason: 'en.$k');
      expect((tr[k] as String).trim(), isNotEmpty, reason: 'tr.$k');
    }
  });

  test('Türkçe metinler şablonda olmayan yer tutucu kullanmaz', () {
    // Türkçe'de çoğul eki olmadığı için bazı yer tutucular atlanabilir; ama
    // şablonda tanımsız bir değişken kullanmak derleme/çalışma hatasıdır.
    for (final k in enKeys) {
      expect(
        _placeholders(en[k] as String)
            .containsAll(_placeholders(tr[k] as String)),
        isTrue,
        reason: k,
      );
    }
  });

  test(
    'adı geçen yer tutucular her iki dilde de kullanılıyor (çoğul hariç)',
    () {
      for (final k in enKeys) {
        final enP = _placeholders(en[k] as String);
        final trP = _placeholders(tr[k] as String);
        final isPlural = (en[k] as String).contains('plural');
        if (!isPlural) {
          expect(trP, enP, reason: k);
        }
      }
    },
  );

  test('yer tutucusu olan her anahtarın şablonda tanımı var', () {
    for (final k in enKeys) {
      if (_placeholders(en[k] as String).isNotEmpty) {
        expect(en.containsKey('@$k'), isTrue, reason: '@$k eksik');
      }
    }
  });

  test('Türkçe ve İngilizce metinler birbirinin kopyası değil', () {
    var same = 0;
    for (final k in enKeys) {
      if (en[k] == tr[k]) same++;
    }
    // Marka adı gibi birkaç ortak metin olabilir.
    expect(same, lessThan(6));
  });
}
