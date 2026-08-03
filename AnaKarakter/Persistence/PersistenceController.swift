import Foundation
import SwiftData

/// SwiftData kurulumu — composition root'un kalıcılık ucu.
///
/// `--uitest-clean` bayrağı (Köken deseni): UI testleri her koşuda temiz
/// bir bellek içi mağazayla başlar; diskteki gerçek arşiv kirlenmez.
@MainActor
enum PersistenceController {
    static let uiTestCleanFlag = "--uitest-clean"

    static var isUITestClean: Bool {
        CommandLine.arguments.contains(uiTestCleanFlag)
    }

    static func makeContainer(inMemory: Bool = isUITestClean) -> ModelContainer {
        let schema = Schema(versionedSchema: SchemaV1.self)
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: AnaKarakterMigrationPlan.self,
                configurations: [configuration]
            )
        } catch {
            // Diskteki mağaza açılamıyorsa (bozuk dosya, dolu disk) oyun
            // oynanmaz duruma DÜŞMEZ: bellek içi mağazaya düşülür, arşiv o
            // oturum için boş görünür. Sessiz veri kaybı değil — kullanıcı
            // arşivin boş olduğunu görür, oyun çalışmaya devam eder.
            let fallback = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            guard let container = try? ModelContainer(
                for: schema, migrationPlan: AnaKarakterMigrationPlan.self, configurations: [fallback]
            ) else {
                fatalError("SwiftData bellek içi mağaza bile kurulamadı: \(error)")
            }
            return container
        }
    }
}
