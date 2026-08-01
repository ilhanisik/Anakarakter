# Ana Karakter — Proje Kuralları (Claude Code)

Bu dosya, bu depoda çalışan her Claude Code oturumu için bağlayıcıdır.
Detaylar: `docs/01-GDD.md` (oyun tasarımı), `docs/02-ARCHITECTURE.md` (mimari), `docs/03-ROADMAP.md` (MVP fazları 0–5).

## Proje

Türkçe öncelikli yaşam simülasyonu — BitLife formülü, İşıksoft kalitesiyle. Her tur bir yıl; okul, iş, ilişki, para ve Türkiye'ye özgü hayat olaylarıyla doğumdan ölüme bir ömür yaşanır. Her hayatın sonunda paylaşılabilir bir **jenerik kartı** (film jeneriği estetiğinde hayat özeti) kalır. Marka mekaniği: **Ana Karakter Enerjisi (AKE)** — güvenli seçimler hayatı sıradanlaştırır, cesur seçimler "film" yapar.

Mağaza adı: **"Ana Karakter: Yaşam Simülasyonu"**. Bundle: `com.isiksoft.anakarakter`. BlockForge ve Köken'in kardeşi: adil, ince mizahlı, premium his.

- Platform: iOS 17+, iPhone öncelikli, portrait.
- Dil: Swift 6, Strict Concurrency açık. Eski sözdizimi yasak.
- UI: Yalnızca SwiftUI. Storyboard/XIB/Objective-C yasak; UIKit yalnızca teknik zorunlulukta. Metin-öncelikli premium arayüz; SpriteKit/fizik motoru YOK.

## Mimari (özet — detay: docs/02-ARCHITECTURE.md)

- Feature First + MVVM + Repository + constructor DI + POP. Composition over inheritance.
- Oyun kuralları TAMAMEN saf Swift `AnaKarakterKit` paketinde (`LifeDomain`): SwiftUI, SwiftData, UIKit, Observation import etmek YASAK. Modeller Codable + Sendable + Equatable + Hashable.
- Olay içeriği koddan ayrı, tip güvenli **EventCatalog** olarak yaşar; koşul/etki şeması domain'de doğrulanır. İçerik değişikliği de aynı test kapısından geçer.
- Determinizm (bağlayıcı): hayatın tamamı seed'lidir — karakter üretimi, olay çekilişleri, sonuç zarları. `Date()`/`Calendar.current`/`SystemRandomNumberGenerator` doğrudan kullanılmaz, enjekte edilir. Aynı seed + aynı kararlar = aynı hayat (test edilebilirliğin ve Günün Hayatı modunun temeli).
- Persistence: SwiftData, protocol repository arkasında; View'da `@Query` yasak; `VersionedSchema` + migration plan ilk günden.
- Navigation: NavigationStack + tip güvenli Route + merkezi Router; destination-based NavigationLink yasak.
- State: Observation (`@Observable`); global mutable state yok. Concurrency: async/await + Actor; GCD ve completion handler yasak.
- SPM; üçüncü parti kütüphane EKLENMEZ — tek yazılı istisna: Google Mobile Ads SDK + UMP (AdMob; mediation yok). Başkası gerekirse önce gerekçesiyle sor.
- Reklam politikası (bağlayıcı): `import GoogleMobileAds` yalnızca `Services/Ads/` içinde; kurallar saf Swift testli `AdPolicy` tipinde; ödüllü birincil (Şans Tekrarı, Ekstra Sahne), geçişli YALNIZ hayat bittikten ve jenerik kartı kapatıldıktan SONRA, oturumda ≤1 ve iki gösterim arası ≥3 dk; yıl akışının ortasında ASLA, banner ASLA; "Reklamları Kaldır" IAP şart; no-fill akışı sessizce sürer; UMP (KVKK/GDPR) + ATT akışları kurallara uygun.

## İçerik Çizgisi (bağlayıcı)

- Hedef yaş derecelendirmesi 12+. Şunlar YOK: kumar teşviki, uyuşturucu kullanım detayı, intihar/kendine zarar, cinsel içerik, gerçek kişi/kurum/marka isimleri.
- Sağlık ve ölüm olayları insaflı ve kısa yazılır. Mizah durumla dalga geçer, insanla değil.
- Güncel siyaset ve din polemiği yok; Türkiye kültürü sevgiyle işlenir, karikatüre kaçılmaz.
- Karanlık desen yasak: sahte kıtlık, zorla reklam, pay-to-win "tanrı modu" satışı yok.
- Bu çizgiyi zorlayabilecek her içerik fikri implementasyondan ÖNCE SAHİP'e sorulur.

## Ekran Kalite Kapısı

Yeni tasarlanan her ekran, aşağıdakilerin TAMAMINI sağlamadan tamamlanmış sayılmaz; sağlamıyorsa implementasyondan önce yeniden tasarla:

- Apple Human Interface Guidelines
- Native SwiftUI etkileşim kalıpları
- Erişilebilirlik en iyi pratikleri (VoiceOver, Reduce Motion, High Contrast)
- Semantic design system (renk/spacing/tipografi token'ları — hardcoded değer yok)
- Dynamic Type desteği — metin-yoğun oyun: EN BÜYÜK erişilebilirlik boyutlarında düzen bozulmaz
- VoiceOver uyumluluğu — olay akışı doğal okuma sırasıyla seslendirilir
- Dark Mode + Light Mode
- Tutarlı spacing ve tipografi
- Native navigation davranışı
- Performans bilinçli implementasyon (ölçmeden optimizasyon yapma; ölçülebilir jank bırakma)

## Yerelleştirme

- String Catalog (`Localizable.xcstrings`); kullanıcının göreceği hiçbir metin hardcode yazılmaz.
- Arayüz TR + EN; pluralization ve `formatted()` zorunlu.
- Olay içeriği MVP'de Türkçe (EventCatalog yerelleştirilebilir şemayla kurulur); EN içerik seti ayrı karar (docs/03 karar günlüğü).

## Build Kalite Kapısı

Her görev sonunda doğrula; temiz değilse yeni geliştirmeye GEÇME:

- Build başarılı, kendi target'larımızda 0 error / 0 warning; Swift 6 + Strict Concurrency temiz
- `AnaKarakterKit` testleri yeşil (`swift test` paket kökünde, Xcode'suz koşar)
- Domain saflığı: `grep -r "import SwiftUI\|import SwiftData\|import UIKit\|import Observation" Packages/AnaKarakterKit/Sources/` boş dönmeli
- Hayat simülasyon kapısı: 10.000 seed'li otomatik ömür koşusu invariant'ları geçer (çıkmaz hayat yok, stat sınırları korunur, koşul ihlali yok, ölüm yaş dağılımı bantta)
- İçerik değiştiyse içerik lint'i yeşil (şema + kapsama + içerik çizgisi denetimi)
- Dokümantasyon güncel

## Çalışma Prensibi

- Senior Apple Software Engineer gibi düşün. Daha doğru teknik çözüm varsa önce gerekçesini açıkla, önerini sun.
- Fazlar `docs/03-ROADMAP.md`'de tanımlı. Bir fazın kabul kriterleri tamamlanmadan ve SAHİP ONAYI alınmadan sonraki faza geçme.
- Her görev sonunda raporla: (1) neler geliştirildi, (2) mimari kararlar, (3) build durumu, (4) riskler, (5) iyileştirme önerileri, (6) sonraki adım.
- Test: birim/domain testleri Swift Testing; UI ve performans testleri XCTest.
- Teknik borç oluşturma; gerekirse önce refactor.
- Önemli kararlar ilgili dokümanın sonundaki *karar günlüğüne* tarihli işlenir.
