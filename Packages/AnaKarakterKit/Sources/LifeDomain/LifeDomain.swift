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
}
