import 'content.dart';
import 'content_en.dart';
import 'content_tr.dart';

export 'content.dart';

/// Desteklenen dil kodları. İlki varsayılan (dil desteklenmiyorsa) kullanılır.
const List<String> supportedLanguageCodes = ['en', 'tr'];

/// Dil koduna göre oyun içeriği. Bilinmeyen kod İngilizce'ye düşer.
GameContent contentFor(String languageCode) =>
    languageCode == 'tr' ? trContent : enContent;

/// Cihaz dili desteklenmiyorsa İngilizce'ye düşen dil kodu.
String resolveLanguageCode(String? code) =>
    supportedLanguageCodes.contains(code) ? code! : 'en';
