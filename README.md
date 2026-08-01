# Ana Karakter

Türkçe öncelikli yaşam simülasyonu: bir hayat seç, cesur oyna, jenerik aktığında adın büyük yazsın. 🎬
Her tur bir yıl; ÖSYM'den kira zammına Türkiye'ye özgü olaylarla doğumdan ölüme bir ömür.
Swift 6 · SwiftUI · iOS 17+ · iPhone / Portrait · AdMob (adil politika) + Reklamları Kaldır

Mağaza adı: **Ana Karakter: Yaşam Simülasyonu** · Bundle: `com.isiksoft.anakarakter`

## Doküman Haritası

| Dosya | İçerik |
|---|---|
| `CLAUDE.md` | Claude Code oturumları için bağlayıcı proje kuralları, içerik çizgisi, kalite kapıları |
| `docs/01-GDD.md` | Oyun tasarımı: çekirdek döngü, statlar, AKE, sezonlar, olay sistemi, Günün Hayatı, jenerik kartı |
| `docs/02-ARCHITECTURE.md` | AnaKarakterKit (LifeDomain), içerik hattı, determinizm, persistence, reklam mimarisi, test stratejisi |
| `docs/03-ROADMAP.md` | MVP fazları (0–5), kabul kriterleri, riskler |

## Durum

Faz 1 tamamlandı (2026-08-01): LifeDomain çekirdeği (motor + determinizm), `LifeContent` kataloğu (70 olay, 6 sezon omurgası), 72 test — 10.000 hayat simülasyon kapısı, ContentLint ve denge testleri dahil hepsi yeşil. Sıradaki adım: **SAHİP onayı → Faz 2** (oynanabilir dikey dilim).

## Başlangıç

Bu klasörde Claude Code'u aç ve şununla başla:

```
CLAUDE.md ve docs/ altındaki dokümanları oku. Faz 0'ı (proje iskeleti) başlat.
```

Her faz, `docs/03-ROADMAP.md`'deki kabul kriterleri sağlanıp onay verilmeden bir sonrakine geçmez.
