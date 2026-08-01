import SwiftUI

/// Faz 0 yer tutucusu — Faz 2'de gerçek menü gelir:
/// yeni hayat, Günün Hayatı, Jenerik Arşivi, ayarlar.
struct MenuView: View {
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.medium) {
            Text("menu.title")
                .font(.largeTitle.bold())
            Text("menu.phase0.status")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(DesignTokens.Spacing.large)
    }
}

#Preview {
    MenuView()
}
