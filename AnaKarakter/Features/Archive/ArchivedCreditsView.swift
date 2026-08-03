import SwiftUI
import LifeDomain

/// Arşivden açılan jenerik: kart VERİDEN yeniden çizilir (docs/02 kararı),
/// bu yüzden tema/tipografi değişse bile arşiv tutarlı görünür.
struct ArchivedCreditsView: View {
    let lifeID: UUID
    let dependencies: AppDependencies

    @Environment(Router.self) private var router
    @State private var life: ArchivedLife?

    var body: some View {
        Group {
            if let life {
                LifeSummaryView(
                    card: life.card,
                    revealImmediately: true,
                    onNewLife: nil,
                    onBackToMenu: { router.popToRoot() }
                )
            } else {
                ContentUnavailableView(
                    "archive.missing.title",
                    systemImage: "questionmark.folder",
                    description: Text("archive.missing.message")
                )
            }
        }
        .task {
            life = try? dependencies.archive.life(id: lifeID)
        }
    }
}
