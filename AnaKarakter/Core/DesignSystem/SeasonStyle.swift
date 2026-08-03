import SwiftUI
import LifeDomain

/// Sezon paletleri ve poster motifleri — token disiplini (renkler asset
/// katalogundan gelir, Light/Dark varyantlı).
extension Season {
    var accent: Color {
        switch self {
        case .cocukluk: Color("SeasonCocukluk")
        case .okul: Color("SeasonOkul")
        case .yolAyrimi: Color("SeasonYolAyrimi")
        case .kurulus: Color("SeasonKurulus")
        case .ortaSahne: Color("SeasonOrtaSahne")
        case .finalSezonu: Color("SeasonFinalSezonu")
        }
    }

    /// Sezonun **dolgu** rengi: afiş ve zemin için canlı marka tonu.
    /// `accent` ise METİN/İKON içindir ve aydınlık zeminde okunabilsin diye
    /// koyudur. Rengi karartmak yerine üstündeki metni koyulaştırmak hem
    /// kontrastı hem kimliği korur (bkz. GoldButtonStyle).
    var fill: Color {
        switch self {
        case .cocukluk: Color("SeasonCocuklukFill")
        case .okul: Color("SeasonOkulFill")
        case .yolAyrimi: Color("SeasonYolAyrimiFill")
        case .kurulus: Color("SeasonKurulusFill")
        case .ortaSahne: Color("SeasonOrtaSahneFill")
        case .finalSezonu: Color("SeasonFinalSezonuFill")
        }
    }

    /// Poster motifi (SF Symbol).
    var posterSymbol: String {
        switch self {
        case .cocukluk: "sun.max.fill"
        case .okul: "backpack.fill"
        case .yolAyrimi: "signpost.right.and.left.fill"
        case .kurulus: "house.fill"
        case .ortaSahne: "theatermasks.fill"
        case .finalSezonu: "sunset.fill"
        }
    }

    /// Afişteki perde numarası — hayat altı perdelik bir oyundur.
    var actNumber: Int {
        (Season.allCases.firstIndex(of: self) ?? 0) + 1
    }

    /// Perde numarasının roma rakamı (afiş künyesi).
    var actNumeral: String {
        ["I", "II", "III", "IV", "V", "VI"][min(actNumber - 1, 5)]
    }
}
