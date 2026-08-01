/// Tip güvenli navigasyon rotaları (CLAUDE.md: NavigationStack + Route + Router).
enum Route: Hashable {
    /// Bir ömür akışı — seed çifti hayatın tamamını belirler (determinizm).
    case life(personSeed: UInt64, deckSeed: UInt64)
}
