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
                    case let .life(personSeed, deckSeed):
                        LifeFlowView(
                            personSeed: personSeed,
                            deckSeed: deckSeed,
                            dependencies: dependencies
                        )
                    }
                }
        }
        .environment(router)
    }
}

#Preview {
    RootView(dependencies: AppDependencies())
}
