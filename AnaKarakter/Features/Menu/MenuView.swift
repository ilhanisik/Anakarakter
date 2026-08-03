import SwiftUI
import LifeDomain

/// Ana menü: marka + Günün Hayatı + Serbest Hayat + Arşiv + Ayarlar.
struct MenuView: View {
    let dependencies: AppDependencies
    @Environment(Router.self) private var router
    @State private var daily: DailyViewModel

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _daily = State(initialValue: dependencies.makeDailyViewModel())
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.large) {
                masthead
                dailyCard
                freeLifeButton
                secondaryLinks
            }
            .padding(DesignTokens.Spacing.large)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(DesignTokens.Surface.canvas)
        .onAppear { daily.reload() }
    }

    /// Marka bloğu — afiş dili: üstte künye satırı, ortada büyük serif isim,
    /// altında slogan. Jenerik kartıyla aynı tipografiyi konuşur.
    private var masthead: some View {
        VStack(spacing: DesignTokens.Spacing.small) {
            Text(String(localized: "summary.production").uppercased())
                .font(DesignTokens.Typography.creditsCaption)
                .kerning(3)
                .foregroundStyle(DesignTokens.TextColor.secondary)
                .entersScene(delay: 0.05)

            Text("menu.title")
                .font(DesignTokens.Typography.marquee)
                .kerning(1)
                .multilineTextAlignment(.center)
                .entersScene(delay: 0.12, offset: 18)

            rule
                .entersScene(delay: 0.2)

            Text("menu.tagline")
                .font(DesignTokens.Typography.sceneBody)
                .foregroundStyle(DesignTokens.TextColor.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.medium)
                .entersScene(delay: 0.26)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, DesignTokens.Spacing.large)
        .accessibilityElement(children: .combine)
    }

    private var rule: some View {
        Rectangle()
            .fill(Color.accentColor.opacity(0.45))
            .frame(width: 120, height: 1)
            .accessibilityHidden(true)
    }

    /// Günün Hayatı — ritüelin kalbi. Seri baskı aracı değil; oynanmadıysa
    /// davet, oynandıysa kutlama gösterilir (karanlık desen yasağı).
    private var dailyCard: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
            HStack {
                Label("menu.daily.title", systemImage: "calendar")
                    .font(.headline)
                Spacer()
                if daily.streak.current > 0 {
                    Label("menu.daily.streak \(daily.streak.current)", systemImage: "flame.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Season.cocukluk.accent)
                }
            }

            Text(daily.hasPlayedToday ? "menu.daily.done" : "menu.daily.invite")
                .font(.subheadline)
                .foregroundStyle(DesignTokens.TextColor.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if daily.streak.graceRemaining > 0 {
                Label("menu.daily.grace \(daily.streak.graceRemaining)", systemImage: "heart.fill")
                    .font(.caption)
                    .foregroundStyle(DesignTokens.TextColor.secondary)
            }

            Button {
                if let completed = daily.completedLifeID {
                    router.push(.archivedCredits(id: completed))
                } else {
                    let seeds = daily.seeds
                    router.push(.dailyLife(personSeed: seeds.personSeed, deckSeed: seeds.deckSeed))
                }
            } label: {
                Text(daily.hasPlayedToday ? "menu.daily.review" : "menu.daily.play")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(DesignTokens.Accent.gold)
            .padding(.top, DesignTokens.Spacing.xSmall)
        }
        .padding(DesignTokens.Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .floatingCard(tint: DesignTokens.Accent.gold)
        .entersScene(delay: 0.34, offset: 20)
    }

    private var freeLifeButton: some View {
        Button {
            let seeds = dependencies.seedSource.makeSeeds()
            router.push(.freeLife(personSeed: seeds.personSeed, deckSeed: seeds.deckSeed))
        } label: {
            Text("menu.newLife")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .entersScene(delay: 0.42)
    }

    private var secondaryLinks: some View {
        VStack(spacing: DesignTokens.Spacing.small) {
            Button {
                router.push(.archive)
            } label: {
                Label("menu.archive", systemImage: "film.stack")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                router.push(.settings)
            } label: {
                Label("menu.settings", systemImage: "gearshape")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .entersScene(delay: 0.5)
    }
}

#Preview {
    NavigationStack {
        MenuView(dependencies: AppDependencies())
    }
    .environment(Router())
}
