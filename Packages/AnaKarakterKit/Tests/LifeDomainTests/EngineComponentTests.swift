import Testing
@testable import LifeDomain

@Suite("OutcomeRoller")
struct OutcomeRollerTests {
    @Test("Aynı rng durumu aynı sonucu verir")
    func deterministic() {
        let outcomes = [Fixture.outcome("a"), Fixture.outcome("b"), Fixture.outcome("c")]
        var rng1 = SeededRandomSource(seed: 11)
        var rng2 = SeededRandomSource(seed: 11)
        for _ in 0..<50 {
            #expect(OutcomeRoller.roll(outcomes: outcomes, rng: &rng1)
                 == OutcomeRoller.roll(outcomes: outcomes, rng: &rng2))
        }
    }

    @Test("Ağırlıklar dağılıma yansır")
    func respectsWeights() {
        let outcomes = [Fixture.outcome("sik", w: 9), Fixture.outcome("nadir", w: 1)]
        var rng = SeededRandomSource(seed: 3)
        var frequent = 0, rare = 0
        for _ in 0..<2_000 {
            let rolled = OutcomeRoller.roll(outcomes: outcomes, rng: &rng)
            if rolled == outcomes[0] { frequent += 1 } else { rare += 1 }
        }
        #expect(frequent > rare * 5)
        #expect(rare > 0)
    }

    @Test("Boş sonuç listesi nil döner")
    func emptyOutcomes() {
        var rng = SeededRandomSource(seed: 1)
        #expect(OutcomeRoller.roll(outcomes: [], rng: &rng) == nil)
    }
}

@Suite("DeathModel")
struct DeathModelTests {
    @Test("Ölüm olasılığı yaşla monoton artar")
    func monotonicInAge() {
        var previous = -1.0
        for age in stride(from: 0, through: 100, by: 10) {
            let p = DeathModel.annualDeathProbability(age: age, health: 80)
            #expect(p > previous)
            previous = p
        }
    }

    @Test("Düşük sağlık riski büyütür")
    func healthPenalty() {
        let healthy = DeathModel.annualDeathProbability(age: 60, health: 90)
        let frail = DeathModel.annualDeathProbability(age: 60, health: 20)
        #expect(frail > healthy)
    }

    @Test("Üst yaş sınırında olasılık 1'dir — çıkmaz hayat yok")
    func capAge() {
        #expect(DeathModel.annualDeathProbability(age: LifeDomain.maximumAge, health: 100) == 1.0)
    }

    @Test("Sağlık 0 akut risk ekler")
    func zeroHealthAcuteRisk() {
        let p = DeathModel.annualDeathProbability(age: 30, health: 0)
        #expect(p > 0.5)
    }

    @Test("Genç ve sağlıklı için yıllık risk çok düşüktür")
    func youngRiskTiny() {
        #expect(DeathModel.annualDeathProbability(age: 10, health: 90) < 0.001)
    }
}

@Suite("PersonGenerator")
struct PersonGeneratorTests {
    @Test("Aynı seed aynı kişiyi üretir")
    func deterministic() {
        let a = PersonGenerator.makePerson(seed: 777, pools: Fixture.pools)
        let b = PersonGenerator.makePerson(seed: 777, pools: Fixture.pools)
        #expect(a == b)
    }

    @Test("İsim cinsiyete uygun havuzdan gelir; doğum yılı bantta")
    func poolsAndBirthYear() {
        for seed in 0..<50 {
            let person = PersonGenerator.makePerson(seed: UInt64(seed), pools: Fixture.pools)
            switch person.gender {
            case .kadin: #expect(person.name == "Test Kadın")
            case .erkek: #expect(person.name == "Test Erkek")
            }
            #expect(PersonGenerator.defaultBirthYearRange.contains(person.birthYear))
        }
    }

    @Test("Başlangıç statları makul bantlarda, AKE 50")
    func initialStats() {
        for seed in 0..<50 {
            let stats = PersonGenerator.makeInitialStats(seed: UInt64(seed))
            #expect((70...95).contains(stats.health))
            #expect(stats.ake == 50)
            #expect(stats.money == 0)
        }
    }
}

@Suite("EventDeck")
struct EventDeckTests {
    @Test("Kilometre taşı kendi yaşında garanti çekilir")
    func milestoneGuaranteed() {
        let ms = Fixture.milestone("ms.test", age: 7, fx: [.stat(.happiness, 1)])
        let catalog = Fixture.catalog([ms])
        var state = Fixture.state(age: 7)
        let events = EventDeck.drawYearEvents(state: &state, catalog: catalog)
        #expect(events.contains(ms))

        var other = Fixture.state(age: 8)
        let otherEvents = EventDeck.drawYearEvents(state: &other, catalog: catalog)
        #expect(!otherEvents.contains(ms))
    }

    @Test("oncePerLife olay tekrarlanmaz")
    func cooldownOnce() {
        let event = Fixture.news("tek")
        var state = Fixture.state(age: 2)
        state.lastOccurrenceAge[event.id] = 1
        #expect(!EventDeck.cooldownAllows(event, state: state))
    }

    @Test("years(n) soğuması aradaki yılı sayar")
    func cooldownYears() {
        let event = Fixture.news("tekrar", cd: .years(3))
        var state = Fixture.state(age: 3)
        state.lastOccurrenceAge[event.id] = 1
        #expect(!EventDeck.cooldownAllows(event, state: state)) // 2 yıl geçti, 3 gerek
        state.age = 4
        #expect(EventDeck.cooldownAllows(event, state: state))
    }

    @Test("Koşulu sağlamayan olay desteye girmez")
    func conditionFilter() {
        let gated = Fixture.news("kapili", cond: [.minStat(.intelligence, 90)])
        let open = Fixture.news("acik")
        let catalog = Fixture.catalog([gated, open])
        var state = Fixture.state(age: 1, intelligence: 50)
        let events = EventDeck.drawYearEvents(state: &state, catalog: catalog)
        #expect(!events.contains(gated))
    }

    @Test("Vadesi gelen takip olayı çekilir, kuyruktan düşer")
    func followUpDueDrawn() {
        let chain = LifeEvent(id: EventID("zincir"), trigger: .followUpOnly,
                              text: Fixture.text("zincir"), onOccur: [.stat(.happiness, 1)])
        let catalog = Fixture.catalog([chain])
        var state = Fixture.state(age: 5)
        state.followUpQueue = [
            ScheduledFollowUp(eventID: chain.id, dueAge: 5),
            ScheduledFollowUp(eventID: chain.id, dueAge: 9),
        ]
        let events = EventDeck.drawYearEvents(state: &state, catalog: catalog)
        #expect(events.contains(chain))
        #expect(state.followUpQueue == [ScheduledFollowUp(eventID: chain.id, dueAge: 9)])
    }

    @Test("Havuz çekilişi yıllık olay bandını aşmaz")
    func targetBand() {
        let pool = (0..<20).map { Fixture.news("olay\($0)", cd: .years(1)) }
        let catalog = Fixture.catalog(pool)
        for seed in 0..<30 {
            var state = Fixture.state(age: 1, deckSeed: UInt64(seed))
            let events = EventDeck.drawYearEvents(state: &state, catalog: catalog)
            #expect(LifeDomain.eventsPerYear.contains(events.count))
        }
    }
}
