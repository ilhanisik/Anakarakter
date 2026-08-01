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

    public func isSatisfied(by state: LifeState) -> Bool {
        switch self {
        case let .minStat(stat, value): state.stats[stat] >= value
        case let .maxStat(stat, value): state.stats[stat] <= value
        case let .minMoney(value): state.stats.money >= value
        case let .maxMoney(value): state.stats.money <= value
        case let .hasFlag(flag): state.flags.contains(flag)
        case let .lacksFlag(flag): !state.flags.contains(flag)
        }
    }
}

public extension [Condition] {
    func allSatisfied(by state: LifeState) -> Bool {
        allSatisfy { $0.isSatisfied(by: state) }
    }
}
