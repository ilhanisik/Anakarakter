import SwiftUI

/// Semantic design system token'ları — ekranlarda hardcoded değer yasağının
/// tek adresi (CLAUDE.md Ekran Kalite Kapısı).
/// Faz 3'te tipografi ölçeği ve sezon paletleriyle genişler.
enum DesignTokens {
    enum Spacing {
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }

    enum Radius {
        static let card: CGFloat = 16
        static let chip: CGFloat = 8
    }
}
