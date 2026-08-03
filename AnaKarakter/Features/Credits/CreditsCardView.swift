import SwiftUI
import LifeDomain

/// Paylaşım kartı formatları (docs/01: kare 1080×1080 + story 1080×1920).
/// Nokta boyutları @2x render ile piksel hedefini verir.
enum ShareCardFormat: CaseIterable {
    case square, story

    var canvasSize: CGSize {
        switch self {
        case .square: CGSize(width: 540, height: 540)
        case .story: CGSize(width: 540, height: 960)
        }
    }
}

/// Dışa aktarım kartı — SABİT tuval tasarımı. Ekran değil, üretilen görsel
/// olduğu için Dynamic Type yerine tuvale göre sabit puntolar kullanır
/// (Ekran Kalite Kapısı istisnası; erişilebilir sürüm ekrandaki özettir).
struct CreditsCardView: View {
    let card: CreditsCard
    let format: ShareCardFormat

    private var isStory: Bool { format == .story }

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 24)

            Text(String(localized: "summary.production").localizedUppercase)
                .font(.system(size: 15, design: .serif))
                .kerning(3)
                .foregroundStyle(.white.opacity(0.65))

            Text(card.name.localizedUppercase)
                .font(.system(size: isStory ? 58 : 48, weight: .bold, design: .serif))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .foregroundStyle(.white)
                .padding(.top, 10)

            Text(verbatim: "\(card.birthYear)–\(card.finalYear) · \(card.neighborhood)")
                .font(.system(size: 17, design: .serif))
                .foregroundStyle(.white.opacity(0.75))
                .padding(.top, 6)

            divider.padding(.vertical, isStory ? 26 : 18)

            // Rol listesi — jenerik akışı gibi ortalanmış.
            VStack(spacing: 8) {
                ForEach(card.roles.prefix(isStory ? 6 : 4), id: \.key) { role in
                    Text(role.resolved)
                        .font(.system(size: 19, design: .serif))
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }

            if isStory, !card.memorableScenes.isEmpty {
                divider.padding(.vertical, 26)
                VStack(spacing: 14) {
                    ForEach(card.memorableScenes, id: \.self) { scene in
                        VStack(spacing: 3) {
                            Text(String(localized: "summary.age \(scene.age)").localizedUppercase)
                                .font(.system(size: 12, design: .serif))
                                .kerning(2)
                                .foregroundStyle(.white.opacity(0.5))
                            Text(scene.text.resolved)
                                .font(.system(size: 16, design: .serif))
                                .foregroundStyle(.white.opacity(0.85))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                        }
                    }
                }
                .padding(.horizontal, 30)
            }

            Spacer(minLength: 20)

            // Alt bant: statlar + Hayat Puanı.
            HStack(spacing: 18) {
                ForEach(Stat.allCases, id: \.self) { stat in
                    VStack(spacing: 2) {
                        Image(systemName: stat.symbolName)
                            .font(.system(size: 13))
                        Text(card.finalStats[stat].formatted())
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(.white.opacity(0.8))
                }
            }

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(String(localized: "summary.score"))
                    .font(.system(size: 15, design: .serif))
                    .foregroundStyle(.white.opacity(0.65))
                Text(card.lifeScore.formatted())
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(.top, 12)

            Text(verbatim: "Ana Karakter")
                .font(.system(size: 13, design: .serif))
                .kerning(2)
                .foregroundStyle(.white.opacity(0.45))
                .padding(.top, isStory ? 22 : 14)
                .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .frame(width: format.canvasSize.width, height: format.canvasSize.height)
        .background(Color.black)
    }

    private var divider: some View {
        Rectangle()
            .fill(.white.opacity(0.25))
            .frame(width: 120, height: 1)
    }
}
