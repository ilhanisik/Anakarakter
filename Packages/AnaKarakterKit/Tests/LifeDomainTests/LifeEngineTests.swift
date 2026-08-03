import Testing
@testable import LifeDomain

@Suite("LifeEngine")
struct LifeEngineTests {
    @Test("beginYear geliri işler ve yaşla sağlık erozyonu uygular")
    func beginYearIncomeAndErosion() throws {
        let catalog = Fixture.catalog([])
        var state = Fixture.state(age: 50, health: 80, money: 1_000)
        state.annualIncome = 10_000

        let yearStart = try LifeEngine.beginYear(state, catalog: catalog)
        #expect(yearStart.state.stats.money == 11_000)
        #expect(yearStart.state.stats.health == 79) // 45+ → yılda -1

        var elder = Fixture.state(age: 75, health: 80)
        elder.annualIncome = 0
        let elderStart = try LifeEngine.beginYear(elder, catalog: catalog)
        #expect(elderStart.state.stats.health == 78) // 70+ → yılda -2

        let young = Fixture.state(age: 20, health: 80)
        let youngStart = try LifeEngine.beginYear(young, catalog: catalog)
        #expect(youngStart.state.stats.health == 80) // gençlikte erozyon yok
    }

    @Test("Haber olayı etkilerini uygular ve günlüğe yazar")
    func newsResolution() throws {
        let event = Fixture.news("haber", fx: [.stat(.happiness, 3)])
        let state = Fixture.state(age: 4, happiness: 60)
        let resolution = try LifeEngine.resolve(event: event, choiceID: nil, state: state)
        #expect(resolution.state.stats.happiness == 63)
        #expect(resolution.state.log.count == 1)
        #expect(resolution.state.log[0].eventID == event.id)
        #expect(resolution.state.lastOccurrenceAge[event.id] == 4)
    }

    @Test("Karar olayı: cesaret AKE'si + sonuç etkileri + günlük")
    func decisionResolution() throws {
        let event = Fixture.decision("karar", choices: [
            Fixture.choice("cesur", .bold, outcomes: [Fixture.outcome("olumlu", fx: [.stat(.social, 5)])]),
            Fixture.choice("temkinli", .safe, outcomes: [Fixture.outcome("sakin", fx: [])]),
        ])
        let state = Fixture.state(age: 10, social: 50, ake: 50)

        // Cesaret bonusu azalan verimlidir: AKE 50'de ham +6 → uygulanan +3.
        let bold = try LifeEngine.resolve(event: event, choiceID: ChoiceID("cesur"), state: state)
        #expect(bold.state.stats.ake == 53)
        #expect(bold.state.stats.social == 55)
        #expect(bold.akeDelta == 3)
        // Sahne ağırlığı ham cesaret etkisini korur — jenerik sahne seçimi
        // AKE tavanından/eğrisinden etkilenmez.
        #expect(bold.state.log[0].sceneWeight == 6)
        #expect(bold.state.log[0].choiceID == ChoiceID("cesur"))

        // Güvenli seçimin bedeli AKE seviyesinden bağımsız, sabit.
        let safe = try LifeEngine.resolve(event: event, choiceID: ChoiceID("temkinli"), state: state)
        #expect(safe.state.stats.ake == 47) // safe: -3
    }

    @Test("Aynı cesaret düşük AKE'de çok, yüksek AKE'de az yükseltir")
    func boldGainDiminishes() throws {
        let event = Fixture.decision("karar", choices: [
            Fixture.choice("cesur", .bold, outcomes: [Fixture.outcome("olumlu", fx: [])]),
            Fixture.choice("temkinli", .safe, outcomes: [Fixture.outcome("sakin", fx: [])]),
        ])
        func gain(atAKE ake: Int) throws -> Int {
            try LifeEngine.resolve(
                event: event, choiceID: ChoiceID("cesur"), state: Fixture.state(age: 30, ake: ake)
            ).akeDelta
        }
        #expect(try gain(atAKE: 0) == 6)
        #expect(try gain(atAKE: 50) == 3)
        #expect(try gain(atAKE: 80) == 1)
        // Tavana yakınken cesaret artık yükseltmez; gösterge doyuma ulaşmaz.
        #expect(try gain(atAKE: 95) == 0)
    }

    @Test("AKE doğal erozyonu 6 yaşından itibaren işler, ceza kapısı açmaz")
    func akeErosion() throws {
        let catalog = Fixture.catalog([])
        let child = try LifeEngine.beginYear(Fixture.state(age: 3, ake: 50), catalog: catalog)
        #expect(child.state.stats.ake == 50) // çocuklukta erozyon yok

        let adult = try LifeEngine.beginYear(Fixture.state(age: 30, ake: 50), catalog: catalog)
        #expect(adult.state.stats.ake == 48) // 6+ → yılda -2

        // Erozyon AKE'yi negatife düşürmez (clamp korunur).
        let empty = try LifeEngine.beginYear(Fixture.state(age: 30, ake: 0), catalog: catalog)
        #expect(empty.state.stats.ake == 0)
    }

    @Test("AKE tavandayken bile cesur seçim sahne ağırlığı taşır")
    func sceneWeightSurvivesClamp() throws {
        let event = Fixture.decision("karar", choices: [
            Fixture.choice("cesur", .bold, outcomes: [Fixture.outcome("o", fx: [.stat(.ake, 4)])]),
        ])
        // AKE zaten tavanda: stat değişimi 0 ama sahne ağırlığı 6 + 4 = 10.
        let maxed = Fixture.state(ake: 100)
        let resolution = try LifeEngine.resolve(event: event, choiceID: ChoiceID("cesur"), state: maxed)
        #expect(resolution.akeDelta == 0)
        #expect(resolution.state.log[0].sceneWeight == 10)
    }

    @Test("Takip olayı en az 1 yıl gecikmeyle kuyruğa girer")
    func followUpQueued() throws {
        let event = Fixture.decision("kaynak", choices: [
            Fixture.choice("sec", outcomes: [
                Fixture.outcome("son", fx: [], follow: FollowUp(eventID: EventID("hedef"), delayYears: 2)),
            ]),
        ])
        let state = Fixture.state(age: 10)
        let resolution = try LifeEngine.resolve(event: event, choiceID: ChoiceID("sec"), state: state)
        #expect(resolution.state.followUpQueue == [ScheduledFollowUp(eventID: EventID("hedef"), dueAge: 12)])
    }

    @Test("Sözleşme ihlalleri hata fırlatır")
    func errorPaths() throws {
        let decision = Fixture.decision("karar", choices: [
            Fixture.choice("acik", outcomes: [Fixture.outcome("o")]),
            Fixture.choice("kapili", cond: [.minStat(.intelligence, 99)], outcomes: [Fixture.outcome("o2")]),
        ])
        let state = Fixture.state(age: 10, intelligence: 50)

        #expect(throws: LifeEngineError.decisionRequired(decision.id)) {
            try LifeEngine.resolve(event: decision, choiceID: nil, state: state)
        }
        #expect(throws: LifeEngineError.unknownChoice(decision.id, ChoiceID("yok"))) {
            try LifeEngine.resolve(event: decision, choiceID: ChoiceID("yok"), state: state)
        }
        #expect(throws: LifeEngineError.choiceNotEligible(decision.id, ChoiceID("kapili"))) {
            try LifeEngine.resolve(event: decision, choiceID: ChoiceID("kapili"), state: state)
        }

        var dead = Fixture.state()
        dead.isAlive = false
        #expect(throws: LifeEngineError.lifeAlreadyEnded) {
            try LifeEngine.beginYear(dead, catalog: Fixture.catalog([]))
        }
    }

    @Test("Görünür seçenekler koşula göre süzülür")
    func eligibleChoicesFiltering() {
        let event = Fixture.decision("karar", choices: [
            Fixture.choice("herkese", outcomes: [Fixture.outcome("o")]),
            Fixture.choice("zekiye", cond: [.minStat(.intelligence, 70)], outcomes: [Fixture.outcome("o2")]),
        ])
        let ordinary = Fixture.state(intelligence: 50)
        #expect(LifeEngine.eligibleChoices(for: event, state: ordinary).map(\.id) == [ChoiceID("herkese")])
        let bright = Fixture.state(intelligence: 80)
        #expect(LifeEngine.eligibleChoices(for: event, state: bright).count == 2)
    }

    @Test("Üst yaş sınırında finishYear kesin ölümle biter")
    func finishYearDeathAtMaxAge() throws {
        var state = Fixture.state(age: LifeDomain.maximumAge, health: 100)
        state.age = LifeDomain.maximumAge
        let yearEnd = try LifeEngine.finishYear(state)
        #expect(yearEnd.died)
        #expect(!yearEnd.state.isAlive)
        #expect(yearEnd.state.deathAge == LifeDomain.maximumAge)
    }

    @Test("Hayatta kalınan yıl yaşı bir artırır")
    func survivingYearIncrementsAge() throws {
        let state = Fixture.state(age: 10, health: 95)
        let yearEnd = try LifeEngine.finishYear(state)
        // 10 yaş + 95 sağlıkta ölüm olasılığı ~0.0001; bu seed'le hayatta kalınır.
        #expect(!yearEnd.died)
        #expect(yearEnd.state.age == 11)
    }
}

@Suite("LifeScore ve CreditsComposer")
struct ScoringTests {
    @Test("Hayat Puanı formülü şeffaftır")
    func scoreFormula() {
        var state = Fixture.state(health: 40, happiness: 40, intelligence: 40, social: 40, ake: 30)
        state.deathAge = 80
        state.peakAKE = 90
        state.credits = [Fixture.text("rol1"), Fixture.text("rol2")]
        // 80 + (160/8=20) + 90 + 2*5 = 200
        #expect(LifeScore.score(for: state) == 200)
    }

    @Test("Düşük AKE cezalandırmaz — bileşen yalnız ekler")
    func lowAKENotPenalized() {
        var quiet = Fixture.state(ake: 0)
        quiet.peakAKE = 0
        quiet.deathAge = 70
        var flashy = quiet
        flashy.peakAKE = 100
        #expect(LifeScore.score(for: quiet) >= 70) // AKE 0 olsa bile taban puan yaş + denge
        #expect(LifeScore.score(for: flashy) == LifeScore.score(for: quiet) + 100)
    }

    @Test("Jenerik: en yüksek 3 AKE sıçraması kronolojik sırayla seçilir")
    func topScenesSelection() {
        var state = Fixture.state()
        state.deathAge = 70
        state.log = [
            LifeLogEntry(age: 10, eventID: EventID("a"), choiceID: nil, text: Fixture.text("a"), akeDelta: 6, akeAfter: 56, sceneWeight: 6),
            LifeLogEntry(age: 20, eventID: EventID("b"), choiceID: nil, text: Fixture.text("b"), akeDelta: 2, akeAfter: 58, sceneWeight: 2),
            LifeLogEntry(age: 30, eventID: EventID("c"), choiceID: nil, text: Fixture.text("c"), akeDelta: 9, akeAfter: 67, sceneWeight: 9),
            LifeLogEntry(age: 40, eventID: EventID("d"), choiceID: nil, text: Fixture.text("d"), akeDelta: -3, akeAfter: 64, sceneWeight: -3),
            LifeLogEntry(age: 50, eventID: EventID("e"), choiceID: nil, text: Fixture.text("e"), akeDelta: 7, akeAfter: 71, sceneWeight: 7),
        ]
        let card = CreditsComposer.compose(from: state)
        #expect(card.memorableScenes.map(\.age) == [10, 30, 50]) // en büyük 3 delta: 9,7,6 → kronolojik
    }

    @Test("Jenerik sahneleri üç perdeye yayılır — tek döneme yığılmaz")
    func scenesSpreadAcrossActs() {
        var state = Fixture.state()
        state.deathAge = 90
        // Çocuklukta üç eşit güçte sahne + orta ve final perdelerde birer sahne.
        state.log = [1, 2, 3, 40, 70].map { age in
            LifeLogEntry(age: age, eventID: EventID("e\(age)"), choiceID: nil,
                         text: Fixture.text("s\(age)"), akeDelta: 6, akeAfter: 60, sceneWeight: 6)
        }
        let card = CreditsComposer.compose(from: state)
        // Eski kural [1,2,3] seçerdi; perde kuralı ömrün tamamını anar.
        #expect(card.memorableScenes.map(\.age) == [1, 40, 70])
    }

    @Test("Jenerik kartı kimlik ve yıl aralığını doğru kurar")
    func cardIdentity() {
        var state = Fixture.state()
        state.deathAge = 84
        state.credits = [Fixture.text("rol")]
        let card = CreditsComposer.compose(from: state)
        #expect(card.name == "Test Kadın")
        #expect(card.birthYear == 1990)
        #expect(card.finalYear == 2074)
        #expect(card.roles.count == 1)
        #expect(card.lifeScore == LifeScore.score(for: state))
    }
}

@Suite("DailyLifeSelector")
struct DailyLifeSelectorTests {
    @Test("Aynı tarih her cihazda aynı seed çiftini üretir")
    func sameDateSameSeeds() {
        let date = DailyDate(year: 2026, month: 8, day: 1)
        let a = DailyLifeSelector.seeds(for: date)
        let b = DailyLifeSelector.seeds(for: date)
        #expect(a == b)
    }

    @Test("Farklı günler farklı hayatlar üretir")
    func differentDatesDiffer() {
        let today = DailyLifeSelector.seeds(for: DailyDate(year: 2026, month: 8, day: 1))
        let tomorrow = DailyLifeSelector.seeds(for: DailyDate(year: 2026, month: 8, day: 2))
        #expect(today != tomorrow)
    }
}
