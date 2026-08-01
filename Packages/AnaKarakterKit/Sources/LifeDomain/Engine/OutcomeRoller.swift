/// Seçenek sonuç dağılımını seed'li zarla çözer.
/// "Cesur seçim = nötr beklenen değer, yüksek varyans" dengesi bu dağılımlar
/// üzerinden ContentLint'te test edilir.
public enum OutcomeRoller {
    public static func roll(outcomes: [Outcome], rng: inout SeededRandomSource) -> Outcome? {
        guard !outcomes.isEmpty else { return nil }
        guard let index = rng.weightedIndex(weights: outcomes.map(\.weight)) else { return nil }
        return outcomes[index]
    }
}
