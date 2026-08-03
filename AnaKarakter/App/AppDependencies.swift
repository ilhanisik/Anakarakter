import Foundation
import SwiftData
import LifeDomain
import LifeContent
import AppPolicy

/// Composition root — tüm bağımlılıklar burada kurulur ve constructor DI ile
/// aşağı akar (CLAUDE.md). Global mutable state ve singleton yok.
@MainActor
final class AppDependencies {
    /// Aktif olay kataloğu (tip güvenli, lint kapısından geçmiş içerik).
    let catalog: EventCatalog
    /// Serbest Hayat seed üretici.
    let seedSource: any SeedSource
    /// Sentez ses efektleri (Faz 3).
    let audio: AudioService
    let dateProvider: any DateProviding

    let archive: any LifeArchiveRepository
    let dailyRuns: any DailyRunRepository
    let settingsStore: any SettingsRepository
    let ads: any AdsControlling
    let store: any StoreServicing

    /// Mağazanın ömrü bu tipe bağlıdır; bırakılırsa bağlam kapanır.
    private let container: ModelContainer?

    /// Uygulama kurulumu — SwiftData mağazası ve gerçek reklam denetleyicisi.
    convenience init() {
        let container = PersistenceController.makeContainer()
        let context = container.mainContext
        self.init(
            archive: SwiftDataLifeArchiveRepository(context: context),
            dailyRuns: SwiftDataDailyRunRepository(context: context),
            settingsStore: SwiftDataSettingsRepository(context: context),
            // UI test koşusunda reklam yok: akış deterministik kalsın.
            ads: PersistenceController.isUITestClean ? NoOpAdsController() : GoogleAdsController(),
            store: PersistenceController.isUITestClean ? InMemoryStoreService() : StoreKitStoreService(),
            container: container
        )
        // Satın alma durumu değişince ayarlara yazılır: reklam kararları
        // (AdPolicy) bu tek bayrağı okur.
        store.onEntitlementChange = { [weak self] owned in
            guard let self else { return }
            var settings = self.settings
            guard settings.removeAdsPurchased != owned else { return }
            settings.removeAdsPurchased = owned
            try? self.settingsStore.save(settings)
        }
    }

    /// Test/önizleme kurulumu — bellek içi ikizler.
    init(
        catalog: EventCatalog = ContentCatalog.catalog,
        seedSource: any SeedSource = SystemSeedSource(),
        audio: AudioService = AudioService(),
        dateProvider: any DateProviding = SystemDateProvider(),
        archive: any LifeArchiveRepository = InMemoryLifeArchiveRepository(),
        dailyRuns: any DailyRunRepository = InMemoryDailyRunRepository(),
        settingsStore: any SettingsRepository = InMemorySettingsRepository(),
        ads: any AdsControlling = NoOpAdsController(),
        store: any StoreServicing = InMemoryStoreService(),
        container: ModelContainer? = nil
    ) {
        self.catalog = catalog
        self.seedSource = seedSource
        self.audio = audio
        self.dateProvider = dateProvider
        self.archive = archive
        self.dailyRuns = dailyRuns
        self.settingsStore = settingsStore
        self.ads = ads
        self.store = store
        self.container = container
    }

    var settings: AppSettings {
        (try? settingsStore.load()) ?? AppSettings()
    }

    func makeLifeFlowViewModel(personSeed: UInt64, deckSeed: UInt64, mode: LifeMode) -> LifeFlowViewModel {
        LifeFlowViewModel(
            personSeed: personSeed,
            deckSeed: deckSeed,
            mode: mode,
            catalog: catalog,
            seedSource: seedSource,
            audio: audio,
            dateProvider: dateProvider,
            archive: archive,
            dailyRuns: dailyRuns
        )
    }

    func makeArchiveViewModel() -> ArchiveViewModel {
        ArchiveViewModel(archive: archive)
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(store: settingsStore, archive: archive, purchases: store)
    }

    func makeDailyViewModel() -> DailyViewModel {
        DailyViewModel(dailyRuns: dailyRuns, archive: archive, dateProvider: dateProvider)
    }

    /// Reklam altyapısını hazırlar (UMP → ATT → SDK). Uygulama açılışında
    /// bir kez çağrılır; satın alma varsa SDK hiç başlatılmaz.
    func prepareAds() async {
        await store.loadProducts()
        await ads.prepare(removeAdsPurchased: settings.removeAdsPurchased)
    }

    /// Reklam kararlarının bağlamı — tek yerden kurulur ki "satın aldı mı"
    /// bayrağı hiçbir çağrı yerinde unutulmasın.
    func adContext(
        nowSecond: Int, isMidYearFlow: Bool = false,
        creditsCardDismissed: Bool = false, targetsDeathOutcome: Bool = false
    ) -> AdContext {
        AdContext(
            nowSecond: nowSecond,
            removeAdsPurchased: settings.removeAdsPurchased,
            isMidYearFlow: isMidYearFlow,
            creditsCardDismissed: creditsCardDismissed,
            targetsDeathOutcome: targetsDeathOutcome
        )
    }
}
