import SwiftUI

/// "Sahneye giriş" — yeni beliren içerik yerine ışınlanmaz, kadraja girer.
///
/// Oyun hissinin ucuz ama en etkili parçası: bir satır anında var olursa
/// liste görünür, süzülerek gelirse sahne akar. Reduce Motion açıkken
/// hareket tamamen kalkar (içerik aynı anda ve eksiksiz görünür).
struct SceneEntrance: ViewModifier {
    var delay: Double = 0
    var offset: CGFloat = 14
    var scales = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var entered = false

    func body(content: Content) -> some View {
        content
            .opacity(entered ? 1 : 0)
            .offset(y: entered ? 0 : offset)
            .scaleEffect(scales && !entered ? 0.96 : 1, anchor: .center)
            .onAppear {
                guard !reduceMotion else {
                    entered = true
                    return
                }
                withAnimation(DesignTokens.Motion.timeline.delay(delay)) {
                    entered = true
                }
            }
    }
}

extension View {
    /// Öğe kadraja girer (fade + hafif yukarı süzülme).
    func entersScene(delay: Double = 0, offset: CGFloat = 14, scales: Bool = false) -> some View {
        modifier(SceneEntrance(delay: delay, offset: offset, scales: scales))
    }
}

/// Değeri değişince kısa bir vurgu — hangi statın oynadığı gözden kaçmasın.
/// Renk tek başına bilgi taşımaz: sayı zaten yanında yazılıdır.
struct ValuePulse: ViewModifier {
    let value: Int
    var tint: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulse = false

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.chip)
                    .fill(tint.opacity(pulse ? 0.22 : 0))
                    .padding(-DesignTokens.Spacing.xSmall)
            )
            .onChange(of: value) {
                guard !reduceMotion else { return }
                withAnimation(.easeOut(duration: 0.18)) { pulse = true }
                withAnimation(.easeIn(duration: 0.5).delay(0.18)) { pulse = false }
            }
    }
}

extension View {
    func pulses(on value: Int, tint: Color) -> some View {
        modifier(ValuePulse(value: value, tint: tint))
    }
}
