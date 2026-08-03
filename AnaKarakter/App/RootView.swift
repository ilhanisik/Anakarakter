import SwiftUI

/// Uygulama kökü: merkezi Router'ı kurar, NavigationStack'i sahiplenir ve
/// tüm rota hedeflerini tek noktadan eşler (destination-based NavigationLink
/// yasak — CLAUDE.md).
struct RootView: View {
    let dependencies: AppDependencies
    @State private var router = Router()

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.path) {
            MenuView(dependencies: dependencies)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case let .life(personSeed, deckSeed, isDaily):
                        LifeFlowView(
                            personSeed: personSeed,
                            deckSeed: deckSeed,
                            mode: isDaily ? .daily : .free,
                            dependencies: dependencies
                        )
                    case .archive:
                        ArchiveView(dependencies: dependencies)
                    case let .archivedCredits(id):
                        ArchivedCreditsView(lifeID: id, dependencies: dependencies)
                    case .settings:
                        SettingsView(dependencies: dependencies)
                    }
                }
        }
        .environment(router)
        // UMP → ATT → SDK sırası açılışta bir kez; satın alma varsa hiç.
        .task { await dependencies.prepareAds() }
    }
}

#Preview {
    RootView(dependencies: AppDependencies())
}
