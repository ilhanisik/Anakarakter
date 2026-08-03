import Foundation
import SwiftData
import LifeDomain

/// Arşiv listesinde gösterilen özet — View, `@Model` tipini görmez
/// (CLAUDE.md: View'da `@Query` yasak; ViewModel repository'den değer alır).
struct ArchivedLife: Identifiable, Sendable, Equatable, Hashable {
    let id: UUID
    let personSeed: UInt64
    let deckSeed: UInt64
    let mode: LifeMode
    let finishedAt: Date
    let card: CreditsCard

    var name: String { card.name }
    var lifeScore: Int { card.lifeScore }
}

enum ArchiveSort: Sendable, Equatable, CaseIterable {
    case newestFirst
    case highestScore
}

/// Jenerik Arşivi — biten hayatların koleksiyonu.
@MainActor
protocol LifeArchiveRepository {
    func save(card: CreditsCard, personSeed: UInt64, deckSeed: UInt64, mode: LifeMode, finishedAt: Date) throws -> UUID
    func all(sortedBy sort: ArchiveSort) throws -> [ArchivedLife]
    func life(id: UUID) throws -> ArchivedLife?
    func delete(id: UUID) throws
    func count() throws -> Int
}

@MainActor
struct SwiftDataLifeArchiveRepository: LifeArchiveRepository {
    let context: ModelContext

    func save(
        card: CreditsCard, personSeed: UInt64, deckSeed: UInt64, mode: LifeMode, finishedAt: Date
    ) throws -> UUID {
        let data = try JSONEncoder().encode(card)
        let record = LifeRecordModel(
            personSeed: personSeed, deckSeed: deckSeed, mode: mode,
            finishedAt: finishedAt, card: card, creditsData: data
        )
        context.insert(record)
        try context.save()
        return record.id
    }

    func all(sortedBy sort: ArchiveSort) throws -> [ArchivedLife] {
        var descriptor = FetchDescriptor<LifeRecordModel>()
        descriptor.sortBy = switch sort {
        case .newestFirst: [SortDescriptor(\.finishedAt, order: .reverse)]
        case .highestScore: [SortDescriptor(\.lifeScore, order: .reverse),
                             SortDescriptor(\.finishedAt, order: .reverse)]
        }
        return try context.fetch(descriptor).compactMap(Self.archived)
    }

    func life(id: UUID) throws -> ArchivedLife? {
        var descriptor = FetchDescriptor<LifeRecordModel>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first.flatMap(Self.archived)
    }

    func delete(id: UUID) throws {
        try context.delete(model: LifeRecordModel.self, where: #Predicate { $0.id == id })
        try context.save()
    }

    func count() throws -> Int {
        try context.fetchCount(FetchDescriptor<LifeRecordModel>())
    }

    /// Bozuk/eski kayıt akışı düşürmez: çözülemeyen kart sessizce atlanır.
    private static func archived(_ model: LifeRecordModel) -> ArchivedLife? {
        guard let card = try? JSONDecoder().decode(CreditsCard.self, from: model.creditsData) else {
            return nil
        }
        return ArchivedLife(
            id: model.id, personSeed: model.personSeed, deckSeed: model.deckSeed,
            mode: model.mode, finishedAt: model.finishedAt, card: card
        )
    }
}

/// ViewModel testlerinin ikizi (CLAUDE.md: InMemory ikizleri).
@MainActor
final class InMemoryLifeArchiveRepository: LifeArchiveRepository {
    private(set) var storage: [ArchivedLife] = []

    init(seed: [ArchivedLife] = []) {
        storage = seed
    }

    func save(
        card: CreditsCard, personSeed: UInt64, deckSeed: UInt64, mode: LifeMode, finishedAt: Date
    ) throws -> UUID {
        let life = ArchivedLife(
            id: UUID(), personSeed: personSeed, deckSeed: deckSeed,
            mode: mode, finishedAt: finishedAt, card: card
        )
        storage.append(life)
        return life.id
    }

    func all(sortedBy sort: ArchiveSort) throws -> [ArchivedLife] {
        switch sort {
        case .newestFirst:
            storage.sorted { $0.finishedAt > $1.finishedAt }
        case .highestScore:
            storage.sorted {
                $0.lifeScore != $1.lifeScore ? $0.lifeScore > $1.lifeScore : $0.finishedAt > $1.finishedAt
            }
        }
    }

    func life(id: UUID) throws -> ArchivedLife? { storage.first { $0.id == id } }
    func delete(id: UUID) throws { storage.removeAll { $0.id == id } }
    func count() throws -> Int { storage.count }
}
