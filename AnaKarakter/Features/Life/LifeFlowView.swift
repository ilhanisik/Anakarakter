import SwiftUI
import LifeDomain

/// Yıl akışı ekranı: kimlik başlığı + stat panosu + zaman şeridi + eylem alanı.
struct LifeFlowView: View {
    @State private var viewModel: LifeFlowViewModel
    @Environment(Router.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(personSeed: UInt64, deckSeed: UInt64, dependencies: AppDependencies) {
        _viewModel = State(initialValue: dependencies.makeLifeFlowViewModel(
            personSeed: personSeed, deckSeed: deckSeed
        ))
    }

    var body: some View {
        Group {
            if case let .ended(card) = viewModel.phase {
                LifeSummaryView(
                    card: card,
                    onNewLife: { viewModel.startNewLife() },
                    onBackToMenu: { router.popToRoot() }
                )
            } else {
                livingView
            }
        }
        .navigationTitle(viewModel.state.person.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var livingView: some View {
        VStack(spacing: 0) {
            VStack(spacing: DesignTokens.Spacing.small) {
                // Erişilebilirlik boyutlarında kimlik satırı dikeyleşir —
                // hiçbir metin kısaltılmaz (Dynamic Type kalite kapısı).
                identityHeader
                    .accessibilityElement(children: .combine)

                StatPanelView(stats: viewModel.state.stats)
            }
            .padding(.horizontal, DesignTokens.Spacing.medium)
            .padding(.bottom, DesignTokens.Spacing.small)

            Divider()

            timeline

            Divider()

            actionArea
                .padding(DesignTokens.Spacing.medium)
        }
    }

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @ViewBuilder
    private var identityHeader: some View {
        let age = Text("life.age \(viewModel.state.age)")
            .font(.subheadline.weight(.semibold))
        let season = Text(viewModel.state.season.localizedName)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        let place = Text(viewModel.state.person.neighborhood)
            .font(.caption)
            .foregroundStyle(.secondary)

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xSmall) {
                age
                season
                place
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            HStack {
                age
                Text(verbatim: "·")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                season
                Spacer()
                place.lineLimit(1)
            }
        }
    }

    private var timeline: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                    ForEach(viewModel.timeline) { item in
                        TimelineItemView(item: item)
                            .id(item.id)
                    }
                }
                .padding(DesignTokens.Spacing.medium)
            }
            .onChange(of: viewModel.timeline.count) {
                guard let lastID = viewModel.timeline.last?.id else { return }
                if reduceMotion {
                    proxy.scrollTo(lastID, anchor: .bottom)
                } else {
                    withAnimation(.easeOut) {
                        proxy.scrollTo(lastID, anchor: .bottom)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var actionArea: some View {
        switch viewModel.phase {
        case .readyForYear:
            Button {
                viewModel.liveYear()
            } label: {
                Text("life.liveYear")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        case let .decision(event):
            DecisionCardView(event: event, choices: viewModel.eligibleChoices) { choiceID in
                viewModel.choose(choiceID)
            }
        case .ended:
            EmptyView()
        }
    }
}

/// Zaman şeridi satırı.
private struct TimelineItemView: View {
    let item: LifeFlowViewModel.TimelineItem

    var body: some View {
        switch item.kind {
        case let .yearMarker(age, season):
            Text("timeline.year \(age) \(season.localizedName)")
                .font(.footnote.smallCaps().weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.top, DesignTokens.Spacing.small)
                .accessibilityAddTraits(.isHeader)
        case let .moment(text, deltas):
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xSmall) {
                Text(text)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                if let deltas {
                    Text(deltas)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .combine)
        case let .finale(name, birthYear, finalYear):
            VStack(spacing: DesignTokens.Spacing.xSmall) {
                Text("life.creditsRoll")
                    .font(.footnote.smallCaps())
                    .foregroundStyle(.secondary)
                Text(verbatim: "\(name) (\(birthYear)–\(finalYear))")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignTokens.Spacing.small)
            .accessibilityElement(children: .combine)
        }
    }
}
