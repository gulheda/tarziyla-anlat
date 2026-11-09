// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tarzıyla Anlat';

  @override
  String get homeClassic => 'Classic';

  @override
  String get homeClassicDesc =>
      'Relaxed party mode.\nThe guesser and the actor both score.';

  @override
  String get homeCompetitive => 'Competitive';

  @override
  String get homeCompetitiveDesc =>
      'Teams race the clock.\nScore for every guess.';

  @override
  String get homeHowTo => 'How to play?';

  @override
  String homeCounts(int words, int styles) {
    return '$words words · $styles styles';
  }

  @override
  String get settings => 'Settings';

  @override
  String get howToTitle => 'How to play';

  @override
  String get howTo1Title => 'Grab the phone';

  @override
  String get howTo1Body =>
      'The player whose turn it is takes the phone. Everyone else looks away, peeking ruins the fun.';

  @override
  String get howTo2Title => 'Draw two cards';

  @override
  String get howTo2Body =>
      'The WORD card says what to act out, the STYLE card says how. For example \"Penguin\" + \"Talk like your grandma\".';

  @override
  String get howTo3Title => 'Make a fool of yourself';

  @override
  String get howTo3Body =>
      'Describe the word without saying it, staying true to your style. The others guess.';

  @override
  String get howTo4Title => 'Collect points';

  @override
  String get howTo4Body =>
      'In Classic mode the guesser and the actor each get a point. In Competitive mode you describe as many cards as you can before time runs out, one point each.';

  @override
  String get howTo5Title => 'A winner is crowned';

  @override
  String get howTo5Body =>
      'When all rounds are done, the highest score wins. The last place gets the stage fright award.';

  @override
  String get howTo6Title => 'Swipe to play';

  @override
  String get howTo6Body =>
      'Swipe the cards right for \"Got it\" or left for \"Pass\". The buttons work too.';

  @override
  String get setupClassicTitle => 'Classic mode';

  @override
  String get setupCompetitiveTitle => 'Competitive mode';

  @override
  String get players => 'Players';

  @override
  String get teams => 'Teams';

  @override
  String get addPlayer => 'Add player';

  @override
  String get addTeam => 'Add team';

  @override
  String get removeEntry => 'Remove';

  @override
  String roundsLabel(int n) {
    return 'Rounds: $n';
  }

  @override
  String roundsHint(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Everyone performs $n times.',
      one: 'Everyone performs once.',
    );
    return '$_temp0';
  }

  @override
  String get timeLabel => 'Time';

  @override
  String secondsShort(int n) {
    return '$n s';
  }

  @override
  String get startGame => 'Start the show!';

  @override
  String get labelWord => 'WORD';

  @override
  String get labelStyle => 'STYLE';

  @override
  String roundBadge(int n, int total) {
    return 'ROUND $n / $total';
  }

  @override
  String secondsToGo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '⏱️ $n seconds to go',
      one: '⏱️ 1 second to go',
    );
    return '$_temp0';
  }

  @override
  String passButton(int n) {
    return 'Pass ($n)';
  }

  @override
  String swapButton(int n) {
    return 'Swap ($n)';
  }

  @override
  String get gotItButton => 'Got it!';

  @override
  String get giveUp => 'Give up, nobody got it';

  @override
  String get swipeGotIt => 'GOT IT!';

  @override
  String get swipePass => 'PASS';

  @override
  String get paused => 'Paused';

  @override
  String get pausedHint => 'The clock is stopped. Tap to continue.';

  @override
  String get resumeButton => 'Resume';

  @override
  String get pauseTimerHint => 'Tap the timer to pause';

  @override
  String get timeUp => 'Time\'s up!';

  @override
  String get roundOver => 'Round over';

  @override
  String get gotItTitle => 'Got it!';

  @override
  String cardsGuessed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'cards guessed',
      one: 'card guessed',
    );
    return '$_temp0';
  }

  @override
  String get whoGuessed => 'Who guessed it?';

  @override
  String nextUp(String name) {
    return 'Next: $name';
  }

  @override
  String get seeResults => 'See results';

  @override
  String winnerTitle(String name) {
    return '$name wins!';
  }

  @override
  String get tieTitle => 'It\'s a tie!';

  @override
  String get playAgain => 'Play again';

  @override
  String get mainMenu => 'Main menu';

  @override
  String pointsLabel(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pts',
      one: '1 pt',
    );
    return '$_temp0';
  }

  @override
  String get exitTitle => 'Leaving the stage?';

  @override
  String get exitBody => 'If you leave, the scores are lost.';

  @override
  String get keepPlaying => 'Keep playing';

  @override
  String get leave => 'Leave';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get settingsVibration => 'Vibration';

  @override
  String get settingsVibrationDesc =>
      'Short buzzes on taps and in the last seconds.';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutBody =>
      'A free, open-source party game. No ads, no accounts, no data collected.';

  @override
  String get settingsSource => 'Source code on GitHub';

  @override
  String get settingsLicenses => 'Open-source licenses';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String semanticsTimer(int n) {
    return '$n seconds left';
  }

  @override
  String semanticsScore(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n correct',
      one: '1 correct',
    );
    return '$_temp0';
  }
}
