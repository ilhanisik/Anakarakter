# Ana Karakter — Oyun Tasarım Dokümanı (GDD)

## Vizyon

Tek cümle: **"Bir hayat seç, cesur oyna, jenerik aktığında adın büyük yazsın."**

BitLife formülünün (yıl yıl yaşanan, seçim tabanlı hayat simülasyonu) Türkçe hayatı henüz hakkıyla yapılmadı: talep ölçülebilir (TikTok'ta "BitLife Türkçe" aramaları), mevcut TR denemeleri sığ ve özensiz. Ana Karakter bu boşluğu İşıksoft ilkeleriyle doldurur: **adil** (karanlık desen yok, kanıtlı-dengeli sistemler), **ince mizahlı** (durumla güler, insanla değil), **premium his** (dizi/film estetiği, tipografi disiplini).

Marka tezi: Gen Z'nin "ana karakter enerjisi" dili oyunun hem adı hem çekirdek mekaniğidir — sıradan yaşarsan figüransın, cesur yaşarsan filmin ana karakterisin.

## Çekirdek Döngü

**Yıl geç → olaylar gel → karar ver → statlar ve hikâye değişsin → sezonlar ilerlesin → jenerik aksın → yeni hayat.**

- Bir tur = bir yıl. Yılda 2–4 olay: kimi haber (karar yok), kimi 2–4 seçenekli karar kartı.
- Kararlar anlık çözülür; sonuç metni kısa ve vurucu. Deneme cezasız, bekleme/enerji duvarı YOK.
- Ölüm: yaş + sağlık + olay kaynaklı; geldiğinde dramatik değil sinematik — jenerik akar.
- Bir ömür ~10–20 dakika (hızlı yıl geçişiyle daha kısa). "Bir hayat daha" düğmesi döngünün kalbidir.

## İstatistikler

| Stat | Aralık | Not |
|---|---|---|
| Sağlık | 0–100 | 0 = ölüm riski; yaşla doğal erozyon |
| Mutluluk | 0–100 | Düşük kalıcı mutluluk olayları tetikler |
| Zekâ | 0–100 | Okul/kariyer kapılarını açar |
| Sosyal | 0–100 | İlişki/çevre olaylarını açar |
| Para | ₺ sayaç | Gelir/gider yıllık işler; enflasyon olayları dokunur |
| **AKE** | 0–100 | Ana Karakter Enerjisi — marka metresi (aşağıda) |

## Ana Karakter Enerjisi (AKE) — imza mekanik

- Güvenli/pasif seçimler AKE düşürür; cesur, riskli, "sahneli" seçimler yükseltir.
- AKE eşikleri **Sahne** olayları açar: hayatına özel, yüksek riskli-yüksek ödüllü set parçaları ("sahne senin").
- AKE asla ceza aracı değildir: düşük AKE sadece sıradan bir hayat demektir — bu da geçerli bir oyun tarzıdır (jenerikte "mütevazı efsane" onuru).
- Denge kuralı (bağlayıcı): cesur seçim beklenen değerde nötr, varyansta yüksektir — oyuncu kumar değil karakter seçer.

## Yaş Dönemleri ("Sezonlar" — dizi diliyle)

| Sezon | Yaş | Omurga olayları |
|---|---|---|
| Çocukluk | 0–5 | aile, mahalle, ilk kıvılcım |
| Okul | 6–17 | LGS, lise tercihi, harçlık, ilk arkadaşlıklar |
| Yol Ayrımı | 18–24 | ÖSYM, üniversite/çalışma, askerlik, ilk aşk |
| Kuruluş | 25–39 | kariyer, kira/ev, evlilik/düğün altını, çocuk |
| Orta Sahne | 40–64 | zirve/kriz, sağlık uyarıları, ebeveynlik tersine döner |
| Final Sezonu | 65+ | emeklilik, torunlar, miras, jenerik hazırlığı |

Her sezon açılışında **sezon posteri** (o hayatın o dönemine özel jeneratif kapak) — koleksiyon değeri + paylaşım anı.

## Olay Sistemi

- Olay = `id + sezon/yaş bandı + koşullar (stat eşiği, bayrak, para) + ağırlık + metin + seçenekler`.
- Seçenek = `metin + sonuç dağılımı (olasılıklı) + stat etkileri + bayrak set/clear + takip olayı`.
- Deste: omurga kilometre taşları (ÖSYM gibi) garantili; kalan slotlar koşullu havuzdan seed'li çekilir.
- Takip zincirleri hikâye sürekliliği verir (ör. "kanka" bayrağı 40 yıl sonra düğünde geri döner).
- MVP içerik hedefi: **~300 olay + 40 meslek + isim/mahalle havuzları** (docs/03 faz planı).
- TR omurgası örnekleri: karne günü, LGS/ÖSYM, KYK yurdu, askerlik yemin günü, kira zammı, düğün takı listesi, bayram ziyareti, emekli maaşı zammı, komşuluk.

## Modlar

1. **Serbest Hayat** — rastgele seed; istediğin kadar hayat.
2. **Günün Hayatı** — tarih-seed'li: herkes aynı bebekle, aynı desteyle başlar; günde tek deneme; sonuç **Hayat Puanı** ile karşılaştırılabilir. Seri + 7 günde bir telafi (Köken kuralı). Türün günlük-ritüel boşluğu burada kapanır — BitLife klonlarının hiçbirinde yok.
3. (MVP sonrası adayları: "Miras" — çocuğunla devam; temalı hayat paketleri.)

**Hayat Puanı** = yaş + stat dengesi + AKE zirvesi + başarımlar; formül saf domain'de, testli ve şeffaf (ayrıntı: 02-ARCHITECTURE).

## Jenerik Kartı — paylaşım mekaniği

Hayat bitince film jeneriği akar ve tek görsele damıtılır:

- "Bir İşıksoft yapımı — **AYŞE (1990–2074)**"
- Rol listesi: meslekler + hayat rolleri ("3 çocuk annesi", "mahallenin avukatı")
- 3 unutulmaz sahne (AKE zirveleri) + stat özeti + Hayat Puanı
- Günün Hayatı'nda ek satır: "Günün Hayatı #12 · 🔥 seri 8"

Format: kare 1080×1080 + story 1080×1920; `ImageRenderer` + `ShareLink`. Emoji satırı (kopyalanabilir metin) Wordle refleksini tetikler.

## Monetizasyon (AdMob + IAP — politika CLAUDE.md'de bağlayıcı)

- **Ödüllü (birincil):** "Şans Tekrarı" — kötü bir sonucu hayatta bir kez yeniden çevir (ölüm hariç; adalet ilkesi) · "Ekstra Sahne" — bir AKE sahnesi daha aç.
- **Geçişli:** yalnız jenerik kartı kapatıldıktan sonra; oturumda ≤1, ≥3 dk aralık.
- **Reklamları Kaldır IAP** şart. MVP-sonrası kozmetik aday: sezon posteri tema paketleri.
- Banner ASLA. Pay-to-win ("tanrı modu" stat satışı) ASLA — karar günlüğü.

## Erişilebilirlik

Metin-öncelikli oyun = erişilebilirlikte fırsat: VoiceOver ile UÇTAN UCA oynanabilir olmak MVP kabul kriteridir. Dynamic Type en büyük boyutlarda düzen bozulmaz; Reduce Motion'da jenerik animasyonu sade akışa düşer; stat değişimleri renk + ikon + metinle (renk tek başına bilgi taşımaz).

## Karar Günlüğü

- 2026-08-01 — Konsept (TR yaşam simülasyonu) ve AdMob-dahil v1.0 para modeli SAHİP onayıyla seçildi.
- 2026-08-01 — İsim: SAHİP "gençlere hitap eden, BitLife tarzı" istedi, son kararı devretti → **"Ana Karakter: Yaşam Simülasyonu"**. Elenenler: Bir Ömür/Nasip (genç kitle zayıf), BiHayat (App Store'da alınmış), TekCan, Yaşa!, NPC (ton riski).
- 2026-08-01 — Cinsiyet/karakter üretimi: MVP'de karakter seed'den gelir (isim/aile/mahalle); oyuncu düzenlemesi MVP sonrası.
- 2026-08-01 — Askerlik, göç, sağlık gibi hassas omurga olayları içerik çizgisi süzgecinden geçer; ilk içerik turunda SAHİP okuması alınır.
- 2026-08-01 — EN olay içeriği ertelendi (kültürel içerik çeviriden fazlası); arayüz TR+EN.
