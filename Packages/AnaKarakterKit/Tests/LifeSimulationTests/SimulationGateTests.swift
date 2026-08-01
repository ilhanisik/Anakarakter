import Testing
import Foundation
import LifeDomain
import LifeContent

/// Build Kalite Kapısı: 10.000 seed'li otomatik ömür koşusu (CLAUDE.md).
/// Invariant'lar: çıkmaz hayat yok, stat sınırları korunur, soğuma/kilometre
/// taşı kuralları log'dan doğrulanır, ölüm yaş dağılımı bantta, her olay
/// en az bir hayatta tetiklenir (reachability).
@Suite("10.000 hayat simülasyon kapısı")
struct SimulationGateTests {
    static let lifeCount = 10_000

    /// Tek koşuda tüm invariant'lar — 10k hayat bir kez simüle edilir.
    @Test("10.000 seed'li ömür: invariant'lar ve kapsama", .timeLimit(.minutes(5)))
    func tenThousandLives() throws {
        let catalog = ContentCatalog.catalog
        let allEventIDs = Set(catalog.events.map(\.id))
        var triggeredEventIDs = Set<EventID>()
        var deathAges: [Int] = []
        deathAges.reserveCapacity(Self.lifeCount)
        var totalDistinctEvents = 0 // çeşitlilik metriği (docs/03 risk tablosu)

        for seed in 0..<Self.lifeCount {
            var policy = RandomDecisionPolicy(seed: UInt64(seed) &+ 0xDECAF)
            let life = try LifeSimulator.simulateLife(
                personSeed: UInt64(seed),
                deckSeed: UInt64(seed) &* 31 &+ 7,
                catalog: catalog,
                policy: &policy
            )

            // Çıkmaz hayat yok: her hayat ölümle biter, yaş bantta.
            #expect(!life.isAlive)
            let deathAge = try #require(life.deathAge)
            #expect((0...LifeDomain.maximumAge).contains(deathAge))
            deathAges.append(deathAge)

            // Stat sınırları (clamp) korunmuş.
            let stats = life.stats
            for stat in Stat.allCases {
                #expect(StatBlock.statRange.contains(stats[stat]))
            }
            #expect(stats.money >= 0)

            // Log tutarlılığı: katalog dışı olay yok; kilometre taşları kendi
            // yaşında; soğuma kuralı ihlal edilmemiş.
            var occurrences: [EventID: [Int]] = [:]
            for entry in life.log {
                let event = try #require(catalog.event(id: entry.eventID))
                triggeredEventIDs.insert(entry.eventID)
                occurrences[entry.eventID, default: []].append(entry.age)
                if case let .milestone(age) = event.trigger {
                    #expect(entry.age == age, "\(event.id.rawValue) kilometre taşı yanlış yaşta")
                }
            }
            totalDistinctEvents += occurrences.count
            for (eventID, ages) in occurrences {
                let event = try #require(catalog.event(id: eventID))
                switch event.cooldown {
                case .oncePerLife:
                    #expect(ages.count == 1, "\(eventID.rawValue) oncePerLife ama \(ages.count) kez")
                case let .years(gap):
                    for pair in zip(ages, ages.dropFirst()) {
                        #expect(pair.1 - pair.0 >= gap, "\(eventID.rawValue) soğuma ihlali")
                    }
                }
            }
        }

        // Ölüm yaşı dağılımı: ortalama 70–85 bandında (docs/03 kabul kriteri).
        let mean = Double(deathAges.reduce(0, +)) / Double(deathAges.count)
        #expect((70.0...85.0).contains(mean), "ortalama ölüm yaşı \(mean)")

        // Reachability: her olay 10.000 hayatın en az birinde tetiklendi.
        let unreached = allEventIDs.subtracting(triggeredEventIDs)
        #expect(unreached.isEmpty, "ulaşılmayan olaylar: \(unreached.map(\.rawValue).sorted())")

        // Çeşitlilik: bir ömürde ortalama tekil olay sayısı — tekrar
        // oynanabilirlik erken tükenmesin (docs/03 risk tablosu).
        let averageDistinct = Double(totalDistinctEvents) / Double(Self.lifeCount)
        #expect(averageDistinct >= 30.0, "ömür başına ortalama tekil olay \(averageDistinct)")
    }

    @Test("Determinizm: aynı seed + aynı kararlar = bit-bit aynı hayat")
    func determinism() throws {
        let catalog = ContentCatalog.catalog
        var policyA = RandomDecisionPolicy(seed: 424242)
        var policyB = RandomDecisionPolicy(seed: 424242)
        let a = try LifeSimulator.simulateLife(personSeed: 100, deckSeed: 200, catalog: catalog, policy: &policyA)
        let b = try LifeSimulator.simulateLife(personSeed: 100, deckSeed: 200, catalog: catalog, policy: &policyB)
        #expect(a == b)
        #expect(a.hashValue == b.hashValue)
    }

    @Test("Farklı deste seed'i farklı hayat üretir")
    func differentSeedsDiverge() throws {
        let catalog = ContentCatalog.catalog
        var policyA = RandomDecisionPolicy(seed: 1)
        var policyB = RandomDecisionPolicy(seed: 1)
        let a = try LifeSimulator.simulateLife(personSeed: 100, deckSeed: 200, catalog: catalog, policy: &policyA)
        let b = try LifeSimulator.simulateLife(personSeed: 100, deckSeed: 201, catalog: catalog, policy: &policyB)
        #expect(a != b)
    }

    @Test("Ara kayıttan devam determinizmi bozmaz (Codable snapshot)")
    func codableRoundtripContinuation() throws {
        let catalog = ContentCatalog.catalog

        // Referans: kesintisiz 30 yıl.
        var reference = LifeEngine.makeLife(personSeed: 55, deckSeed: 66, catalog: catalog)
        var scripted = ScriptedDecisionPolicy(decisions: [])
        reference = try Self.advance(reference, years: 30, catalog: catalog, policy: &scripted)

        // Aynı hayat: 15. yılda JSON'a yaz, geri yükle, devam et.
        var snapshotRun = LifeEngine.makeLife(personSeed: 55, deckSeed: 66, catalog: catalog)
        var scripted2 = ScriptedDecisionPolicy(decisions: [])
        snapshotRun = try Self.advance(snapshotRun, years: 15, catalog: catalog, policy: &scripted2)
        let data = try JSONEncoder().encode(snapshotRun)
        var restored = try JSONDecoder().decode(LifeState.self, from: data)
        restored = try Self.advance(restored, years: 15, catalog: catalog, policy: &scripted2)

        #expect(reference == restored)
    }

    @Test("Günün Hayatı: aynı tarih aynı hayatı üretir")
    func dailyLifeDeterminism() throws {
        let catalog = ContentCatalog.catalog
        let seeds = DailyLifeSelector.seeds(for: DailyDate(year: 2026, month: 8, day: 1))
        var policyA = ScriptedDecisionPolicy(decisions: [])
        var policyB = ScriptedDecisionPolicy(decisions: [])
        let a = try LifeSimulator.simulateLife(personSeed: seeds.personSeed, deckSeed: seeds.deckSeed, catalog: catalog, policy: &policyA)
        let b = try LifeSimulator.simulateLife(personSeed: seeds.personSeed, deckSeed: seeds.deckSeed, catalog: catalog, policy: &policyB)
        #expect(a == b)
        #expect(a.person == b.person)
    }

    @Test("Performans: yıl geçişi ortalaması < 5 ms")
    func yearAdvancePerformance() throws {
        let catalog = ContentCatalog.catalog
        var totalYears = 0
        let clock = ContinuousClock()

        let elapsed = try clock.measure {
            for seed in 0..<200 {
                var policy = RandomDecisionPolicy(seed: UInt64(seed))
                let life = try LifeSimulator.simulateLife(
                    personSeed: UInt64(seed) &+ 90_000,
                    deckSeed: UInt64(seed) &+ 91_000,
                    catalog: catalog,
                    policy: &policy
                )
                totalYears += (life.deathAge ?? 0) + 1
            }
        }

        let perYear = elapsed / totalYears
        #expect(perYear < .milliseconds(5), "yıl geçişi ortalaması \(perYear)")
    }

    private static func advance(
        _ input: LifeState, years: Int, catalog: EventCatalog,
        policy: inout some DecisionPolicy
    ) throws -> LifeState {
        var state = input
        for _ in 0..<years {
            guard state.isAlive else { break }
            let yearStart = try LifeEngine.beginYear(state, catalog: catalog)
            state = yearStart.state
            for event in yearStart.events {
                if event.isDecision {
                    let eligible = LifeEngine.eligibleChoices(for: event, state: state)
                    guard !eligible.isEmpty else { continue }
                    let choice = policy.choose(event: event, eligibleChoices: eligible, state: state)
                    state = try LifeEngine.resolve(event: event, choiceID: choice, state: state).state
                } else {
                    state = try LifeEngine.resolve(event: event, choiceID: nil, state: state).state
                }
            }
            state = try LifeEngine.finishYear(state).state
        }
        return state
    }
}
