import SwiftUI
import LifeDomain

/// Jeneratif sezon afişi — hayatın her perdesi için basılmış bir film afişi.
///
/// Kompozisyon bilinçli olarak afiş dilindedir ve yukarıdan aşağı okunur:
/// **künye** (perde numarası) → **motif** → **başlık** (sezon adı) →
/// **oyuncu** (karakter adı) → **yıllar**. Aynı hiyerarşi jenerik kartında da
/// var; oyun tek bir grafik dil konuşuyor.
///
/// Varyasyon tamamen deterministiktir: ışığın geldiği yön, motifin açısı ve
/// grenin dağılımı seed'den türer — aynı hayat aynı afişi basar.
struct SeasonPosterView: View {
    let season: Season
    let personName: String
    let variantSeed: UInt64

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private struct Variant {
        let lightAnchor: UnitPoint
        let symbolRotation: Angle
        let symbolScale: CGFloat
        /// Kâğıt greni — afişe baskı dokusu veren noktalar.
        let grain: [GrainDot]
    }

    private struct GrainDot {
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
    }

    private var variant: Variant {
        var rng = SeededRandomSource(seed: variantSeed)
        let anchors: [UnitPoint] = [
            .topLeading, .top, .topTrailing,
            UnitPoint(x: 0.3, y: 0.1), UnitPoint(x: 0.7, y: 0.15),
        ]
        let anchor = anchors[rng.int(in: 0...(anchors.count - 1))]

        // Gren sabit sayıda ve önceden hesaplanır: çizim başına iş sabit
        // kalsın, kaydırmada jank olmasın (Ekran Kalite Kapısı).
        var grain: [GrainDot] = []
        grain.reserveCapacity(180)
        for _ in 0..<180 {
            grain.append(GrainDot(
                x: CGFloat(rng.int(in: 0...1000)) / 1000,
                y: CGFloat(rng.int(in: 0...1000)) / 1000,
                size: CGFloat(rng.int(in: 1...3)),
                opacity: Double(rng.int(in: 3...11)) / 100
            ))
        }

        return Variant(
            lightAnchor: anchor,
            symbolRotation: .degrees(Double(rng.int(in: -8...8))),
            symbolScale: 1.0 + CGFloat(rng.int(in: 0...4)) * 0.07,
            grain: grain
        )
    }

    /// Erişilebilirlik boyutlarında afiş uzar; metin kırpılmaz.
    private var minimumHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 340 : 260
    }

    var body: some View {
        let variant = variant
        VStack(spacing: DesignTokens.Spacing.small) {
            billing
            motif(variant)
            title
            Spacer(minLength: 0)
            footer
        }
        .padding(DesignTokens.Spacing.medium)
        .frame(maxWidth: .infinity, minHeight: minimumHeight)
        .background { surface(variant) }
        .overlay { printFrame }
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.card))
        .entersScene(offset: 24, scales: true)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("poster.a11y \(season.localizedName)"))
    }

    // MARK: Kompozisyon

    /// Künye satırı — "PERDE II".
    private var billing: some View {
        Text("poster.act \(season.actNumeral)")
            .font(DesignTokens.Typography.creditsCaption)
            .kerning(3)
            .foregroundStyle(.white.opacity(0.7))
    }

    private func motif(_ variant: Variant) -> some View {
        Image(systemName: season.posterSymbol)
            .font(.system(size: 44))
            .scaleEffect(variant.symbolScale)
            .rotationEffect(variant.symbolRotation)
            .foregroundStyle(.white.opacity(0.95))
            .shadow(color: .black.opacity(0.35), radius: 12, y: 4)
            .padding(.vertical, DesignTokens.Spacing.small)
            .accessibilityHidden(true)
    }

    private var title: some View {
        Text(season.localizedName.uppercased())
            .font(DesignTokens.Typography.posterTitle)
            .kerning(2)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.7)
    }

    /// Alt bant: oyuncu adı + perdenin yaş aralığı.
    private var footer: some View {
        VStack(spacing: DesignTokens.Spacing.xSmall) {
            rule
            Text(personName.uppercased())
                .font(DesignTokens.Typography.creditsCaption)
                .kerning(2)
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(verbatim: ageRangeText)
                .font(.caption2)
                .kerning(1)
                .foregroundStyle(.white.opacity(0.6))
                .monospacedDigit()
        }
    }

    private var ageRangeText: String {
        let range = season.ageRange
        return range.upperBound >= LifeDomain.maximumAge
            ? "\(range.lowerBound)+"
            : "\(range.lowerBound)–\(range.upperBound)"
    }

    private var rule: some View {
        Rectangle()
            .fill(.white.opacity(0.35))
            .frame(width: 64, height: 1)
            .accessibilityHidden(true)
    }

    // MARK: Yüzey

    /// Afişin basılı yüzeyi: sezon rengi + yönlü ışık + vinyet + gren.
    private func surface(_ variant: Variant) -> some View {
        ZStack {
            LinearGradient(
                colors: [season.accent, season.accent.opacity(0.5)],
                startPoint: variant.lightAnchor,
                endPoint: UnitPoint(x: 1 - variant.lightAnchor.x, y: 1)
            )

            // Işık kaynağı — motifin arkasına düşen huzme.
            RadialGradient(
                colors: [.white.opacity(0.28), .clear],
                center: variant.lightAnchor,
                startRadius: 0,
                endRadius: 260
            )

            // Vinyet: kenarlar kararır, metin kontrastı korunur.
            RadialGradient(
                colors: [.clear, .black.opacity(0.45)],
                center: .center,
                startRadius: 80,
                endRadius: 300
            )

            grainLayer(variant)
        }
    }

    /// Kâğıt greni — afişe baskı dokusu. Noktalar seed'den geldiği için
    /// aynı hayat aynı dokuyu basar.
    private func grainLayer(_ variant: Variant) -> some View {
        Canvas { context, size in
            for dot in variant.grain {
                let rect = CGRect(
                    x: dot.x * size.width, y: dot.y * size.height,
                    width: dot.size, height: dot.size
                )
                context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(dot.opacity)))
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    /// Afiş çerçevesi — baskı kenarı.
    private var printFrame: some View {
        RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
            .inset(by: 6)
            .strokeBorder(.white.opacity(0.22), lineWidth: 1)
            .accessibilityHidden(true)
    }
}

#Preview("Afişler") {
    ScrollView {
        VStack(spacing: DesignTokens.Spacing.medium) {
            ForEach(Array(Season.allCases.enumerated()), id: \.element) { index, season in
                SeasonPosterView(
                    season: season,
                    personName: "Ayşe Yıldırım",
                    variantSeed: UInt64(index * 977 + 13)
                )
            }
        }
        .padding()
    }
}
