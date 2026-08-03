import Testing
@testable import LifeDomain

@Suite("LuckRetry — Şans Tekrarı")
struct LuckRetryTests {
    /// İki sonuçlu cesur seçim: zar gerçekten farklı düşebilmeli.
    private func event() -> LifeEvent {
        Fixture.decision("karar", choices: [
            Fixture.choice("cesur", .bold, outcomes: [
                Fixture.outcome("iyi", fx: [.stat(.happiness, 10)]),
                Fixture.outcome("kotu", fx: [.stat(.happiness, -10)]),
            ]),
            Fixture.choice("guvenli", .safe, outcomes: [Fixture.outcome("sakin", fx: [])]),
        ])
    }

    @Test("Geri sarma karar öncesi statları geri getirir")
    func rewindRestoresStats() throws {
        let before = Fixture.state(age: 20, happiness: 50)
        let after = try LifeEngine.resolve(
            event: event(), choiceID: ChoiceID("cesur"), state: before
        ).state
        #expect(after.stats.happiness != 50 || after.log.count == 1)

        let rewound = LuckRetry.rewind(to: before, keepingRandomnessOf: after)
        #expect(rewound.stats.happiness == 50)
        #expect(rewound.log.isEmpty)
        #expect(rewound.lastOccurrenceAge.isEmpty)
    }

    @Test("Rastgelelik ilerlemiş kalır — tekrar aynı sonucu vermez")
    func rewindKeepsAdvancedRandomness() throws {
        let before = Fixture.state(age: 20, happiness: 50)
        let after = try LifeEngine.resolve(
            event: event(), choiceID: ChoiceID("cesur"), state: before
        ).state

        let rewound = LuckRetry.rewind(to: before, keepingRandomnessOf: after)
        // RNG geri sarılmadı: aynı anlık görüntüden farklı bir yol açılır.
        #expect(rewound.rng != before.rng)
        #expect(rewound.rng == after.rng)
    }

    @Test("Tekrar deterministiktir: aynı girdi aynı ikinci sonucu verir")
    func retryIsDeterministic() throws {
        func run() throws -> LifeState {
            let before = Fixture.state(age: 20, happiness: 50)
            let first = try LifeEngine.resolve(
                event: event(), choiceID: ChoiceID("cesur"), state: before
            ).state
            let rewound = LuckRetry.rewind(to: before, keepingRandomnessOf: first)
            return try LifeEngine.resolve(
                event: event(), choiceID: ChoiceID("cesur"), state: rewound
            ).state
        }
        #expect(try run() == run())
    }

    @Test("Ölmüş hayat tekrara uygun değildir")
    func deathIsNotEligible() {
        var state = Fixture.state(age: 80)
        #expect(LuckRetry.isEligible(state))
        state.isAlive = false
        #expect(!LuckRetry.isEligible(state))
    }

    @Test("Tekrar sonrası günlükte tek kayıt kalır")
    func logHasSingleEntryAfterRetry() throws {
        let before = Fixture.state(age: 20, happiness: 50)
        let first = try LifeEngine.resolve(
            event: event(), choiceID: ChoiceID("cesur"), state: before
        ).state
        let rewound = LuckRetry.rewind(to: before, keepingRandomnessOf: first)
        let second = try LifeEngine.resolve(
            event: event(), choiceID: ChoiceID("cesur"), state: rewound
        ).state
        #expect(second.log.count == 1, "iptal edilen sonuç jenerikte anılmamalı")
    }
}

@Suite("CreditsComposer — Ekstra Sahne")
struct ExtraSceneTests {
    @Test("Sahne sayısı ödülle uzatılabilir")
    func extendedSceneCount() throws {
        var state = Fixture.state(age: 0, ake: 40)
        // Farklı yaşlarda beş cesur an üret.
        let event = Fixture.decision("k", choices: [
            Fixture.choice("cesur", .bold, outcomes: [Fixture.outcome("o", fx: [])]),
        ])
        for age in [5, 20, 35, 50, 70] {
            state.age = age
            state = try LifeEngine.resolve(event: event, choiceID: ChoiceID("cesur"), state: state).state
            state.lastOccurrenceAge = [:] // soğuma testin konusu değil
        }
        state.deathAge = 70
        state.isAlive = false

        let normal = CreditsComposer.compose(from: state)
        let extended = CreditsComposer.compose(from: state, sceneCount: CreditsComposer.extendedSceneCount)
        #expect(normal.memorableScenes.count == 3)
        #expect(extended.memorableScenes.count == 4)
        #expect(extended.lifeScore == normal.lifeScore, "ödül puanı değiştirmez — yalnız kartı uzatır")
    }
}
