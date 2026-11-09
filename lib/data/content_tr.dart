import 'cards.dart';
import 'content.dart';
import 'funny.dart';

/// Türkçe oyun içeriği.
const GameContent trContent = GameContent(
  code: 'tr',
  categories: anlatCategories,
  styles: tarzCards,
  taglines: taglines,
  handoverLines: handoverLines,
  verdictsZero: verdictsZero,
  verdictsLow: verdictsLow,
  verdictsMid: verdictsMid,
  verdictsHigh: verdictsHigh,
  guessedLines: guessedLines,
  nobodyLines: nobodyLines,
  winnerLines: winnerLines,
  loserLines: loserLines,
  tieLine: 'Herkes aynı puanda. Adalet bu kadar olur.',
  playerNicknames: playerNicknames,
  teamNicknames: teamNicknames,
);
