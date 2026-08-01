import Observation
import LifeDomain

/// Bir ömür akışının durumu: yıl geç → olaylar → kararlar → jenerik.
/// Motor saf domain'de; bu tip yalnız sunum durumunu yönetir.
@Observable
@MainActor
final class LifeFlowViewModel {
    enum Phase: Equatable {
        /// "Yılı Yaşa" düğmesi aktif.
        case readyForYear
        /// Karar kartı ekranda; oyuncunun seçimi bekleniyor.
        case decision(LifeEvent)
        /// Hayat bitti; jenerik verisi hazır.
        case ended(CreditsCard)
    }

    struct TimelineItem: Identifiable, Equatable {
        enum Kind: Equatable {
            case yearMarker(age: Int, season: Season)
            case moment(text: String, deltas: String?)
            case finale(name: String, birthYear: Int, finalYear: Int)
        }

        let id: Int
        let kind: Kind
    }

    private let catalog: EventCatalog
    private let seedSource: any SeedSource

    private(set) var state: LifeState
    private(set) var timeline: [TimelineItem] = []
    private(set) var phase: Phase = .readyForYear
    private var pendingEvents: [LifeEvent] = []
    private var itemCounter = 0

    init(personSeed: UInt64, deckSeed: UInt64, catalog: EventCatalog, seedSource: any SeedSource) {
        self.catalog = catalog
        self.seedSource = seedSource
        self.state = LifeEngine.makeLife(personSeed: personSeed, deckSeed: deckSeed, catalog: catalog)
    }

    /// Karar kartındaki görünür seçenekler.
    var eligibleChoices: [Choice] {
        guard case let .decision(event) = phase else { return [] }
        return LifeEngine.eligibleChoices(for: event, state: state)
    }

    // MARK: Oyuncu eylemleri

    func liveYear() {
        guard phase == .readyForYear, state.isAlive else { return }
        do {
            let yearStart = try LifeEngine.beginYear(state, catalog: catalog)
            state = yearStart.state
            pendingEvents = yearStart.events
            append(.yearMarker(age: state.age, season: state.season))
            processNextEvent()
        } catch {
            assertionFailure("beginYear sözleşme ihlali: \(error)")
        }
    }

    func choose(_ choiceID: ChoiceID) {
        guard case let .decision(event) = phase else { return }
        phase = .readyForYear
        resolveAndAppend(event: event, choiceID: choiceID)
        processNextEvent()
    }

    /// "Bir hayat daha" — döngünün kalbi (docs/01).
    func startNewLife() {
        let seeds = seedSource.makeSeeds()
        state = LifeEngine.makeLife(personSeed: seeds.personSeed, deckSeed: seeds.deckSeed, catalog: catalog)
        timeline = []
        pendingEvents = []
        itemCounter = 0
        phase = .readyForYear
    }

    // MARK: Yıl akışı

    private func processNextEvent() {
        while !pendingEvents.isEmpty {
            let event = pendingEvents.removeFirst()
            if event.isDecision {
                guard !LifeEngine.eligibleChoices(for: event, state: state).isEmpty else { continue }
                // Olay metni şeride girer; kart seçimleri gösterir. VoiceOver
                // doğal sırası: olay → seçenekler → sonuç.
                append(.moment(text: event.text.resolved, deltas: nil))
                phase = .decision(event)
                return
            }
            resolveAndAppend(event: event, choiceID: nil)
        }
        finishYear()
    }

    private func resolveAndAppend(event: LifeEvent, choiceID: ChoiceID?) {
        do {
            let resolution = try LifeEngine.resolve(event: event, choiceID: choiceID, state: state)
            state = resolution.state
            append(.moment(
                text: resolution.text.resolved,
                deltas: Self.deltaSummary(effects: resolution.effects, akeDelta: resolution.akeDelta)
            ))
        } catch {
            assertionFailure("resolve sözleşme ihlali: \(error)")
        }
    }

    private func finishYear() {
        do {
            let yearEnd = try LifeEngine.finishYear(state)
            state = yearEnd.state
            if yearEnd.died {
                let person = state.person
                let finalYear = person.birthYear + (state.deathAge ?? state.age)
                append(.finale(name: person.name, birthYear: person.birthYear, finalYear: finalYear))
                phase = .ended(CreditsComposer.compose(from: state))
            } else {
                phase = .readyForYear
            }
        } catch {
            assertionFailure("finishYear sözleşme ihlali: \(error)")
        }
    }

    private func append(_ kind: TimelineItem.Kind) {
        itemCounter += 1
        timeline.append(TimelineItem(id: itemCounter, kind: kind))
    }

    /// Sonuç etkilerini kısa bir özet satırına çevirir: "Mutluluk +5 · AKE +6".
    /// AKE, cesaret bonusuyla birlikte `akeDelta`dan okunur (çift sayım yok).
    private static func deltaSummary(effects: [Effect], akeDelta: Int) -> String? {
        var parts: [String] = []
        for effect in effects {
            switch effect {
            case let .stat(stat, delta) where stat != .ake && delta != 0:
                parts.append("\(stat.localizedName) \(delta.signedFormatted)")
            case let .money(amount) where amount != 0:
                parts.append("\(String(localized: "stat.money")) \(amount > 0 ? "+" : "−")\(abs(amount).liraFormatted)")
            default:
                break
            }
        }
        if akeDelta != 0 {
            parts.append("\(String(localized: "stat.ake")) \(akeDelta.signedFormatted)")
        }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
}

private extension Int {
    var signedFormatted: String {
        self > 0 ? "+\(formatted())" : "−\(abs(self).formatted())"
    }
}
