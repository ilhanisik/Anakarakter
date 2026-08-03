import Testing
import AppPolicy

@Suite("AdPolicy — geçişli reklam")
struct InterstitialPolicyTests {
    let afterCredits = AdContext(nowSecond: 1_000, creditsCardDismissed: true)

    @Test("Jenerik kartı kapandıktan sonra gösterilir")
    func allowedAfterCredits() {
        let decision = AdPolicy.decide(.interstitialAfterCredits, state: AdPolicyState(), context: afterCredits)
        #expect(decision == .show)
    }

    @Test("Jenerik kartı açıkken gösterilmez")
    func deniedWhileCardOpen() {
        let context = AdContext(nowSecond: 1_000, creditsCardDismissed: false)
        #expect(AdPolicy.decide(.interstitialAfterCredits, state: AdPolicyState(), context: context)
                == .deny(.creditsCardStillOpen))
    }

    @Test("Yıl akışının ortasında ASLA")
    func neverMidYear() {
        let context = AdContext(nowSecond: 1_000, isMidYearFlow: true, creditsCardDismissed: true)
        #expect(AdPolicy.decide(.interstitialAfterCredits, state: AdPolicyState(), context: context)
                == .deny(.midYearFlow))
    }

    @Test("Oturumda en çok bir kez")
    func sessionLimit() {
        let shown = AdPolicy.registerShown(.interstitialAfterCredits, state: AdPolicyState(), context: afterCredits)
        #expect(shown.interstitialsThisSession == 1)
        let later = AdContext(nowSecond: 99_999, creditsCardDismissed: true)
        #expect(AdPolicy.decide(.interstitialAfterCredits, state: shown, context: later)
                == .deny(.sessionLimitReached))
    }

    @Test("İki gösterim arası en az 3 dakika")
    func minimumGap() {
        // Oturum limiti bu kuralı gölgelemesin diye limit dolmamış bir durum kurulur.
        let state = AdPolicyState(interstitialsThisSession: 0, lastInterstitialSecond: 1_000)
        let tooSoon = AdContext(nowSecond: 1_000 + 179, creditsCardDismissed: true)
        #expect(AdPolicy.decide(.interstitialAfterCredits, state: state, context: tooSoon)
                == .deny(.tooSoon(remainingSeconds: 1)))

        let justEnough = AdContext(nowSecond: 1_000 + 180, creditsCardDismissed: true)
        #expect(AdPolicy.decide(.interstitialAfterCredits, state: state, context: justEnough) == .show)
    }

    @Test("Reklamları Kaldır satın alındıysa geçişli hiç gösterilmez")
    func removeAdsBlocksInterstitial() {
        let context = AdContext(nowSecond: 1_000, removeAdsPurchased: true, creditsCardDismissed: true)
        #expect(AdPolicy.decide(.interstitialAfterCredits, state: AdPolicyState(), context: context) != .show)
    }
}

@Suite("AdPolicy — ödüllü yerleşimler")
struct RewardedPolicyTests {
    @Test("Şans Tekrarı hayat başına bir kez")
    func luckRetryOncePerLife() {
        let context = AdContext(nowSecond: 10)
        var state = AdPolicyState()
        #expect(AdPolicy.decide(.rewardedLuckRetry, state: state, context: context) == .show)

        state = AdPolicy.registerShown(.rewardedLuckRetry, state: state, context: context)
        #expect(AdPolicy.decide(.rewardedLuckRetry, state: state, context: context)
                == .deny(.luckRetryAlreadyUsed))

        // Yeni hayat hakkı geri verir.
        state.beginNewLife()
        #expect(AdPolicy.decide(.rewardedLuckRetry, state: state, context: context) == .show)
    }

    @Test("Şans Tekrarı ölüm sonucuna uygulanamaz")
    func luckRetryCannotUndoDeath() {
        let context = AdContext(nowSecond: 10, targetsDeathOutcome: true)
        #expect(AdPolicy.decide(.rewardedLuckRetry, state: AdPolicyState(), context: context)
                == .deny(.cannotUndoDeath))
    }

    @Test("Satın alan oyuncuya ödül reklamsız verilir")
    func rewardGrantedWithoutAd() {
        let context = AdContext(nowSecond: 10, removeAdsPurchased: true)
        #expect(AdPolicy.decide(.rewardedLuckRetry, state: AdPolicyState(), context: context) == .grantWithoutAd)
        #expect(AdPolicy.decide(.rewardedExtraScene, state: AdPolicyState(), context: context) == .grantWithoutAd)
    }

    @Test("Reklamsız verilen ödül de hakkı tüketir")
    func grantedRewardConsumesAllowance() {
        let state = AdPolicy.registerGranted(.rewardedLuckRetry, state: AdPolicyState())
        #expect(state.luckRetriesThisLife == 1)
        let context = AdContext(nowSecond: 10, removeAdsPurchased: true)
        #expect(AdPolicy.decide(.rewardedLuckRetry, state: state, context: context)
                == .deny(.luckRetryAlreadyUsed))
    }

    @Test("Ekstra Sahne yıl akışında sunulmaz")
    func extraSceneNotMidYear() {
        let context = AdContext(nowSecond: 10, isMidYearFlow: true)
        #expect(AdPolicy.decide(.rewardedExtraScene, state: AdPolicyState(), context: context)
                == .deny(.midYearFlow))
    }
}

@Suite("AdPolicy — no-fill sözleşmesi")
struct AdFailureTests {
    @Test("Gösterilemeyen reklam hak yakmaz")
    func noFillKeepsAllowance() {
        // registerShown YALNIZ gerçekten gösterildiğinde çağrılır; çağrılmazsa
        // durum değişmez ve oyuncu hakkını kaybetmez.
        let state = AdPolicyState()
        let context = AdContext(nowSecond: 500, creditsCardDismissed: true)
        #expect(AdPolicy.decide(.interstitialAfterCredits, state: state, context: context) == .show)
        // (no-fill: registerShown çağrılmadı)
        #expect(AdPolicy.decide(.interstitialAfterCredits, state: state, context: context) == .show)
    }

    @Test("Banner yerleşimi diye bir şey yok")
    func noBannerPlacement() {
        #expect(AdPlacement.allCases.count == 3)
        #expect(!AdPlacement.allCases.contains { $0.rawValue.lowercased().contains("banner") })
    }
}
