/// Karar sağlayıcı: simülasyonda seed'li/senaryolu, arayüzde insan.
public protocol DecisionPolicy {
    mutating func choose(event: LifeEvent, eligibleChoices: [Choice], state: LifeState) -> ChoiceID
}

/// Seed'li rastgele karar — 10.000 hayat kapısının sürücüsü.
public struct RandomDecisionPolicy: DecisionPolicy {
    private var rng: SeededRandomSource

    public init(seed: UInt64) {
        self.rng = SeededRandomSource(seed: seed)
    }

    public mutating func choose(event: LifeEvent, eligibleChoices: [Choice], state: LifeState) -> ChoiceID {
        eligibleChoices[rng.int(in: 0...(eligibleChoices.count - 1))].id
    }
}

/// Sıralı senaryo kararları — determinizm testlerinin sürücüsü.
/// Liste biterse ilk görünür seçeneğe düşer.
public struct ScriptedDecisionPolicy: DecisionPolicy {
    private var decisions: [ChoiceID]
    private var index = 0

    public init(decisions: [ChoiceID]) {
        self.decisions = decisions
    }

    public mutating func choose(event: LifeEvent, eligibleChoices: [Choice], state: LifeState) -> ChoiceID {
        defer { index += 1 }
        if index < decisions.count,
           eligibleChoices.contains(where: { $0.id == decisions[index] }) {
            return decisions[index]
        }
        return eligibleChoices[0].id
    }
}

/// Doğumdan ölüme tam ömür sürücüsü (saf; UI hızlı-ileri sarma da bunu kullanır).
public enum LifeSimulator {
    public static func simulateLife(
        personSeed: UInt64,
        deckSeed: UInt64,
        catalog: EventCatalog,
        policy: inout some DecisionPolicy
    ) throws -> LifeState {
        var state = LifeEngine.makeLife(personSeed: personSeed, deckSeed: deckSeed, catalog: catalog)

        while state.isAlive {
            let yearStart = try LifeEngine.beginYear(state, catalog: catalog)
            state = yearStart.state

            for event in yearStart.events {
                if event.isDecision {
                    let eligible = LifeEngine.eligibleChoices(for: event, state: state)
                    // Şema kuralı (ContentLint): her karar olayında en az bir
                    // koşulsuz seçenek vardır; yine de savunmacı davran.
                    guard !eligible.isEmpty else { continue }
                    let choiceID = policy.choose(event: event, eligibleChoices: eligible, state: state)
                    state = try LifeEngine.resolve(event: event, choiceID: choiceID, state: state).state
                } else {
                    state = try LifeEngine.resolve(event: event, choiceID: nil, state: state).state
                }
            }

            state = try LifeEngine.finishYear(state).state
        }

        return state
    }
}
