/// Reklam kararları — saf, saat enjekte, testli (CLAUDE.md reklam politikası).
///
/// Bu tip `GoogleMobileAds` bilmez ve bilmemelidir: SDK yalnız app hedefindeki
/// `Services/Ads/` içinde import edilir, karar burada verilir. Böylece
/// "yıl akışının ortasında asla", "oturumda ≤1 geçişli", "≥3 dk aralık" gibi
/// kurallar `swift test` ile Xcode'suz doğrulanabilir.
public enum AdPlacement: String, Codable, Sendable, Equatable, Hashable, CaseIterable {
    /// Jenerik kartı kapatıldıktan SONRA gösterilebilen tek zorunlu reklam.
    case interstitialAfterCredits
    /// Ödüllü: Şans Tekrarı — bir sonucu yeniden çevirir.
    case rewardedLuckRetry
    /// Ödüllü: Ekstra Sahne — jeneriğe bir sahne daha ekler.
    case rewardedExtraScene

    public var isRewarded: Bool {
        switch self {
        case .interstitialAfterCredits: false
        case .rewardedLuckRetry, .rewardedExtraScene: true
        }
    }
}

/// Oturum boyunca taşınan reklam durumu.
public struct AdPolicyState: Codable, Sendable, Equatable, Hashable {
    public var interstitialsThisSession: Int
    /// Son geçişli reklamın gösterildiği an (oturum başlangıcından saniye).
    public var lastInterstitialSecond: Int?
    /// Bu hayatta Şans Tekrarı kaç kez kullanıldı.
    public var luckRetriesThisLife: Int

    public init(
        interstitialsThisSession: Int = 0,
        lastInterstitialSecond: Int? = nil,
        luckRetriesThisLife: Int = 0
    ) {
        self.interstitialsThisSession = interstitialsThisSession
        self.lastInterstitialSecond = lastInterstitialSecond
        self.luckRetriesThisLife = luckRetriesThisLife
    }

    /// Yeni hayat başlarken hayat kapsamlı sayaçlar sıfırlanır.
    public mutating func beginNewLife() {
        luckRetriesThisLife = 0
    }
}

/// Kararın verildiği andaki bağlam. Saat enjekte: `nowSecond` oturum
/// başlangıcından beri geçen saniyedir (monotonik; `Date()` kullanılmaz).
public struct AdContext: Sendable, Equatable {
    public var nowSecond: Int
    /// "Reklamları Kaldır" satın alındı mı.
    public var removeAdsPurchased: Bool
    /// Oyuncu yıl akışının ortasında mı (karar bekliyor / yıl işleniyor).
    public var isMidYearFlow: Bool
    /// Jenerik kartı kapatıldı mı.
    public var creditsCardDismissed: Bool
    /// Şans Tekrarı bir ölüm sonucuna mı uygulanacak.
    public var targetsDeathOutcome: Bool

    public init(
        nowSecond: Int,
        removeAdsPurchased: Bool = false,
        isMidYearFlow: Bool = false,
        creditsCardDismissed: Bool = false,
        targetsDeathOutcome: Bool = false
    ) {
        self.nowSecond = nowSecond
        self.removeAdsPurchased = removeAdsPurchased
        self.isMidYearFlow = isMidYearFlow
        self.creditsCardDismissed = creditsCardDismissed
        self.targetsDeathOutcome = targetsDeathOutcome
    }
}

public enum AdDenialReason: Sendable, Equatable, Hashable {
    case sessionLimitReached
    case tooSoon(remainingSeconds: Int)
    case midYearFlow
    case creditsCardStillOpen
    case luckRetryAlreadyUsed
    case cannotUndoDeath
}

public enum AdDecision: Sendable, Equatable, Hashable {
    /// Reklam gösterilebilir.
    case show
    /// Reklamsız ödül verilir — oyuncu "Reklamları Kaldır"ı satın almış.
    /// Ödülü kilitlemek satın almayı cezalandırmak olurdu (karanlık desen yasağı).
    case grantWithoutAd
    case deny(AdDenialReason)
}

public enum AdPolicy {
    /// Oturum başına en çok geçişli reklam.
    public static let maxInterstitialsPerSession = 1
    /// İki geçişli reklam arasında en az bu kadar saniye.
    public static let minimumInterstitialGapSeconds = 180
    /// Hayat başına en çok Şans Tekrarı.
    public static let maxLuckRetriesPerLife = 1

    public static func decide(
        _ placement: AdPlacement,
        state: AdPolicyState,
        context: AdContext
    ) -> AdDecision {
        switch placement {
        case .interstitialAfterCredits:
            decideInterstitial(state: state, context: context)
        case .rewardedLuckRetry:
            decideLuckRetry(state: state, context: context)
        case .rewardedExtraScene:
            decideExtraScene(context: context)
        }
    }

    private static func decideInterstitial(state: AdPolicyState, context: AdContext) -> AdDecision {
        // Satın alan oyuncu zorunlu reklam görmez; "ödül" diye bir şey de yok.
        if context.removeAdsPurchased { return .deny(.sessionLimitReached) }
        // Yıl akışının ortasında ASLA.
        if context.isMidYearFlow { return .deny(.midYearFlow) }
        // Yalnız jenerik kartı kapatıldıktan SONRA.
        guard context.creditsCardDismissed else { return .deny(.creditsCardStillOpen) }
        guard state.interstitialsThisSession < maxInterstitialsPerSession else {
            return .deny(.sessionLimitReached)
        }
        if let last = state.lastInterstitialSecond {
            let elapsed = context.nowSecond - last
            if elapsed < minimumInterstitialGapSeconds {
                return .deny(.tooSoon(remainingSeconds: minimumInterstitialGapSeconds - elapsed))
            }
        }
        return .show
    }

    private static func decideLuckRetry(state: AdPolicyState, context: AdContext) -> AdDecision {
        // Ölümü geri almak yok: hayatın sonu pazarlık konusu değildir (docs/01).
        if context.targetsDeathOutcome { return .deny(.cannotUndoDeath) }
        guard state.luckRetriesThisLife < maxLuckRetriesPerLife else {
            return .deny(.luckRetryAlreadyUsed)
        }
        return context.removeAdsPurchased ? .grantWithoutAd : .show
    }

    private static func decideExtraScene(context: AdContext) -> AdDecision {
        // Ekstra Sahne jenerik ekranında sunulur; yıl akışında yeri yok.
        if context.isMidYearFlow { return .deny(.midYearFlow) }
        return context.removeAdsPurchased ? .grantWithoutAd : .show
    }

    /// Reklam gerçekten gösterildikten sonra durumu ilerletir.
    /// No-fill/hata hâlinde ÇAĞRILMAZ — akış sessizce sürer, hak yanmaz.
    public static func registerShown(
        _ placement: AdPlacement,
        state: AdPolicyState,
        context: AdContext
    ) -> AdPolicyState {
        var new = state
        switch placement {
        case .interstitialAfterCredits:
            new.interstitialsThisSession += 1
            new.lastInterstitialSecond = context.nowSecond
        case .rewardedLuckRetry:
            new.luckRetriesThisLife += 1
        case .rewardedExtraScene:
            break
        }
        return new
    }

    /// Ödül reklamsız verildiğinde de hak tüketilir (satın alan oyuncu için
    /// limitler aynı kalır; avantajı reklam izlememektir, sınırsızlık değil).
    public static func registerGranted(
        _ placement: AdPlacement,
        state: AdPolicyState
    ) -> AdPolicyState {
        var new = state
        if placement == .rewardedLuckRetry { new.luckRetriesThisLife += 1 }
        return new
    }
}
