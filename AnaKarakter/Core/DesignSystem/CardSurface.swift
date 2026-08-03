import SwiftUI

/// Floating kart yüzeyi — oyunun tek kart dili.
///
/// Brief: büyük, yuvarlatılmış köşeler, hafif gölge, cam etkisi, yumuşak
/// degrade. Tüm kartlar (olay, seçim, arşiv afişi) aynı yüzeyden türer ki
/// ekranlar birbirinin devamı gibi okunsun.
struct FloatingCard: ViewModifier {
    var radius: CGFloat = DesignTokens.Radius2.hero
    var tint: Color?

    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        let elevation = DesignTokens.Elevation.card(colorScheme)
        content
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(DesignTokens.Surface.card)
                    .overlay {
                        // Yumuşak degrade: kartın üstü hafif aydınlık.
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .fill(LinearGradient(
                                colors: [
                                    (tint ?? .accentColor).opacity(colorScheme == .dark ? 0.10 : 0.06),
                                    .clear,
                                ],
                                startPoint: .top,
                                endPoint: .center
                            ))
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(
                        tint?.opacity(0.30) ?? DesignTokens.Surface.cardStroke,
                        lineWidth: 1
                    )
            }
            .shadow(color: elevation.color, radius: elevation.radius, y: elevation.y)
    }
}

extension View {
    func floatingCard(radius: CGFloat = DesignTokens.Radius2.hero, tint: Color? = nil) -> some View {
        modifier(FloatingCard(radius: radius, tint: tint))
    }
}

/// Basılınca hafifçe küçülen düğme — brief: "seçim yapınca hafif scale".
/// Dokunuşun fiziksel bir karşılığı olur, oyun hissi buradan gelir.
struct PressableButtonStyle: ButtonStyle {
    var tint: Color = .accentColor

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed && !reduceMotion
        return configuration.label
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, DesignTokens.Spacing.medium)
            .padding(.horizontal, DesignTokens.Spacing.medium)
            .background {
                RoundedRectangle(cornerRadius: DesignTokens.Radius2.action, style: .continuous)
                    .fill(tint.opacity(colorScheme == .dark ? 0.18 : 0.10))
            }
            .overlay {
                RoundedRectangle(cornerRadius: DesignTokens.Radius2.action, style: .continuous)
                    .strokeBorder(tint.opacity(configuration.isPressed ? 0.65 : 0.32), lineWidth: 1)
            }
            .scaleEffect(pressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

/// Birincil eylem düğmesi — canlı altın dolgu, koyu metin.
///
/// `.borderedProminent` + `.tint(gold)` beyaz metin çiziyordu; kontrastı
/// tutturmak için altını karartmak gerekiyordu ve marka rengi kayboluyordu.
/// Metni koyulaştırmak aynı sorunu çözer, rengi de korur (kontrast ≥ 8:1).
struct GoldButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(DesignTokens.Accent.onGold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignTokens.Spacing.medium)
            .background {
                RoundedRectangle(cornerRadius: DesignTokens.Radius2.action, style: .continuous)
                    .fill(DesignTokens.Accent.goldFill)
            }
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
