# App Store Yayın Kontrol Listesi

## Yapılanlar
- [x] Kart etiketleri "ANLAT / GİBİ" yerine **"KONU / TARZ"** yapıldı (oyun, "Nasıl oynanır?" ve kod).
- [x] Paket adı değiştirildi: `com.gulhedakizilhan.tarziylaanlat` (Android ve iOS). Eski adda "gibianlat" geçiyordu.
- [x] Uygulama adı "Tarzıyla Anlat", ikon, açılış ekranı ve yazı tipi hazır.
- [x] iOS: şifreleme dışa aktarım sorusu için `ITSAppUsesNonExemptEncryption = false` eklendi.
- [x] Mağaza metinleri: `store/app-store-listing.md`
- [x] Gizlilik politikası sayfası: `store/privacy-policy.html`

## Senin yapman gerekenler

### 1) Paket adını onayla
Paket adı **App Store'da yayınlandıktan sonra değiştirilemez.** Beğenmezsen ilk kayıttan önce söyle, ben değiştiririm.

### 2) Marka sorgusu
1. https://www.turkpatent.gov.tr adresinde "Marka Araştırması" bölümüne gir.
2. "Gibi Anlat" ve "Tarzıyla Anlat" adlarını sorgula.
3. Benzer bir tescil görürsen yayından önce bir avukata danış.

### 3) Fikri mülkiyet avukatı (önerilir)
Tek seferlik bir danışmanlık yeterli. Sorulacak: "Başka bir kutu oyununa benzer mekanikte, tamamen kendi içeriği ve farklı adıyla bir mobil oyun yayınlayabilir miyim?"

### 4) Molfy'ye yazmak (isteğe bağlı)
Doğrudan iletişime geçip iş birliği ya da izin istemek ileride sorun çıkma ihtimalini azaltabilir.

### 5) Gizlilik politikasını yayınla
Apple'ın istediği, herkese açık bir internet adresi (URL).
1. `store/privacy-policy.html` içindeki `[E-POSTA ADRESİNİ BURAYA YAZ]` yerine kendi iletişim e-postanı yaz.
2. Dosyayı herkese açık bir yerde yayınla (GitHub Pages, Notion'da herkese açık sayfa ya da kendi siten).
3. Çıkan adresi App Store Connect'te "Gizlilik Politikası URL'si" alanına yaz.

### 6) Apple Developer hesabı
1. https://developer.apple.com/programs adresinden **Apple Developer Program**'a katıl (yıllık 99 dolar).
2. Xcode > Settings > Accounts bölümünden Apple Kimliğini ekle.

### 7) Uygulamayı Xcode'da imzala ve yükle
1. `ios/Runner.xcworkspace` dosyasını Xcode'da aç.
2. Runner > Signing & Capabilities: **Team**'i seç, "Automatically manage signing" açık kalsın.
3. Terminalde: `flutter build ipa` (ya da Xcode'da Product > Archive).
4. Xcode Organizer'dan "Distribute App > App Store Connect" ile yükle.

### 8) App Store Connect kaydı
1. https://appstoreconnect.apple.com > Uygulamalar > Yeni Uygulama.
2. Bundle ID: `com.gulhedakizilhan.tarziylaanlat`
3. `store/app-store-listing.md` içindeki metinleri, kategoriyi, yaş ve gizlilik cevaplarını gir.
4. Ekran görüntülerini yükle (6,9 inç iPhone, 1320 x 2868). İstersen simülatörden ben alırım.
5. Önce **TestFlight** ile arkadaşlarında dene, sonra "İncelemeye Gönder".

### 9) Android (Google Play)
Google Play için ayrıca bir geliştirici hesabı (tek seferlik 25 dolar) ve imzalama anahtarı gerekir. İstersen o adımları da hazırlarım.

---

## Sadece arkadaşlarla paylaşmak (mağazada yayınlamadan)

### Android
`dist/TarziylaAnlat.apk` dosyasını (50 MB) WhatsApp, Drive ya da e-posta ile gönder. Arkadaşın dosyaya dokunup "Bilinmeyen kaynaklardan yüklemeye izin ver" demeli. Mağaza gerekmez, ücretsizdir.

### iPhone: TestFlight (önerilen, yıllık 99 dolar)
1. Apple Developer Program'a katıl (yukarıdaki 6. madde).
2. Uygulamayı yükle (7. madde) ve App Store Connect'te kaydını aç (8. madde).
3. App Store Connect > TestFlight bölümüne gir.
4. **Dahili test:** En fazla 100 kişi. Arkadaşlarını App Store Connect'e kullanıcı olarak eklersin, inceleme beklemezsin.
5. **Harici test:** En fazla 10.000 kişi, herkese açık bir bağlantıyla. İlk sürüm için Apple'ın kısa bir beta incelemesi (genelde 1 gün) olur.
6. Arkadaşların "TestFlight" uygulamasını indirip bağlantıya dokunur. Uygulama App Store'da aranmaz, sadece davetlilere görünür.
7. Her yüklenen sürüm 90 gün çalışır, sonra yenisini yüklemen gerekir.

### iPhone: ücretsiz seçenekler
- **Kendi telefonuna kablo ile (ücretsiz Apple Kimliği):** Xcode'dan kurarsın. 7 gün sonra süresi dolar, her hafta yeniden kurman gerekir. Arkadaşların telefonlarını da tek tek bilgisayara bağlaman gerekir. Pratik değil.
- **Web uygulaması (hazır, ücretsiz):** `dist/TarziylaAnlat-web.zip` dosyasının içindekileri herkese açık bir adreste yayınla. Arkadaşların iPhone'da **Safari** ile adresi açıp Paylaş > **Ana Ekrana Ekle** der. Uygulama gibi tam ekran açılır. Hesap ve ücret gerekmez.
  - **Yayınlama (en kolay):** https://app.netlify.com/drop adresine `dist/TarziylaAnlat-web.zip` içindeki klasörü sürükle. Ücretsiz hesap açman istenir. Çıkan adresi arkadaşlarına gönder.
  - **Alternatifler:** GitHub Pages ya da Cloudflare Pages (ikisi de ücretsiz). Alt klasörde yayınlayacaksan `flutter build web --release --base-href /klasor-adi/` ile yeniden derlemek gerekir.
  - **Sınırlar:** İlk açılışta internet gerekir (yaklaşık 7 MB iner, emojiler de internetten gelir). Sonrasında önbelleğe alınır. Haptik titreşim çalışmaz. App Store'da aranmaz.
  - Web sürümünü yeniden derlemek için: `flutter build web --release`
