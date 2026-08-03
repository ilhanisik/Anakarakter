import Testing
import LifeDomain

@Suite("AKEModel — azalan verim")
struct AKEModelTests {
    @Test("Kazanç kalan başlıkla ölçeklenir")
    func gainScalesWithHeadroom() {
        #expect(AKEModel.appliedDelta(base: 6, currentAKE: 0) == 6)
        #expect(AKEModel.appliedDelta(base: 6, currentAKE: 25) == 5)
        #expect(AKEModel.appliedDelta(base: 6, currentAKE: 50) == 3)
        #expect(AKEModel.appliedDelta(base: 6, currentAKE: 75) == 2)
        #expect(AKEModel.appliedDelta(base: 6, currentAKE: 90) == 1)
        #expect(AKEModel.appliedDelta(base: 6, currentAKE: 100) == 0)
    }

    @Test("Kazanç monotondur — yüksek AKE hiçbir zaman daha çok kazandırmaz")
    func gainIsMonotonic() {
        for ake in 1...100 {
            let previous = AKEModel.appliedDelta(base: 6, currentAKE: ake - 1)
            let current = AKEModel.appliedDelta(base: 6, currentAKE: ake)
            #expect(current <= previous, "AKE \(ake): kazanç arttı (\(previous) → \(current))")
        }
    }

    @Test("Kazanç asla eksiye dönmez — AKE ceza aracı değildir")
    func gainNeverNegative() {
        for ake in 0...100 {
            #expect(AKEModel.appliedDelta(base: 6, currentAKE: ake) >= 0)
        }
    }

    @Test("Kayıp AKE seviyesinden bağımsız, olduğu gibi uygulanır")
    func lossIsFlat() {
        for ake in 0...100 {
            #expect(AKEModel.appliedDelta(base: -3, currentAKE: ake) == -3)
        }
        #expect(AKEModel.appliedDelta(base: 0, currentAKE: 40) == 0)
    }

    @Test("Doyum yok: yalnız cesaretle 100'e yapışılamaz")
    func noSaturation() {
        // Erozyonsuz, art arda 500 cesur seçim bile tavanı doldurmaz.
        var ake = 50
        for _ in 0..<500 {
            ake = min(100, ake + AKEModel.appliedDelta(base: 6, currentAKE: ake))
        }
        #expect(ake < 100, "AKE tavana yapıştı (\(ake))")
        #expect(ake >= 85, "AKE cesur oyuncuyu ödüllendirmiyor (\(ake))")
    }
}
