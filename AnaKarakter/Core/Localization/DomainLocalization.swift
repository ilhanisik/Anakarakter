import SwiftUI
import LifeDomain

extension Season {
    /// Sezonun yerelleştirilmiş adı (String Catalog).
    var localizedName: String {
        switch self {
        case .cocukluk: String(localized: "season.cocukluk")
        case .okul: String(localized: "season.okul")
        case .yolAyrimi: String(localized: "season.yolAyrimi")
        case .kurulus: String(localized: "season.kurulus")
        case .ortaSahne: String(localized: "season.ortaSahne")
        case .finalSezonu: String(localized: "season.finalSezonu")
        }
    }
}

extension Stat {
    /// Statın yerelleştirilmiş kısa adı.
    var localizedName: String {
        switch self {
        case .health: String(localized: "stat.health")
        case .happiness: String(localized: "stat.happiness")
        case .intelligence: String(localized: "stat.intelligence")
        case .social: String(localized: "stat.social")
        case .ake: String(localized: "stat.ake")
        }
    }

    /// VoiceOver için tam ad (AKE kısaltması açılır).
    var accessibilityName: String {
        self == .ake ? String(localized: "stat.ake.full") : localizedName
    }

    var symbolName: String {
        switch self {
        case .health: "heart.fill"
        case .happiness: "face.smiling"
        case .intelligence: "brain.head.profile"
        case .social: "person.2.fill"
        case .ake: "sparkles"
        }
    }

    /// Dekoratif renk — bilgi her zaman ikon + metin + sayı ile taşınır.
    /// Semantik stat rengi. Ham sistem renkleri (`.red`, `.orange`…)
    /// kullanılmaz: hem token disiplinine aykırı hem de aydınlık zeminde
    /// kontrastı yetersiz (Faz 5 erişilebilirlik denetiminde düştüler).
    /// Renk tek başına bilgi taşımaz; ikon + ad + sayı her zaman yanındadır.
    var tint: Color {
        switch self {
        case .health: Color("StatHealth")
        case .happiness: Color("StatHappiness")
        case .intelligence: Color("StatIntelligence")
        case .social: Color("StatSocial")
        case .ake: Color("StatAKE")
        }
    }
}

/// Para biçimlendirme — tek adres (`formatted()` zorunluluğu, CLAUDE.md).
extension Int {
    var liraFormatted: String {
        formatted(.currency(code: "TRY").precision(.fractionLength(0)))
    }
}
