import SwiftUI
import LifeDomain

/// Sahne zemini — oyunun her ekranının altında duran sinematik yüzey.
///
/// Tasarım fikri: oyuncu bir salonda oturuyor, ışık sahneden geliyor.
/// Sezon rengi o ışığın rengidir; hayat ilerledikçe ekranın atmosferi
/// değişir. Bu, "mobil uygulama" hissini kıran tek en büyük hamledir —
/// ekran sabit beyaz değil, hayatın nerede olduğunu söyleyen bir yüzeydir.
///
/// Erişilebilirlik: renk hiçbir zaman TEK BAŞINA bilgi taşımaz (sezon adı
/// her yerde metinle de yazılır) ve Reduce Motion açıkken ışık gezinmesi
/// durur, yalnız durağan degrade kalır.
struct StageBackground: View {
    /// Zemini renklendiren sezon; menüde `nil` (marka rengi kullanılır).
    var season: Season?
    /// Ortam hareketi — menüde açık, yoğun metin ekranlarında kapalı.
    var animatesLight = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme
    @State private var lightPhase: CGFloat = 0

    private var lightColor: Color {
        season?.accent ?? .accentColor
    }

    /// Işığın gücü: Dark Mode'da sahne ışığı belirgin, Light Mode'da yalnız
    /// bir sıcaklık dokunuşu (metin kontrastı asla düşmesin).
    private var lightOpacity: Double {
        colorScheme == .dark ? 0.30 : 0.13
    }

    var body: some View {
        ZStack {
            DesignTokens.Surface.stage

            // Sahne ışığı: üstten gelen yumuşak bir huzme.
            RadialGradient(
                colors: [lightColor.opacity(lightOpacity), .clear],
                center: UnitPoint(x: 0.5 + lightPhase * 0.12, y: -0.05),
                startRadius: 0,
                endRadius: 520
            )

            // Alt vinyet: dikkat metne toplansın.
            LinearGradient(
                colors: [.clear, DesignTokens.Surface.stage.opacity(0.9)],
                startPoint: .center,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
        .animation(DesignTokens.Motion.seasonShift, value: season)
        .onAppear {
            guard animatesLight, !reduceMotion else { return }
            withAnimation(DesignTokens.Motion.ambient) { lightPhase = 1 }
        }
    }
}

extension View {
    /// Ekranı sahne zeminine oturtur.
    func stageBackground(season: Season? = nil, animatesLight: Bool = false) -> some View {
        background(StageBackground(season: season, animatesLight: animatesLight))
    }
}

#Preview("Sezonlar") {
    VStack(spacing: 0) {
        ForEach(Season.allCases, id: \.self) { season in
            Text(season.localizedName)
                .font(DesignTokens.Typography.chapter)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .stageBackground(season: season)
        }
    }
}
