@testable import LifeDomain

/// Birim testleri için küçük, kontrollü içerik parçaları.
enum Fixture {
    static let pools = PersonPools(
        femaleNames: ["Test Kadın"],
        maleNames: ["Test Erkek"],
        neighborhoods: ["Test Mahalle"]
    )

    static func text(_ raw: String) -> EventText {
        EventText(key: "test.\(raw)", tr: raw)
    }

    static func catalog(_ events: [LifeEvent]) -> EventCatalog {
        EventCatalog(events: events, pools: pools)
    }

    static func state(
        age: Int = 0,
        health: Int = 80,
        happiness: Int = 60,
        intelligence: Int = 60,
        social: Int = 60,
        ake: Int = 50,
        money: Int = 0,
        flags: Set<LifeFlag> = [.kadin],
        deckSeed: UInt64 = 42
    ) -> LifeState {
        var state = LifeState(
            person: Person(name: "Test Kadın", gender: .kadin, birthYear: 1990, neighborhood: "Test Mahalle"),
            personSeed: 1,
            deckSeed: deckSeed,
            stats: StatBlock(health: health, happiness: happiness, intelligence: intelligence,
                             social: social, ake: ake, money: money),
            flags: flags
        )
        state.age = age
        return state
    }

    static func news(_ id: String, seasons: Set<Season> = [.cocukluk], w: Int = 10,
                     cond: [Condition] = [], cd: Cooldown = .oncePerLife,
                     fx: [Effect] = [.stat(.happiness, 1)]) -> LifeEvent {
        LifeEvent(id: EventID(id), trigger: .pool(seasons: seasons), conditions: cond,
                  weight: w, cooldown: cd, text: text(id), choices: [], onOccur: fx)
    }

    static func decision(_ id: String, seasons: Set<Season> = [.cocukluk], w: Int = 10,
                         cond: [Condition] = [], cd: Cooldown = .oncePerLife,
                         choices: [Choice]) -> LifeEvent {
        LifeEvent(id: EventID(id), trigger: .pool(seasons: seasons), conditions: cond,
                  weight: w, cooldown: cd, text: text(id), choices: choices)
    }

    static func milestone(_ id: String, age: Int, cond: [Condition] = [],
                          fx: [Effect] = [], choices: [Choice] = []) -> LifeEvent {
        LifeEvent(id: EventID(id), trigger: .milestone(age: age), conditions: cond,
                  text: text(id), choices: choices, onOccur: fx)
    }

    static func choice(_ raw: String, _ boldness: Boldness = .neutral,
                       cond: [Condition] = [], outcomes: [Outcome]) -> Choice {
        Choice(id: ChoiceID(raw), text: text(raw), boldness: boldness,
               conditions: cond, outcomes: outcomes)
    }

    static func outcome(_ raw: String, w: Int = 1, fx: [Effect] = [],
                        follow: FollowUp? = nil) -> Outcome {
        Outcome(weight: w, text: text(raw), effects: fx, followUp: follow)
    }
}
