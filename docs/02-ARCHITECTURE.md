# Ana Karakter — Mimari

## Katmanlar

```
App/            IsikApp benzeri giriş: AnaKarakterApp, AppDependencies (composition root), RootView
Features/       Menu, Life (yıl akışı), Decision, Credits (jenerik), Archive (Jenerik Arşivi), Daily, Settings
Core/           DesignSystem (token'lar, tipografi, sezon paletleri), Navigation (Route + Router)
Services/       Ads/ (AdsController + AdPolicy), HapticService, AudioService, ShareCardRenderer, SettingsStore
Persistence/    SwiftData modelleri, SchemaV1 + migration plan, repository'ler (+ InMemory ikizleri)
Packages/
  AnaKarakterKit/   saf Swift domain — aşağıda
Content/        EventCatalog dosyaları (tip güvenli Swift katalogları)
```

Kural seti CLAUDE.md'dekiyle aynıdır: Feature First + MVVM + Repository + constructor DI; View'da `@Query` yasak; Observation; Router.

## AnaKarakterKit (saf Swift — UI importu yasak)

Modül: `LifeDomain`

- **Tipler:** `Person` (isim, doğum yılı, aile, mahalle — seed'den üretilir), `StatBlock` (sağlık/mutluluk/zekâ/sosyal 0–100 clamp + para + AKE), `Season` (6 sezon + yaş bantları), `LifeFlag` (bayrak seti), `LifeState` (tam oyun durumu — Codable snapshot).
- **EventCatalog tipleri:** `LifeEvent` (koşullar + ağırlık + metin anahtarı + seçenekler), `Choice` (sonuç dağılımı + etkiler + bayrak + takip), `Condition` (stat eşiği / bayrak / para / sezon), `Effect` (stat delta / bayrak / para / AKE).
- **LifeEngine:** `advanceYear(state, decisions) -> YearResult` — saf fonksiyon zinciri; omurga kilometre taşları + seed'li havuz çekilişi; takip olayı kuyruğu.
- **EventDeck:** koşul süzgeci + ağırlıklı seed'li çekiliş; aynı olayın tekrarını soğuma kuralıyla engeller.
- **OutcomeRoller:** seçenek sonuç dağılımını seed'li zarla çözer; "cesur seçim = nötr beklenen değer, yüksek varyans" dengesi burada test edilir.
- **PersonGenerator / DeathModel:** seed'li karakter üretimi; yaş+sağlık+olay tabanlı ölüm olasılığı (aktüeryal eğri, testli bant: ortalama ömür 70–85).
- **LifeScore:** Hayat Puanı formülü — şeffaf, saf, testli.
- **DailyLifeSelector:** (tarih, seed) → aynı bebek + aynı deste (Köken `DailyRootSelector` deseni; takvim enjekte).
- **CreditsComposer:** `LifeState` → jenerik kartı veri modeli (rol listesi, 3 sahne seçimi, özet). Render UI katmanında.
- **SeededRandomSource:** BlockForge/Köken'deki desen birebir taşınır.

## İçerik Hattı

- Olaylar `Content/` altında tip güvenli Swift katalog dosyaları (derleyici denetimli; dış dosya formatı YOK — BlockForge parça kataloğu deseni). Metinler String Catalog anahtarına işaret eder (yerelleştirilebilir şema).
- **ContentLint (test hedefi):** şema doğrulama (koşulsuz ulaşılmaz olay yok, boş seçenek yok), kapsama (her sezonda yeterli havuz), içerik çizgisi denetimi (yasaklı tema/kelime listesi CLAUDE.md İçerik Çizgisi'nden türetilir), yazım kuralları (uzunluk sınırları).
- Üretim akışı: taslak (Claude) → lint → SAHİP okuma turu (hassas omurga olayları) → katalog commit'i.

## Determinizm Sözleşmesi

- Girdi: `(personSeed, deckSeed, [kararlar])` → Çıktı: bit-bit aynı `LifeState`. Test kapısı bunu doğrular.
- Tarih/saat ve rastgelelik yalnız enjekte kaynaklardan; `Date()` yasağı CLAUDE.md'de.
- Bu sözleşme Günün Hayatı'nın adaletinin ve replay/paylaşım doğruluğunun temelidir.

## Persistence (SwiftData — SchemaV1 ilk günden)

- `LifeRecordModel` — biten hayatlar: seed'ler, karar özeti, jenerik verisi (görsel DEĞİL, veri — kart yeniden çizilebilir), Hayat Puanı.
- `DailyRunModel` — günün hayatı sonucu + tarih; `StreakModel` — seri + telafi hakkı (Köken kuralı).
- `SettingsModel` — ses/haptik/tema tercihleri.
- Tümü protocol repository arkasında; ViewModel testleri InMemory ikizleriyle.

## Reklam Mimarisi (Faz 4)

- BlockForge `AdPolicy` birebir port: saf, testli, enjekte saat; oturum ≤1 geçiş, ≥3 dk aralık, yalnız jenerik kapanışı sonrası.
- Ödüllü yerleşimler: `Şans Tekrarı` (hayat başına 1; ölüm sonucuna uygulanamaz), `Ekstra Sahne` (AKE sahnesi).
- Sıra: UMP (ConsentInformation → gerekliyse form) → ATT istemi → `MobileAds.shared.start` — reklam yüklemeden ÖNCE.
- Debug'da Google test kimlikleri; gerçek kimlikler yalnız Release. `--uitest-clean` bayrağıyla reklamsız test koşusu (Köken deseni).
- AdMob konsolunda uygulama + birimler Faz 4'te açılır; kimlikler bu dokümana işlenir.

## Paylaşım Kartı

- `CreditsComposer` verisi → SwiftUI görünümü → `ImageRenderer` → `ShareLink` (kare + story varyantı).
- Kart üretimi anlıktır, ağ yok; görsel diske kaydedilmez (istenirse sistem paylaşımından).

## Test Stratejisi

- **Swift Testing (AnaKarakterKit):**
  - 10.000 seed'li ömür simülasyonu: çıkmaz hayat yok (her hayat ölümle biter), stat clamp ihlali yok, koşulsuz olay tetiklenmez, ölüm yaşı dağılımı bantta.
  - Determinizm: aynı girdi → aynı `LifeState` (hash karşılaştırma).
  - Erişilebilirlik-öncesi denge: cesur/güvenli seçim beklenen değer testleri; AKE asla cezaya dönüşmez.
  - Kapsama: her olay en az bir simüle hayatta tetiklenebilir (reachability).
  - `LifeScore`, `DeathModel`, `DailyLifeSelector` birim testleri.
- **ContentLint** ayrı test hedefi (içerik değişince koşar).
- **XCTest:** UI akışları + `performAccessibilityAudit` (Köken deseni) + yıl geçişi performansı (< 5 ms hedef, ölçüm Faz 1'de).

## Karar Günlüğü

- 2026-08-01 — Olay içeriği dış dosya (JSON) değil tip güvenli Swift katalog: derleyici + lint çift denetim, modding MVP hedefi değil.
- 2026-08-01 — Jenerik kartında görsel değil VERİ saklanır; kart her açılışta yeniden çizilir (tema değişse bile arşiv tutarlı).
- 2026-08-01 — Para basit sayaç (₺, Int); yatırım/portföy sistemleri MVP dışı.
- 2026-08-01 — App target'ında `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` (Xcode 26 şablon varsayılanı): UI katmanı doğal olarak MainActor; `AnaKarakterKit` standart (nonisolated) izolasyonda kalır — domain saflığı ve Sendable disiplini paket sınırında korunur.
- 2026-08-01 — `AnaKarakterKit` platformlarına macOS eklendi: `swift test` paket kökünde Xcode'suz koşabilsin diye (Build Kalite Kapısı gereği). iOS 17 birincil hedef olmaya devam eder.
