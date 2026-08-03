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
                    .contentTransition(.numericText())
                    .animation(DesignTokens.Motion.value, value: stats.money)
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
                // Sayı yerinde değişmez, sayaç gibi döner — değişim görülür.
                Text(value.formatted())
                    .font(.caption.weight(.semibold))
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(value)))
            }
            meter
        }
        .animation(DesignTokens.Motion.value, value: value)
        .pulses(on: value, tint: stat.tint)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(stat.accessibilityName)
        .accessibilityValue("\(value)/100")
    }

    /// Kendi çizdiğimiz çubuk: `ProgressView` genişliği animasyonlamıyor,
    /// oysa statın dolup boşalması oyunun en sık görülen geri bildirimi.
    private var meter: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(stat.tint.opacity(0.16))
                Capsule()
                    .fill(stat.tint)
                    .frame(width: proxy.size.width * CGFloat(value) / 100)
            }
        }
        .frame(height: 5)
    }
}

#Preview {
    StatPanelView(stats: StatBlock(health: 82, happiness: 64, intelligence: 71, social: 55, ake: 68, money: 125_000))
        .padding()
}
