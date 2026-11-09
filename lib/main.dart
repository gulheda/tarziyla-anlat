import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/contents.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/settings.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  registerLicenses();
  final settings = await AppSettings.load();
  runApp(TarziylaAnlatApp(settings: settings));
}

/// Uygulamayla birlikte gelen yazı tipinin (SIL Open Font License) metnini
/// "Açık kaynak lisansları" sayfasına ekler.
void registerLicenses() {
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/fonts/OFL-PaytoneOne.txt');
    yield LicenseEntryWithLineBreaks(['Paytone One (font)'], text);
  });
}

/// Cihaz dillerinden ilk desteklenen (en/tr) dili seçer; hiçbiri yoksa İngilizce.
Locale resolveLocale(List<Locale>? locales, Iterable<Locale> supported) {
  for (final locale in locales ?? const <Locale>[]) {
    if (supportedLanguageCodes.contains(locale.languageCode)) {
      return Locale(locale.languageCode);
    }
  }
  return const Locale('en');
}

class TarziylaAnlatApp extends StatelessWidget {
  const TarziylaAnlatApp({super.key, required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsScope(
      settings: settings,
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appName,
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeListResolutionCallback: resolveLocale,
          // Çok büyük yazı boyutlarında düzenin bozulmasını önler.
          builder: (context, child) => MediaQuery.withClampedTextScaling(
            minScaleFactor: 0.9,
            maxScaleFactor: 1.3,
            child: child!,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
