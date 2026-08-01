import Testing
@testable import LifeDomain

@Suite("SeededRandomSource")
struct SeededRandomSourceTests {
    @Test("Aynı seed aynı diziyi üretir")
    func sameSeedSameSequence() {
        var a = SeededRandomSource(seed: 12345)
        var b = SeededRandomSource(seed: 12345)
        for _ in 0..<100 {
            #expect(a.next() == b.next())
        }
    }

    @Test("Farklı seed farklı dizi üretir")
    func differentSeedDiverges() {
        var a = SeededRandomSource(seed: 1)
        var b = SeededRandomSource(seed: 2)
        let aValues = (0..<10).map { _ in a.next() }
        let bValues = (0..<10).map { _ in b.next() }
        #expect(aValues != bValues)
    }

    @Test("int(in:) aralık sınırlarına uyar ve tüm değerleri üretebilir")
    func intInRangeBounds() {
        var rng = SeededRandomSource(seed: 7)
        var seen = Set<Int>()
        for _ in 0..<1_000 {
            let value = rng.int(in: 2...4)
            #expect((2...4).contains(value))
            seen.insert(value)
        }
        #expect(seen == [2, 3, 4])
    }

    @Test("weightedIndex ağırlıklara saygı duyar")
    func weightedIndexDistribution() {
        var rng = SeededRandomSource(seed: 99)
        var counts = [0, 0]
        for _ in 0..<3_000 {
            if let index = rng.weightedIndex(weights: [9, 1]) {
                counts[index] += 1
            }
        }
        #expect(counts[0] + counts[1] == 3_000)
        #expect(counts[0] > counts[1] * 5) // 9:1 ağırlık belirgin fark yaratmalı
        #expect(counts[1] > 0)             // düşük ağırlık asla imkânsız değil
    }

    @Test("weightedIndex toplam sıfırsa nil döner")
    func weightedIndexZeroTotal() {
        var rng = SeededRandomSource(seed: 1)
        #expect(rng.weightedIndex(weights: []) == nil)
        #expect(rng.weightedIndex(weights: [0, 0]) == nil)
    }

    @Test("roll(probability:) uç değerlerde deterministiktir")
    func rollExtremes() {
        var rng = SeededRandomSource(seed: 5)
        for _ in 0..<50 {
            let certain = rng.roll(probability: 1.0)
            let impossible = rng.roll(probability: 0.0)
            #expect(certain)
            #expect(!impossible)
        }
    }
}
