/// Sonuç etkisi: stat deltası, para, bayrak, yıllık gelir veya jenerik rolü.
public enum Effect: Codable, Sendable, Equatable, Hashable {
    case stat(Stat, Int)
    case money(Int)
    case setFlag(LifeFlag)
    case clearFlag(LifeFlag)
    /// Yıllık geliri BU değere ayarlar (delta değil) — iş/emeklilik geçişleri.
    case annualIncome(Int)
    /// Jenerik kartına rol satırı ekler ("mahallenin avukatı" gibi).
    case credit(EventText)
}
