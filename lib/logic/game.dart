import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/cards.dart';
import '../data/funny.dart';

enum GameMode { classic, competitive }

enum Phase { handover, playing, result, finished }

class CardPair {
  const CardPair(this.konu, this.tarz);

  final String konu;
  final String tarz;
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
    this.categoryIds = const [],
  });

  final GameMode mode;
  final List<String> names;
  final int rounds;
  final int seconds;

  /// Kullanılacak "Anlat" paketleri. Boşsa tüm paketler kullanılır.
  final List<String> categoryIds;

  /// Klasik modda kart değiştirmek için tek hak, rekabetçi modda üç pas hakkı.
  int get passLimit => mode == GameMode.classic ? 1 : 3;
}

/// Tek cihazda oynanan oyunun durumu. Ekranlar yalnızca bu sınıfı dinler.
class Game extends ChangeNotifier {
  Game(this.config, {Random? random})
    : _random = random ?? Random(),
      participants = [
        for (var i = 0; i < config.names.length; i++)
          Participant(config.names[i], avatars[i % avatars.length]),
      ] {
    _anlatSource = anlatPool(
      config.categoryIds.isEmpty
          ? anlatCategories.map((c) => c.id)
          : config.categoryIds,
    );
    _anlatDeck = _shuffled(_anlatSource);
    _tarzDeck = _shuffled(tarzCards);
    secondsLeft = config.seconds;
    _pickTurnLines();
  }

  final GameConfig config;
  final Random _random;
  final List<Participant> participants;

  late final List<String> _anlatSource;
  late List<String> _anlatDeck;
  late List<String> _tarzDeck;
  Timer? _ticker;

  Phase phase = Phase.handover;
  int turnIndex = 0;
  late int secondsLeft;
  late CardPair current;
  int passesLeft = 0;

  /// Bu turda doğru anlatılan kartlar.
  final List<CardPair> turnCorrect = [];

  /// Klasik modda tur sonunda anlatım doğru bilindiyse true.
  bool classicSolved = false;

  /// Klasik modda kelimeyi bilen oyuncu (puan verildikten sonra dolar).
  Participant? guesser;

  /// Ekranlarda gösterilen, tur başına bir kez seçilen esprili metinler.
  String handoverLine = '';
  String readyLine = '';
  String verdict = '';
  String finalLine = '';

  int get totalTurns => participants.length * config.rounds;
  int get currentIndex => turnIndex % participants.length;
  int get round => turnIndex ~/ participants.length + 1;
  Participant get currentPlayer => participants[currentIndex];

  List<Participant> get ranking =>
      [...participants]..sort((a, b) => b.score.compareTo(a.score));

  List<String> _shuffled(List<String> source) => [...source]..shuffle(_random);

  String _pick(List<String> lines) => lines[_random.nextInt(lines.length)];

  CardPair _draw() {
    if (_anlatDeck.isEmpty) _anlatDeck = _shuffled(_anlatSource);
    if (_tarzDeck.isEmpty) _tarzDeck = _shuffled(tarzCards);
    return CardPair(_anlatDeck.removeLast(), _tarzDeck.removeLast());
  }

  void _pickTurnLines() {
    handoverLine = _pick(handoverLines).replaceAll('{n}', currentPlayer.name);
    readyLine = _pick(readyLines);
  }

  /// Telefon anlatıcıdayken tek dokunuşla (geri sayımdan sonra) tur başlar.
  void startTurn() {
    turnCorrect.clear();
    classicSolved = false;
    guesser = null;
    verdict = '';
    passesLeft = config.passLimit;
    secondsLeft = config.seconds;
    current = _draw();
    phase = Phase.playing;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => tick());
    notifyListeners();
  }

  /// Süreyi bir saniye azaltır. Testlerde doğrudan çağrılabilir.
  void tick() {
    if (phase != Phase.playing) return;
    secondsLeft--;
    if (secondsLeft <= 0) {
      secondsLeft = 0;
      _endTurn();
    } else {
      notifyListeners();
    }
  }

  void markCorrect() {
    if (phase != Phase.playing) return;
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

  bool get canPass => phase == Phase.playing && passesLeft > 0;

  void pass() {
    if (!canPass) return;
    passesLeft--;
    current = _draw();
    notifyListeners();
  }

  /// Anlatıcı turu süre dolmadan bitirmek isterse.
  void endTurnEarly() {
    if (phase == Phase.playing) _endTurn();
  }

  void _endTurn() {
    _ticker?.cancel();
    phase = Phase.result;
    verdict = _resultVerdict();
    notifyListeners();
  }

  String _resultVerdict() {
    if (config.mode == GameMode.classic) {
      return classicSolved ? '' : _pick(nobodyLines);
    }
    final n = turnCorrect.length;
    if (n == 0) return _pick(verdictsZero);
    if (n <= 2) return _pick(verdictsLow);
    if (n <= 5) return _pick(verdictsMid);
    return _pick(verdictsHigh);
  }

  /// Klasik mod: kelimeyi bilen oyuncuya ve anlatıcıya birer puan verir.
  void awardClassic(int guesserIndex) {
    if (phase != Phase.result || !classicSolved || guesser != null) return;
    if (guesserIndex == currentIndex) return;
    participants[guesserIndex].score++;
    currentPlayer.score++;
    guesser = participants[guesserIndex];
    verdict = _pick(guessedLines)
        .replaceAll('{g}', guesser!.name)
        .replaceAll('{d}', currentPlayer.name);
    notifyListeners();
  }

  void nextTurn() {
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
    if (r.first.score == r.last.score) {
      return 'Herkes aynı puanda. Adalet bu kadar olur.';
    }
    return '${_pick(winnerLines)}\n'
        '${_pick(loserLines).replaceAll('{n}', r.last.name)}';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
