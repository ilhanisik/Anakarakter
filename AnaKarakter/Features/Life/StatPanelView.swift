import SwiftUI
import LifeDomain

/// Stat panosu: 5 stat göstergesi + para satırı.
/// Renk dekoratiftir; bilgi ikon + ad + sayı ile taşınır (erişilebilirlik).
struct StatPanelView: View {
    let stats: StatBlock
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Erişilebilirlik boyutlarında göstergeler tek/iki kolona düşer;
    /// stat adları kısalmadan okunur (Dynamic Type kalite kapısı).
    private var columns: [GridItem] {
        let minimum: CGFloat = dynamicTypeSize.isAccessibilitySize ? 220 : 96
        return [GridItem(.adaptive(minimum: minimum), spacing: DesignTokens.Spacing.small)]
    }

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.small) {
            LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.small) {
                ForEach(Stat.allCases, id: \.self) { stat in
                    StatGaugeView(stat: stat, value: stats[stat])
                }
            }
            HStack(spacing: DesignTokens.Spacing.small) {
                Image(systemName: "turkishlirasign.circle.fill")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                Text("stat.money")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer(minLength: DesignTokens.Spacing.small)
                Text(stats.money.liraFormatted)
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
            }
            .accessibilityElement(children: .combine)
        }
    }
}

private struct StatGaugeView: View {
    let stat: Stat
    let value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xSmall) {
            HStack(spacing: DesignTokens.Spacing.xSmall) {
                Image(systemName: stat.symbolName)
                    .font(.caption)
                    .foregroundStyle(stat.tint)
                    .accessibilityHidden(true)
                Text(stat.localizedName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Spacer(minLength: 0)
                Text(value.formatted())
                    .font(.caption.weight(.semibold))
                    .monospacedDigit()
            }
            ProgressView(value: Double(value), total: 100)
                .tint(stat.tint)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(stat.accessibilityName)
        .accessibilityValue("\(value)/100")
    }
}

#Preview {
    StatPanelView(stats: StatBlock(health: 82, happiness: 64, intelligence: 71, social: 55, ake: 68, money: 125_000))
        .padding()
}
