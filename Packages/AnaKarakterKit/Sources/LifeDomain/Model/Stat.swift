/// 0–100 bantlı istatistikler. Para (`money`) ayrı bir sayaçtır, `Stat` değildir.
public enum Stat: String, CaseIterable, Codable, Sendable, Equatable, Hashable {
    case health        // Sağlık — 0 = ölüm riski
    case happiness     // Mutluluk
    case intelligence  // Zekâ
    case social        // Sosyal
    case ake           // Ana Karakter Enerjisi — marka metresi
}
