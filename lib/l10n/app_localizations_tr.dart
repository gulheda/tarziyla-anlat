// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Tarzıyla Anlat';

  @override
  String get homeClassic => 'Klasik';

  @override
  String get homeClassicDesc =>
      'Rahat parti modu.\nBilen ve anlatan puan alır.';

  @override
  String get homeCompetitive => 'Rekabetçi';

  @override
  String get homeCompetitiveDesc =>
      'Takımlar sayaca karşı yarışır.\nBildikçe puan.';

  @override
  String get homeHowTo => 'Nasıl oynanır?';

  @override
  String homeCounts(int words, int styles) {
    return '$words kelime · $styles tarz';
  }

  @override
  String get settings => 'Ayarlar';

  @override
  String get howToTitle => 'Nasıl oynanır?';

  @override
  String get howTo1Title => 'Telefonu al';

  @override
  String get howTo1Body =>
      'Sırası gelen oyuncu telefonu alır. Diğerleri ekrana bakmaz, bakarsa komik olmaz.';

  @override
  String get howTo2Title => 'İki kart çek';

  @override
  String get howTo2Body =>
      'KELİME kartı ne anlatacağını, TARZ kartı nasıl anlatacağını söyler. Örneğin \"Penguen\" + \"Nenen gibi konuş\".';

  @override
  String get howTo3Title => 'Rezil ol';

  @override
  String get howTo3Body =>
      'Kelimeyi söylemeden, tarzına sadık kalarak anlat. Diğerleri tahmin eder.';

  @override
  String get howTo4Title => 'Puanı topla';

  @override
  String get howTo4Body =>
      'Klasik modda bilen ve anlatan birer puan alır. Rekabetçi modda süre bitene kadar bildiğin kadar kart anlatırsın, her doğru bir puandır.';

  @override
  String get howTo5Title => 'Kazanan belli olur';

  @override
  String get howTo5Body =>
      'Tüm turlar bitince en çok puanlı kazanır. Sonuncu da sahne korkusu ödülünü alır.';

  @override
  String get howTo6Title => 'Kaydırarak oyna';

  @override
  String get howTo6Body =>
      'Kartı sağa kaydırınca \"Bildiler\", sola kaydırınca \"Pas\" olur. Butonlar da çalışır.';

  @override
  String get setupClassicTitle => 'Klasik mod';

  @override
  String get setupCompetitiveTitle => 'Rekabetçi mod';

  @override
  String get players => 'Oyuncular';

  @override
  String get teams => 'Takımlar';

  @override
  String get addPlayer => 'Oyuncu ekle';

  @override
  String get addTeam => 'Takım ekle';

  @override
  String get removeEntry => 'Kaldır';

  @override
  String roundsLabel(int n) {
    return 'Tur sayısı: $n';
  }

  @override
  String roundsHint(int n) {
    return 'Herkes $n kez sahneye çıkar.';
  }

  @override
  String get timeLabel => 'Süre';

  @override
  String secondsShort(int n) {
    return '$n sn';
  }

  @override
  String get startGame => 'Perde açılsın!';

  @override
  String get labelWord => 'KELİME';

  @override
  String get labelStyle => 'TARZ';

  @override
  String roundBadge(int n, int total) {
    return 'TUR $n / $total';
  }

  @override
  String secondsToGo(int n) {
    return '⏱️ $n saniyen var';
  }

  @override
  String passButton(int n) {
    return 'Pas ($n)';
  }

  @override
  String swapButton(int n) {
    return 'Değiştir ($n)';
  }

  @override
  String get gotItButton => 'Bildiler!';

  @override
  String get giveUp => 'Vazgeç, kimse bilemedi';

  @override
  String get swipeGotIt => 'BİLDİLER!';

  @override
  String get swipePass => 'PAS';

  @override
  String get paused => 'Duraklatıldı';

  @override
  String get pausedHint => 'Süre durdu. Devam etmek için dokun.';

  @override
  String get resumeButton => 'Devam et';

  @override
  String get pauseTimerHint => 'Duraklatmak için sayaca dokun';

  @override
  String get timeUp => 'Süre doldu!';

  @override
  String get roundOver => 'Tur bitti';

  @override
  String get gotItTitle => 'Bildiler!';

  @override
  String cardsGuessed(int n) {
    return 'kart bildirdin';
  }

  @override
  String get whoGuessed => 'Kim bildi?';

  @override
  String nextUp(String name) {
    return 'Sıradaki: $name';
  }

  @override
  String get seeResults => 'Sonuçları gör';

  @override
  String winnerTitle(String name) {
    return '$name kazandı!';
  }

  @override
  String get tieTitle => 'Berabere!';

  @override
  String get playAgain => 'Tekrar oyna';

  @override
  String get mainMenu => 'Ana menü';

  @override
  String pointsLabel(int n) {
    return '$n puan';
  }

  @override
  String get exitTitle => 'Perde mi iniyor?';

  @override
  String get exitBody => 'Çıkarsan skorlar kaybolur.';

  @override
  String get keepPlaying => 'Devam';

  @override
  String get leave => 'Çık';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get languageSystem => 'Cihaz dili';

  @override
  String get settingsVibration => 'Titreşim';

  @override
  String get settingsVibrationDesc =>
      'Dokunuşlarda ve son saniyelerde kısa titreşim.';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsAboutBody =>
      'Ücretsiz, açık kaynaklı bir parti oyunu. Reklam yok, hesap yok, veri toplanmaz.';

  @override
  String get settingsSource => 'GitHub\'da kaynak kod';

  @override
  String get settingsLicenses => 'Açık kaynak lisansları';

  @override
  String settingsVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String semanticsTimer(int n) {
    return '$n saniye kaldı';
  }

  @override
  String semanticsScore(int n) {
    return '$n doğru';
  }
}
