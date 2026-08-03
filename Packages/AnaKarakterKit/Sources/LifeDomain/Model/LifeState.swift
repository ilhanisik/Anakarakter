/// Yaşanmış bir sahnenin günlük kaydı — jenerik kartının hammaddesi.
public struct LifeLogEntry: Codable, Sendable, Equatable, Hashable {
    public let age: Int
    public let eventID: EventID
    public let choiceID: ChoiceID?
    public let text: EventText
    /// Statta gerçekleşen AKE değişimi (0–100 clamp'ine tabi).
    public let akeDelta: Int
    public let akeAfter: Int
    /// Sahnenin "ana karakterlik" ağırlığı: uygulanmak İSTENEN ham AKE etkisi.
    /// AKE tavana vurduğunda `akeDelta` 0'a düşer; jenerik sahne seçimi bu
    /// yüzden clamp'ten etkilenmeyen bu değere bakar (yoksa jenerik yalnız
    /// AKE'nin dolduğu ilk yılları anardı).
    public let sceneWeight: Int

    public init(
        age: Int, eventID: EventID, choiceID: ChoiceID?, text: EventText,
        akeDelta: Int, akeAfter: Int, sceneWeight: Int
    ) {
        self.age = age
        self.eventID = eventID
        self.choiceID = choiceID
        self.text = text
        self.akeDelta = akeDelta
        self.akeAfter = akeAfter
        self.sceneWeight = sceneWeight
    }
}

/// Kuyruğa alınmış takip olayı.
public struct ScheduledFollowUp: Codable, Sendable, Equatable, Hashable {
    public let eventID: EventID
    public let dueAge: Int

    public init(eventID: EventID, dueAge: Int) {
        self.eventID = eventID
        self.dueAge = dueAge
    }
}

/// Tam oyun durumu — Codable snapshot. Determinizm sözleşmesi:
/// `(personSeed, deckSeed, [kararlar])` → bit-bit aynı `LifeState`.
/// RNG durumu state'in İÇİNDEDİR; ara kayıttan devam da deterministiktir.
public struct LifeState: Codable, Sendable, Equatable, Hashable {
    public let person: Person
    public let personSeed: UInt64
    public let deckSeed: UInt64

    public internal(set) var age: Int
    public internal(set) var stats: StatBlock
    public internal(set) var flags: Set<LifeFlag>
    public internal(set) var annualIncome: Int
    public internal(set) var peakAKE: Int
    public internal(set) var isAlive: Bool
    public internal(set) var deathAge: Int?
    public internal(set) var credits: [EventText]
    public internal(set) var log: [LifeLogEntry]
    public internal(set) var lastOccurrenceAge: [EventID: Int]
    public internal(set) var followUpQueue: [ScheduledFollowUp]
    public internal(set) var rng: SeededRandomSource

    public var season: Season { Season.forAge(age) }

    public init(person: Person, personSeed: UInt64, deckSeed: UInt64, stats: StatBlock, flags: Set<LifeFlag>) {
        self.person = person
        self.personSeed = personSeed
        self.deckSeed = deckSeed
        self.age = 0
        self.stats = stats
        self.flags = flags
        self.annualIncome = 0
        self.peakAKE = stats.ake
        self.isAlive = true
        self.deathAge = nil
        self.credits = []
        self.log = []
        self.lastOccurrenceAge = [:]
        self.followUpQueue = []
        self.rng = SeededRandomSource(seed: deckSeed)
    }

    /// Tek etki uygular; AKE zirvesini izler.
    mutating func apply(_ effect: Effect) {
        switch effect {
        case let .stat(stat, delta):
            stats.add(delta, to: stat)
            if stat == .ake { peakAKE = max(peakAKE, stats.ake) }
        case let .money(delta):
            stats.addMoney(delta)
        case let .setFlag(flag):
            flags.insert(flag)
        case let .clearFlag(flag):
            flags.remove(flag)
        case let .annualIncome(amount):
            annualIncome = max(0, amount)
        case let .credit(text):
            // Aynı rol iki kez yazılmaz — jenerik kartı tekrarsız kalır.
            if !credits.contains(text) { credits.append(text) }
        }
    }

    mutating func apply(_ effects: [Effect]) {
        for effect in effects { apply(effect) }
    }
}
