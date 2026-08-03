import SwiftUI
import LifeDomain
import AppPolicy

/// Yıl akışı ekranı: kimlik başlığı + stat panosu + zaman şeridi + eylem alanı.
struct LifeFlowView: View {
    @State private var viewModel: LifeFlowViewModel
    @Environment(Router.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showsTimeline = false

    private let dependencies: AppDependencies

    init(personSeed: UInt64, deckSeed: UInt64, mode: LifeMode, dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = State(initialValue: dependencies.makeLifeFlowViewModel(
            personSeed: personSeed, deckSeed: deckSeed, mode: mode
        ))
    }

    /// Ödüllü yerleşimi dener; ödül verilirse `true`.
    private func offerRewarded(_ placement: AdPlacement, targetsDeathOutcome: Bool = false) async -> Bool {
        let context = dependencies.adContext(
            nowSecond: dependencies.ads.sessionSecond,
            isMidYearFlow: false,
            targetsDeathOutcome: targetsDeathOutcome
        )
        return await dependencies.ads.present(placement, context: context)
    }

    var body: some View {
        Group {
            if case let .ended(card) = viewModel.phase {
                summaryView(card: card)
            } else {
                livingView
            }
        }
        .navigationTitle(viewModel.state.person.name)
        .navigationBarTitleDisplayMode(.inline)
        // Haptik seti (Faz 3): yıl geçişi hafif, karar seçimi selection,
        // jenerik başlangıcı success. Sistem, Reduce Motion/haptik
        // tercihlerinde geri bildirimi kendisi kısar.
        .sensoryFeedback(.impact(weight: .light), trigger: viewModel.state.age)
        .sensoryFeedback(.selection, trigger: viewModel.decisionCount)
        .sensoryFeedback(.success, trigger: viewModel.isEnded)
    }

    /// Ödüllü "Şans Tekrarı" — son kararın sonucunu bir kez daha çevirir.
    /// İstek oyuncudan gelir; reklam gösterilemezse hak yanmaz.
    private var luckRetryButton: some View {
        Button {
            Task {
                guard await offerRewarded(.rewardedLuckRetry) else { return }
                viewModel.applyLuckRetry()
            }
        } label: {
            Label("ads.luckRetry", systemImage: "dice")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .accessibilityHint(Text("ads.luckRetry.hint"))
    }

    private func summaryView(card: CreditsCard) -> some View {
        var onExtraScene: (() async -> Void)?
        if viewModel.creditsSceneCount == CreditsComposer.sceneCount {
            onExtraScene = { await grantExtraScene() }
        }
        return LifeSummaryView(
            card: card,
            onExtraScene: onExtraScene,
            onNewLife: { startAnotherLife() },
            onBackToMenu: { leaveCredits() }
        )
    }

    private func grantExtraScene() async {
        guard await offerRewarded(.rewardedExtraScene) else { return }
        viewModel.applyExtraScene()
    }

    private func startAnotherLife() {
        viewModel.startNewLife()
        dependencies.ads.beginNewLife()
    }

    /// Geçişli reklam YALNIZ jenerik kartı kapatılırken denenir; gösterilemezse
    /// akış sessizce sürer ve menüye dönüş gecikmez.
    private func leaveCredits() {
        Task {
            let context = dependencies.adContext(
                nowSecond: dependencies.ads.sessionSecond,
                creditsCardDismissed: true
            )
            await dependencies.ads.present(.interstitialAfterCredits, context: context)
            router.popToRoot()
        }
    }

    /// Ana oyun ekranı — brief düzeni: üstte statlar, ortada büyük olay
    /// kartı, altta büyük seçim düğmeleri. Tek elle oynanır; oyuncu hangi
    /// düğmeye basacağını aramaz çünkü seçimler her zaman aynı yerdedir.
    private var livingView: some View {
        VStack(spacing: 0) {
            StatChipBar(
                age: viewModel.state.age,
                season: viewModel.state.season,
                stats: viewModel.state.stats
            )
            .padding(.horizontal, DesignTokens.Spacing.medium)
            .padding(.bottom, DesignTokens.Spacing.medium)

            ScrollView {
                VStack(spacing: DesignTokens.Spacing.medium) {
                    if let title = viewModel.currentCardTitle {
                        EventCardView(
                            season: viewModel.state.season,
                            title: title,
                            outcome: viewModel.currentCardOutcome,
                            deltas: viewModel.lastOutcomeDeltas,
                            isSetback: viewModel.lastOutcomeWasSetback
                        )
                        .id(viewModel.timeline.count)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.94).combined(with: .opacity),
                            removal: .opacity
                        ))
                    } else {
                        openingCard
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.medium)
                .padding(.bottom, DesignTokens.Spacing.medium)
                .animation(reduceMotion ? nil : DesignTokens.Motion.enter, value: viewModel.timeline.count)
            }
            .scrollBounceBehavior(.basedOnSize)

            actionArea
                .padding(.horizontal, DesignTokens.Spacing.medium)
                .padding(.bottom, DesignTokens.Spacing.medium)
        }
        .background(DesignTokens.Surface.canvas)
        .shakes(on: viewModel.setbackCount)
        .celebrates(on: viewModel.celebrationCount)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showsTimeline = true
                } label: {
                    Label("life.timeline", systemImage: "list.bullet.rectangle")
                }
            }
        }
        .sheet(isPresented: $showsTimeline) {
            NavigationStack { timelineSheet }
        }
    }

    /// Hayat henüz başlamadı — ilk kart bir davet.
    private var openingCard: some View {
        VStack(spacing: DesignTokens.Spacing.small) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .foregroundStyle(DesignTokens.Accent.gold)
                .accessibilityHidden(true)
            Text("life.opening.title")
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
            Text("life.opening.body")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(DesignTokens.Spacing.large)
        .frame(maxWidth: .infinity)
        .floatingCard(tint: viewModel.state.season.accent)
        .accessibilityElement(children: .combine)
    }

    /// Zaman çizelgesi ayrı bir ekranda — ana ekran karta odaklı kalsın.
    private var timelineSheet: some View {
        timeline
            .navigationTitle("life.timeline")
            .navigationBarTitleDisplayMode(.inline)
            .background(DesignTokens.Surface.canvas)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.done") { showsTimeline = false }
                }
            }
    }

    private var timeline: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                    ForEach(Array(viewModel.timeline.enumerated()), id: \.element.id) { index, item in
                        TimelineItemView(item: item, personName: viewModel.state.person.name)
                            .id(item.id)
                            .entersScene(delay: DesignTokens.Motion.stagger(
                                index - max(0, viewModel.timeline.count - 5)
                            ))
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
            VStack(spacing: DesignTokens.Spacing.small) {
                if viewModel.canOfferLuckRetry {
                    luckRetryButton
                }
                Button {
                    viewModel.liveYear()
                } label: {
                    Text("life.liveYear")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(DesignTokens.Accent.gold)
            }
        case .decision:
            VStack(spacing: DesignTokens.Spacing.small) {
                ForEach(Array(viewModel.eligibleChoices.enumerated()), id: \.element.id) { index, choice in
                    ChoiceButton(choice: choice) {
                        viewModel.choose(choice.id)
                    }
                    .entersScene(delay: DesignTokens.Motion.stagger(index), offset: 12)
                }
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        case .ended:
            EmptyView()
        }
    }
}

/// Zaman şeridi satırı.
private struct TimelineItemView: View {
    let item: LifeFlowViewModel.TimelineItem
    let personName: String

    private func rule(_ season: Season) -> some View {
        Rectangle()
            .fill(season.accent.opacity(0.35))
            .frame(height: 1)
            .accessibilityHidden(true)
    }

    var body: some View {
        switch item.kind {
        case let .yearMarker(age, season):
            // Bölüm kartı: iki ince çizgi arasında yıl başlığı — jenerik
            // diliyle aynı serif, "yeni perde" hissi.
            HStack(spacing: DesignTokens.Spacing.small) {
                rule(season)
                Text("timeline.year \(age) \(season.localizedName)")
                    .font(DesignTokens.Typography.chapter)
                    .kerning(1.5)
                    .foregroundStyle(season.accent)
                    .layoutPriority(1)
                rule(season)
            }
            .padding(.top, DesignTokens.Spacing.medium)
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
        case let .seasonPoster(season, variantSeed):
            SeasonPosterView(season: season, personName: personName, variantSeed: variantSeed)
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
                    .font(DesignTokens.Typography.creditsCaption)
                    .foregroundStyle(.secondary)
                Text(verbatim: "\(name) (\(birthYear)–\(finalYear))")
                    .font(DesignTokens.Typography.sceneBody.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignTokens.Spacing.small)
            .accessibilityElement(children: .combine)
        }
    }
}
