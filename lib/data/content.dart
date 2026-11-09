/// Bir kelime paketi (kendi içinde gruplanmış kelimeler).
class CardCategory {
  const CardCategory(this.id, this.name, this.emoji, this.cards);

  final String id;
  final String name;
  final String emoji;
  final List<String> cards;
}

/// Bir dile ait tüm oyun içeriği: kelimeler, tarzlar ve esprili metinler.
///
/// Metinlerde `{n}` anlatıcının, `{g}` bilenin, `{d}` anlatıcının adıyla değişir.
class GameContent {
  const GameContent({
    required this.code,
    required this.categories,
    required this.styles,
    required this.taglines,
    required this.handoverLines,
    required this.verdictsZero,
    required this.verdictsLow,
    required this.verdictsMid,
    required this.verdictsHigh,
    required this.guessedLines,
    required this.nobodyLines,
    required this.winnerLines,
    required this.loserLines,
    required this.tieLine,
    required this.playerNicknames,
    required this.teamNicknames,
  });

  final String code;
  final List<CardCategory> categories;
  final List<String> styles;
  final List<String> taglines;
  final List<String> handoverLines;
  final List<String> verdictsZero;
  final List<String> verdictsLow;
  final List<String> verdictsMid;
  final List<String> verdictsHigh;
  final List<String> guessedLines;
  final List<String> nobodyLines;
  final List<String> winnerLines;
  final List<String> loserLines;
  final String tieLine;
  final List<String> playerNicknames;
  final List<String> teamNicknames;

  /// Tüm kategorilerdeki kelimeler, tek düz liste.
  List<String> get words => [for (final c in categories) ...c.cards];
}

const List<String> avatars = ['🦄', '🐸', '🦊', '🐙', '🐧', '🦖', '🐼', '🐯'];
