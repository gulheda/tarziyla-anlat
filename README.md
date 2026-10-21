# Tarzıyla Anlat

Kelimeyi çek, tarzı çek, kelimeyi söylemeden anlat! Arkadaşların tahmin etsin, kahkaha garanti.

**Canlı demo:** https://guileless-pithivier-46ef21.netlify.app
(Telefonda açıp "Ana Ekrana Ekle" dersen uygulama gibi çalışır. iPhone'da Safari, Android'de Chrome.)

## İndir
- **Android:** [Son sürümü indir (APK)](https://github.com/gulheda/tarziyla-anlat/releases/latest). Dosyayı açıp "bilinmeyen kaynaklardan yükle" izni vermen gerekir.
- **iPhone ve diğerleri:** Yukarıdaki canlı demo bağlantısını Safari ya da Chrome'da aç, "Ana Ekrana Ekle" de.

## Nasıl oynanır
1. Sırası gelen oyuncu telefonu alır.
2. İki kart çıkar: **KELİME** ne anlatılacağını, **TARZ** nasıl anlatılacağını söyler.
3. Anlatıcı kelimeyi söylemeden o tarzda anlatır, diğerleri tahmin eder.
4. Kartı sağa kaydırmak "Bildiler", sola kaydırmak "Pas" demektir.
5. Tur başına tek dokunuş: sonuç ekranındaki "Sıradaki" düğmesi geri sayımı başlatır.

## Modlar
- **Klasik:** Rahat parti modu. Kelimeyi bilen ve anlatan birer puan alır.
- **Rekabetçi:** Takımlar sayaca karşı yarışır. Süre bitene kadar bildiğin kadar kart anlat, her doğru bir puan.

2 ile 8 oyuncu ya da takım, 30/60/90 saniye, 1 ile 10 tur. Hesap ve internet gerekmez, hiçbir veri toplanmaz.

## İçerik
621 tek kelime ve 219 tarz kartı, hepsi özgün ve karışık gelir. Kartlar [lib/data/cards.dart](lib/data/cards.dart), oyun içi espriler [lib/data/funny.dart](lib/data/funny.dart) dosyasında. Yeni kart eklemek için ilgili listeye bir satır eklemek yeterli.

## Çalıştırmak için
[Flutter](https://docs.flutter.dev/get-started/install) kurulu olmalı.

```
flutter pub get
flutter run                  # bağlı telefon ya da emülatör
flutter run -d chrome        # web
flutter test                 # testler
```

Derleme:
```
flutter build apk --release  # Android (build/app/outputs/flutter-apk/app-release.apk)
flutter build web --release  # Web (build/web klasörü)
flutter build ipa            # iPhone (Apple Developer hesabı gerekir)
```

## Proje yapısı
- `lib/logic/game.dart`: Oyun durumu, tur ve puan mantığı
- `lib/screens/`: Ana ekran, kurulum, oyun ve "Nasıl oynanır?" ekranları
- `lib/ui/`: Tema, renkler ve ortak bileşenler
- `lib/data/`: Kartlar ve esprili metinler
- `store/`: App Store metinleri, gizlilik politikası ve yayın kontrol listesi

## Yayın
Mağaza metinleri ve adım adım kontrol listesi için [store/YAYIN_KONTROL_LISTESI.md](store/YAYIN_KONTROL_LISTESI.md) dosyasına bak.

## Web'i otomatik yayınlamak
`.github/workflows/deploy-web.yml`, `main` dalına her yüklemede web sürümünü derleyip Netlify'a gönderir. Çalışması için repo ayarlarında iki gizli değer tanımlanmalı:

```
gh secret set NETLIFY_AUTH_TOKEN
gh secret set NETLIFY_SITE_ID
```
Token'ı Netlify'da *User settings > Applications > Personal access tokens* bölümünden, site kimliğini *Site configuration > Site ID* alanından alırsın. Bu değerler yoksa akış yayınlamayı atlar.
