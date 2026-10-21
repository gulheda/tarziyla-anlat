# Tarzıyla Anlat

Konuyu çek, tarzı çek, kelimeyi söylemeden anlat! Arkadaşların tahmin etsin, kahkaha garanti.

**Canlı demo:** https://guileless-pithivier-46ef21.netlify.app
(Telefonda açıp "Ana Ekrana Ekle" dersen uygulama gibi çalışır. iPhone'da Safari, Android'de Chrome.)

## Nasıl oynanır
1. Sırası gelen oyuncu telefonu alır.
2. İki kart çıkar: **KONU** ne anlatılacağını, **TARZ** nasıl anlatılacağını söyler.
3. Anlatıcı kelimeyi söylemeden o tarzda anlatır, diğerleri tahmin eder.
4. Kartı sağa kaydırmak "Bildiler", sola kaydırmak "Pas" demektir.

## Modlar
- **Klasik:** Rahat parti modu. Kelimeyi bilen ve anlatan birer puan alır.
- **Rekabetçi:** Takımlar sayaca karşı yarışır. Süre bitene kadar bildiğin kadar kart anlat, her doğru bir puan.

2 ile 8 oyuncu ya da takım, 30/60/90 saniye, 1 ile 10 tur. Hesap ve internet gerekmez, hiçbir veri toplanmaz.

## İçerik
520 konu ve 210 tarz kartı, hepsi özgün ve karışık gelir. Kartlar [lib/data/cards.dart](lib/data/cards.dart), oyun içi espriler [lib/data/funny.dart](lib/data/funny.dart) dosyasında. Yeni kart eklemek için ilgili listeye bir satır eklemek yeterli.

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
