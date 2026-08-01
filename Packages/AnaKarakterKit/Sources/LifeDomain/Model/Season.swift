/// Yaş dönemleri — dizi diliyle "sezonlar" (docs/01 GDD).
public enum Season: String, CaseIterable, Codable, Sendable, Equatable, Hashable {
    case cocukluk      // 0–5: aile, mahalle, ilk kıvılcım
    case okul          // 6–17: LGS, harçlık, ilk arkadaşlıklar
    case yolAyrimi     // 18–24: ÖSYM, üniversite/çalışma, askerlik, ilk aşk
    case kurulus       // 25–39: kariyer, kira/ev, evlilik, çocuk
    case ortaSahne     // 40–64: zirve/kriz, sağlık uyarıları
    case finalSezonu   // 65+: emeklilik, torunlar, jenerik hazırlığı

    public var ageRange: ClosedRange<Int> {
        switch self {
        case .cocukluk: 0...5
        case .okul: 6...17
        case .yolAyrimi: 18...24
        case .kurulus: 25...39
        case .ortaSahne: 40...64
        case .finalSezonu: 65...LifeDomain.maximumAge
        }
    }

    public static func forAge(_ age: Int) -> Season {
        for season in allCases where season.ageRange.contains(age) {
            return season
        }
        // Negatif yaş domain hatasıdır; en yakın anlamlı sezona düşür.
        return age < 0 ? .cocukluk : .finalSezonu
    }
}
