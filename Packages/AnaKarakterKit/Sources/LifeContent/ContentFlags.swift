import LifeDomain

// İçerik kataloğunun bayrak sözlüğü. ContentLint, koşullarda geçen her
// bayrağın (domain çekirdeği + bu liste) tanımlı olduğunu denetler.
public extension LifeFlag {
    // Çocukluk kıvılcımları
    static let kitapKurdu = LifeFlag("kitapKurdu")
    static let sporcuRuh = LifeFlag("sporcuRuh")
    static let sahneAski = LifeFlag("sahneAski")

    // Okul
    static let kanka = LifeFlag("kanka")
    static let lider = LifeFlag("lider")
    static let fenLisesi = LifeFlag("fenLisesi")

    // Yol ayrımı
    static let universiteli = LifeFlag("universiteli")
    static let stajYapti = LifeFlag("stajYapti")
    static let mezun = LifeFlag("mezun")
    static let iliskide = LifeFlag("iliskide")
    static let askerYapti = LifeFlag("askerYapti")
    static let gonullu = LifeFlag("gonullu")
    static let ehliyetVar = LifeFlag("ehliyetVar")

    // Kuruluş
    static let calisiyor = LifeFlag("calisiyor")
    static let evli = LifeFlag("evli")
    static let cocukVar = LifeFlag("cocukVar")
    static let evSahibi = LifeFlag("evSahibi")
    static let arabaVar = LifeFlag("arabaVar")
    static let girisimciRuh = LifeFlag("girisimciRuh")
    static let iyiKomsu = LifeFlag("iyiKomsu")

    // Orta sahne / final
    static let hobiUstasi = LifeFlag("hobiUstasi")
    static let emekli = LifeFlag("emekli")
    static let torunVar = LifeFlag("torunVar")

    // Faz 2 zincirleri
    static let evcilDost = LifeFlag("evcilDost")
    static let teknoMeraki = LifeFlag("teknoMeraki")
}

/// Katalogda kullanılabilir bayrakların tam listesi (lint denetimi için).
public enum ContentFlags {
    public static let all: Set<LifeFlag> = [
        .kadin, .erkek,
        .kitapKurdu, .sporcuRuh, .sahneAski,
        .kanka, .lider, .fenLisesi,
        .universiteli, .stajYapti, .mezun, .iliskide, .askerYapti, .gonullu, .ehliyetVar,
        .calisiyor, .evli, .cocukVar, .evSahibi, .arabaVar, .girisimciRuh, .iyiKomsu,
        .hobiUstasi, .emekli, .torunVar,
        .evcilDost, .teknoMeraki,
    ]
}
