import LifeDomain

/// Composition root — tüm bağımlılıklar burada kurulur ve constructor DI ile
/// aşağı akar (CLAUDE.md). Global mutable state ve singleton yok.
///
/// Faz 1+: LifeEngine, repository'ler ve servisler burada örneklenip
/// ViewModel'lere constructor üzerinden verilecek.
@MainActor
final class AppDependencies {
    /// Persistence uyum denetimleri Faz 4'te bu sürüme bağlanır.
    let domainSchemaVersion = LifeDomain.schemaVersion
}
