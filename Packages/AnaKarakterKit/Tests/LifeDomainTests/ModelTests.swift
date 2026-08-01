import Testing
@testable import LifeDomain

@Suite("StatBlock")
struct StatBlockTests {
    @Test("Statlar 0–100'e kilitlenir (üst sınır)")
    func clampUpper() {
        var stats = StatBlock(health: 95, happiness: 50, intelligence: 50, social: 50, ake: 50, money: 0)
        stats.add(20, to: .health)
        #expect(stats.health == 100)
    }

    @Test("Statlar 0–100'e kilitlenir (alt sınır)")
    func clampLower() {
        var stats = StatBlock(health: 5, happiness: 50, intelligence: 50, social: 50, ake: 50, money: 0)
        stats.add(-20, to: .health)
        #expect(stats.health == 0)
    }

    @Test("Kurucu da taşan değerleri kilitler")
    func initClamps() {
        let stats = StatBlock(health: 150, happiness: -10, intelligence: 50, social: 50, ake: 50, money: -500)
        #expect(stats.health == 100)
        #expect(stats.happiness == 0)
        #expect(stats.money == 0)
    }

    @Test("Para 0'ın altına inmez")
    func moneyFloor() {
        var stats = StatBlock(health: 50, happiness: 50, intelligence: 50, social: 50, ake: 50, money: 1_000)
        stats.addMoney(-5_000)
        #expect(stats.money == 0)
        stats.addMoney(300)
        #expect(stats.money == 300)
    }

    @Test("Subscript tüm statları okur", arguments: Stat.allCases)
    func subscriptReads(stat: Stat) {
        let stats = StatBlock(health: 10, happiness: 20, intelligence: 30, social: 40, ake: 50, money: 0)
        let expected: [Stat: Int] = [.health: 10, .happiness: 20, .intelligence: 30, .social: 40, .ake: 50]
        #expect(stats[stat] == expected[stat])
    }
}

@Suite("Season")
struct SeasonTests {
    @Test("Yaş → sezon eşlemesi", arguments: [
        (0, Season.cocukluk), (5, .cocukluk),
        (6, .okul), (17, .okul),
        (18, .yolAyrimi), (24, .yolAyrimi),
        (25, .kurulus), (39, .kurulus),
        (40, .ortaSahne), (64, .ortaSahne),
        (65, .finalSezonu), (110, .finalSezonu),
    ])
    func ageMapping(age: Int, expected: Season) {
        #expect(Season.forAge(age) == expected)
    }

    @Test("Sezon bantları boşluksuz ve çakışmasız 0–110'u kapsar")
    func bandsCoverAllAges() {
        for age in 0...LifeDomain.maximumAge {
            let matches = Season.allCases.filter { $0.ageRange.contains(age) }
            #expect(matches.count == 1, "yaş \(age) tek sezona düşmeli")
        }
    }
}

@Suite("Condition")
struct ConditionTests {
    @Test("Stat koşulları")
    func statConditions() {
        let state = Fixture.state(intelligence: 60)
        #expect(Condition.minStat(.intelligence, 60).isSatisfied(by: state))
        #expect(!Condition.minStat(.intelligence, 61).isSatisfied(by: state))
        #expect(Condition.maxStat(.intelligence, 60).isSatisfied(by: state))
        #expect(!Condition.maxStat(.intelligence, 59).isSatisfied(by: state))
    }

    @Test("Bayrak koşulları")
    func flagConditions() {
        let state = Fixture.state(flags: [.kadin, LifeFlag("kanka")])
        #expect(Condition.hasFlag(LifeFlag("kanka")).isSatisfied(by: state))
        #expect(!Condition.hasFlag(LifeFlag("evli")).isSatisfied(by: state))
        #expect(Condition.lacksFlag(LifeFlag("evli")).isSatisfied(by: state))
        #expect(!Condition.lacksFlag(LifeFlag("kanka")).isSatisfied(by: state))
    }

    @Test("Para koşulları ve boş liste")
    func moneyConditions() {
        let state = Fixture.state(money: 5_000)
        #expect(Condition.minMoney(5_000).isSatisfied(by: state))
        #expect(!Condition.minMoney(5_001).isSatisfied(by: state))
        #expect(Condition.maxMoney(5_000).isSatisfied(by: state))
        #expect([Condition]().allSatisfied(by: state)) // koşulsuz olay her zaman uygun
    }
}

@Suite("Effect uygulama")
struct EffectTests {
    @Test("Stat, para, bayrak ve gelir etkileri")
    func applyEffects() {
        var state = Fixture.state(money: 1_000)
        state.apply([
            .stat(.happiness, 5),
            .money(2_000),
            .setFlag(LifeFlag("evli")),
            .annualIncome(80_000),
        ])
        #expect(state.stats.happiness == 65)
        #expect(state.stats.money == 3_000)
        #expect(state.flags.contains(LifeFlag("evli")))
        #expect(state.annualIncome == 80_000)

        state.apply(.clearFlag(LifeFlag("evli")))
        #expect(!state.flags.contains(LifeFlag("evli")))
    }

    @Test("AKE zirvesi izlenir, düşüşte geri sarmaz")
    func akePeakTracking() {
        var state = Fixture.state(ake: 50)
        state.apply(.stat(.ake, 30))
        #expect(state.peakAKE == 80)
        state.apply(.stat(.ake, -40))
        #expect(state.stats.ake == 40)
        #expect(state.peakAKE == 80)
    }

    @Test("Aynı jenerik rolü iki kez yazılmaz")
    func creditDedup() {
        var state = Fixture.state()
        let role = Fixture.text("rol")
        state.apply(.credit(role))
        state.apply(.credit(role))
        #expect(state.credits.count == 1)
    }
}
