import Foundation
import UIKit
import AppTrackingTransparency
import GoogleMobileAds
import UserMessagingPlatform
import AppPolicy

/// `GoogleMobileAds` importunun BULUNDUĞU TEK YER (CLAUDE.md).
/// Kural yok, karar yok — yalnız `AdPolicy`'nin verdiği kararı uygular.
@MainActor
final class GoogleAdsController: AdsControlling {
    private(set) var policyState = AdPolicyState()

    private var isStarted = false
    private var interstitial: InterstitialAd?
    private var rewarded: RewardedAd?
    private var presenter: FullScreenPresenter?

    /// Oturum başlangıcı — `AdContext.nowSecond` bundan türetilir (monotonik).
    private let sessionStart = ContinuousClock.now

    var sessionSecond: Int {
        Int((ContinuousClock.now - sessionStart).components.seconds)
    }

    // MARK: Hazırlık — UMP → ATT → SDK

    func prepare(removeAdsPurchased: Bool) async {
        // Satın alan oyuncu için SDK hiç başlatılmaz: istek yok, izleme yok.
        guard !removeAdsPurchased, !isStarted else { return }

        await requestConsent()
        await requestTrackingAuthorizationIfNeeded()

        guard ConsentInformation.shared.canRequestAds else { return }
        _ = await MobileAds.shared.start()
        isStarted = true

        await preload()
    }

    /// UMP (KVKK/GDPR): onay bilgisini tazele, gerekiyorsa formu sun.
    private func requestConsent() async {
        let parameters = RequestParameters()
        #if DEBUG
        let debugSettings = DebugSettings()
        debugSettings.geography = .EEA // form akışı geliştirmede görünsün
        parameters.debugSettings = debugSettings
        #endif

        do {
            try await ConsentInformation.shared.requestConsentInfoUpdate(with: parameters)
            guard let root = Self.rootViewController else { return }
            try await ConsentForm.loadAndPresentIfRequired(from: root)
        } catch {
            // Onay akışı başarısızsa reklam gösterilmez; oyun etkilenmez.
        }
    }

    /// ATT istemi UMP'den SONRA gelir (Google'ın önerdiği sıra).
    private func requestTrackingAuthorizationIfNeeded() async {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
        _ = await ATTrackingManager.requestTrackingAuthorization()
    }

    // MARK: Yükleme

    private func preload() async {
        async let interstitialLoad: Void = loadInterstitial()
        async let rewardedLoad: Void = loadRewarded()
        _ = await (interstitialLoad, rewardedLoad)
    }

    private func loadInterstitial() async {
        guard interstitial == nil else { return }
        interstitial = try? await InterstitialAd.load(
            with: AdUnits.interstitial, request: Request()
        )
    }

    private func loadRewarded() async {
        guard rewarded == nil else { return }
        rewarded = try? await RewardedAd.load(
            with: AdUnits.rewarded, request: Request()
        )
    }

    // MARK: Sunum

    @discardableResult
    func present(_ placement: AdPlacement, context: AdContext) async -> Bool {
        switch AdPolicy.decide(placement, state: policyState, context: context) {
        case .deny:
            return false
        case .grantWithoutAd:
            policyState = AdPolicy.registerGranted(placement, state: policyState)
            return true
        case .show:
            break
        }

        guard isStarted, let root = Self.rootViewController else { return false }

        let shown: Bool = switch placement {
        case .interstitialAfterCredits: await showInterstitial(from: root)
        case .rewardedLuckRetry, .rewardedExtraScene: await showRewarded(from: root)
        }

        // No-fill/hata: durum ilerlemez, hak yanmaz, akış sessizce sürer.
        guard shown else { return false }
        policyState = AdPolicy.registerShown(placement, state: policyState, context: context)
        return true
    }

    private func showInterstitial(from root: UIViewController) async -> Bool {
        guard let ad = interstitial else {
            await loadInterstitial() // bir sonraki sefere hazır olsun
            return false
        }
        interstitial = nil
        let dismissed = await withCheckedContinuation { continuation in
            let presenter = FullScreenPresenter { continuation.resume(returning: $0) }
            self.presenter = presenter
            ad.fullScreenContentDelegate = presenter
            ad.present(from: root)
        }
        presenter = nil
        await loadInterstitial()
        return dismissed
    }

    private func showRewarded(from root: UIViewController) async -> Bool {
        guard let ad = rewarded else {
            await loadRewarded()
            return false
        }
        rewarded = nil
        let earned = await withCheckedContinuation { continuation in
            var didEarn = false
            let presenter = FullScreenPresenter { presented in
                continuation.resume(returning: presented && didEarn)
            }
            self.presenter = presenter
            ad.fullScreenContentDelegate = presenter
            ad.present(from: root) { didEarn = true }
        }
        presenter = nil
        await loadRewarded()
        return earned
    }

    func beginNewLife() {
        policyState.beginNewLife()
    }

    /// Sunum için kök denetleyici — UIKit yalnız bu teknik zorunlulukta.
    private static var rootViewController: UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows.first { $0.isKeyWindow }?
            .rootViewController
    }
}

/// Tam ekran reklam yaşam döngüsünü tek bir `Bool`'a indirger:
/// gösterildi ve kapandı mı.
private final class FullScreenPresenter: NSObject, FullScreenContentDelegate {
    private var finish: ((Bool) -> Void)?

    init(finish: @escaping (Bool) -> Void) {
        self.finish = finish
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        finish?(false)
        finish = nil
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        finish?(true)
        finish = nil
    }
}
