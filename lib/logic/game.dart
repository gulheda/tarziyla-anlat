import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/contents.dart';

enum GameMode { classic, competitive }

enum Phase { handover, playing, result, finished }

class CardPair {
  const CardPair(this.word, this.style);

  final String word;
  final String style;
}

class Participant {
  Participant(this.name, this.emoji);

  final String name;
  final String emoji;
  int score = 0;
}

class GameConfig {
  const GameConfig({
    required this.mode,
    required this.names,
    required this.rounds,
    required this.seconds,
    this.languageCode = 'en',
  });

  final GameMode mode;
  final List<String> names;
  final int rounds;
  final int seconds;

  /// Kelime ve tarz kartlarının, esprili metinlerin dili ('en' ya da 'tr').
  final String languageCode;

  /// Klasik modda kart değiştirmek için tek hak, rekabetçi modda üç pas hakkı.
  int get passLimit => mode == GameMode.classic ? 1 : 3;
}

/// Tek cihazda oynanan oyunun durumu. Ekranlar yalnızca bu sınıfı dinler.
///
/// Süre, saniye saymak yerine gerçek saate göre hesaplanır; böylece sayaç
/// kayma yapmaz ve duraklatılıp devam ettirildiğinde doğru kalır.
class Game extends ChangeNotifier {
  Game(this.config, {Random? random, DateTime Function()? clock})
    : _random = random ?? Random(),
      _clock = clock ?? DateTime.now,
      content = contentFor(config.languageCode),
      participants = [
        for (var i = 0; i < config.names.length; i++)
          Participant(config.names[i], avatars[i % avatars.length]),
      ] {
    assert(participants.length >= 2, 'En az iki oyuncu gerekir');
    _wordDeck = _shuffled(content.words);
    _styleDeck = _shuffled(content.styles);
    secondsLeft = config.seconds;
    _pickTurnLines();
  }

  final GameConfig config;
  final GameContent content;
  final Random _random;
  final DateTime Function() _clock;
  final List<Participant> participants;

  late List<String> _wordDeck;
  late List<String> _styleDeck;
  String? _lastWord;
  String? _lastStyle;
  Timer? _ticker;
  DateTime? _endsAt;
  Duration _remainingWhilePaused = Duration.zero;

  Phase phase = Phase.handover;
  int turnIndex = 0;
  late int secondsLeft;
  late CardPair current;
  int passesLeft = 0;
  bool paused = false;

  /// Bu turda doğru anlatılan kartlar.
  final List<CardPair> turnCorrect = [];

  /// Klasik modda tur sonunda anlatım doğru bilindiyse true.
  bool classicSolved = false;

  /// Klasik modda kelimeyi bilen oyuncu (puan verildikten sonra dolar).
  Participant? guesser;

  /// Ekranlarda gösterilen, tur başına bir kez seçilen esprili metinler.
  String handoverLine = '';
  String verdict = '';
  String finalLine = '';

  int get totalTurns => participants.length * config.rounds;
  int get currentIndex => turnIndex % participants.length;
  int get round => turnIndex ~/ participants.length + 1;
  Participant get currentPlayer => participants[currentIndex];

  /// Sıradaki oyuncu (son turdaysa yine mevcut oyuncuya döner).
  Participant get nextPlayer =>
      participants[(turnIndex + 1) % participants.length];

  bool get isLastTurn => turnIndex + 1 >= totalTurns;

  List<Participant> get ranking => [...participants]
    ..sort(
      (a, b) => b.score.compareTo(a.score),
    ); // kararlı: eşitlikte sıra korunur

  List<String> _shuffled(List<String> source) => [...source]..shuffle(_random);

  String _pick(List<String> lines) => lines[_random.nextInt(lines.length)];

  /// Desteden bir kart çeker. Deste biterse yeniden karıştırır ve aynı kartın
  /// arka arkaya gelmesini önler.
  String _take(List<String> deck, List<String> source, String? last) {
    if (deck.isEmpty) {
      deck.addAll(_shuffled(source));
      if (deck.length > 1 && deck.last == last) {
        final swap = deck.length - 2;
        final tmp = deck[swap];
        deck[swap] = deck.last;
        deck[deck.length - 1] = tmp;
      }
    }
    return deck.removeLast();
  }

  CardPair _draw() {
    final word = _take(_wordDeck, content.words, _lastWord);
    final style = _take(_styleDeck, content.styles, _lastStyle);
    _lastWord = word;
    _lastStyle = style;
    return CardPair(word, style);
  }

  void _pickTurnLines() {
    handoverLine = _pick(content.handoverLines)
        .replaceAll('{n}', currentPlayer.name);
  }

  /// Turu başlatır (geri sayım bittikten sonra çağrılır).
  void startTurn() {
    if (phase != Phase.handover) return;
    turnCorrect.clear();
    classicSolved = false;
    guesser = null;
    verdict = '';
    paused = false;
    passesLeft = config.passLimit;
    secondsLeft = config.seconds;
    current = _draw();
    phase = Phase.playing;
    _endsAt = _clock().add(Duration(seconds: config.seconds));
    _startTicker();
    notifyListeners();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) => tick());
  }

  /// Kalan süreyi gerçek saate göre yeniler. Testlerde doğrudan çağrılabilir.
  void tick() {
    if (phase != Phase.playing || paused) return;
    final remaining = _endsAt!.difference(_clock());
    final secs = max(0, (remaining.inMilliseconds / 1000).ceil());
    if (secs == secondsLeft) return;
    secondsLeft = secs;
    if (secs <= 0) {
      _endTurn();
    } else {
      notifyListeners();
    }
  }

  /// Süreyi durdurur (uygulama arka plana gidince ya da oyuncu isteyince).
  void pause() {
    if (phase != Phase.playing || paused) return;
    tick();
    if (phase != Phase.playing) return;
    _remainingWhilePaused = _endsAt!.difference(_clock());
    paused = true;
    _ticker?.cancel();
    notifyListeners();
  }

  /// Duraklatılmış süreyi kaldığı yerden sürdürür.
  void resume() {
    if (phase != Phase.playing || !paused) return;
    _endsAt = _clock().add(_remainingWhilePaused);
    paused = false;
    _startTicker();
    notifyListeners();
  }

  void markCorrect() {
    if (phase != Phase.playing || paused) return;
    turnCorrect.add(current);
    if (config.mode == GameMode.competitive) {
      currentPlayer.score++;
      current = _draw();
      notifyListeners();
    } else {
      classicSolved = true;
      _endTurn();
    }
  }

  bool get canPass => phase == Phase.playing && !paused && passesLeft > 0;

  void pass() {
    if (!canPass) return;
    passesLeft--;
    current = _draw();
    notifyListeners();
  }

  /// Anlatıcı turu süre dolmadan bitirmek isterse.
  void endTurnEarly() {
    if (phase == Phase.playing && !paused) _endTurn();
  }

  void _endTurn() {
    _ticker?.cancel();
    paused = false;
    phase = Phase.result;
    verdict = _resultVerdict();
    notifyListeners();
  }

  String _resultVerdict() {
    if (config.mode == GameMode.classic) {
      return classicSolved ? '' : _pick(content.nobodyLines);
    }
    final n = turnCorrect.length;
    if (n == 0) return _pick(content.verdictsZero);
    if (n <= 2) return _pick(content.verdictsLow);
    if (n <= 5) return _pick(content.verdictsMid);
    return _pick(content.verdictsHigh);
  }

  /// Klasik mod: kelimeyi bilen oyuncuya ve anlatıcıya birer puan verir.
  void awardClassic(int guesserIndex) {
    if (phase != Phase.result || !classicSolved || guesser != null) return;
    if (guesserIndex == currentIndex) return;
    if (guesserIndex < 0 || guesserIndex >= participants.length) return;
    participants[guesserIndex].score++;
    currentPlayer.score++;
    guesser = participants[guesserIndex];
    verdict = _pick(content.guessedLines)
        .replaceAll('{g}', guesser!.name)
        .replaceAll('{d}', currentPlayer.name);
    notifyListeners();
  }

  /// Sonuç ekranından bir sonraki tura ya da bitiş ekranına geçer.
  void nextTurn() {
    if (phase != Phase.result) return;
    // Klasik modda doğru bilindiyse puan henüz verilmediyse geçilemez.
    if (classicSolved && guesser == null) return;
    turnIndex++;
    if (turnIndex >= totalTurns) {
      phase = Phase.finished;
      finalLine = _buildFinalLine();
    } else {
      phase = Phase.handover;
      secondsLeft = config.seconds;
      _pickTurnLines();
    }
    notifyListeners();
  }

  String _buildFinalLine() {
    final r = ranking;
    if (r.first.score == r.last.score) return content.tieLine;
    return '${_pick(content.winnerLines)}\n'
        '${_pick(content.loserLines).replaceAll('{n}', r.last.name)}';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
