import SwiftUI

/// Ana menü: marka + "Yeni Hayat". (Günün Hayatı ve Arşiv Faz 4'te açılır.)
struct MenuView: View {
    let dependencies: AppDependencies
    @Environment(Router.self) private var router

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.large) {
            Spacer()

            VStack(spacing: DesignTokens.Spacing.medium) {
                Image(systemName: "sparkles.tv")
                    .font(.system(size: 56))
                    .foregroundStyle(.tint)
                    .accessibilityHidden(true)
                Text("menu.title")
                    .font(.largeTitle.bold())
                Text("menu.tagline")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .accessibilityElement(children: .combine)

            Spacer()

            Button {
                let seeds = dependencies.seedSource.makeSeeds()
                router.push(.life(personSeed: seeds.personSeed, deckSeed: seeds.deckSeed))
            } label: {
                Text("menu.newLife")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(DesignTokens.Spacing.large)
    }
}

#Preview {
    NavigationStack {
        MenuView(dependencies: AppDependencies())
    }
    .environment(Router())
}
