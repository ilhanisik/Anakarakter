import SwiftUI
import LifeDomain

/// Ekranın ortasındaki büyük olay kartı — oyunun kalbi.
///
/// Brief: "orta bölümde büyük olay kartı; içinde olay başlığı, kısa açıklama,
/// illüstrasyon". Bu oyun **metin-öncelikli** (CLAUDE.md) olduğu için
/// illüstrasyonun yerini sezon motifi + renk alır: her kart, hayatın hangi
/// perdesinde geçtiğini görselleştirir. Karakter çizimi yok, atmosfer var.
struct EventCardView: View {
    let season: Season
    let title: String
    /// Sonuç metni — karar verildikten sonra kartın altına düşer.
    var outcome: String?
    var deltas: String?
    /// Sonuç olumsuzsa vurgu turuncuya döner (kırmızı yok — bkz. brief).
    var isSetback = false

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
            motif
            Text(title)
                .font(.title3.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)

            if let outcome {
                Divider().opacity(0.5)
                Text(outcome)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            if let deltas {
                Text(deltas)
                    .font(.footnote.weight(.medium))
                    .monospacedDigit()
                    .foregroundStyle(isSetback ? DesignTokens.Accent.warn : DesignTokens.Accent.gold)
            }
        }
        .padding(DesignTokens.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .floatingCard(tint: season.accent)
        .accessibilityElement(children: .combine)
    }

    /// Sezon rozeti — illüstrasyon yerine atmosfer.
    private var motif: some View {
        HStack(spacing: DesignTokens.Spacing.small) {
            Image(systemName: season.posterSymbol)
                .font(.headline)
                .foregroundStyle(season.accent)
                .accessibilityHidden(true)
            Text(season.localizedName.localizedUppercase)
                .font(.caption.weight(.semibold))
                .kerning(1.5)
                .foregroundStyle(season.accent)
            Spacer(minLength: 0)
        }
    }
}

/// Büyük seçim düğmesi — brief: "alt bölümde büyük seçim butonları",
/// tek elle ulaşılabilir, aranmadan bulunur.
struct ChoiceButton: View {
    let choice: Choice
    let action: () -> Void

    private var tint: Color {
        switch choice.boldness {
        case .safe: DesignTokens.Accent.calm
        case .neutral: .accentColor
        case .bold: DesignTokens.Accent.gold
        }
    }

    private var symbol: String {
        switch choice.boldness {
        case .safe: "shield"
        case .neutral: "circle"
        case .bold: "sparkles"
        }
    }

    private var hint: Text {
        switch choice.boldness {
        case .safe: Text("a11y.choice.safe")
        case .neutral: Text("a11y.choice.neutral")
        case .bold: Text("a11y.choice.bold")
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.medium) {
                Image(systemName: symbol)
                    .font(.headline)
                    .foregroundStyle(tint)
                    .frame(width: 24)
                    .accessibilityHidden(true)
                Text(choice.text.resolved)
                    .font(.body.weight(.medium))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
        }
        .buttonStyle(PressableButtonStyle(tint: tint))
        .accessibilityHint(hint)
    }
}
