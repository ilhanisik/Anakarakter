/// Bir hayatın sayısal durumu. Statlar 0–100'e kilitlenir (clamp);
/// para negatif olamaz (borç sistemi MVP dışı — docs/02 karar günlüğü).
public struct StatBlock: Codable, Sendable, Equatable, Hashable {
    public static let statRange: ClosedRange<Int> = 0...100

    public private(set) var health: Int
    public private(set) var happiness: Int
    public private(set) var intelligence: Int
    public private(set) var social: Int
    public private(set) var ake: Int
    public private(set) var money: Int

    public init(health: Int, happiness: Int, intelligence: Int, social: Int, ake: Int, money: Int) {
        self.health = Self.clamped(health)
        self.happiness = Self.clamped(happiness)
        self.intelligence = Self.clamped(intelligence)
        self.social = Self.clamped(social)
        self.ake = Self.clamped(ake)
        self.money = max(0, money)
    }

    public subscript(stat: Stat) -> Int {
        switch stat {
        case .health: health
        case .happiness: happiness
        case .intelligence: intelligence
        case .social: social
        case .ake: ake
        }
    }

    /// Stat deltası uygular, 0–100'e kilitler.
    public mutating func add(_ delta: Int, to stat: Stat) {
        switch stat {
        case .health: health = Self.clamped(health + delta)
        case .happiness: happiness = Self.clamped(happiness + delta)
        case .intelligence: intelligence = Self.clamped(intelligence + delta)
        case .social: social = Self.clamped(social + delta)
        case .ake: ake = Self.clamped(ake + delta)
        }
    }

    /// Para deltası uygular; bakiye 0'ın altına inmez.
    public mutating func addMoney(_ delta: Int) {
        money = max(0, money + delta)
    }

    private static func clamped(_ value: Int) -> Int {
        min(statRange.upperBound, max(statRange.lowerBound, value))
    }
}
