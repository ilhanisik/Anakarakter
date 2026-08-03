import Foundation
import AppPolicy

/// AdMob birim kimlikleri.
///
/// Debug'da Google'ın resmî test kimlikleri kullanılır; gerçek kimlikler
/// yalnız Release'e girer (docs/02). Geliştirme sırasında canlı envantere
/// istek göndermek AdMob politika ihlalidir ve hesabı riske atar.
///
/// SAHİP'in AdMob konsolunda açtığı 6 birimden yalnız 2'si burada yer alır:
/// banner, yerel gelişmiş ve uygulama açılışı biçimleri CLAUDE.md reklam
/// politikasıyla çelişir ("banner ASLA"; geçişli yalnız jenerik sonrası).
/// Kullanılmayan birimler kasıtlı olarak bağlanmamıştır.
enum AdUnits {
    /// Info.plist'teki `GADApplicationIdentifier` ile aynı olmalıdır.
    static let applicationID = "ca-app-pub-9761096075581160~6562713925"

    #if DEBUG
    static let interstitial = "ca-app-pub-3940256099942544/4411468910"
    static let rewarded = "ca-app-pub-3940256099942544/1712485313"
    #else
    static let interstitial = "ca-app-pub-9761096075581160/5249632253"
    static let rewarded = "ca-app-pub-9761096075581160/7005567052"
    #endif

    /// Her yerleşimin hangi birimden yükleneceği. İki ödüllü yerleşim aynı
    /// birimi paylaşır; ayrı raporlama istenirse konsolda ikinci bir ödüllü
    /// birim açılıp burada ayrıştırılır.
    static func unitID(for placement: AdPlacement) -> String {
        switch placement {
        case .interstitialAfterCredits: interstitial
        case .rewardedLuckRetry, .rewardedExtraScene: rewarded
        }
    }
}
