/// Takvim günü — enjekte edilir; domain `Date()`/`Calendar.current` kullanmaz.
public struct DailyDate: Codable, Sendable, Equatable, Hashable, Comparable {
    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    /// Proleptik Gregoryen takvimde sabit bir başlangıca göre gün numarası
    /// (Howard Hinnant `days_from_civil`). Saf tamsayı aritmetiği —
    /// `Calendar` bağımlılığı olmadan "kaç gün arayla" hesabı yapılabilsin diye.
    public var dayNumber: Int {
        var y = year - (month <= 2 ? 1 : 0)
        let era = (y >= 0 ? y : y - 399) / 400
        y -= era * 400 // yoe: [0, 399]
        let doy = (153 * (month + (month > 2 ? -3 : 9)) + 2) / 5 + day - 1
        let doe = y * 365 + y / 4 - y / 100 + doy
        return era * 146_097 + doe - 719_468
    }

    /// İki gün arasındaki fark (gün).
    public func days(since other: DailyDate) -> Int {
        dayNumber - other.dayNumber
    }

    public static func < (lhs: DailyDate, rhs: DailyDate) -> Bool {
        lhs.dayNumber < rhs.dayNumber
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
