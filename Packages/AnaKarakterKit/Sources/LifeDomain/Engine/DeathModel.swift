/// Aktüeryal ölüm modeli: yaş (Gompertz eğrisi) + sağlık çarpanı.
/// Test bandı: 10.000 seed'li ömürde ortalama ölüm yaşı 70–85 (docs/02).
public enum DeathModel {
    /// Gompertz taban katsayısı.
    static let baseRate = 0.000038
    /// Yıllık risk çarpanı ≈ e^0.095 — transandantal fonksiyon kullanmadan
    /// (domain saf kalır) tam deterministik kuvvet alma ile uygulanır.
    static let growthPerYear = 1.0996

    /// Yaş çarpanları tablosu — her yıl için `growthPerYear^yaş`.
    /// Bir kez hesaplanır; 10.000 hayat kapısında sıcak yol budur.
    static let ageFactors: [Double] = {
        var factors = [Double](repeating: 1.0, count: LifeDomain.maximumAge + 1)
        var factor = 1.0
        for age in 0...LifeDomain.maximumAge {
            factors[age] = factor
            factor *= growthPerYear
        }
        return factors
    }()

    /// Bu yaş ve sağlıkla BU yıl ölme olasılığı.
    public static func annualDeathProbability(age: Int, health: Int) -> Double {
        guard age < LifeDomain.maximumAge else { return 1.0 }

        var probability = baseRate * ageFactors[max(0, age)]

        // Düşük sağlık riski büyütür (50 altında doğrusal, en çok 2.5×).
        let healthPenalty = 1.0 + Double(max(0, 50 - health)) / 50.0 * 1.5
        probability *= healthPenalty

        // Sağlık 0 = akut ölüm riski (docs/01 stat tablosu).
        if health <= 0 {
            probability += 0.5
        }

        return min(1.0, probability)
    }

    /// Seed'li ölüm zarı.
    public static func rollDeath(age: Int, health: Int, rng: inout SeededRandomSource) -> Bool {
        rng.roll(probability: annualDeathProbability(age: age, health: health))
    }
}
