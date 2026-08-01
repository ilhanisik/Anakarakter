import Observation

/// Merkezi yönlendirici — tek doğruluk kaynağı navigasyon yığını.
/// View'lar rota kararını Router'a bildirir; destination eşlemesi RootView'da.
@Observable
@MainActor
final class Router {
    var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    /// Yığını tek rotayla değiştirir ("bir hayat daha" akışı).
    func replace(with route: Route) {
        path = [route]
    }
}
