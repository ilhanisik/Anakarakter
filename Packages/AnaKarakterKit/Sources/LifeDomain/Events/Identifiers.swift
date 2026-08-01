/// Tip güvenli olay kimliği.
public struct EventID: RawRepresentable, Codable, Sendable, Equatable, Hashable, Comparable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public static func < (lhs: EventID, rhs: EventID) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// Tip güvenli seçenek kimliği (olay içinde benzersiz).
public struct ChoiceID: RawRepresentable, Codable, Sendable, Equatable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}
