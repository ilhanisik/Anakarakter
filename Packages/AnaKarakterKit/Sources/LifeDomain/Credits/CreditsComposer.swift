/// Jenerikte anılan sahne (AKE zirvesi).
public struct MemorableScene: Codable, Sendable, Equatable, Hashable {
    public let age: Int
    public let text: EventText

    public init(age: Int, text: EventText) {
        self.age = age
        self.text = text
    }
}

/// Jenerik kartı VERİ modeli — render UI katmanında (`ImageRenderer`, Faz 3).
/// Görsel değil veri saklanır; kart her açılışta yeniden çizilir (docs/02).
public struct CreditsCard: Codable, Sendable, Equatable, Hashable {
    public let name: String
    public let neighborhood: String
    public let birthYear: Int
    public let finalYear: Int
    public let roles: [EventText]
    public let memorableScenes: [MemorableScene]
    public let finalStats: StatBlock
    public let peakAKE: Int
    public let lifeScore: Int
}

/// `LifeState` → jenerik kartı verisi.
public enum CreditsComposer {
    /// Jenerikte anılan sahne sayısı (docs/01: "3 unutulmaz sahne").
    public static let sceneCount = 3
    /// "Ekstra Sahne" ödüllü yerleşimi kartı bir sahne uzatır (docs/02).
    public static let extendedSceneCount = 4

    public static func compose(from state: LifeState, sceneCount: Int = sceneCount) -> CreditsCard {
        let sceneCount = max(1, sceneCount)
        let finalAge = state.deathAge ?? state.age

        // 3 unutulmaz sahne — "üç perde" kuralı: hayat üç eşit yaş bandına
        // bölünür ve her perdeden en güçlü AKE sıçraması seçilir; jenerik
        // tüm ömrü ansın, sahneler tek döneme yığılmasın (Faz 3 kararı).
        // Eksik perdeler kalan en iyi sahnelerle tamamlanır. Tam deterministik.
        // Sahne ağırlığı clamp'ten etkilenmez: AKE tavandayken bile cesur
        // anlar jenerikte anılır (bkz. LifeLogEntry.sceneWeight).
        let positives = state.log.filter { $0.sceneWeight > 0 }
        let bandLength = max(1, finalAge / sceneCount + 1)

        func better(_ lhs: LifeLogEntry, _ rhs: LifeLogEntry) -> Bool {
            if lhs.sceneWeight != rhs.sceneWeight { return lhs.sceneWeight > rhs.sceneWeight }
            if lhs.age != rhs.age { return lhs.age < rhs.age }
            return lhs.eventID < rhs.eventID
        }

        var chosen: [LifeLogEntry] = []
        for band in 0..<sceneCount {
            let candidates = positives.filter { min(sceneCount - 1, $0.age / bandLength) == band }
            if let best = candidates.sorted(by: better).first {
                chosen.append(best)
            }
        }
        if chosen.count < sceneCount {
            let remaining = positives.filter { !chosen.contains($0) }.sorted(by: better)
            chosen.append(contentsOf: remaining.prefix(sceneCount - chosen.count))
        }

        let scenes = chosen
            .sorted { $0.age < $1.age } // kartta kronolojik akış
            .map { MemorableScene(age: $0.age, text: $0.text) }

        return CreditsCard(
            name: state.person.name,
            neighborhood: state.person.neighborhood,
            birthYear: state.person.birthYear,
            finalYear: state.person.birthYear + finalAge,
            roles: state.credits,
            memorableScenes: scenes,
            finalStats: state.stats,
            peakAKE: state.peakAKE,
            lifeScore: LifeScore.score(for: state)
        )
    }
}
