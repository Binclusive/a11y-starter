import SwiftUI

/// Visual tokens for the clone. The screen is a faithful copy of the shipping
/// app — including the parts that are wrong, like the placeholder grey below.
enum Theme {
    static let brandYellow = Color(red: 0.93, green: 0.75, blue: 0.32)
    static let brandYellowDeep = Color(red: 0.89, green: 0.68, blue: 0.20)
    static let navy = Color(red: 0.17, green: 0.22, blue: 0.30)
    static let ink = Color(red: 0.13, green: 0.16, blue: 0.22)
    static let canvas = Color(red: 0.945, green: 0.957, blue: 0.969)
    static let card = Color.white
    static let hairline = Color(red: 0.86, green: 0.88, blue: 0.91)
    static let orange = Color(red: 0.93, green: 0.35, blue: 0.16)
    static let green = Color(red: 0.20, green: 0.60, blue: 0.29)
    static let bolBolRed = Color(red: 0.90, green: 0.22, blue: 0.16)

    /// Placeholder / secondary grey as shipped — 2.4:1 on white, below the
    /// 4.5:1 WCAG 1.4.3 floor. `mutedAccessible` below is the compliant value.
    static let mutedLow = Color(red: 0.68, green: 0.71, blue: 0.75)
    /// 4.6:1 on white.
    static let mutedAccessible = Color(red: 0.42, green: 0.45, blue: 0.50)

    static let cardRadius: CGFloat = 14
}

extension View {
    func pegasusCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
    }
}
