import SwiftUI

extension Color {
    static let hareruPrimary = Color(red: 0.33, green: 0.44, blue: 0.85)
    static let hareruBrandBlue = Color(red: 0.33, green: 0.44, blue: 0.85) // #5570DA
    static let hareruExpense = Color(red: 1.0, green: 0.32, blue: 0.32)
    static let hareruTransfer = Color(red: 0.27, green: 0.54, blue: 1.0)
    static let hareruSaving = Color(red: 0.30, green: 0.69, blue: 0.31)
    static let hareruIncome = Color(red: 0.49, green: 0.30, blue: 1.0)

    // Tinted card backgrounds (8% opacity tint)
    static let expenseTint = Color(red: 1.0, green: 0.32, blue: 0.32).opacity(0.08)
    static let transferTint = Color(red: 0.27, green: 0.54, blue: 1.0).opacity(0.08)
    static let savingTint = Color(red: 0.30, green: 0.69, blue: 0.31).opacity(0.08)
    static let incomeTint = Color(red: 0.49, green: 0.30, blue: 1.0).opacity(0.08)

    // Budget ring colors
    static let budgetGreen = Color(red: 0.30, green: 0.69, blue: 0.31)
    static let budgetYellow = Color(red: 0.95, green: 0.75, blue: 0.10)
    static let budgetRed = Color(red: 1.0, green: 0.32, blue: 0.32)
}
