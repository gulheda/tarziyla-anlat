import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Tarzıyla Anlat'**
  String get appName;

  /// No description provided for @homeClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get homeClassic;

  /// No description provided for @homeClassicDesc.
  ///
  /// In en, this message translates to:
  /// **'Relaxed party mode.\nThe guesser and the actor both score.'**
  String get homeClassicDesc;

  /// No description provided for @homeCompetitive.
  ///
  /// In en, this message translates to:
  /// **'Competitive'**
  String get homeCompetitive;

  /// No description provided for @homeCompetitiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Teams race the clock.\nScore for every guess.'**
  String get homeCompetitiveDesc;

  /// No description provided for @homeHowTo.
  ///
  /// In en, this message translates to:
  /// **'How to play?'**
  String get homeHowTo;

  /// No description provided for @homeCounts.
  ///
  /// In en, this message translates to:
  /// **'{words} words · {styles} styles'**
  String homeCounts(int words, int styles);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @howToTitle.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get howToTitle;

  /// No description provided for @howTo1Title.
  ///
  /// In en, this message translates to:
  /// **'Grab the phone'**
  String get howTo1Title;

  /// No description provided for @howTo1Body.
  ///
  /// In en, this message translates to:
  /// **'The player whose turn it is takes the phone. Everyone else looks away, peeking ruins the fun.'**
  String get howTo1Body;

  /// No description provided for @howTo2Title.
  ///
  /// In en, this message translates to:
  /// **'Draw two cards'**
  String get howTo2Title;

  /// No description provided for @howTo2Body.
  ///
  /// In en, this message translates to:
  /// **'The WORD card says what to act out, the STYLE card says how. For example \"Penguin\" + \"Talk like your grandma\".'**
  String get howTo2Body;

  /// No description provided for @howTo3Title.
  ///
  /// In en, this message translates to:
  /// **'Make a fool of yourself'**
  String get howTo3Title;

  /// No description provided for @howTo3Body.
  ///
  /// In en, this message translates to:
  /// **'Describe the word without saying it, staying true to your style. The others guess.'**
  String get howTo3Body;

  /// No description provided for @howTo4Title.
  ///
  /// In en, this message translates to:
  /// **'Collect points'**
  String get howTo4Title;

  /// No description provided for @howTo4Body.
  ///
  /// In en, this message translates to:
  /// **'In Classic mode the guesser and the actor each get a point. In Competitive mode you describe as many cards as you can before time runs out, one point each.'**
  String get howTo4Body;

  /// No description provided for @howTo5Title.
  ///
  /// In en, this message translates to:
  /// **'A winner is crowned'**
  String get howTo5Title;

  /// No description provided for @howTo5Body.
  ///
  /// In en, this message translates to:
  /// **'When all rounds are done, the highest score wins. The last place gets the stage fright award.'**
  String get howTo5Body;

  /// No description provided for @howTo6Title.
  ///
  /// In en, this message translates to:
  /// **'Swipe to play'**
  String get howTo6Title;

  /// No description provided for @howTo6Body.
  ///
  /// In en, this message translates to:
  /// **'Swipe the cards right for \"Got it\" or left for \"Pass\". The buttons work too.'**
  String get howTo6Body;

  /// No description provided for @setupClassicTitle.
  ///
  /// In en, this message translates to:
  /// **'Classic mode'**
  String get setupClassicTitle;

  /// No description provided for @setupCompetitiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Competitive mode'**
  String get setupCompetitiveTitle;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @addPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add player'**
  String get addPlayer;

  /// No description provided for @addTeam.
  ///
  /// In en, this message translates to:
  /// **'Add team'**
  String get addTeam;

  /// No description provided for @removeEntry.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeEntry;

  /// No description provided for @roundsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rounds: {n}'**
  String roundsLabel(int n);

  /// No description provided for @roundsHint.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Everyone performs once.} other{Everyone performs {n} times.}}'**
  String roundsHint(int n);

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'{n} s'**
  String secondsShort(int n);

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start the show!'**
  String get startGame;

  /// No description provided for @labelWord.
  ///
  /// In en, this message translates to:
  /// **'WORD'**
  String get labelWord;

  /// No description provided for @labelStyle.
  ///
  /// In en, this message translates to:
  /// **'STYLE'**
  String get labelStyle;

  /// No description provided for @roundBadge.
  ///
  /// In en, this message translates to:
  /// **'ROUND {n} / {total}'**
  String roundBadge(int n, int total);

  /// No description provided for @secondsToGo.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{⏱️ 1 second to go} other{⏱️ {n} seconds to go}}'**
  String secondsToGo(int n);

  /// No description provided for @passButton.
  ///
  /// In en, this message translates to:
  /// **'Pass ({n})'**
  String passButton(int n);

  /// No description provided for @swapButton.
  ///
  /// In en, this message translates to:
  /// **'Swap ({n})'**
  String swapButton(int n);

  /// No description provided for @gotItButton.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotItButton;

  /// No description provided for @giveUp.
  ///
  /// In en, this message translates to:
  /// **'Give up, nobody got it'**
  String get giveUp;

  /// No description provided for @swipeGotIt.
  ///
  /// In en, this message translates to:
  /// **'GOT IT!'**
  String get swipeGotIt;

  /// No description provided for @swipePass.
  ///
  /// In en, this message translates to:
  /// **'PASS'**
  String get swipePass;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @pausedHint.
  ///
  /// In en, this message translates to:
  /// **'The clock is stopped. Tap to continue.'**
  String get pausedHint;

  /// No description provided for @resumeButton.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeButton;

  /// No description provided for @pauseTimerHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the timer to pause'**
  String get pauseTimerHint;

  /// No description provided for @timeUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up!'**
  String get timeUp;

  /// No description provided for @roundOver.
  ///
  /// In en, this message translates to:
  /// **'Round over'**
  String get roundOver;

  /// No description provided for @gotItTitle.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotItTitle;

  /// No description provided for @cardsGuessed.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{card guessed} other{cards guessed}}'**
  String cardsGuessed(int n);

  /// No description provided for @whoGuessed.
  ///
  /// In en, this message translates to:
  /// **'Who guessed it?'**
  String get whoGuessed;

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'Next: {name}'**
  String nextUp(String name);

  /// No description provided for @seeResults.
  ///
  /// In en, this message translates to:
  /// **'See results'**
  String get seeResults;

  /// No description provided for @winnerTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} wins!'**
  String winnerTitle(String name);

  /// No description provided for @tieTitle.
  ///
  /// In en, this message translates to:
  /// **'It\'s a tie!'**
  String get tieTitle;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'Main menu'**
  String get mainMenu;

  /// No description provided for @pointsLabel.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 pt} other{{n} pts}}'**
  String pointsLabel(int n);

  /// No description provided for @exitTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaving the stage?'**
  String get exitTitle;

  /// No description provided for @exitBody.
  ///
  /// In en, this message translates to:
  /// **'If you leave, the scores are lost.'**
  String get exitBody;

  /// No description provided for @keepPlaying.
  ///
  /// In en, this message translates to:
  /// **'Keep playing'**
  String get keepPlaying;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @settingsVibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get settingsVibration;

  /// No description provided for @settingsVibrationDesc.
  ///
  /// In en, this message translates to:
  /// **'Short buzzes on taps and in the last seconds.'**
  String get settingsVibrationDesc;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'A free, open-source party game. No ads, no accounts, no data collected.'**
  String get settingsAboutBody;

  /// No description provided for @settingsSource.
  ///
  /// In en, this message translates to:
  /// **'Source code on GitHub'**
  String get settingsSource;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @semanticsTimer.
  ///
  /// In en, this message translates to:
  /// **'{n} seconds left'**
  String semanticsTimer(int n);

  /// No description provided for @semanticsScore.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 correct} other{{n} correct}}'**
  String semanticsScore(int n);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
