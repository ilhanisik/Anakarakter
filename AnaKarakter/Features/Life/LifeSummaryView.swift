import SwiftUI
import LifeDomain

/// Jenerik: hayat bitince film jeneriği estetiğinde özet.
/// Bölümler sinematik sırayla belirir; Reduce Motion açıkken ya da
/// "Geç" ile akış atlanınca her şey anında görünür (tam işlev korunur).
struct LifeSummaryView: View {
    let card: CreditsCard
    /// Arşivden açıldığında sahne akışı çalışmaz — jenerik bir kez akar,
    /// arşiv bir kayıt defteridir.
    var revealImmediately: Bool = false
    /// Ödüllü "Ekstra Sahne" — sunulabiliyorsa düğme çizilir.
    var onExtraScene: (() async -> Void)?
    /// Arşiv görünümünde "bir hayat daha" yoktur.
    let onNewLife: (() -> Void)?
    let onBackToMenu: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var revealStage = 0
    @State private var squareImage: Image?
    @State private var storyImage: Image?

    private static let totalStages = 5

    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.large) {
                header
                    .revealed(stage: 1, current: revealStage)

                scoreCard
                    .revealed(stage: 2, current: revealStage)

                Group {
                    if !card.roles.isEmpty {
                        section(titleKey: "summary.roles") {
                            ForEach(card.roles, id: \.key) { role in
                                Label {
                                    Text(role.resolved)
                                        .font(DesignTokens.Typography.sceneBody)
                                } icon: {
                                    Image(systemName: "star")
                                        .foregroundStyle(Season.finalSezonu.accent)
                                }
                            }
                        }
                    }

                    if !card.memorableScenes.isEmpty {
                        section(titleKey: "summary.scenes") {
                            ForEach(card.memorableScenes, id: \.self) { scene in
                                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xSmall) {
                                    Text("summary.age \(scene.age)")
                                        .font(DesignTokens.Typography.creditsCaption)
                                        .foregroundStyle(DesignTokens.TextColor.secondary)
                                    Text(scene.text.resolved)
                                        .font(DesignTokens.Typography.sceneBody)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .accessibilityElement(children: .combine)
                            }
                        }
                    }
                }
                .revealed(stage: 3, current: revealStage)

                section(titleKey: "summary.finalStats") {
                    StatPanelView(stats: card.finalStats)
                }
                .revealed(stage: 4, current: revealStage)

                extraSceneButton
                    .revealed(stage: 5, current: revealStage)

                shareSection
                    .revealed(stage: 5, current: revealStage)

                actionButtons
                    .revealed(stage: 5, current: revealStage)
            }
            .padding(DesignTokens.Spacing.medium)
        }
        .stageBackground(season: .finalSezonu)
        .navigationBarBackButtonHidden(true)
        .contentShape(Rectangle())
        .onTapGesture { skipReveal() }
        .toolbar {
            if revealStage < Self.totalStages {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("credits.skip") { skipReveal() }
                }
            }
        }
        .task { await runReveal() }
    }

    // MARK: Bölümler

    private var header: some View {
        VStack(spacing: DesignTokens.Spacing.small) {
            Text(String(localized: "summary.production").uppercased())
                .font(DesignTokens.Typography.creditsCaption)
                .kerning(2)
                .foregroundStyle(DesignTokens.TextColor.secondary)
            Text(card.name)
                .font(DesignTokens.Typography.displayName)
                .multilineTextAlignment(.center)
            Text(verbatim: "\(card.birthYear)–\(card.finalYear)")
                .font(DesignTokens.Typography.sceneBody)
                .foregroundStyle(DesignTokens.TextColor.secondary)
                .monospacedDigit()
            Text(card.neighborhood)
                .font(.subheadline)
                .foregroundStyle(DesignTokens.TextColor.secondary)
        }
        .accessibilityElement(children: .combine)
    }

    private var scoreCard: some View {
        VStack(spacing: DesignTokens.Spacing.xSmall) {
            Text("summary.score")
                .font(DesignTokens.Typography.creditsCaption)
                .foregroundStyle(DesignTokens.TextColor.secondary)
            Text(card.lifeScore.formatted())
                .font(DesignTokens.Typography.score)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(DesignTokens.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(.regularMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .strokeBorder(Color.accentColor.opacity(0.28), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }

    /// Jenerik kartı paylaşımı: kare + story (docs/01; render anlık, disk yok).
    /// Erişilebilirlik boyutlarında iki düğme alt alta geçer — yan yana
    /// kalsalardı etiketler harf harf kırılırdı (Dynamic Type kalite kapısı).
    private var shareSection: some View {
        section(titleKey: "summary.share") {
            let layout = dynamicTypeSize.isAccessibilitySize
                ? AnyLayout(VStackLayout(spacing: DesignTokens.Spacing.small))
                : AnyLayout(HStackLayout(spacing: DesignTokens.Spacing.small))

            layout {
                if let squareImage {
                    ShareLink(
                        item: squareImage,
                        preview: SharePreview(card.name, image: squareImage)
                    ) {
                        Label("share.square", systemImage: "square.on.square")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                if let storyImage {
                    ShareLink(
                        item: storyImage,
                        preview: SharePreview(card.name, image: storyImage)
                    ) {
                        Label("share.story", systemImage: "rectangle.portrait.on.rectangle.portrait")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .task {
            // Kart üretimi anlık ve yereldir; bir kez üretilir, önbelleklenir.
            if squareImage == nil {
                squareImage = ShareCardRenderer.render(card: card, format: .square)
                storyImage = ShareCardRenderer.render(card: card, format: .story)
            }
        }
    }

    /// Ödüllü yerleşim — istek oyuncudan gelir, dayatılmaz.
    @ViewBuilder
    private var extraSceneButton: some View {
        if let onExtraScene {
            Button {
                Task { await onExtraScene() }
            } label: {
                Label("ads.extraScene", systemImage: "play.rectangle.on.rectangle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .accessibilityHint(Text("ads.extraScene.hint"))
        }
    }

    private var actionButtons: some View {
        VStack(spacing: DesignTokens.Spacing.small) {
            if let onNewLife {
                Button(action: onNewLife) {
                    Text("summary.newLife")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }

            Button(action: onBackToMenu) {
                Text("summary.backToMenu")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }

    // MARK: Jenerik akışı

    private func runReveal() async {
        // Reduce Motion: akış yok, tam içerik anında (docs/01 erişilebilirlik).
        // Arşivden açılışta da akış yok — jenerik bir kez akar.
        guard !reduceMotion, !revealImmediately else {
            revealStage = Self.totalStages
            return
        }
        for stage in 1...Self.totalStages {
            guard revealStage < stage else { continue }
            withAnimation(.easeOut(duration: 0.5)) {
                revealStage = stage
            }
            try? await Task.sleep(for: .milliseconds(650))
        }
    }

    private func skipReveal() {
        guard revealStage < Self.totalStages else { return }
        withAnimation(.easeOut(duration: 0.2)) {
            revealStage = Self.totalStages
        }
    }

    @ViewBuilder
    private func section(titleKey: LocalizedStringKey, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
            Text(titleKey)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension View {
    /// Jenerik açılış sahnesi: bölüm, sırası gelene dek görünmez.
    /// İçerik ağaçtan çıkarılmaz (layout zıplamasın), yalnız soluklaşır.
    func revealed(stage: Int, current: Int) -> some View {
        opacity(current >= stage ? 1 : 0)
            .accessibilityHidden(current < stage)
    }
}
