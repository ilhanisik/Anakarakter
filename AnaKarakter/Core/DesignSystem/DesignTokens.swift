import SwiftUI

/// Semantic design system token'ları — ekranlarda hardcoded değer yasağının
/// tek adresi (CLAUDE.md Ekran Kalite Kapısı).
/// Faz 3'te tipografi ölçeği ve sezon paletleriyle genişler.
enum DesignTokens {
    enum Spacing {
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }

    enum Radius {
        static let card: CGFloat = 16
        static let chip: CGFloat = 8
    }

    /// Semantic tipografi — jenerik/film estetiği serif, skorlar rounded.
    /// Hepsi Dynamic Type metin stillerinden türetilir (sabit punto yok);
    /// tek istisna dışa aktarım kartıdır (bkz. CreditsCardView).
    enum Typography {
        /// Jenerikte büyük isim ("AYŞE 1990–2074").
        static let displayName: Font = .system(.largeTitle, design: .serif, weight: .bold)
        /// "BİR İŞIKSOFT YAPIMI" tarzı jenerik etiketleri.
        static let creditsCaption: Font = Font.system(.footnote, design: .serif).smallCaps()
        /// Sezon posteri başlığı.
        static let posterTitle: Font = .system(.title2, design: .serif, weight: .bold)
        /// Jenerikte sahne metinleri.
        static let sceneBody: Font = .system(.body, design: .serif)
        /// Hayat Puanı gibi büyük sayılar.
        static let score: Font = .system(.largeTitle, design: .rounded, weight: .bold)
        /// Menü/marka başlığı — jenerik diliyle aynı serif.
        static let marquee: Font = .system(.largeTitle, design: .serif, weight: .black)
        /// Yıl şeridindeki "bölüm kartı" başlığı.
        static let chapter: Font = Font.system(.subheadline, design: .serif, weight: .semibold).smallCaps()
    }

    /// Hareket token'ları — süre ve eğri tek yerden. Ekranlarda sihirli sayı
    /// yok; Reduce Motion açıkken çağrı yerleri bunları `nil`'e düşürür.
    enum Motion {
        /// Karar kartı, sezon posteri gibi "sahneye giren" öğeler.
        static let enter: Animation = .spring(response: 0.45, dampingFraction: 0.78)
        /// Şeride düşen yeni satırlar.
        static let timeline: Animation = .spring(response: 0.38, dampingFraction: 0.82)
        /// Stat çubukları ve sayılar.
        static let value: Animation = .easeOut(duration: 0.45)
        /// Sezon değişiminde arka planın renk geçişi — yavaş, fark edilir.
        static let seasonShift: Animation = .easeInOut(duration: 1.1)
        /// Ortam hareketi (menüdeki ışık gezinmesi).
        static let ambient: Animation = .easeInOut(duration: 7).repeatForever(autoreverses: true)

        /// Şeride giren satırların sırayla gelmesi için gecikme.
        static func stagger(_ index: Int) -> Double { Double(min(index, 4)) * 0.05 }
    }

    /// Sahne yüzeyi — sinematik zemin (film karanlıktır; Light Mode'da sıcak
    /// kâğıt, Dark Mode'da sinema salonu).
    enum Surface {
        static let stage = Color("StageBackground")
        /// Oyun ekranlarının sade zemini — bol boşluk, pastel sıcaklık.
        static let canvas = Color("CanvasBackground")
        /// Floating kartın yüzeyi.
        static let card = Color("CardSurface")
        static let cardStroke = Color("CardStroke")
    }

    /// Anlam taşıyan vurgular. Kırmızı bilinçli olarak YOK: olumsuz olay
    /// "hata" değil hayatın bir sahnesidir, turuncu/koyu tonla anlatılır.
    enum Accent {
        /// Başarı, rol, kazanım.
        static let gold = Color("GoldAccent")
        /// Olumsuz sonuç.
        static let warn = Color("WarnAccent")
        /// Nötr/sakin seçim.
        static let calm = Color("CalmAccent")
    }

    /// Yükseklik — floating kart hissi. Gölge tek yerden, tutarlı.
    enum Elevation {
        static func card(_ scheme: ColorScheme) -> (color: Color, radius: CGFloat, y: CGFloat) {
            // Dark Mode'da gölge görünmez; ayrım kenarlıkla kurulur.
            scheme == .dark
                ? (.black.opacity(0.5), 18, 8)
                : (.black.opacity(0.10), 20, 10)
        }
    }

    /// Metin renkleri. Sistemin `.secondary`'si özel (krem) zeminimizde
    /// 3.4:1'e düşüyor ve erişilebilirlik denetiminden geçmiyor; ikincil
    /// metin bu token'ı kullanır.
    enum TextColor {
        static let secondary = Color("TextSecondary")
    }

    enum Radius2 {
        /// Büyük floating kart — brief: "büyük, yuvarlatılmış köşeler".
        static let hero: CGFloat = 28
        /// Seçim düğmesi.
        static let action: CGFloat = 18
    }
}
