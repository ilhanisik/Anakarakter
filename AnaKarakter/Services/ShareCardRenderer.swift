import SwiftUI
import LifeDomain

/// Jenerik kartı görselleştirici: `CreditsCard` verisi → paylaşılabilir `Image`.
/// Üretim anlıktır, ağ yok, diske yazılmaz (docs/02).
@MainActor
enum ShareCardRenderer {
    /// @2x ölçek: 540pt tuval → 1080px hedef.
    static func render(card: CreditsCard, format: ShareCardFormat) -> Image? {
        let renderer = ImageRenderer(content: CreditsCardView(card: card, format: format))
        renderer.scale = 2
        guard let cgImage = renderer.cgImage else { return nil }
        return Image(decorative: cgImage, scale: 2)
    }
}
