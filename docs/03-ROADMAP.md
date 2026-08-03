# Ana Karakter — Yol Haritası (MVP Fazları 0–5)

Kural: bir fazın kabul kriterleri tamamlanmadan ve SAHİP onayı alınmadan sonraki faza geçilmez (CLAUDE.md).

## Faz 0 — Proje İskeleti

- Klasör yapısı (02-ARCHITECTURE), filesystem-synchronized `pbxproj` (BlockForge deseni; XcodeGen yok), `AnaKarakterKit` boş paket + ilk test, `Content/` iskeleti, `.gitignore`, git init.
- Kabul: build 0 error / 0 warning; `swift test` paket kökünde yeşil; domain saflık grep'i boş.

## Faz 1 — LifeDomain Çekirdeği

- Tipler, `LifeEngine`, `EventDeck` (soğuma kuralı dahil), `OutcomeRoller`, `PersonGenerator`, `DeathModel`, `LifeScore`, `DailyLifeSelector`, `CreditsComposer`, `SeededRandomSource` portu.
- Çekirdek içerik: 6 sezonun omurga kilometre taşları + ~60 olay (lint'li).
- 10.000 hayat simülasyon kapısı + determinizm testi + denge testleri; toplam ≥ 40 test. Yıl geçişi performans ölçümü.
- Kabul: tüm testler paket kökünde yeşil; ölüm yaşı dağılımı 70–85 bandında; kapsama testi yeşil (ulaşılmaz olay yok).

## Faz 2 — Oynanabilir Dikey Dilim

- Yıl akışı ekranı (zaman şeridi), karar kartları, stat panosu, AKE göstergesi, ölüm + basit özet ekranı; "bir hayat daha" döngüsü.
- İçerik ~150 olaya çıkar; ilk hassas-omurga okuma turu SAHİP'e sunulur.
- Kabul: uçtan uca bir ömür oynanıyor; Dynamic Type büyük boyut kontrolü; VoiceOver iskeleti (olay → seçenek → sonuç doğal sırada okunuyor).

## Faz 3 — His Katmanı + Kimlik

- Tipografi sistemi ve sezon paletleri (token disiplini), sezon posterleri (jeneratif kapaklar), jenerik akışı + jenerik kartı (`ImageRenderer`), haptik seti, hafif ses (sentez), Reduce Motion alternatifleri.
- Kabul: his turu raporu; Reduce Motion'da tam işlev; ölçülebilir jank yok; jenerik kartı iki formatta üretiliyor.

## Faz 4 — Kalıcılık + Modlar + Monetizasyon

- SwiftData SchemaV1 + repository'ler; Jenerik Arşivi (biten hayatlar koleksiyonu); Günün Hayatı + seri/telafi + paylaşım; ayarlar.
- AdMob: SPM, UMP + ATT sırası, `AdPolicy` port + testleri, ödüllü 2 yerleşim (Şans Tekrarı, Ekstra Sahne) + jenerik sonrası geçiş; "Reklamları Kaldır" IAP (StoreKit 2); `--uitest-clean`.
- İçerik ~300 olaya çıkar; ContentLint tam kapsam.
- Kabul: akışlar tam; `AdPolicy` testleri yeşil; IAP'lı reklamsız akış doğrulanmış; Günün Hayatı determinizmi cihazlar arası aynı (seed testi).

## Faz 5 — Cila + Erişilebilirlik + Mağaza Hazırlığı

- VoiceOver ile uçtan uca bir ömür (kabul kriteri!), Dynamic Type en büyük boyut turu, TR/EN arayüz String Catalog, app icon, `PrivacyInfo.xcprivacy`, `ITSAppUsesNonExemptEncryption = NO`, ekran görüntüleri, yaş derecelendirme anketi (12+ hedef), ASC girişleri — Köken `docs/08-ASC-FORM-TEMPLATE.md` şablonu yeniden kullanılır (bundle: `com.isiksoft.anakarakter`).
- Kabul: `performAccessibilityAudit` yeşil (ana ekranlar); Ekran Kalite Kapısı tüm ekranlarda; Release 0/0; mağaza paketi hazır.

## MVP Sonrası Adaylar (04-EXCELLENCE'a taşınır)

"Miras" modu (çocuğunla devam), karakter düzenleme, temalı hayat paketleri, sezon posteri kozmetik IAP'ları, EN içerik seti kararı, widget (Günün Hayatı durumu), App Intents ("Günün Hayatını başlat"), iPad düzeni.

## Riskler

| Risk | Etki | Önlem |
|---|---|---|
| İçerik hacmi (300 olay yazımı) | takvim | Claude içerik hattı + ContentLint; omurga önce, havuz sonra; sayı değil kalite kapısı |
| Ton/hassasiyet (askerlik, sağlık, para) | marka + App Review | İçerik Çizgisi bağlayıcı; hassas olaylarda SAHİP okuma turu (Faz 2 ve 4'te) |
| "BitLife klonu" algısı | keşif/basın | AKE + Günün Hayatı + jenerik estetiği = üç görünür fark; mağaza metni bu üçünü öne koyar |
| Tekrar oynanabilirlik erken tükenir | elde tutma | Takip zincirleri + sezon posterleri + Günün Hayatı ritüeli; 10k simülasyonda çeşitlilik metriği izlenir |
| Metin oyununda reklam dengesi | gelir/his | Geçiş yalnız jenerik sonrası (tek nokta); ödüllüler gerçek değer anlarında |
| Yaş derecelendirmesi beklenenden yüksek çıkar | kitle | 12+ hedefi içerik çizgisiyle güvence altında; şüpheli olay çizgi süzgecinde elenir |

## Faz 3 — His Turu Raporu (2026-08-03)

Cihaz turu: iPhone 17 simülatörü, iOS 26, uçtan uca iki tam ömür (Onur 1990–2064 / Hakan 1995–2056).

Doğrulanan kabul kriterleri:

- **Jenerik kartı iki formatta üretiliyor** — kare (1080×1080) ve story (1080×1920) `ImageRenderer` ile anlık üretiliyor, `ShareLink` üzerinden sistem paylaşım sayfasına düşüyor; kart Quick Look'ta tam boy doğrulandı (serif jenerik estetiği, siyah tuval, rol listesi + statlar + Hayat Puanı).
- **Reduce Motion'da tam işlev** — sistem ayarı açıkken jenerik sahne akışı çalışmıyor, tüm bölümler anında görünüyor, "Geç" düğmesi hiç belirmiyor; zaman şeridi kaydırması animasyonsuz yapılıyor. İşlev kaybı yok.
- **Ölçülebilir jank yok** — yıl geçişi, sezon posteri girişi ve jenerik açılışında gözle görülür takılma yok; domain tarafında yıl geçişi ortalaması < 5 ms (paket testi).
- **Sezon paletleri + posterler** — altı sezonun rengi zaman şeridi başlıklarında ve jeneratif posterlerde tutarlı; poster varyasyonu seed'li.

Bu turda bulunan ve düzeltilen kusur:

- Jenerik ekranındaki "Kare Kart / Story Kart" düğmeleri erişilebilirlik metin boyutlarında yan yana kalıp etiketleri harf harf kırıyordu (Ekran Kalite Kapısı ihlali). `AnyLayout` ile erişilebilirlik boyutlarında dikey yerleşime geçirildi; en büyük boyutta doğrulandı.

SAHİP kararıyla (2026-08-03) Faz 3 kapanmadan çözülen iki madde:

**1. Yaş granülerliği — çözüldü.** `Condition` tipine `.minAge` / `.maxAge` eklendi; içerik DSL'i `from:` / `to:` parametreleriyle bandı beyan ediyor. Sezon artık tek yaş kapısı değil. 40 olaya bant verildi (Çocukluk/Okul ağırlıklı), yaş 0–2 havuzu incelmesin diye dört bebeklik olayı yazıldı, "Okul dönüşü bir yavru kedi" metni çocukluk sezonuna uygun şekilde düzeltildi, "çocuğun okula başladı" olayı havuzdan çıkarılıp `kurulus.cocuk` sonucuna 6 yıl gecikmeli zincire bağlandı (bebek doğduğu yıl okula başlayamaz). Yeni ContentLint kapıları: bant geçerliliği + sezonla kesişme, geniş sezonlarda bant beyanı zorunluluğu, **her yaş için havuz kapsaması** (0–90 arası her yaşta ≥ 4 uygun olay — yıl boşalması imkânsız) ve his turunda görülen somut kusurlar için regresyon testi.

**2. AKE doyumu — çözüldü.** Yeni `AKEModel`: cesaret bonusu kalan başlıkla ölçekleniyor (azalan verim), tamsayı aritmetiğiyle — determinizm sözleşmesi korunuyor. Kazanç asla eksiye dönmez ("AKE ceza aracı değildir"), güvenli seçimin bedeli sabit kalır. Jenerik sahne seçimi ham `sceneWeight` üzerinden çalıştığı için eğriden etkilenmiyor.

600 seed'lik ölçüm — AKE zirvesi artık oyun tarzını ayırt ediyor:

| Oyun tarzı | p10 | ortanca | p90 | en yüksek |
|---|---|---|---|---|
| Hep güvenli | 50 | 50 | 50 | 50 |
| Rastgele | 50 | 54 | 61 | 71 |
| Hep cesur | 78 | 79 | 80 | 82 |

Önceki modelde her tarz 8 yaşında 100'e yapışıyordu. Yan etki: yüksek AKE ile açılan "SAHNE SENİN" olaylarına artık yazı-tura atan oyuncu ulaşamıyor — bu beklenen ve istenen davranış, kapsama kapısı bu yüzden rastgele + hep cesur + hep güvenli tarzlarının birleşimine bakacak şekilde güncellendi (10.000 + 2×1.000 ömür).

Faz 4 içerik turuna devredilen açık maddeler:

3. **Temel statlar tavanda.** Sağlık/Mutluluk/Sosyal ~40 yaşından sonra 100'de sabitleniyor; kararların sonucu görünmez oluyor. Denge turu Faz 4 içerik genişlemesiyle birlikte yapılmalı.
4. **Tekrarlı olayların metni.** `cd: .years(4)` ile tasarım gereği tekrarlanan olaylar ("Üst kata **yeni** komşu taşındı", "Evde zeytinyağlı dönemi **başladı**") üçüncü kez okununca kendini yalanlıyor. Motor doğru çalışıyor; metinler tekrar edilebilir şekilde yeniden yazılmalı.

Süreç notu: uçtan uca bir ömür elle ~120 dokunuş sürüyor — denge ve içerik doğrulaması için pahalı ve güvenilmez bir yol. Ölçüm paket testlerine taşındı (10.000 ömür ~45 sn). Faz 5'te bir ömrü baştan sona oynayan XCTest UI testi yalnızca *arayüz* akışı için yazılacak.

## Karar Günlüğü

- 2026-08-01 — MVP içerik hedefi 300 olay (500 değil): kalite + takip zincirleri > ham hacim; Günün Hayatı ritüeli hacim açığını kapatır.
- 2026-08-01 — Karakter düzenleme MVP dışı: seed bütünlüğü (Günün Hayatı adaleti) ve kapsam disiplini.
- 2026-08-03 — Dışa aktarım kartı (`CreditsCardView`) Dynamic Type'tan muaf, sabit puntoludur: ekran değil üretilen görseldir; erişilebilir sürüm ekrandaki jenerik özetidir.
- 2026-08-03 — (SAHİP kararı) Yaş koşulu ve AKE ölçeklemesi Faz 4'e ertelenmedi, Faz 3 kapanmadan çözüldü: ikisi de "his" katmanının kendisi — yanlış yaşta çekilen olay ve doymuş gösterge, cila değil kusurdur.
- 2026-08-03 — AKE eğrisi azalan verimlidir (`AKEModel`), sezona göre ölçeklenmez: tek bir saf kural hem çocuklukta zirveyi engelliyor hem zirveyi korumayı sürekli cesarete bağlıyor; sezon katsayısı aynı sonucu daha çok ayarlanabilir sabitle alırdı.
- 2026-08-03 — Kapsama kapısı tek bir oyun tarzına değil tarz birleşimine bakar: yüksek AKE ile açılan içeriğe rastgele karar veren oyuncunun ulaşamaması kusur değil tasarımdır.
- 2026-08-03 — Denge ve içerik doğrulaması elle simülatör turuyla değil paket testleriyle yapılır; simülatör yalnız görsel/erişilebilirlik doğrulaması içindir.
- 2026-08-03 — (Faz 4) İçerik 147 → **300 olay**. Yeni dosyalar sezon başına `…EventsC` + sezonlar arası ortak `SliceOfLifeEvents`. Yeni olayların çoğu yaş bandı beyan eder; ContentLint hacim eşiği 140 → 295'e çekildi.
- 2026-08-03 — (Faz 4) "Hayat dokusu" olayları (elektrik kesintisi, pazar günü, semt kedisi) bilinçli olarak çok sezonlu: omurga olayların arasını doldurup çeşitlilik metriğini besliyor, tek bir sezona bağlanmıyor.
- 2026-08-03 — (Faz 4) AdMob'da açılan 6 birimden yalnız 2'si bağlandı (geçişli + ödüllü). **Banner, uygulama açılışı, yerel gelişmiş ve ödüllü geçişli KULLANILMAYACAK**: ilki CLAUDE.md'de açıkça yasak, diğerleri onaylı yerleşim setinin dışında ve "zorunlu reklam yalnız jenerik sonrası" kuralını deler. Kullanılmayan birimler AdMob konsolundan silinmelidir (boş birim envanter raporunu kirletir).
- 2026-08-03 — (Faz 4) Tasarım brief'indeki **"Enerji" statı MVP'ye alınmadı**: 5 stat (Sağlık, Mutluluk, Zekâ, Sosyal, AKE) 300 olayın denge tablosunun temeli; altıncı stat tüm kataloğu ve 10.000 hayat kapısını yeniden dengelemeyi gerektirir. Yeniden değerlendirme yeri: 04-EXCELLENCE.
- 2026-08-03 — (Faz 4) Brief'teki **Kariyer/Eğitim/İlişkiler/Aile/Evler/Arabalar/Banka/Yatırımlar ekranları MVP'ye alınmadı**: bunlar ekran değil oyun sistemidir ve "para basit sayaç; yatırım/portföy MVP dışı" kararıyla (docs/02) çelişir. Ayrıca bu sistemler oyunu tam da kaçınılmak istenen "BitLife klonu" konumuna taşır; farkımız AKE + Günün Hayatı + jenerik kartıdır.
- 2026-08-03 — (Faz 4) Kartlarda **illüstrasyon/karakter görseli kullanılmayacak**: oyun metin-öncelikli (CLAUDE.md). İllüstrasyonun yerini sezon motifi + sezon rengi alır; çizim hattı açmak MVP kapsamını ve maliyetini kökten değiştirir.
- 2026-08-03 — (Faz 4, SAHİP kararı) Arayüzde **bölünmüş sanat yönü**: oynanış yüzeyleri (menü, oyun ekranı, ayarlar) pastel/aydınlık ve floating kart dilinde; jenerik kartı, sezon afişleri ve arşiv duvarı koyu/sinematik kalır. Kural: *yaşarken aydınlık, hatırlarken karanlık.* Tipografi (serif marka başlıkları) ikisinde ortaktır.
