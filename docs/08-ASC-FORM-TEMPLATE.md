# Ana Karakter — App Store Connect Hazırlık Şablonu

Bu doküman mağaza girişlerinin **taslağıdır**. ASC formlarına girmeden önce
SAHİP okuması gerekir; özellikle yaş derecelendirme ve gizlilik bölümleri
beyan niteliğindedir ve yanlış doldurulursa incelemede geri döner.

Bundle: `com.isiksoft.anakarakter` · Birincil kategori: Games ▸ Simulation ·
İkincil: Games ▸ Role Playing · Birincil dil: Türkçe

---

## 1. Mağaza Metinleri

### Ad ve alt başlık

| Alan | TR | EN | Sınır |
|---|---|---|---|
| Ad | Ana Karakter: Yaşam Simülasyonu | Ana Karakter: Life Sim | 30 |
| Alt başlık | Cesur oyna, jeneriğin aksın | Play bold, roll your credits | 30 |

> Ad 30 karakteri aşıyor (34). Kısaltma önerisi: **"Ana Karakter: Yaşam Sim"**
> (23) ya da **"Ana Karakter"** (12) + alt başlıkta tür belirtmek. SAHİP kararı.

### Tanıtım metni (promotional text, 170)

**TR:** Her gün herkese aynı bebek düşer. Aynı hayat, farklı kararlar — bakalım
senin jeneriğinde hangi roller yazacak?

**EN:** Every day, everyone gets the same baby. Same life, different choices —
which roles will your credits list?

### Açıklama — TR

```
Doğumdan son perdeye kadar bir ömür yaşa. Her tur bir yıl; her yıl birkaç
karar. Okul, iş, aşk, para ve Türkiye'ye özgü hayat anlarıyla dolu bir hikâye
seni bekliyor.

ANA KARAKTER ENERJİSİ
Güvenli seçimler hayatı sıradanlaştırır, cesur seçimler onu bir filme çevirir.
AKE göstergesi ne kadar "başrol" oynadığını söyler — ama tepede kalmak sürekli
cesaret ister. Düşük AKE seni asla cezalandırmaz; yalnız hikâyen sakinleşir.

GÜNÜN HAYATI
Her gün tüm oyunculara aynı bebek ve aynı olay destesi düşer. Fark yalnız
senin kararlarında. Serini büyüt, telafi hakkını biriktir.

JENERİK KARTI
Hayat bittiğinde geriye paylaşılabilir bir jenerik kartı kalır: rol listen,
üç unutulmaz sahnen ve Hayat Puanın. Kare ve story formatında.

JENERİK ARŞİVİ
Biten her hayat duvara bir afiş bırakır. Koleksiyonun büyüdükçe hangi hayatın
en iyisiydi, görebilirsin.

• 300'den fazla elle yazılmış olay
• Her hayat tamamen deterministik — aynı seed, aynı hayat
• Tamamen çevrimdışı; hiçbir veri toplanmaz
• VoiceOver, Dynamic Type, Reduce Motion desteği
• Reklamları Kaldır tek seferlik satın alma

Bir İşıksoft yapımı.
```

### Açıklama — EN

```
Live a whole life, from birth to the final act. Each turn is a year; each year
brings a handful of decisions. School, work, love, money and a story rooted in
Turkish everyday life.

MAIN CHARACTER ENERGY
Safe choices make a life ordinary; bold ones turn it into a film. The MCE meter
shows how much of a lead you are playing — but staying on top takes sustained
courage. Low MCE never punishes you; your story simply gets quieter.

LIFE OF THE DAY
Every day, every player gets the same baby and the same event deck. The only
difference is your decisions. Grow your streak, bank your comeback.

CREDITS CARD
When a life ends, a shareable credits card remains: your role list, three
memorable scenes and your Life Score. Square and story formats.

CREDITS ARCHIVE
Every finished life leaves a poster on the wall.

• 300+ hand-written events
• Fully deterministic — same seed, same life
• Fully offline; no data collected
• VoiceOver, Dynamic Type and Reduce Motion support
• One-time Remove Ads purchase

An İşıksoft production.
```

### Anahtar kelimeler (100 karakter, virgülle)

**TR:** `yaşam,simülasyon,hayat,karar,hikaye,seçim,rol,kader,türkçe,jenerik,ömür`

**EN:** `life,simulation,story,choices,decisions,text,narrative,roleplay,destiny`

> Ad ve alt başlıkta geçen kelimeleri tekrarlama; ASC onları zaten indeksler.
> Rakip marka adı YAZILMAZ (BitLife vb.) — App Store kuralı ihlali.

### URL'ler

| Alan | Değer | Durum |
|---|---|---|
| Destek URL'si | — | **SAHİP dolduracak** (zorunlu) |
| Pazarlama URL'si | — | isteğe bağlı |
| Gizlilik Politikası URL'si | — | **zorunlu** (reklam olduğu için) |

---

## 2. Yaş Derecelendirme Anketi — Hedef 12+

İçerik çizgisi (CLAUDE.md) bu hedefi güvence altına alır. Anket cevapları:

| Soru | Cevap | Gerekçe |
|---|---|---|
| Kâinatsal/gerçekçi şiddet | Yok | Oyunda şiddet yok |
| Cinsel içerik veya çıplaklık | Yok | İçerik çizgisinde yasak |
| Küfür / kaba mizah | Yok | Mizah durumla dalga geçer |
| Alkol, tütün, uyuşturucu kullanımı | Yok | İçerik çizgisinde yasak; ContentLint denetler |
| Simüle kumar | **Yok** | Kumar teşviki yasak; ContentLint yasaklı kelime listesinde |
| Korku / dehşet teması | Yok | — |
| Tıbbi/tedavi bilgisi | Yok | Sağlık olayları kısa ve insaflı, tavsiye içermez |
| Yarışma | Yok | — |
| **Kullanıcı tarafından üretilen içerik** | Yok | Oyuncu metin girmiyor |
| **Sınırsız web erişimi** | Yok | Uygulama içi tarayıcı yok |
| **Reklam** | **Var** | AdMob; ödüllü + jenerik sonrası geçişli |

> Ölüm oyunun bir mekaniği ama **görsel/grafik değil**: "hayat sona erdi" bir
> jenerik akışıyla anlatılır. Bu, şiddet kategorisine girmez.
>
> Beklenen çıktı: **12+**. ASC farklı bir sonuç verirse hangi sorunun
> yükselttiği not edilip içerik çizgisi süzgeciyle karşılaştırılmalıdır.

---

## 3. App Privacy (Gizlilik Beslenme Etiketi)

Kod tarafındaki karşılığı `AnaKarakter/PrivacyInfo.xcprivacy`. ASC formundaki
cevaplar onunla **birebir tutarlı** olmalıdır.

| Soru | Cevap |
|---|---|
| Veri topluyor musunuz? | **Evet** — yalnız üçüncü taraf reklam için |
| Tanımlayıcılar ▸ Cihaz Kimliği | Toplanır · Kimliğe bağlı **değil** · **İzleme için kullanılır** |
| Kullanım Verileri ▸ Reklam Verileri | Toplanır · Kimliğe bağlı **değil** · **İzleme için kullanılır** |
| Diğer tüm kategoriler | Toplanmaz |

Oyunun kendi verisi (hayatlar, arşiv, ayarlar) **yalnız cihazda** durur, ağa
çıkmaz. "Reklamları Kaldır" satın alındıysa Google Mobile Ads SDK'sı hiç
başlatılmaz — o durumda hiçbir veri toplanmaz.

ATT istemi metni (Info.plist `NSUserTrackingUsageDescription`):
> "İzin verirsen gördüğün reklamlar ilgi alanlarına daha yakın olur. Vermezsen
> de oyun aynı şekilde çalışır."

---

## 4. Uygulama İçi Satın Alma

| Alan | Değer |
|---|---|
| Referans adı | Reklamları Kaldır |
| Ürün kimliği | `com.isiksoft.anakarakter.removeads` |
| Tür | **Non-Consumable** |
| Görünen ad (TR) | Reklamları Kaldır |
| Açıklama (TR) | Zorunlu reklamlar kalkar; Şans Tekrarı ve Ekstra Sahne reklamsız açılır. |
| Görünen ad (EN) | Remove Ads |
| Açıklama (EN) | Removes forced ads; Luck Retry and Extra Scene unlock without watching. |

> İnceleme notu olarak eklenmeli: *satın alma sonrası ödüllü içerik reklam
> izlemeden verilir; satın alan oyuncu hiçbir işlevden mahrum kalmaz.*

---

## 5. Ekran Görüntüsü Planı

Zorunlu: 6.9" (iPhone 17 Pro Max sınıfı). Diğer boyutlar bundan türetilir.

| # | Ekran | Vurgu | Mod |
|---|---|---|---|
| 1 | Ana oyun ekranı, karar kartı açık | "Her yıl bir karar" | Aydınlık |
| 2 | Sezon afişi görünürken yıl akışı | "Hayatın altı perdesi" | Aydınlık |
| 3 | Jenerik ekranı (rol listesi + Hayat Puanı) | "Jeneriğin aksın" | Karanlık |
| 4 | Jenerik kartı (kare) tam ekran | "Paylaşılabilir kart" | Karanlık |
| 5 | Jenerik Arşivi afiş duvarı | "Koleksiyonun" | Karanlık |
| 6 | Menü — Günün Hayatı kartı + seri | "Her gün aynı bebek" | Aydınlık |

Kurallar: gerçek oyun içi görüntü kullanılır (mockup çerçevesi yok), metin
okunur büyüklükte, kişisel veri içermez, reklam görünmez.

---

## 6. Sürüm Bilgileri

**Sürüm:** 1.0 · **Build:** 1

Yenilikler (1.0):
> İlk sürüm.

İnceleme notları:
```
Oyun tamamen çevrimdışıdır ve giriş gerektirmez.

Reklamlar: yalnız iki yerde. (1) Ödüllü — oyuncu isteğiyle, "Şans Tekrarı" ve
"Ekstra Sahne". (2) Geçişli — yalnız bir hayat bittikten ve jenerik kartı
kapatıldıktan SONRA, oturumda en fazla bir kez. Banner ve açılış reklamı yoktur.

UMP onay akışı ve ATT istemi, SDK başlatılmadan önce bu sırayla sunulur.

"Reklamları Kaldır" satın alındığında Google Mobile Ads SDK'sı hiç
başlatılmaz ve ödüllü içerik reklamsız verilir.
```

---

## 7. Yayın Öncesi Kontrol Listesi

- [ ] Uygulama adı 30 karaktere indirildi (bkz. §1 notu)
- [ ] Destek URL'si ve Gizlilik Politikası URL'si dolduruldu
- [ ] AdMob konsolunda kullanılmayan 4 birim silindi (banner, açılış, yerel, ödüllü geçişli)
- [ ] IAP ürünü ASC'de `com.isiksoft.anakarakter.removeads` kimliğiyle oluşturuldu
- [ ] Xcode şemasında `AnaKarakter.storekit` StoreKit Configuration olarak seçildi (yerel test)
- [ ] `PrivacyInfo.xcprivacy` ile ASC gizlilik cevapları karşılaştırıldı
- [ ] Erişilebilirlik denetimi yeşil (`performAccessibilityAudit`)
- [ ] VoiceOver ile uçtan uca bir ömür oynandı
- [ ] Release derlemesi 0 error / 0 warning
- [ ] Ekran görüntüleri 6 adet, gerçek oyun içi

---

## Karar Günlüğü

- 2026-08-03 — Mağaza adı 30 karakteri aşıyor; kısaltma SAHİP kararına bırakıldı.
- 2026-08-03 — Anahtar kelimelerde rakip marka adı kullanılmayacak (App Store kuralı).
- 2026-08-03 — Ekran görüntülerinde reklam gösterilmeyecek: reklam ürünün vaadi değil, finansmanı.
- 2026-08-04 — 6.9" seti 5 görüntüyle yüklendi (01, 02, 03, 05, 06). **4 numara
  (jenerik kartı tam ekran) çekilemedi:** `CreditsCardView` yalnız
  `ShareCardRenderer` içinde ekran dışı üretiliyor, uygulamada tam ekran
  gösterimi YOK. Tek yol Quick Look önizlemesi ve orada sistem başlığı
  (`.com.apple.Foundation.NSItem…`) ile işaretleme çubuğu görünüyor. Kartı
  tuvale yapıştırmak "gerçek oyun içi görüntü, mockup yok" kuralını çiğnerdi.
  Açık iş: oyuncu kartını paylaşmadan göremiyor — tam ekran kart önizlemesi
  eklenince 4 numara da çekilir.
- 2026-08-04 — Mağaza görüntüleri 01/02 Release, 03/05 Debug derlemesiyle çekilir:
  Debug'daki geçici ⏩ kısayolu araç çubuğunda görünüyor ve yıl akışı
  ekranlarına giriyor. Hepsi `--uitest-clean` ile (reklamsız ikiz).
