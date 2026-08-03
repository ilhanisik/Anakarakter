import Foundation

/// Tip güvenli navigasyon rotaları (CLAUDE.md: NavigationStack + Route + Router).
enum Route: Hashable {
    /// Bir ömür akışı — seed çifti hayatın tamamını belirler (determinizm).
    /// `isDaily` yalnız kaydın hangi moda yazılacağını belirler; akış aynıdır.
    case life(personSeed: UInt64, deckSeed: UInt64, isDaily: Bool)
    /// Jenerik Arşivi listesi.
    case archive
    /// Arşivden açılan jenerik kartı.
    case archivedCredits(id: UUID)
    case settings

    static func freeLife(personSeed: UInt64, deckSeed: UInt64) -> Route {
        .life(personSeed: personSeed, deckSeed: deckSeed, isDaily: false)
    }

    static func dailyLife(personSeed: UInt64, deckSeed: UInt64) -> Route {
        .life(personSeed: personSeed, deckSeed: deckSeed, isDaily: true)
    }
}
