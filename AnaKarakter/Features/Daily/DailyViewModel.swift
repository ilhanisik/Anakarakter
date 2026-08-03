import Foundation
import Observation
import LifeDomain

/// Günün Hayatı kartının durumu: bugünün seed'i, seri ve telafi.
@Observable
@MainActor
final class DailyViewModel {
    private let dailyRuns: any DailyRunRepository
    private let archive: any LifeArchiveRepository
    private let dateProvider: any DateProviding

    private(set) var today: DailyDate
    private(set) var streak = StreakState()
    private(set) var completedLifeID: UUID?

    init(
        dailyRuns: any DailyRunRepository,
        archive: any LifeArchiveRepository,
        dateProvider: any DateProviding
    ) {
        self.dailyRuns = dailyRuns
        self.archive = archive
        self.dateProvider = dateProvider
        self.today = dateProvider.today()
    }

    var seeds: (personSeed: UInt64, deckSeed: UInt64) {
        DailyLifeSelector.seeds(for: today)
    }

    var hasPlayedToday: Bool { completedLifeID != nil }

    /// Bugün oynanmazsa seri kopacak mı — arayüz nazik bir hatırlatma çizer.
    var isStreakAtRisk: Bool {
        StreakRules.isAtRisk(on: today, state: streak)
    }

    func reload() {
        today = dateProvider.today()
        streak = (try? dailyRuns.streak()) ?? StreakState()
        completedLifeID = (try? dailyRuns.run(on: today))?.lifeRecordID
    }
}
