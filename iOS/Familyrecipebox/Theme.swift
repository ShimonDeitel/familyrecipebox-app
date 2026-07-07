import SwiftUI

/// Bespoke palette + typography for Family Recipe Box.
enum Theme {
    static let background = Color(hex: "#2E2118")
    static let accent = Color(hex: "#C97B3D")
    static let secondary = Color(hex: "#B5482E")
    static let cardBackground = Color(hex: "#2E2118").opacity(0.6)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.65)

    static let titleFont: Font = .system(size: 28, weight: .bold, design: .serif)
    static let bodyFont: Font = .system(size: 17, design: .serif)
    static let captionFont: Font = .system(size: 13, weight: .medium, design: .serif)
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
    }
}
