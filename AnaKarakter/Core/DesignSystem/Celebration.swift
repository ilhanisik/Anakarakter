import SwiftUI

/// Kutlama ve sarsıntı — brief: "başarılarda konfeti, olumsuz olaylarda hafif
/// ekran sarsıntısı".
///
/// İkisi de Reduce Motion'da TAMAMEN kapanır ve yerine hiçbir işlev
/// kaybolmaz: bilgi zaten metinde ve sayıda var, bunlar yalnız vurgudur.
/// Sarsıntı bilinçli olarak çok kısa ve küçük; 12+ bir hayat oyununda
/// olumsuz an cezalandırıcı değil, dramatik olmalı.
struct Confetti: View {
    let trigger: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pieces: [Piece] = []

    private struct Piece: Identifiable {
        let id = UUID()
        let x: CGFloat
        let delay: Double
        let rotation: Double
        let tint: Color
        let size: CGFloat
    }

    private static let palette: [Color] = [
        DesignTokens.Accent.gold, DesignTokens.Accent.calm, .accentColor,
    ]

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                ForEach(pieces) { piece in
                    ConfettiPiece(piece: piece, canvasSize: proxy.size)
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onChange(of: trigger) {
            guard !reduceMotion, trigger > 0 else { return }
            burst()
        }
    }

    /// Tek konfeti parçası — derleyicinin tip denetimini kolaylaştırmak için
    /// ayrı bir görünüm (tek ifadede çok fazla modifier zinciri vardı).
    private struct ConfettiPiece: View {
        let piece: Piece
        let canvasSize: CGSize
        @State private var risen = false

        var body: some View {
            RoundedRectangle(cornerRadius: 1.5)
                .fill(piece.tint)
                .frame(width: piece.size, height: piece.size * 1.8)
                .rotationEffect(.degrees(risen ? piece.rotation : 0))
                .opacity(risen ? 0 : 1)
                .offset(y: risen ? -canvasSize.height * 0.9 : 0)
                .position(x: piece.x * canvasSize.width, y: canvasSize.height * 0.85)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.5).delay(piece.delay)) { risen = true }
                }
        }
    }

    private func burst() {
        var made: [Piece] = []
        made.reserveCapacity(18)
        for index in 0..<18 {
            let column: CGFloat = CGFloat(index % 9)
            let x: CGFloat = column / 9.0 + 0.05
            let delay: Double = Double(index % 5) * 0.06
            let rotation: Double = Double((index * 37) % 360)
            let tint: Color = Self.palette[index % Self.palette.count]
            let size: CGFloat = 5.0 + CGFloat(index % 3) * 2.0
            made.append(Piece(x: x, delay: delay, rotation: rotation, tint: tint, size: size))
        }
        pieces = made

        Task {
            try? await Task.sleep(for: .seconds(2))
            pieces = []
        }
    }
}

/// Kısa, küçük bir sarsıntı — olumsuz sonucun bedensel karşılığı.
struct Shake: ViewModifier {
    let trigger: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .onChange(of: trigger) {
                guard !reduceMotion, trigger > 0 else { return }
                Task {
                    for step in [6.0, -5.0, 3.0, -2.0, 0.0] {
                        withAnimation(.easeInOut(duration: 0.055)) { offset = step }
                        try? await Task.sleep(for: .milliseconds(55))
                    }
                }
            }
    }
}

extension View {
    func shakes(on trigger: Int) -> some View {
        modifier(Shake(trigger: trigger))
    }

    /// Kutlama katmanını üste bindirir.
    func celebrates(on trigger: Int) -> some View {
        overlay(Confetti(trigger: trigger))
    }
}
