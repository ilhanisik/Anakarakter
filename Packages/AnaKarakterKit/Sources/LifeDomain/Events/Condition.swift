/// Olay/seçenek görünürlük koşulu. Şema domain'de doğrulanır;
/// ContentLint ek kurallar koyar (ör. AKE üst sınırı koşulu YASAK —
/// düşük AKE asla ceza aracı değildir, docs/01).
public enum Condition: Codable, Sendable, Equatable, Hashable {
    case minStat(Stat, Int)
    case maxStat(Stat, Int)
    case minMoney(Int)
    case maxMoney(Int)
    case hasFlag(LifeFlag)
    case lacksFlag(LifeFlag)
    /// Yaş alt sınırı — sezon tek başına yeterli kapı değildir. Çocukluk 0–5,
    /// Okul 6–17 gibi geniş sezonlarda gelişim basamağı yıl yıl değişir;
    /// "okul dönüşü" olayı 0 yaşında çekilmemelidir (docs/03 Faz 3 his turu).
    case minAge(Int)
    /// Yaş üst sınırı.
    case maxAge(Int)

    public func isSatisfied(by state: LifeState) -> Bool {
        switch self {
        case let .minStat(stat, value): state.stats[stat] >= value
        case let .maxStat(stat, value): state.stats[stat] <= value
        case let .minMoney(value): state.stats.money >= value
        case let .maxMoney(value): state.stats.money <= value
        case let .hasFlag(flag): state.flags.contains(flag)
        case let .lacksFlag(flag): !state.flags.contains(flag)
        case let .minAge(value): state.age >= value
        case let .maxAge(value): state.age <= value
        }
    }
}

public extension Condition {
    /// Koşulun yaş bandı katkısı — ContentLint ve kapsama denetimleri için.
    var ageBound: (min: Int?, max: Int?) {
        switch self {
        case let .minAge(value): (value, nil)
        case let .maxAge(value): (nil, value)
        default: (nil, nil)
        }
    }
}

public extension [Condition] {
    func allSatisfied(by state: LifeState) -> Bool {
        allSatisfy { $0.isSatisfied(by: state) }
    }

    /// Listedeki yaş koşullarının kesişimi. Koşul yoksa iki alan da `nil`'dir;
    /// çelişkili bant (ör. minAge 20 + maxAge 10) olduğu gibi döner —
    /// ContentLint bunu hata olarak yakalar, domain sessizce düzeltmez.
    var declaredAgeBounds: (min: Int?, max: Int?) {
        var lower: Int?
        var upper: Int?
        for condition in self {
            let bound = condition.ageBound
            // Swift.max/min: bu kapsamda çıplak max/min Sequence metoduna gider.
            if let value = bound.min { lower = Swift.max(lower ?? value, value) }
            if let value = bound.max { upper = Swift.min(upper ?? value, value) }
        }
        return (lower, upper)
    }

    /// Yaş koşulları bu yaşa izin veriyor mu (diğer koşullara bakmaz).
    func ageAllows(_ age: Int) -> Bool {
        let bounds = declaredAgeBounds
        if let low = bounds.min, age < low { return false }
        if let high = bounds.max, age > high { return false }
        return true
    }
}
