import SwiftUI
import WidgetKit

// MARK: - Medium: Real Expense + Comparison Widget

struct RealExpenseWidgetView: View {
    @Environment(\.colorScheme) var colorScheme
    let entry: HareruEntry

    private var data: HareruWidgetData { entry.data }
    private var isDark: Bool { colorScheme == .dark }
    private var hasTransfer: Bool { data.apparentExpense != data.realExpense }
    private var diff: Int { data.apparentExpense - data.realExpense }

    private var textPrimary: Color {
        isDark ? .warmTextLight : .warmTextPrimary
    }

    private var dividerColor: Color {
        isDark ? .warmDividerDark : .warmDivider
    }

    private var progressRatio: CGFloat {
        guard data.budgetTotal > 0 else { return 0 }
        return min(CGFloat(data.budgetPercentUsed), 1.0)
    }

    private var progressColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.85 { return .budgetRed }
        if pct > 0.60 { return .budgetYellow }
        return .budgetGreen
    }

    var body: some View {
        VStack(spacing: 0) {
            // Main content
            HStack(alignment: .center, spacing: 0) {
                // Left half — Real expense (hero)
                VStack(alignment: .leading, spacing: 0) {
                    // Label
                    Text(NSLocalizedString("real_expense", comment: ""))
                        .font(.system(size: 11))
                        .foregroundColor(.warmTextSub)

                    Spacer().frame(height: 6)

                    // Hero amount
                    Text(formatYen(data.realExpense, currency: data.currency))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(textPrimary)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

                    // Progress bar
                    if data.hasBudget {
                        Spacer().frame(height: 10)

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(dividerColor)
                                    .frame(height: 4)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(progressColor)
                                    .frame(width: geo.size.width * progressRatio, height: 4)
                            }
                        }
                        .frame(height: 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right half — Apparent expense comparison
                VStack(alignment: .leading, spacing: 0) {
                    if hasTransfer {
                        // Label
                        Text(NSLocalizedString("apparent_expense", comment: ""))
                            .font(.system(size: 11))
                            .foregroundColor(.warmTextSub)

                        Spacer().frame(height: 6)

                        // Amount
                        Text(formatYen(data.apparentExpense, currency: data.currency))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.warmTextSub)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)

                        Spacer().frame(height: 8)

                        // Diff
                        Text("−" + formatYen(abs(diff), currency: data.currency) + " " + NSLocalizedString("transfer_excluded", comment: ""))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.warmGreen)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    } else {
                        Text(NSLocalizedString("same_as_apparent", comment: ""))
                            .font(.system(size: 14))
                            .foregroundColor(.warmTextSub)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            // Footer separator
            Rectangle()
                .fill(dividerColor)
                .frame(height: 0.5)

            Spacer().frame(height: 6)

            // Footer
            HStack {
                // Left: expense dot + amount
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.warmRed)
                        .frame(width: 6, height: 6)
                    Text(NSLocalizedString("expense", comment: "") + " " + formatYen(data.realExpense, currency: data.currency))
                        .font(.system(size: 10))
                        .foregroundColor(.warmRed)
                }

                Spacer()

                // Right: month
                Text(formatMonth(data.month))
                    .font(.system(size: 10))
                    .foregroundColor(.warmTextSub)
            }
        }
        .padding(16)
    }
}

// Tertiary color helper
extension Color {
    static let tertiary = Color(UIColor.tertiaryLabel)
}

struct RealExpenseWidget: Widget {
    let kind = "RealExpenseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                RealExpenseWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        WidgetBackground()
                    }
            } else {
                RealExpenseWidgetView(entry: entry)
                    .padding()
                    .background(WidgetBackground())
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_real_expense_title", comment: ""))
        .description(NSLocalizedString("widget_real_expense_desc", comment: ""))
        .supportedFamilies([.systemMedium])
    }
}
