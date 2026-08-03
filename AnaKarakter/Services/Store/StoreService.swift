import Foundation
import Observation
import StoreKit

/// "Reklamları Kaldır" satın alma akışı (StoreKit 2).
///
/// Karanlık desen yasağı gereği ürün TEK ve kalıcıdır: abonelik yok, para
/// birimi yok, "tanrı modu" satışı yok. Satın alan oyuncu zorunlu reklam
/// görmez ve ödüllü içeriğe reklamsız ulaşır (bkz. `AdPolicy`).
enum StoreProductID {
    static let removeAds = "com.isiksoft.anakarakter.removeads"
}

enum PurchaseOutcome: Sendable, Equatable {
    case purchased
    case cancelled
    case pending
    case failed
}

@MainActor
protocol StoreServicing: AnyObject {
    /// Mağazadan okunan yerelleştirilmiş fiyat; yüklenmediyse `nil`.
    var removeAdsDisplayPrice: String? { get }
    var isRemoveAdsPurchased: Bool { get }
    /// Satın alma durumu değişince çağrılır (ayarları kalıcılaştırmak için).
    var onEntitlementChange: ((Bool) -> Void)? { get set }

    func loadProducts() async
    func purchaseRemoveAds() async -> PurchaseOutcome
    func restore() async
}

@Observable
@MainActor
final class StoreKitStoreService: StoreServicing {
    private(set) var removeAdsDisplayPrice: String?
    private(set) var isRemoveAdsPurchased = false

    @ObservationIgnored
    var onEntitlementChange: ((Bool) -> Void)?

    private var product: Product?
    @ObservationIgnored
    private var updatesTask: Task<Void, Never>?

    init() {
        // Uygulama dışında tamamlanan işlemler (Ask to Buy, başka cihaz)
        // buradan gelir; dinleyici uygulama ömrü boyunca açık kalır.
        updatesTask = Task { [weak self] in
            for await update in Transaction.updates {
                guard case let .verified(transaction) = update else { continue }
                await transaction.finish()
                await self?.refreshEntitlements()
            }
        }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProducts() async {
        product = try? await Product.products(for: [StoreProductID.removeAds]).first
        removeAdsDisplayPrice = product?.displayPrice
        await refreshEntitlements()
    }

    func purchaseRemoveAds() async -> PurchaseOutcome {
        guard let product else { return .failed }
        do {
            switch try await product.purchase() {
            case let .success(verification):
                guard case let .verified(transaction) = verification else { return .failed }
                await transaction.finish()
                await refreshEntitlements()
                return .purchased
            case .userCancelled:
                return .cancelled
            case .pending:
                // Ask to Buy: onay gelince `Transaction.updates` yakalar.
                return .pending
            @unknown default:
                return .failed
            }
        } catch {
            return .failed
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    private func refreshEntitlements() async {
        var owned = false
        for await entitlement in Transaction.currentEntitlements {
            guard case let .verified(transaction) = entitlement else { continue }
            if transaction.productID == StoreProductID.removeAds, transaction.revocationDate == nil {
                owned = true
            }
        }
        guard owned != isRemoveAdsPurchased else { return }
        isRemoveAdsPurchased = owned
        onEntitlementChange?(owned)
    }
}

/// Önizleme/test ikizi — StoreKit'e dokunmaz.
@Observable
@MainActor
final class InMemoryStoreService: StoreServicing {
    private(set) var removeAdsDisplayPrice: String?
    private(set) var isRemoveAdsPurchased: Bool

    @ObservationIgnored
    var onEntitlementChange: ((Bool) -> Void)?
    @ObservationIgnored
    var nextOutcome: PurchaseOutcome = .purchased

    init(purchased: Bool = false, displayPrice: String? = "₺149,99") {
        isRemoveAdsPurchased = purchased
        removeAdsDisplayPrice = displayPrice
    }

    func loadProducts() async {}

    func purchaseRemoveAds() async -> PurchaseOutcome {
        if nextOutcome == .purchased {
            isRemoveAdsPurchased = true
            onEntitlementChange?(true)
        }
        return nextOutcome
    }

    func restore() async {
        onEntitlementChange?(isRemoveAdsPurchased)
    }
}
