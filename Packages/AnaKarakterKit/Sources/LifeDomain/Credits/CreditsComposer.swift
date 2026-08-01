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

    public static func compose(from state: LifeState) -> CreditsCard {
        let finalAge = state.deathAge ?? state.age

        // 3 unutulmaz sahne: en yüksek AKE sıçramaları; eşitlikte erken yaş
        // ve olay kimliği belirler (tam deterministik sıralama).
        let scenes = state.log
            .filter { $0.akeDelta > 0 }
            .sorted {
                if $0.akeDelta != $1.akeDelta { return $0.akeDelta > $1.akeDelta }
                if $0.age != $1.age { return $0.age < $1.age }
                return $0.eventID < $1.eventID
            }
            .prefix(sceneCount)
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
