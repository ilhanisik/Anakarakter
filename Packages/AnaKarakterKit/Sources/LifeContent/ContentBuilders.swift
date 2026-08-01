import LifeDomain

// İçerik DSL'i — katalog dosyalarını kısa ve okunur tutar.
// Anahtar üretimi tek yerden: "event.<id>", "event.<id>.<seçenek>",
// "event.<id>.<seçenek>.o<n>", "credit.<id>".

func t(_ key: String, _ tr: String) -> EventText {
    EventText(key: key, tr: tr)
}

func news(
    _ id: String, seasons: Set<Season>, w: Int = 10,
    cond: [Condition] = [], cd: Cooldown = .oncePerLife,
    tr: String, fx: [Effect] = []
) -> LifeEvent {
    LifeEvent(
        id: EventID(id), trigger: .pool(seasons: seasons), conditions: cond,
        weight: w, cooldown: cd, text: t("event.\(id)", tr), choices: [], onOccur: fx
    )
}

func decision(
    _ id: String, seasons: Set<Season>, w: Int = 10,
    cond: [Condition] = [], cd: Cooldown = .oncePerLife,
    tr: String, choices: [Choice]
) -> LifeEvent {
    LifeEvent(
        id: EventID(id), trigger: .pool(seasons: seasons), conditions: cond,
        weight: w, cooldown: cd, text: t("event.\(id)", tr), choices: choices
    )
}

func milestone(
    _ id: String, age: Int, cond: [Condition] = [],
    tr: String, choices: [Choice] = [], fx: [Effect] = []
) -> LifeEvent {
    LifeEvent(
        id: EventID(id), trigger: .milestone(age: age), conditions: cond,
        text: t("event.\(id)", tr), choices: choices, onOccur: fx
    )
}

/// Yalnız takip zinciriyle gelen olay (havuzdan asla çekilmez).
func chained(
    _ id: String, cond: [Condition] = [],
    tr: String, choices: [Choice] = [], fx: [Effect] = []
) -> LifeEvent {
    LifeEvent(
        id: EventID(id), trigger: .followUpOnly, conditions: cond,
        text: t("event.\(id)", tr), choices: choices, onOccur: fx
    )
}

func choice(
    _ eventID: String, _ raw: String, _ boldness: Boldness,
    cond: [Condition] = [], tr: String, outcomes: [Outcome]
) -> Choice {
    Choice(
        id: ChoiceID(raw), text: t("event.\(eventID).\(raw)", tr),
        boldness: boldness, conditions: cond, outcomes: outcomes
    )
}

func outcome(
    _ eventID: String, _ choiceRaw: String, _ n: Int, w: Int = 1,
    tr: String, fx: [Effect] = [], follow: FollowUp? = nil
) -> Outcome {
    Outcome(weight: w, text: t("event.\(eventID).\(choiceRaw).o\(n)", tr), effects: fx, followUp: follow)
}

// Etki kısayolları.
func hp(_ d: Int) -> Effect { .stat(.happiness, d) }
func hl(_ d: Int) -> Effect { .stat(.health, d) }
func iq(_ d: Int) -> Effect { .stat(.intelligence, d) }
func so(_ d: Int) -> Effect { .stat(.social, d) }
func tl(_ d: Int) -> Effect { .money(d) }
func flag(_ f: LifeFlag) -> Effect { .setFlag(f) }
func unflag(_ f: LifeFlag) -> Effect { .clearFlag(f) }
func income(_ v: Int) -> Effect { .annualIncome(v) }
func rol(_ id: String, _ tr: String) -> Effect { .credit(t("credit.\(id)", tr)) }

func follow(_ id: String, delay: Int) -> FollowUp {
    FollowUp(eventID: EventID(id), delayYears: delay)
}
