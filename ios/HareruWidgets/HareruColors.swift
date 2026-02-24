import SwiftUI

extension Color {
    // Warm Minimal palette
    static let warmCream = Color(red: 0.96, green: 0.94, blue: 0.92)       // #F5F0EB
    static let warmDarkBg = Color(red: 0.165, green: 0.165, blue: 0.165)   // #2A2A2A
    static let warmTextPrimary = Color(red: 0.10, green: 0.10, blue: 0.10) // #1A1A1A
    static let warmTextLight = Color(red: 0.94, green: 0.93, blue: 0.91)   // #F0ECE7
    static let warmTextSub = Color(red: 0.54, green: 0.54, blue: 0.54)     // #8A8A8A
    static let warmDivider = Color(red: 0.90, green: 0.88, blue: 0.86)     // #E5E0DB
    static let warmDividerDark = Color(red: 0.23, green: 0.23, blue: 0.23) // #3A3A3A
    static let warmRed = Color(red: 0.91, green: 0.27, blue: 0.24)         // #E8453C
    static let warmGreen = Color(red: 0.18, green: 0.55, blue: 0.30)       // #2D8C4E

    // Budget conditional colors
    static let budgetGreen = Color(red: 0.18, green: 0.55, blue: 0.30)     // #2D8C4E
    static let budgetYellow = Color(red: 0.95, green: 0.75, blue: 0.10)
    static let budgetRed = Color(red: 0.91, green: 0.27, blue: 0.24)       // #E8453C
}

// Adaptive background helper
struct WidgetBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        colorScheme == .dark ? Color.warmDarkBg : Color.warmCream
    }
}
