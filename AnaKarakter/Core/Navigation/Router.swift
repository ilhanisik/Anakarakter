import Observation

/// Merkezi yönlendirici — tek doğruluk kaynağı navigasyon yığını.
/// View'lar rota kararını Router'a bildirir; destination eşlemesi RootView'da.
@Observable
@MainActor
final class Router {
    var path: [Route] = []

    // Faz 2: gerçek rotalarla birlikte push/pop API'si buraya eklenir.
    // (Route şu an boş enum; asla çağrılamayacak gövdeler uyarı üretir.)

    func popToRoot() {
        path.removeAll()
    }
}
