import SwiftUI

extension Color {
    static let hareruPrimary = Color(red: 0.33, green: 0.44, blue: 0.85)
    static let hareruBrandBlue = Color(red: 0.33, green: 0.44, blue: 0.85) // #5570DA
    static let hareruExpense = Color(red: 1.0, green: 0.32, blue: 0.32)
    static let hareruTransfer = Color(red: 0.27, green: 0.54, blue: 1.0)
    static let hareruSaving = Color(red: 0.30, green: 0.69, blue: 0.31)
    static let hareruIncome = Color(red: 0.49, green: 0.30, blue: 1.0)

    // Gradient backgrounds
    static let widgetLightTop = Color.white
    static let widgetLightBottom = Color(red: 0.94, green: 0.96, blue: 1.0) // #F0F4FF
    static let widgetDarkTop = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
    static let widgetDarkBottom = Color(red: 0.17, green: 0.17, blue: 0.18) // #2C2C2E

    // Tinted card backgrounds (10% opacity tint)
    static let expenseTint = Color(red: 1.0, green: 0.32, blue: 0.32).opacity(0.10)
    static let transferTint = Color(red: 0.27, green: 0.54, blue: 1.0).opacity(0.10)
    static let savingTint = Color(red: 0.30, green: 0.69, blue: 0.31).opacity(0.10)
    static let incomeTint = Color(red: 0.49, green: 0.30, blue: 1.0).opacity(0.10)
}

struct WidgetGradientBackground: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        LinearGradient(
            colors: colorScheme == .dark
                ? [.widgetDarkTop, .widgetDarkBottom]
                : [.widgetLightTop, .widgetLightBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
