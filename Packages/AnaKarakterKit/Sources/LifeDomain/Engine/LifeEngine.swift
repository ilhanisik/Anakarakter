/// Motor hataları — içerik/çağrı sözleşmesi ihlalleri.
public enum LifeEngineError: Error, Equatable, Sendable {
    case lifeAlreadyEnded
    case decisionRequired(EventID)
    case unknownChoice(EventID, ChoiceID)
    case choiceNotEligible(EventID, ChoiceID)
}

/// Yıl başlangıcı: ekonomi/erozyon işlenmiş durum + yılın olayları.
public struct YearStart: Sendable, Equatable {
    public let state: LifeState
    public let events: [LifeEvent]
}

/// Tek olayın çözümü.
public struct EventResolution: Sendable, Equatable {
    public let state: LifeState
    public let text: EventText
    public let effects: [Effect]
    public let akeDelta: Int
}

/// Yıl sonu: ölüm zarı atılmış durum.
public struct YearEnd: Sendable, Equatable {
    public let state: LifeState
    public let died: Bool
}

/// Saf fonksiyon zinciri — durum alır, yeni durum döner; hiçbir şey saklamaz.
///
/// Bir yılın akışı (sıra determinizmin parçasıdır):
/// `beginYear` (gelir + doğal erozyon + deste çekilişi) →
/// her olay için `resolve` (karar + sonuç zarı + etkiler) →
/// `finishYear` (ölüm zarı; hayattaysa yaş +1).
public enum LifeEngine {
    // MARK: Hayat kurulumu

    public static func makeLife(personSeed: UInt64, deckSeed: UInt64, catalog: EventCatalog) -> LifeState {
        let person = PersonGenerator.makePerson(seed: personSeed, pools: catalog.pools)
        let stats = PersonGenerator.makeInitialStats(seed: personSeed)
        let genderFlag: LifeFlag = person.gender == .kadin ? .kadin : .erkek
        return LifeState(
            person: person,
            personSeed: personSeed,
            deckSeed: deckSeed,
            stats: stats,
            flags: [genderFlag]
        )
    }

    // MARK: Yıl akışı

    public static func beginYear(_ input: LifeState, catalog: EventCatalog) throws -> YearStart {
        guard input.isAlive else { throw LifeEngineError.lifeAlreadyEnded }
        var state = input

        // Yıllık ekonomi.
        if state.annualIncome > 0 {
            state.stats.addMoney(state.annualIncome)
        }

        // Yaşla doğal sağlık erozyonu (docs/01 stat tablosu).
        if state.age >= 70 {
            state.stats.add(-2, to: .health)
        } else if state.age >= 45 {
            state.stats.add(-1, to: .health)
        }

        let events = EventDeck.drawYearEvents(state: &state, catalog: catalog)
        return YearStart(state: state, events: events)
    }

    /// Olayın şu anki durumda görünür seçenekleri.
    public static func eligibleChoices(for event: LifeEvent, state: LifeState) -> [Choice] {
        event.choices.filter { $0.conditions.allSatisfied(by: state) }
    }

    public static func resolve(event: LifeEvent, choiceID: ChoiceID?, state input: LifeState) throws -> EventResolution {
        guard input.isAlive else { throw LifeEngineError.lifeAlreadyEnded }
        var state = input
        state.lastOccurrenceAge[event.id] = state.age

        // Haber olayı: etkiler doğrudan uygulanır.
        guard event.isDecision else {
            state.apply(event.onOccur)
            let akeAfter = state.stats.ake
            state.log.append(LifeLogEntry(
                age: state.age, eventID: event.id, choiceID: nil,
                text: event.text, akeDelta: 0, akeAfter: akeAfter
            ))
            return EventResolution(state: state, text: event.text, effects: event.onOccur, akeDelta: 0)
        }

        // Karar olayı: seçim zorunlu ve görünür olmalı.
        guard let choiceID else { throw LifeEngineError.decisionRequired(event.id) }
        guard let choice = event.choices.first(where: { $0.id == choiceID }) else {
            throw LifeEngineError.unknownChoice(event.id, choiceID)
        }
        guard choice.conditions.allSatisfied(by: state) else {
            throw LifeEngineError.choiceNotEligible(event.id, choiceID)
        }

        // Cesaret AKE'si + sonuç zarı + etkiler.
        let akeBefore = state.stats.ake
        state.apply(.stat(.ake, choice.boldness.akeDelta))
        let outcome = OutcomeRoller.roll(outcomes: choice.outcomes, rng: &state.rng)

        var appliedEffects: [Effect] = []
        var resolutionText = choice.text
        if let outcome {
            state.apply(outcome.effects)
            appliedEffects = outcome.effects
            resolutionText = outcome.text
            if let followUp = outcome.followUp {
                state.followUpQueue.append(ScheduledFollowUp(
                    eventID: followUp.eventID,
                    dueAge: state.age + max(1, followUp.delayYears)
                ))
            }
        }

        let akeDelta = state.stats.ake - akeBefore
        state.log.append(LifeLogEntry(
            age: state.age, eventID: event.id, choiceID: choiceID,
            text: resolutionText, akeDelta: akeDelta, akeAfter: state.stats.ake
        ))
        return EventResolution(state: state, text: resolutionText, effects: appliedEffects, akeDelta: akeDelta)
    }

    public static func finishYear(_ input: LifeState) throws -> YearEnd {
        guard input.isAlive else { throw LifeEngineError.lifeAlreadyEnded }
        var state = input

        let died = DeathModel.rollDeath(age: state.age, health: state.stats.health, rng: &state.rng)
        if died {
            state.isAlive = false
            state.deathAge = state.age
        } else {
            state.age += 1
        }
        return YearEnd(state: state, died: died)
    }
}
