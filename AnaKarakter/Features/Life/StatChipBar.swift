import SwiftUI
import LifeDomain

/// Oyun ekranının üst şeridi: yaş + statlar, basit ikonlarla.
///
/// Brief: "üst kısımda yaş, isim, statlar — basit ikonlarla". Ayrıntılı
/// çubuklu pano jenerik ekranında kalır; oyun ekranında amaç **tek bakışta
/// okumak**, o yüzden çip düzeni. Sayılar animasyonlu değişir.
struct StatChipBar: View {
    let age: Int
    let season: Season
    let stats: StatBlock

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Erişilebilirlik boyutlarında çipler sarar; hiçbir sayı kırpılmaz.
    private var columns: [GridItem] {
        let minimum: CGFloat = dynamicTypeSize.isAccessibilitySize ? 150 : 88
        return [GridItem(.adaptive(minimum: minimum), spacing: DesignTokens.Spacing.small)]
    }

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.small) {
            header
            LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.small) {
                ForEach(Stat.allCases, id: \.self) { stat in
                    StatChip(
                        symbol: stat.symbolName,
                        tint: stat.tint,
                        value: stats[stat].formatted(),
                        label: Text(stat.accessibilityName),
                        accessibilityValue: "\(stats[stat])/100",
                        changeKey: stats[stat]
                    )
                }
                StatChip(
                    symbol: "turkishlirasign.circle.fill",
                    tint: DesignTokens.Accent.gold,
                    value: stats.money.liraFormatted,
                    label: Text("stat.money"),
                    accessibilityValue: stats.money.liraFormatted,
                    changeKey: stats.money
                )
            }
        }
    }

    /// Yaş + sezon — hayatın nerede olduğunu söyleyen tek satır.
    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: DesignTokens.Spacing.small) {
            Text("life.age \(age)")
                .font(.title3.weight(.bold))
                .contentTransition(.numericText(value: Double(age)))
            Text(season.localizedName)
                .font(.subheadline)
                .foregroundStyle(season.accent)
            Spacer(minLength: 0)
        }
        .animation(DesignTokens.Motion.value, value: age)
        .accessibilityElement(children: .combine)
    }
}

/// Tek stat çipi.
private struct StatChip: View {
    let symbol: String
    let tint: Color
    let value: String
    let label: Text
    let accessibilityValue: String
    /// Değer değişince vurgu için izlenen sayı.
    let changeKey: Int

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xSmall) {
            Image(systemName: symbol)
                .font(.caption)
                .foregroundStyle(tint)
                .accessibilityHidden(true)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .contentTransition(.numericText())
                // minimumScaleFactor KULLANILMAZ: metni küçültmek erişilebilirlik
                // denetiminde "kırpılmış metin" sayılır. Çip yerine genişler.
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(.vertical, DesignTokens.Spacing.small)
        .padding(.horizontal, DesignTokens.Spacing.small)
        .background {
            RoundedRectangle(cornerRadius: DesignTokens.Radius.chip, style: .continuous)
                .fill(tint.opacity(0.12))
        }
        .animation(DesignTokens.Motion.value, value: changeKey)
        .pulses(on: changeKey, tint: tint)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(accessibilityValue)
    }
}
