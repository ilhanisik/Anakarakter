import Foundation
import AppPolicy

/// Reklam sunumunun uygulama tarafı sözleşmesi.
///
/// Karar `AdPolicy`'de (saf, testli); bu tip yalnız **uygular**. Böylece
/// `GoogleMobileAds` importu tek bir dosyada kalır ve kurallar SDK'sız
/// doğrulanabilir (CLAUDE.md).
@MainActor
protocol AdsControlling: AnyObject {
    /// Politika durumu — yerleşim kararları buna göre verilir.
    var policyState: AdPolicyState { get }
    /// Oturum başından beri geçen saniye — "≥3 dk aralık" kuralının saati.
    var sessionSecond: Int { get }

    /// UMP onayı → ATT → SDK başlatma sırası. Reklam yüklemeden ÖNCE.
    func prepare(removeAdsPurchased: Bool) async

    /// Yerleşimi dener. Dönen değer ödülün verilip verilmeyeceğidir:
    /// - `true`: reklam izlendi ya da satın alma nedeniyle reklamsız verildi.
    /// - `false`: politika izin vermedi ya da reklam gösterilemedi.
    ///
    /// No-fill/hata hâlinde akış SESSİZCE sürer: geçişlide `false` görmezden
    /// gelinir, ödüllüde oyuncuya hakkı iade edilir (hak yanmaz).
    @discardableResult
    func present(_ placement: AdPlacement, context: AdContext) async -> Bool

    /// Yeni hayat başladı — hayat kapsamlı sayaçlar sıfırlanır.
    func beginNewLife()
}

/// Reklamsız ikiz: `--uitest-clean` koşularında, UI testlerinde ve
/// "Reklamları Kaldır" satın alındığında composition root bunu enjekte eder.
@MainActor
final class NoOpAdsController: AdsControlling {
    private(set) var policyState = AdPolicyState()
    var sessionSecond = 0
    /// Test gözlemi: hangi yerleşimler istendi.
    private(set) var requested: [AdPlacement] = []

    func prepare(removeAdsPurchased: Bool) async {}

    @discardableResult
    func present(_ placement: AdPlacement, context: AdContext) async -> Bool {
        requested.append(placement)
        // Ödüllü içerik reklamsız da olsa verilir; geçişli hiç gösterilmez.
        guard placement.isRewarded else { return false }
        policyState = AdPolicy.registerGranted(placement, state: policyState)
        return true
    }

    func beginNewLife() {
        policyState.beginNewLife()
    }
}
