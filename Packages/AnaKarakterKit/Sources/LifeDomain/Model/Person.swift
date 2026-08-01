/// Seed'den üretilen karakter kimliği (isim, doğum yılı, mahalle).
/// Oyuncu düzenlemesi MVP dışı (docs/01 karar günlüğü).
public struct Person: Codable, Sendable, Equatable, Hashable {
    public enum Gender: String, CaseIterable, Codable, Sendable, Equatable, Hashable {
        case kadin, erkek
    }

    public let name: String
    public let gender: Gender
    public let birthYear: Int
    public let neighborhood: String

    public init(name: String, gender: Gender, birthYear: Int, neighborhood: String) {
        self.name = name
        self.gender = gender
        self.birthYear = birthYear
        self.neighborhood = neighborhood
    }
}

/// İsim/mahalle havuzları — içerik katmanı sağlar, üretici seed'le çeker.
public struct PersonPools: Codable, Sendable, Equatable, Hashable {
    public let femaleNames: [String]
    public let maleNames: [String]
    public let neighborhoods: [String]

    public init(femaleNames: [String], maleNames: [String], neighborhoods: [String]) {
        self.femaleNames = femaleNames
        self.maleNames = maleNames
        self.neighborhoods = neighborhoods
    }
}
