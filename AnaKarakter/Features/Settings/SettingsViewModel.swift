import Foundation
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    private let store: any SettingsRepository
    private let archive: any LifeArchiveRepository
    private let purchases: any StoreServicing

    private(set) var settings = AppSettings()
    private(set) var archivedLifeCount = 0
    private(set) var isPurchasing = false
    /// Satın alma sonrası kullanıcıya gösterilecek durum; nil ise mesaj yok.
    var purchaseNotice: PurchaseNotice?

    enum PurchaseNotice: String, Identifiable {
        case restored
        case pending
        case failed
        var id: String { rawValue }
    }

    init(store: any SettingsRepository, archive: any LifeArchiveRepository, purchases: any StoreServicing) {
        self.store = store
        self.archive = archive
        self.purchases = purchases
    }

    func reload() {
        settings = (try? store.load()) ?? AppSettings()
        archivedLifeCount = (try? archive.count()) ?? 0
    }

    var soundEnabled: Bool {
        get { settings.soundEnabled }
        set { settings.soundEnabled = newValue; persist() }
    }

    var hapticsEnabled: Bool {
        get { settings.hapticsEnabled }
        set { settings.hapticsEnabled = newValue; persist() }
    }

    /// Satın alma gerçeği mağazadan gelir; ayarlar yalnız kopyayı taşır.
    var removeAdsPurchased: Bool {
        purchases.isRemoveAdsPurchased || settings.removeAdsPurchased
    }

    var removeAdsPrice: String? { purchases.removeAdsDisplayPrice }

    func purchaseRemoveAds() async {
        guard !isPurchasing else { return }
        isPurchasing = true
        defer { isPurchasing = false }

        switch await purchases.purchaseRemoveAds() {
        case .purchased:
            settings.removeAdsPurchased = true
            persist()
        case .pending:
            purchaseNotice = .pending
        case .failed:
            purchaseNotice = .failed
        case .cancelled:
            break // iptal bir hata değildir; sessizce geç
        }
        reload()
    }

    func restorePurchases() async {
        guard !isPurchasing else { return }
        isPurchasing = true
        defer { isPurchasing = false }

        await purchases.restore()
        if purchases.isRemoveAdsPurchased {
            settings.removeAdsPurchased = true
            persist()
        }
        purchaseNotice = .restored
        reload()
    }

    private func persist() {
        try? store.save(settings)
    }
}
