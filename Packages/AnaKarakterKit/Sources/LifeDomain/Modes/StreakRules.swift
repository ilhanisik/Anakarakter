/// Günün Hayatı serisinin durumu — kalıcı saklanır (SwiftData `StreakModel`).
public struct StreakState: Codable, Sendable, Equatable, Hashable {
    public var lastPlayed: DailyDate?
    public var current: Int
    public var best: Int
    /// Kalan telafi hakkı: bir gün kaçırıldığında seriyi kurtarır.
    public var graceRemaining: Int

    public init(lastPlayed: DailyDate? = nil, current: Int = 0, best: Int = 0, graceRemaining: Int = 0) {
        self.lastPlayed = lastPlayed
        self.current = current
        self.best = best
        self.graceRemaining = graceRemaining
    }
}

/// Seri + telafi kuralları (Köken deseni) — saf, takvim enjekte, testli.
///
/// Tasarım ilkesi (CLAUDE.md "karanlık desen yasak"): seri bir baskı aracı
/// değil, bir ritüel ödülüdür. Bu yüzden:
/// - Telafi hakkı **kazanılır**, satılmaz; reklamla veya parayla alınmaz.
/// - Seri kopması ceza üretmez, yalnız sayaç 1'e döner.
/// - Aynı gün ikinci kez oynamak seriyi ne bozar ne büyütür.
public enum StreakRules {
    /// Aynı anda taşınabilecek en çok telafi hakkı.
    public static let maximumGrace = 2
    /// Her bu kadar günlük seride bir telafi hakkı kazanılır.
    public static let graceEarnedEveryDays = 7

    public enum Outcome: Sendable, Equatable, Hashable {
        /// İlk kez oynandı.
        case started
        /// Dün de oynanmıştı; seri büyüdü.
        case continued
        /// Tam bir gün kaçırılmıştı; telafi harcandı, seri korundu.
        case recoveredWithGrace
        /// Seri koptu; sayaç 1'den başladı.
        case restarted
        /// Bugün zaten oynanmış; durum değişmedi.
        case alreadyPlayedToday
    }

    public struct Result: Sendable, Equatable {
        public let state: StreakState
        public let outcome: Outcome
        /// Bu oyunla yeni telafi hakkı kazanıldı mı (arayüz kutlar).
        public let earnedGrace: Bool
    }

    /// Bir Günün Hayatı tamamlandığında çağrılır.
    public static func register(play date: DailyDate, in state: StreakState) -> Result {
        guard let last = state.lastPlayed else {
            var new = state
            new.lastPlayed = date
            new.current = 1
            new.best = max(state.best, 1)
            return Result(state: new, outcome: .started, earnedGrace: false)
        }

        let gap = date.days(since: last)

        // Geçmişe dönük kayıt (saat dilimi/manuel tarih oynaması) seriyi
        // büyütmez; durum olduğu gibi kalır.
        guard gap > 0 else {
            return Result(state: state, outcome: .alreadyPlayedToday, earnedGrace: false)
        }

        var new = state
        new.lastPlayed = date
        let outcome: Outcome

        switch gap {
        case 1:
            new.current = state.current + 1
            outcome = .continued
        case 2 where state.graceRemaining > 0:
            // Tam bir gün kaçırıldı ve telafi hakkı var: seri korunur.
            new.graceRemaining = state.graceRemaining - 1
            new.current = state.current + 1
            outcome = .recoveredWithGrace
        default:
            new.current = 1
            outcome = .restarted
        }

        new.best = max(state.best, new.current)

        // Telafi hakkı: her 7 günlük seri eşiğinde bir, tavana kadar.
        let earnedGrace = outcome != .restarted
            && new.current % graceEarnedEveryDays == 0
            && new.graceRemaining < maximumGrace
        if earnedGrace {
            new.graceRemaining = min(maximumGrace, new.graceRemaining + 1)
        }

        return Result(state: new, outcome: outcome, earnedGrace: earnedGrace)
    }

    /// Bugün oynanmış mı (arayüz "bugünü tamamladın" rozetini bununla çizer).
    public static func hasPlayed(on date: DailyDate, state: StreakState) -> Bool {
        state.lastPlayed.map { $0.dayNumber >= date.dayNumber } ?? false
    }

    /// Seri, bugün oynanmazsa kopar mı? (Telafi hakkı varsa bir gün daha dayanır.)
    public static func isAtRisk(on date: DailyDate, state: StreakState) -> Bool {
        guard let last = state.lastPlayed, state.current > 0 else { return false }
        let gap = date.days(since: last)
        return gap == 1 || (gap == 2 && state.graceRemaining > 0)
    }
}
