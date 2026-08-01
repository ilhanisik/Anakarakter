/// Takvim günü — enjekte edilir; domain `Date()`/`Calendar.current` kullanmaz.
public struct DailyDate: Codable, Sendable, Equatable, Hashable {
    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
}

/// Günün Hayatı: (tarih) → aynı bebek + aynı deste, her cihazda
/// (Köken `DailyRootSelector` deseni). Adaletin temeli determinizm sözleşmesi.
public enum DailyLifeSelector {
    /// Oyuna özel tuz — başka İşıksoft oyunlarının günlük seed'leriyle çakışmasın.
    static let gameSalt: UInt64 = 0x414E_414B_4152_414B // "ANAKARAK"

    public static func seeds(for date: DailyDate) -> (personSeed: UInt64, deckSeed: UInt64) {
        let dayNumber = UInt64(bitPattern: Int64(date.year)) &* 10_000
            &+ UInt64(date.month) &* 100
            &+ UInt64(date.day)
        var rng = SeededRandomSource(seed: dayNumber ^ gameSalt)
        return (personSeed: rng.next(), deckSeed: rng.next())
    }
}
