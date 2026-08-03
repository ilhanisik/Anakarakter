import Foundation
import SwiftData
import LifeDomain

/// Bir Günün Hayatı koşusunun özeti.
struct DailyRunSummary: Sendable, Equatable, Hashable {
    let date: DailyDate
    /// Tamamlandıysa arşiv kaydının kimliği; başlanıp bitirilmediyse `nil`.
    let lifeRecordID: UUID?
    let completedAt: Date
}

/// Günün Hayatı kayıtları + seri durumu. Kurallar domain'de (`StreakRules`);
/// bu tip yalnız saklar ve okur.
@MainActor
protocol DailyRunRepository {
    func run(on date: DailyDate) throws -> DailyRunSummary?
    func recordRun(date: DailyDate, lifeRecordID: UUID?, completedAt: Date) throws
    func streak() throws -> StreakState
    func saveStreak(_ state: StreakState) throws
}

extension DailyRunRepository {
    /// Bugünün hayatı tamamlanmış mı.
    func hasCompletedRun(on date: DailyDate) throws -> Bool {
        try run(on: date)?.lifeRecordID != nil
    }
}

@MainActor
struct SwiftDataDailyRunRepository: DailyRunRepository {
    let context: ModelContext

    func run(on date: DailyDate) throws -> DailyRunSummary? {
        try model(for: date).map {
            DailyRunSummary(date: $0.date, lifeRecordID: $0.lifeRecordID, completedAt: $0.completedAt)
        }
    }

    func recordRun(date: DailyDate, lifeRecordID: UUID?, completedAt: Date) throws {
        if let existing = try model(for: date) {
            existing.lifeRecordID = lifeRecordID
            existing.completedAt = completedAt
        } else {
            context.insert(DailyRunModel(date: date, lifeRecordID: lifeRecordID, completedAt: completedAt))
        }
        try context.save()
    }

    func streak() throws -> StreakState {
        try singleton().state
    }

    func saveStreak(_ state: StreakState) throws {
        try singleton().apply(state)
        try context.save()
    }

    private func model(for date: DailyDate) throws -> DailyRunModel? {
        let dayNumber = date.dayNumber
        var descriptor = FetchDescriptor<DailyRunModel>(predicate: #Predicate { $0.dayNumber == dayNumber })
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    private func singleton() throws -> StreakModel {
        var descriptor = FetchDescriptor<StreakModel>()
        descriptor.fetchLimit = 1
        if let existing = try context.fetch(descriptor).first { return existing }
        let fresh = StreakModel(state: StreakState())
        context.insert(fresh)
        return fresh
    }
}

@MainActor
final class InMemoryDailyRunRepository: DailyRunRepository {
    private var runs: [Int: DailyRunSummary] = [:]
    private var streakState: StreakState

    init(streak: StreakState = StreakState()) {
        streakState = streak
    }

    func run(on date: DailyDate) throws -> DailyRunSummary? { runs[date.dayNumber] }

    func recordRun(date: DailyDate, lifeRecordID: UUID?, completedAt: Date) throws {
        runs[date.dayNumber] = DailyRunSummary(
            date: date, lifeRecordID: lifeRecordID, completedAt: completedAt
        )
    }

    func streak() throws -> StreakState { streakState }
    func saveStreak(_ state: StreakState) throws { streakState = state }
}
