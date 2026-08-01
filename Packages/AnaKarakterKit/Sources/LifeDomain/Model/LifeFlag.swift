/// Hayat bayrağı — olay zincirlerinin hafızası ("kanka" bayrağı 40 yıl sonra
/// düğünde geri döner). İçerik katalogları kendi bayraklarını extension ile
/// tanımlar; ContentLint tutarlılığı denetler.
public struct LifeFlag: RawRepresentable, Codable, Sendable, Equatable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

// Domain çekirdeğinin tanıdığı bayraklar (karakter üretiminde atanır).
public extension LifeFlag {
    static let kadin = LifeFlag("kadin")
    static let erkek = LifeFlag("erkek")
}
