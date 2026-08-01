/// Seed'li karakter üretimi: isim, cinsiyet, doğum yılı, mahalle ve
/// başlangıç statları tek seed'den türetilir.
public enum PersonGenerator {
    public static let defaultBirthYearRange: ClosedRange<Int> = 1975...2005

    public static func makePerson(
        seed: UInt64,
        pools: PersonPools,
        birthYearRange: ClosedRange<Int> = defaultBirthYearRange
    ) -> Person {
        var rng = SeededRandomSource(seed: seed)
        let gender: Person.Gender = rng.roll(probability: 0.5) ? .kadin : .erkek
        let names = gender == .kadin ? pools.femaleNames : pools.maleNames
        let name = names[rng.int(in: 0...(names.count - 1))]
        let birthYear = rng.int(in: birthYearRange)
        let neighborhood = pools.neighborhoods[rng.int(in: 0...(pools.neighborhoods.count - 1))]
        return Person(name: name, gender: gender, birthYear: birthYear, neighborhood: neighborhood)
    }

    /// Başlangıç statları: orta bantta, seed'e göre hafif dağılımlı.
    /// AKE herkes için 50'den başlar — ana karakterlik seçimlerle kazanılır.
    public static func makeInitialStats(seed: UInt64) -> StatBlock {
        var rng = SeededRandomSource(seed: seed &+ 0xBEBE)
        return StatBlock(
            health: rng.int(in: 70...95),
            happiness: rng.int(in: 55...80),
            intelligence: rng.int(in: 40...80),
            social: rng.int(in: 40...80),
            ake: 50,
            money: 0
        )
    }
}
