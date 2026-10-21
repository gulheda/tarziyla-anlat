// Oyunun espri dozunu taşıyan metinler.
// `{n}` anlatıcının, `{g}` bilenin, `{d}` anlatıcının adıyla değişir.

const List<String> avatars = ['🦄', '🐸', '🦊', '🐙', '🐧', '🦖', '🐼', '🐯'];

const List<String> playerNicknames = [
  'Kaptan',
  'Şef',
  'Profesör',
  'Sultan',
  'Maestro',
  'Efsane',
  'Komutan',
  'Dahi',
];

const List<String> teamNicknames = [
  'Kaplanlar',
  'Şahinler',
  'Hamsiler',
  'Bukalemunlar',
  'Panterler',
  'Kartallar',
  'Yunuslar',
  'Ejderler',
];

const List<String> taglines = [
  'Kelimeyi çek, tarzı çek, rezil ol!',
  'Bilen bilir, bilmeyen güler.',
  'Sahne senin, utanç bizim.',
  'Arkadaşlıkları sınayan oyun.',
  'Anlatması kolay, anlatmaması zor.',
  'Ana karakter sensin, kamera hazır.',
  'Rizz seviyeni bu gece ölçüyoruz.',
  'Aura puanı yarışması başlasın.',
  'Bugün kim cringe, kim slay?',
  'Gündem değişir, rezil olmak kalır.',
  'Quote tweet değil, tarz atıyoruz.',
  'Odak süren sekiz saniyeyse bu oyun tam sana göre.',
];

const List<String> handoverLines = [
  'Sahne senin, {n}! Rezil olmaya hazır mısın?',
  'Sıra {n}\'de. Herkes nefesini tutsun.',
  '{n}, bugün Oscar için sahnedesin.',
  'Telefonu {n}\'e uzatın. Ama yavaş, kıpırdamadan.',
  '{n} sahneye! Alkışlar... ya da gülüşmeler.',
  'Dikkat, {n} konuşacak. Ciddiyetinizi koruyun.',
  '{n}, ana karakter enerjisi şimdi!',
  'Aura puanı sıfırlandı. {n}, sıra sende.',
  'Kameralar {n}\'de, herkes sessiz olsun.',
  '{n} sahnede. Notlar alınıyor, aura ölçülüyor.',
  'Tarih dersi başladı: sıra {n}\'de.',
  'Kanıt sunuldu: sahne {n}\'in.',
  '{n}, bugünün gündemi sensin.',
];

const List<String> readyLines = [
  'Kartları kimseye gösterme. Sır küpü ol.',
  'Süre başlayınca geri dönüş yok. Utanmak serbest.',
  'Derin bir nefes al. Utancı sonra düşünürsün.',
  'Mimikler, sesler, jestler... hepsi serbest. Kelimeyi söylemek hariç.',
  'Seyirci hazır, sahne hazır. Gerisi sende.',
  'Cringe olmaktan korkma, zaten herkes kayıtta.',
  'Vibe\'ını yakala, gerisi gelir.',
  'Aklında tut: en komik olan kazanır.',
  'Gündemi takip et ama bu turda sahne senin.',
  'Nedenini bilen yok ama sen yine de dene.',
];

const List<String> verdictsZero = [
  'Sıfır mı? Seyirci bile üzüldü.',
  'Hiç bildirmedin. Belki de kelimeler seni anlamadı.',
  'Sessiz sinema bile bundan iyiydi.',
  'Aura eksiye düştü. Toparlanma vakti.',
  'NPC modu aktif. Yeniden başlatın.',
];

const List<String> verdictsLow = [
  'İdare eder. Annen yine de gurur duydu.',
  'Fena değil, bir sonraki turda konuşuruz.',
  'Isınma turu sayalım.',
  'Fena değil ama viral olmaz.',
  'Ortalama, ama sevimli.',
  'Yılbaşı hedefleri gibi: iyi niyetli.',
  'Gündem olmadı ama emek var.',
];

const List<String> verdictsMid = [
  'İyi iş! Sahneye çıkabilirsin.',
  'Dikkat, yetenek fark ediliyor.',
  'Takım arkadaşların seni tanıyor, kıskanmıyor.',
  'Rizz seviyesi yükseliyor.',
  'Ana karakter vibe\'ı fark edildi.',
];

const List<String> verdictsHigh = [
  'Efsane! Oscar\'ı hazırlayın.',
  'Bu hız normal değil. Kontrole gelin.',
  'Dahilik sınırlarında dolaşıyorsun.',
  'Aura puanın tavan yaptı.',
  'Bu sahne viral olurdu.',
  'Slay! Alkışlar sana.',
  'Ratio yemedin, ratio yedirdin.',
  'Bu tur gündem sensin.',
];

const List<String> guessedLines = [
  '{g} çözdü! {g} ve {d} birer puan aldı. Telepati mi bu?',
  '{g} bildi! İkiniz de birer puan aldınız. Ne uyum ama.',
  'Aferin {g}! Aferin {d}! Birer puan sizin.',
  '{g} ve {d} resmen aynı frekansta. Slay!',
  '{d} anlattı, {g} çözdü. Aura puanı ikiye katlandı.',
];

const List<String> nobodyLines = [
  'Kimse bilemedi. Ya anlatan, ya dinleyenler... ikisi de olabilir.',
  'Bu kez kimse çözemedi. Utanç ortak.',
  'Sıfır puan. Ama emeğe saygı duyduk.',
  'Kimse çözemedi. Herkes NPC modunda.',
  'Beyin çürümesi mi, yoksa zor kart mı? Belli değil.',
];

const List<String> winnerLines = [
  'Tiyatro dünyasının yeni yıldızı!',
  'Mimikleriyle herkesi ezdi geçti.',
  'Bugünün sahne kralı/kraliçesi!',
  'Anlatması bir yetenek, onda var.',
  'Aura puanı sınırsız. Şampiyon belli.',
  'Ana karakter bugün o. Sırtını sıvazlayın.',
  'Rizz Kralı/Kraliçesi ilan edildi.',
];

const List<String> loserLines = [
  '{n}: Sahne Korkusu Ödülü senin. Yine bekleriz.',
  '{n}, "Sessiz Sinema" ödülünü alıyor. Sonraki sefere!',
  '{n} sonuncu ama kahkahalar bedava.',
  '{n} NPC ödülünü aldı. Bir dahaki sefere slay!',
  '{n}, "Aura Eksi" ödülünü kazandı. Yeniden denesin.',
];
