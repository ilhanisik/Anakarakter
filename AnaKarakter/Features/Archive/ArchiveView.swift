import SwiftUI
import LifeDomain

/// Jenerik Arşivi — biten hayatların afiş duvarı.
struct ArchiveView: View {
    @State private var viewModel: ArchiveViewModel
    @Environment(Router.self) private var router
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(dependencies: AppDependencies) {
        _viewModel = State(initialValue: dependencies.makeArchiveViewModel())
    }

    /// Erişilebilirlik boyutlarında duvar tek kolona düşer — afiş küçülüp
    /// okunmaz hâle gelmez (Dynamic Type kalite kapısı).
    private var columns: [GridItem] {
        let minimum: CGFloat = dynamicTypeSize.isAccessibilitySize ? 280 : 150
        return [GridItem(.adaptive(minimum: minimum), spacing: DesignTokens.Spacing.medium)]
    }

    var body: some View {
        Group {
            if viewModel.isEmpty {
                emptyState
            } else {
                wall
            }
        }
        .navigationTitle("archive.title")
        .navigationBarTitleDisplayMode(.large)
        .stageBackground(season: .finalSezonu)
        .toolbar {
            if !viewModel.isEmpty {
                ToolbarItem(placement: .topBarTrailing) { sortMenu }
            }
        }
        .onAppear { viewModel.reload() }
    }

    private var sortMenu: some View {
        Menu {
            Picker("archive.sort", selection: Binding(
                get: { viewModel.sort },
                set: { viewModel.sort = $0 }
            )) {
                Text("archive.sort.newest").tag(ArchiveSort.newestFirst)
                Text("archive.sort.score").tag(ArchiveSort.highestScore)
            }
        } label: {
            Label("archive.sort", systemImage: "arrow.up.arrow.down")
        }
    }

    private var wall: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.medium) {
                ForEach(Array(viewModel.lives.enumerated()), id: \.element.id) { index, life in
                    Button {
                        router.push(.archivedCredits(id: life.id))
                    } label: {
                        LifePosterView(life: life)
                    }
                    .buttonStyle(.plain)
                    .entersScene(delay: DesignTokens.Motion.stagger(index), scales: true)
                    .contextMenu {
                        Button(role: .destructive) {
                            viewModel.delete(life)
                        } label: {
                            Label("archive.delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(DesignTokens.Spacing.medium)
            .animation(DesignTokens.Motion.enter, value: viewModel.sort)
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("archive.empty.title", systemImage: "film.stack")
        } description: {
            Text(viewModel.loadFailed ? "archive.empty.failed" : "archive.empty.message")
        }
    }
}
