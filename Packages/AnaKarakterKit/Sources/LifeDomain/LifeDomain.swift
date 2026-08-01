/// `LifeDomain` — Ana Karakter'in saf Swift oyun kuralları modülü.
///
/// Bağlayıcı kurallar (CLAUDE.md):
/// - Bu modül SwiftUI, SwiftData, UIKit veya Observation import ETMEZ.
/// - Tüm rastgelelik ve tarih/saat enjekte edilir; `Date()`, `Calendar.current`
///   ve `SystemRandomNumberGenerator` doğrudan kullanılmaz.
/// - Aynı seed + aynı kararlar = bit-bit aynı hayat (determinizm sözleşmesi).
public enum LifeDomain {
    /// Domain şema sürümü — persistence ve içerik kataloğu uyumluluk denetimlerinde kullanılır.
    public static let schemaVersion = 1

    /// Üst yaş sınırı: bu yaşta ölüm olasılığı 1'dir ("çıkmaz hayat yok" garantisi).
    public static let maximumAge = 110

    /// Bir yılda sunulan olay sayısı bandı (kilometre taşları ve takipler hariç
    /// havuz çekilişleri bu banda tamamlanır — docs/01: yılda 2–4 olay).
    public static let eventsPerYear: ClosedRange<Int> = 2...4
}
