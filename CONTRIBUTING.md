# Contributing / Katkıda bulunmak

Thank you for helping make **Tarzıyla Anlat** funnier! / Oyunu daha komik yapmana yardım ettiğin için teşekkürler!

## The easiest way: add cards / En kolay yol: kart eklemek

All cards live in plain Dart lists, one per language:

| What | English | Türkçe |
|---|---|---|
| Words (single word each) | `lib/data/cards_en.dart` | `lib/data/cards.dart` |
| Styles ("Talk like…") | `enStyles` in `lib/data/cards_en.dart` | `tarzCards` in `lib/data/cards.dart` |
| Jokes & messages | `lib/data/funny_en.dart` | `lib/data/funny.dart` |

Rules (the tests check them for you):
- A **word** is exactly one word: no spaces, 20 characters at most.
- A **style** is 8–80 characters and tells the player *how* to act: "Talk like a grumpy taxi driver", "Meow every now and then while talking".
- No duplicates. Keep it friendly: no politics, religion, slurs or jokes about real people.
- Aim for *medium* difficulty and *funny* — the style card does the comedy.

## Translating the interface / Arayüzü çevirmek

Strings are in `lib/l10n/app_en.arb` (template) and `lib/l10n/app_tr.arb`. To add a language, copy `app_en.arb` to `app_xx.arb`, translate it, add the content lists under `lib/data/`, and register the code in `lib/data/contents.dart`. Then run `flutter gen-l10n`.

## Development / Geliştirme

```
flutter pub get
flutter gen-l10n
flutter analyze
flutter test        # content, localization, game logic and screen layout tests
flutter run
```

Please make sure `flutter analyze` and `flutter test` pass before opening a pull request. / Pull request açmadan önce ikisinin de geçtiğinden emin ol.

## Bugs and ideas / Hata ve fikirler

Open an issue — there are templates for bug reports and card suggestions. / Hata ve kart önerileri için hazır şablonlar var.
