/// Serbest Hayat modunun entropi kaynağı. Sistem RNG'si domain'e asla girmez;
/// yalnız bu servis üretir, composition root enjekte eder (determinizm kuralı).
protocol SeedSource: Sendable {
    func makeSeeds() -> (personSeed: UInt64, deckSeed: UInt64)
}

struct SystemSeedSource: SeedSource {
    func makeSeeds() -> (personSeed: UInt64, deckSeed: UInt64) {
        var generator = SystemRandomNumberGenerator()
        return (personSeed: generator.next(), deckSeed: generator.next())
    }
}
