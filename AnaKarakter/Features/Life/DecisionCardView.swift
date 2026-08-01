import SwiftUI
import LifeDomain

/// Karar kartı: olay metni + 2–4 seçenek. Cesaret seviyesi ikon + erişilebilirlik
/// ipucuyla belirtilir; renk tek başına bilgi taşımaz.
struct DecisionCardView: View {
    let event: LifeEvent
    let choices: [Choice]
    let onChoose: (ChoiceID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
            Text(event.text.resolved)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            ForEach(choices, id: \.id) { choice in
                Button {
                    onChoose(choice.id)
                } label: {
                    HStack(spacing: DesignTokens.Spacing.small) {
                        Image(systemName: symbolName(for: choice.boldness))
                            .accessibilityHidden(true)
                        Text(choice.text.resolved)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, DesignTokens.Spacing.xSmall)
                }
                .buttonStyle(.bordered)
                .accessibilityHint(accessibilityHint(for: choice.boldness))
            }
        }
        .padding(DesignTokens.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func symbolName(for boldness: Boldness) -> String {
        switch boldness {
        case .safe: "shield"
        case .neutral: "circle"
        case .bold: "sparkles"
        }
    }

    private func accessibilityHint(for boldness: Boldness) -> Text {
        switch boldness {
        case .safe: Text("a11y.choice.safe")
        case .neutral: Text("a11y.choice.neutral")
        case .bold: Text("a11y.choice.bold")
        }
    }
}
