import Foundation
import LifeDomain

/// Takvim ucu — domain `Date()`/`Calendar.current` kullanamaz (determinizm
/// sözleşmesi), bu yüzden "bugün" bilgisi enjekte edilir.
protocol DateProviding: Sendable {
    /// Kullanıcının yerel takvimine göre bugün.
    func today() -> DailyDate
    /// Kayıt zaman damgası (arşiv sıralaması).
    func now() -> Date
}

struct SystemDateProvider: DateProviding {
    /// Günün Hayatı **yerel** güne bağlıdır: oyuncu kendi sabahında oynar.
    /// Seed tarihten türediği için aynı takvim gününde herkes aynı hayatı
    /// alır; saat dilimi farkı yalnız "ne zaman açılacağını" değiştirir.
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func today() -> DailyDate {
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return DailyDate(
            year: components.year ?? 2026,
            month: components.month ?? 1,
            day: components.day ?? 1
        )
    }

    func now() -> Date { Date() }
}

/// Testlerin ikizi — sabit gün.
struct FixedDateProvider: DateProviding {
    let date: DailyDate
    let timestamp: Date

    init(date: DailyDate, timestamp: Date = Date(timeIntervalSince1970: 0)) {
        self.date = date
        self.timestamp = timestamp
    }

    func today() -> DailyDate { date }
    func now() -> Date { timestamp }
}
