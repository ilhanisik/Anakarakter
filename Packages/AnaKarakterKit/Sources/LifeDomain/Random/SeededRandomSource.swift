/// Seed'li, platformdan bağımsız, tamamen deterministik rastgelelik kaynağı
/// (SplitMix64). BlockForge/Köken deseninin portu.
///
/// Determinizm sözleşmesi (docs/02): aynı seed → aynı çıktı dizisi, her cihazda.
/// Bu yüzden stdlib'in `random(in:using:)` yardımcıları yerine kendi türetme
/// fonksiyonlarımızı kullanırız — stdlib algoritması sürümler arasında
/// değişebilir, buradaki asla değişmez.
public struct SeededRandomSource: RandomNumberGenerator, Codable, Sendable, Equatable, Hashable {
    private var state: UInt64

    public init(seed: UInt64) {
        self.state = seed
    }

    public mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }

    /// Kapalı aralıkta tekdüze tamsayı. Oyun zarları küçük aralıklar kullanır;
    /// 2^64'e karşı modulo sapması ihmal edilebilir, determinizm ise mutlak.
    public mutating func int(in range: ClosedRange<Int>) -> Int {
        let span = UInt64(range.upperBound - range.lowerBound) &+ 1
        return range.lowerBound + Int(next() % span)
    }

    /// [0, 1) aralığında 53 bit hassasiyetli çift.
    public mutating func double01() -> Double {
        Double(next() >> 11) * 0x1.0p-53
    }

    /// Verilen olasılıkla `true` döner.
    public mutating func roll(probability: Double) -> Bool {
        double01() < probability
    }

    /// Ağırlıklı indeks çekilişi. Ağırlıklar pozitif olmalı; toplam 0 ise `nil`.
    public mutating func weightedIndex(weights: [Int]) -> Int? {
        let total = weights.reduce(0, +)
        guard total > 0 else { return nil }
        var ticket = int(in: 1...total)
        for (index, weight) in weights.enumerated() {
            ticket -= weight
            if ticket <= 0 { return index }
        }
        return weights.indices.last
    }
}
