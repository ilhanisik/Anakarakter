import LifeDomain
import LifeContent

/// Composition root — tüm bağımlılıklar burada kurulur ve constructor DI ile
/// aşağı akar (CLAUDE.md). Global mutable state ve singleton yok.
@MainActor
final class AppDependencies {
    /// Aktif olay kataloğu (tip güvenli, lint kapısından geçmiş içerik).
    let catalog: EventCatalog
    /// Serbest Hayat seed üretici.
    let seedSource: any SeedSource

    init(
        catalog: EventCatalog = ContentCatalog.catalog,
        seedSource: any SeedSource = SystemSeedSource()
    ) {
        self.catalog = catalog
        self.seedSource = seedSource
    }

    func makeLifeFlowViewModel(personSeed: UInt64, deckSeed: UInt64) -> LifeFlowViewModel {
        LifeFlowViewModel(
            personSeed: personSeed,
            deckSeed: deckSeed,
            catalog: catalog,
            seedSource: seedSource
        )
    }
}
