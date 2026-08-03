import Foundation
import Observation

/// Jenerik Arşivi — biten hayatların koleksiyonu.
/// View `@Query` kullanmaz; veri repository'den değer olarak gelir (CLAUDE.md).
@Observable
@MainActor
final class ArchiveViewModel {
    private let archive: any LifeArchiveRepository

    private(set) var lives: [ArchivedLife] = []
    private(set) var loadFailed = false
    var sort: ArchiveSort = .newestFirst {
        didSet { reload() }
    }

    init(archive: any LifeArchiveRepository) {
        self.archive = archive
    }

    var isEmpty: Bool { lives.isEmpty }

    /// Arşivin özeti — boş durumda gösterilmez.
    var bestScore: Int? { lives.map(\.lifeScore).max() }

    func reload() {
        do {
            lives = try archive.all(sortedBy: sort)
            loadFailed = false
        } catch {
            // Arşiv okunamazsa oyun oynanmaz hâle gelmez: liste boş görünür,
            // kullanıcıya sessiz bir hata değil açık bir durum gösterilir.
            lives = []
            loadFailed = true
        }
    }

    func delete(_ life: ArchivedLife) {
        try? archive.delete(id: life.id)
        reload()
    }
}
