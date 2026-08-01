import SwiftUI

/// Uygulama kökü: merkezi Router'ı kurar ve NavigationStack'i sahiplenir.
/// Rota hedefleri Faz 2'de `Route` üzerinden bağlanır (destination-based
/// NavigationLink yasak — CLAUDE.md).
struct RootView: View {
    let dependencies: AppDependencies
    @State private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            MenuView()
        }
        .environment(router)
    }
}

#Preview {
    RootView(dependencies: AppDependencies())
}
