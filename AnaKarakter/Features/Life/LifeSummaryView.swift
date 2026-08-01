import SwiftUI
import LifeDomain

/// Ölüm sonrası basit özet — jenerik estetiği Faz 3'te gelir; veri modeli aynı.
struct LifeSummaryView: View {
    let card: CreditsCard
    let onNewLife: () -> Void
    let onBackToMenu: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.large) {
                VStack(spacing: DesignTokens.Spacing.small) {
                    Text("summary.production")
                        .font(.footnote.smallCaps())
                        .foregroundStyle(.secondary)
                    Text(card.name)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    Text(verbatim: "\(card.birthYear)–\(card.finalYear)")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                    Text(card.neighborhood)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)

                VStack(spacing: DesignTokens.Spacing.xSmall) {
                    Text("summary.score")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(card.lifeScore.formatted())
                        .font(.system(.largeTitle, design: .rounded).bold())
                        .monospacedDigit()
                }
                .frame(maxWidth: .infinity)
                .padding(DesignTokens.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                        .fill(Color(.secondarySystemBackground))
                )
                .accessibilityElement(children: .combine)

                if !card.roles.isEmpty {
                    section(titleKey: "summary.roles") {
                        ForEach(card.roles, id: \.key) { role in
                            Label(role.resolved, systemImage: "star")
                                .font(.body)
                        }
                    }
                }

                if !card.memorableScenes.isEmpty {
                    section(titleKey: "summary.scenes") {
                        ForEach(card.memorableScenes, id: \.self) { scene in
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xSmall) {
                                Text("summary.age \(scene.age)")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                Text(scene.text.resolved)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }
                }

                section(titleKey: "summary.finalStats") {
                    StatPanelView(stats: card.finalStats)
                }

                VStack(spacing: DesignTokens.Spacing.small) {
                    Button(action: onNewLife) {
                        Text("summary.newLife")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button(action: onBackToMenu) {
                        Text("summary.backToMenu")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
            }
            .padding(DesignTokens.Spacing.medium)
        }
        .navigationBarBackButtonHidden(true)
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
