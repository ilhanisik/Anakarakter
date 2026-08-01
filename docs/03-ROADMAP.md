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

## Karar Günlüğü

- 2026-08-01 — MVP içerik hedefi 300 olay (500 değil): kalite + takip zincirleri > ham hacim; Günün Hayatı ritüeli hacim açığını kapatır.
- 2026-08-01 — Karakter düzenleme MVP dışı: seed bütünlüğü (Günün Hayatı adaleti) ve kapsam disiplini.
