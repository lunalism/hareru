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
            HStack(alignment: .top, spacing: 0) {
                // Left half — Real expense (main)
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()

                    // Label — matches app home
                    Text(NSLocalizedString("real_expense", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.warmTextSub)

                    Spacer().frame(height: 4)

                    // Amount
                    Text(formatYen(data.realExpense, currency: data.currency))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(textPrimary)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

                    Spacer().frame(height: 10)

                    // Progress bar
                    if data.hasBudget {
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

                        Spacer().frame(height: 6)

                        // Budget remaining — matches app home
                        Text(budgetRemainingText())
                            .font(.system(size: 10))
                            .foregroundColor(.warmTextSub)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right half — Apparent expense comparison
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()

                    if hasTransfer {
                        VStack(alignment: .leading, spacing: 6) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(NSLocalizedString("apparent_expense", comment: ""))
                                    .font(.system(size: 10))
                                    .foregroundColor(.warmTextSub)
                                Text(formatYen(data.apparentExpense, currency: data.currency))
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.warmTextSub)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                            }

                            Text("−" + formatYen(abs(diff), currency: data.currency) + " " + NSLocalizedString("transfer_excluded", comment: ""))
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.warmGreen)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                    } else {
                        Text(NSLocalizedString("same_as_apparent", comment: ""))
                            .font(.system(size: 14))
                            .foregroundColor(.warmTextSub)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

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

    private func budgetRemainingText() -> String {
        let prefix = NSLocalizedString("budget_remaining_prefix", comment: "")
        let suffix = NSLocalizedString("budget_remaining_suffix", comment: "")
        let amount = formatYen(data.budgetRemaining, currency: data.currency)
        if prefix.isEmpty {
            return "\(amount) \(suffix)"
        }
        return "\(prefix) \(amount) \(suffix)"
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
