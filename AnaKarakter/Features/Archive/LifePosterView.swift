import SwiftUI
import LifeDomain

/// Arşivdeki bir hayatın afişi.
///
/// Arşiv bir liste değil **afiş duvarı**: her biten hayat, duvara asılan bir
/// film afişi bırakır. Koleksiyon hissi tekrar oynamanın motoru (docs/03 risk
/// tablosu: "tekrar oynanabilirlik erken tükenir").
///
/// Afiş, hayatın kendisinden deterministik olarak türer: renk ölüm sezonundan,
/// motif seed'den. Aynı hayat her açılışta aynı afişi verir.
struct LifePosterView: View {
    let life: ArchivedLife

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Hayatın kapandığı sezon afişin rengini belirler.
    private var season: Season {
        Season.forAge(life.card.finalYear - life.card.birthYear)
    }

    private var variant: (rotation: Angle, symbolScale: CGFloat) {
        var rng = SeededRandomSource(seed: life.personSeed ^ life.deckSeed)
        return (.degrees(Double(rng.int(in: -8...8))), 1.0 + CGFloat(rng.int(in: 0...3)) * 0.08)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            artwork
            caption
        }
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(.regularMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .strokeBorder(season.accent.opacity(0.35), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.card))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("archive.poster.a11y \(life.name) \(life.card.birthYear) \(life.card.finalYear) \(life.lifeScore)"))
    }

    /// Afişin görsel alanı — sezon rengi + motif + künye.
    private var artwork: some View {
        ZStack {
            LinearGradient(
                colors: [season.accent, season.accent.opacity(0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            // Metin kontrastı için karartma; renk tek başına bilgi taşımaz.
            Color.black.opacity(0.28)

            VStack(spacing: DesignTokens.Spacing.xSmall) {
                Image(systemName: season.posterSymbol)
                    .font(.system(size: 28))
                    .scaleEffect(variant.symbolScale)
                    .rotationEffect(variant.rotation)
                    .foregroundStyle(.white.opacity(0.92))
                    .accessibilityHidden(true)

                Text(life.name.uppercased())
                    .font(DesignTokens.Typography.chapter)
                    .kerning(1.5)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(DesignTokens.Spacing.small)
        }
        .frame(height: dynamicTypeSize.isAccessibilitySize ? 96 : 128)
    }

    /// Künye bandı — afişin altındaki bilgi şeridi.
    private var caption: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(verbatim: "\(life.card.birthYear)–\(life.card.finalYear)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()

            HStack(spacing: DesignTokens.Spacing.xSmall) {
                Text("archive.score \(life.lifeScore)")
                    .font(.caption.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(season.accent)
                Spacer(minLength: 0)
                if life.mode == .daily {
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignTokens.Spacing.small)
    }
}
