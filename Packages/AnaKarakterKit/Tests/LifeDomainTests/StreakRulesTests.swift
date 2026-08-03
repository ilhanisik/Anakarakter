import Testing
import LifeDomain

@Suite("DailyDate — takvim aritmetiği")
struct DailyDateTests {
    @Test("Gün numarası bilinen tarihlerde doğru")
    func dayNumbers() {
        #expect(DailyDate(year: 1970, month: 1, day: 1).dayNumber == 0)
        #expect(DailyDate(year: 1970, month: 1, day: 2).dayNumber == 1)
        #expect(DailyDate(year: 2000, month: 3, day: 1).dayNumber == 11_017)
        #expect(DailyDate(year: 2026, month: 8, day: 3).dayNumber == 20_668)
    }

    @Test("Ay ve yıl sınırları doğru geçilir")
    func boundaries() {
        let ocakSon = DailyDate(year: 2026, month: 1, day: 31)
        let subatIlk = DailyDate(year: 2026, month: 2, day: 1)
        #expect(subatIlk.days(since: ocakSon) == 1)

        let yilSon = DailyDate(year: 2025, month: 12, day: 31)
        let yilIlk = DailyDate(year: 2026, month: 1, day: 1)
        #expect(yilIlk.days(since: yilSon) == 1)

        // Artık yıl: 2024 Şubat 29 vardır.
        let subat28 = DailyDate(year: 2024, month: 2, day: 28)
        let mart1 = DailyDate(year: 2024, month: 3, day: 1)
        #expect(mart1.days(since: subat28) == 2)
    }

    @Test("Karşılaştırılabilir")
    func comparable() {
        #expect(DailyDate(year: 2026, month: 1, day: 1) < DailyDate(year: 2026, month: 1, day: 2))
        #expect(DailyDate(year: 2025, month: 12, day: 31) < DailyDate(year: 2026, month: 1, day: 1))
    }
}

@Suite("StreakRules — seri ve telafi")
struct StreakRulesTests {
    private func date(_ day: Int) -> DailyDate {
        // 2026 Ocak ayında ilerleyen günler (ay sınırı testleri ayrı).
        DailyDate(year: 2026, month: 1, day: day)
    }

    @Test("İlk oyun seriyi başlatır")
    func firstPlay() {
        let result = StreakRules.register(play: date(1), in: StreakState())
        #expect(result.outcome == .started)
        #expect(result.state.current == 1)
        #expect(result.state.best == 1)
    }

    @Test("Ardışık gün seriyi büyütür")
    func consecutiveDays() {
        var state = StreakRules.register(play: date(1), in: StreakState()).state
        for day in 2...5 {
            let result = StreakRules.register(play: date(day), in: state)
            #expect(result.outcome == .continued)
            state = result.state
        }
        #expect(state.current == 5)
        #expect(state.best == 5)
    }

    @Test("Aynı gün ikinci oyun seriyi ne bozar ne büyütür")
    func samedayIsNoop() {
        let first = StreakRules.register(play: date(1), in: StreakState()).state
        let again = StreakRules.register(play: date(1), in: first)
        #expect(again.outcome == .alreadyPlayedToday)
        #expect(again.state == first)
    }

    @Test("Telafi hakkı yokken bir gün kaçırmak seriyi koparır")
    func missedDayWithoutGrace() {
        let state = StreakRules.register(play: date(1), in: StreakState()).state
        let result = StreakRules.register(play: date(3), in: state)
        #expect(result.outcome == .restarted)
        #expect(result.state.current == 1)
        #expect(result.state.best == 1) // en iyi korunur
    }

    @Test("Telafi hakkı bir günlük boşluğu kurtarır ve tükenir")
    func graceRecovers() {
        let state = StreakState(lastPlayed: date(1), current: 4, best: 4, graceRemaining: 1)
        let result = StreakRules.register(play: date(3), in: state)
        #expect(result.outcome == .recoveredWithGrace)
        #expect(result.state.current == 5)
        #expect(result.state.graceRemaining == 0)

        // İkinci kaçırma artık kurtarılamaz.
        let second = StreakRules.register(play: date(5), in: result.state)
        #expect(second.outcome == .restarted)
    }

    @Test("İki günden uzun boşluk telafiyle bile kurtarılamaz")
    func graceCoversOnlyOneDay() {
        let state = StreakState(lastPlayed: date(1), current: 9, best: 9, graceRemaining: 2)
        let result = StreakRules.register(play: date(5), in: state)
        #expect(result.outcome == .restarted)
        #expect(result.state.graceRemaining == 2) // hak boşa harcanmaz
    }

    @Test("Her 7 günde bir telafi hakkı kazanılır, tavan 2")
    func graceIsEarned() {
        var state = StreakRules.register(play: date(1), in: StreakState()).state
        var earnedCount = 0
        for day in 2...22 {
            let result = StreakRules.register(play: date(day), in: state)
            if result.earnedGrace { earnedCount += 1 }
            state = result.state
        }
        #expect(state.current == 22)
        #expect(earnedCount == 2, "21 günde 3 eşik geçildi ama tavan 2")
        #expect(state.graceRemaining == StreakRules.maximumGrace)
    }

    @Test("Seri koptuğunda telafi kazanılmaz")
    func noGraceOnRestart() {
        let state = StreakState(lastPlayed: date(1), current: 6, best: 6, graceRemaining: 0)
        let result = StreakRules.register(play: date(20), in: state)
        #expect(result.outcome == .restarted)
        #expect(!result.earnedGrace)
    }

    @Test("Risk göstergesi: bugün oynanmazsa seri kopacak mı")
    func atRisk() {
        let played = StreakState(lastPlayed: date(1), current: 3, best: 3, graceRemaining: 0)
        #expect(StreakRules.isAtRisk(on: date(2), state: played))
        #expect(!StreakRules.isAtRisk(on: date(1), state: played)) // bugün oynandı
        #expect(!StreakRules.isAtRisk(on: date(9), state: played)) // seri zaten kopmuş

        let withGrace = StreakState(lastPlayed: date(1), current: 3, best: 3, graceRemaining: 1)
        #expect(StreakRules.isAtRisk(on: date(3), state: withGrace))
    }

    @Test("Bugün oynandı mı")
    func hasPlayedToday() {
        let state = StreakState(lastPlayed: date(4), current: 1, best: 1, graceRemaining: 0)
        #expect(StreakRules.hasPlayed(on: date(4), state: state))
        #expect(!StreakRules.hasPlayed(on: date(5), state: state))
        #expect(!StreakRules.hasPlayed(on: date(1), state: StreakState()))
    }
}
