import Foundation
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
            case seasonPoster(season: Season, variantSeed: UInt64)
            case moment(text: String, deltas: String?)
            case finale(name: String, birthYear: Int, finalYear: Int)
        }

        let id: Int
        let kind: Kind
    }

    private let catalog: EventCatalog
    private let seedSource: any SeedSource
    private let audio: AudioService
    private let dateProvider: any DateProviding
    private let archive: any LifeArchiveRepository
    private let dailyRuns: any DailyRunRepository

    /// Son karar öncesi anlık görüntü — Şans Tekrarı bunu geri sarar.
    private var snapshotBeforeDecision: LifeState?
    /// Şans Tekrarı bu karar için sunulabilir mi (henüz kullanılmadıysa).
    private(set) var canOfferLuckRetry = false
    /// Jenerik kartına eklenecek sahne sayısı (Ekstra Sahne ödülü uzatır).
    private(set) var creditsSceneCount = CreditsComposer.sceneCount

    private var personSeed: UInt64
    private var deckSeed: UInt64
    private var mode: LifeMode

    /// Bu ömrün arşiv kaydı (biterse yazılır).
    private(set) var archivedID: UUID?
    /// Günün Hayatı bu koşuda seriyi nasıl etkiledi (jenerik ekranı gösterir).
    private(set) var streakOutcome: StreakRules.Outcome?
    private(set) var streakAfterRun: StreakState?

    private(set) var state: LifeState
    private(set) var timeline: [TimelineItem] = []
    private(set) var phase: Phase = .readyForYear
    /// Haptik tetikleyicisi: her çözülen kararda artar.
    private(set) var decisionCount = 0

    // MARK: Sunum vurguları (arayüz kutlama/sarsıntı için izler)

    /// Başarı anı sayacı — yeni bir jenerik rolü kazanılınca artar (konfeti).
    private(set) var celebrationCount = 0
    /// Olumsuz sonuç sayacı — materyal etki eksiye düşünce artar (sarsıntı).
    private(set) var setbackCount = 0
    /// Kartta gösterilen son olayın kendi metni (soru/durum).
    private(set) var lastPromptText: String?
    /// Kartta gösterilen son sonuç metni.
    private(set) var lastOutcomeText: String?
    private(set) var lastOutcomeDeltas: String?
    private(set) var lastOutcomeWasSetback = false
    private var pendingEvents: [LifeEvent] = []
    private var itemCounter = 0
    private var postedSeasons: Set<Season> = []
    private var lastDecision: (event: LifeEvent, choiceID: ChoiceID)?

    var isEnded: Bool {
        if case .ended = phase { return true }
        return false
    }

    init(
        personSeed: UInt64, deckSeed: UInt64, mode: LifeMode, catalog: EventCatalog,
        seedSource: any SeedSource, audio: AudioService, dateProvider: any DateProviding,
        archive: any LifeArchiveRepository, dailyRuns: any DailyRunRepository
    ) {
        self.personSeed = personSeed
        self.deckSeed = deckSeed
        self.mode = mode
        self.catalog = catalog
        self.seedSource = seedSource
        self.audio = audio
        self.dateProvider = dateProvider
        self.archive = archive
        self.dailyRuns = dailyRuns
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

            // Yeni sezona giriş: jeneratif poster (koleksiyon + paylaşım anı).
            if !postedSeasons.contains(state.season) {
                postedSeasons.insert(state.season)
                append(.seasonPoster(
                    season: state.season,
                    variantSeed: state.personSeed ^ UInt64(state.age &+ 1)
                ))
            }

            append(.yearMarker(age: state.age, season: state.season))
            audio.play(.yearTick)
            processNextEvent()
        } catch {
            assertionFailure("beginYear sözleşme ihlali: \(error)")
        }
    }

    func choose(_ choiceID: ChoiceID) {
        guard case let .decision(event) = phase else { return }
        phase = .readyForYear
        decisionCount += 1
        // Şans Tekrarı için karar öncesine dönebilmek adına anlık görüntü.
        snapshotBeforeDecision = state
        lastDecision = (event, choiceID)
        resolveAndAppend(event: event, choiceID: choiceID)
        canOfferLuckRetry = LuckRetry.isEligible(state)
        processNextEvent()
    }

    /// Ödüllü "Şans Tekrarı" verildikten sonra çağrılır: son kararın sonucu
    /// iptal edilir ve zar yeniden atılır. Ölüm sonrası çağrılmaz.
    func applyLuckRetry() {
        guard canOfferLuckRetry,
              let snapshot = snapshotBeforeDecision,
              let (event, choiceID) = lastDecision,
              LuckRetry.isEligible(state)
        else { return }

        canOfferLuckRetry = false
        // İptal edilen sonucun şerit satırını da geri al.
        if let index = timeline.lastIndex(where: { if case .moment = $0.kind { return true } else { return false } }) {
            timeline.remove(at: index)
        }
        state = LuckRetry.rewind(to: snapshot, keepingRandomnessOf: state)
        resolveAndAppend(event: event, choiceID: choiceID)
    }

    /// Ödüllü "Ekstra Sahne": jenerik kartı bir sahne uzar.
    func applyExtraScene() {
        guard case .ended = phase, creditsSceneCount == CreditsComposer.sceneCount else { return }
        creditsSceneCount = CreditsComposer.extendedSceneCount
        phase = .ended(CreditsComposer.compose(from: state, sceneCount: creditsSceneCount))
    }

    /// "Bir hayat daha" — döngünün kalbi (docs/01).
    /// Yeni hayat her zaman Serbest Hayat'tır: Günün Hayatı günde birdir,
    /// aynı seed'i tekrar oynamak adaleti bozar.
    func startNewLife() {
        let seeds = seedSource.makeSeeds()
        personSeed = seeds.personSeed
        deckSeed = seeds.deckSeed
        mode = .free
        archivedID = nil
        snapshotBeforeDecision = nil
        lastDecision = nil
        canOfferLuckRetry = false
        creditsSceneCount = CreditsComposer.sceneCount
        celebrationCount = 0
        setbackCount = 0
        lastPromptText = nil
        lastOutcomeText = nil
        lastOutcomeDeltas = nil
        lastOutcomeWasSetback = false
        streakOutcome = nil
        streakAfterRun = nil
        state = LifeEngine.makeLife(personSeed: seeds.personSeed, deckSeed: seeds.deckSeed, catalog: catalog)
        timeline = []
        pendingEvents = []
        itemCounter = 0
        decisionCount = 0
        postedSeasons = []
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
            let creditsBefore = state.credits.count
            let resolution = try LifeEngine.resolve(event: event, choiceID: choiceID, state: state)
            state = resolution.state
            let deltas = Self.deltaSummary(effects: resolution.effects, akeDelta: resolution.akeDelta)
            append(.moment(text: resolution.text.resolved, deltas: deltas))

            lastPromptText = event.text.resolved
            lastOutcomeText = resolution.text.resolved
            lastOutcomeDeltas = deltas
            lastOutcomeWasSetback = Self.materialScore(resolution.effects) < 0
            if lastOutcomeWasSetback { setbackCount += 1 }
            // Yeni bir rol kazanıldıysa bu bir başarıdır — jenerikte anılacak.
            if state.credits.count > creditsBefore { celebrationCount += 1 }
        } catch {
            assertionFailure("resolve sözleşme ihlali: \(error)")
        }
    }

    /// Sonucun materyal yönü: statlar (AKE hariç) + para. AKE dışarıda çünkü
    /// cesaret bir "kayıp" değildir; sarsıntı yalnız gerçek kayıpta olur.
    private static func materialScore(_ effects: [Effect]) -> Double {
        effects.reduce(0.0) { total, effect in
            switch effect {
            case let .stat(stat, delta) where stat != .ake: total + Double(delta)
            case let .money(amount): total + Double(amount) / 10_000
            default: total
            }
        }
    }

    /// Kartta gösterilecek başlık: karar bekleniyorsa olayın metni,
    /// beklenmiyorsa son yaşanan an.
    var currentCardTitle: String? {
        if case let .decision(event) = phase { return event.text.resolved }
        return lastPromptText
    }

    /// Karar bekleniyorken sonuç gizlenir (henüz seçim yapılmadı). Haber
    /// olaylarında olay metni ile sonuç metni AYNIDIR — o zaman tekrar
    /// yazdırmayız, kart tek bir cümle gösterir.
    var currentCardOutcome: String? {
        if case .decision = phase { return nil }
        guard let outcome = lastOutcomeText, outcome != lastPromptText else { return nil }
        return outcome
    }

    /// Haber olayında etkiler başlığın altına düşer (ayrı sonuç bloğu yok).
    var currentCardDeltas: String? { lastOutcomeDeltas }

    private func finishYear() {
        do {
            let yearEnd = try LifeEngine.finishYear(state)
            state = yearEnd.state
            if yearEnd.died {
                let person = state.person
                let finalYear = person.birthYear + (state.deathAge ?? state.age)
                append(.finale(name: person.name, birthYear: person.birthYear, finalYear: finalYear))
                audio.play(.creditsChord)
                canOfferLuckRetry = false
                let card = CreditsComposer.compose(from: state, sceneCount: creditsSceneCount)
                persistFinishedLife(card: card)
                phase = .ended(card)
            } else {
                phase = .readyForYear
            }
        } catch {
            assertionFailure("finishYear sözleşme ihlali: \(error)")
        }
    }

    /// Hayat bitti: arşive yaz, Günün Hayatı ise koşuyu ve seriyi kaydet.
    /// Kalıcılık hatası oyunu düşürmez — jenerik yine gösterilir, yalnız
    /// arşive girmez (oyuncunun o anki deneyimi kesilmez).
    private func persistFinishedLife(card: CreditsCard) {
        let finishedAt = dateProvider.now()
        archivedID = try? archive.save(
            card: card, personSeed: personSeed, deckSeed: deckSeed,
            mode: mode, finishedAt: finishedAt
        )

        guard mode == .daily else { return }
        let today = dateProvider.today()
        try? dailyRuns.recordRun(date: today, lifeRecordID: archivedID, completedAt: finishedAt)

        let before = (try? dailyRuns.streak()) ?? StreakState()
        let result = StreakRules.register(play: today, in: before)
        try? dailyRuns.saveStreak(result.state)
        streakOutcome = result.outcome
        streakAfterRun = result.state
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
