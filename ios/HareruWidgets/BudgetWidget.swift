import SwiftUI
import WidgetKit

// MARK: - Small: 진짜 지출 (Real Expense Hero)

struct BudgetWidgetView: View {
    @Environment(\.colorScheme) var colorScheme
    let entry: HareruEntry

    private var data: HareruWidgetData { entry.data }
    private var isDark: Bool { colorScheme == .dark }

    private var textPrimary: Color {
        isDark ? .warmTextLight : .warmTextPrimary
    }

    private var progressColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.80 { return .budgetRed }
        if pct > 0.50 { return .budgetYellow }
        return .budgetGreen
    }

    private var progressRatio: CGFloat {
        min(CGFloat(data.budgetPercentUsed), 1.0)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top label
            Text(NSLocalizedString("real_expense", comment: ""))
                .font(.system(size: 10))
                .foregroundColor(.warmTextSub)

            Spacer()

            // Hero amount
            Text(formatYen(data.realExpense, currency: data.currency))
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(textPrimary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Spacer().frame(height: 12)

            if data.hasBudget {
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 1.5)
                            .fill(isDark ? Color.warmDividerDark : Color.warmDivider)
                            .frame(height: 3)
                        RoundedRectangle(cornerRadius: 1.5)
                            .fill(progressColor)
                            .frame(width: geo.size.width * progressRatio, height: 3)
                    }
                }
                .frame(height: 3)

                Spacer().frame(height: 8)

                // Remaining
                Text(budgetRemainingText())
                    .font(.system(size: 11))
                    .foregroundColor(.warmTextSub)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            } else {
                // No budget
                Text(NSLocalizedString("no_budget", comment: ""))
                    .font(.system(size: 11))
                    .foregroundColor(.warmTextSub)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .widgetURL(URL(string: "hareru://home")!)
    }

    private func budgetRemainingText() -> String {
        let prefix = NSLocalizedString("budget_remaining_prefix", comment: "")
        let suffix = NSLocalizedString("budget_remaining_suffix", comment: "")
        let amount = formatYen(data.budgetRemaining, currency: data.currency)
        var parts: [String] = []
        if !prefix.isEmpty { parts.append(prefix) }
        parts.append(amount)
        if !suffix.isEmpty { parts.append(suffix) }
        return parts.joined(separator: " ")
    }
}

struct BudgetWidget: Widget {
    let kind = "BudgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                BudgetWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        WidgetBackground()
                    }
            } else {
                BudgetWidgetView(entry: entry)
                    .padding()
                    .background(WidgetBackground())
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_budget_title", comment: ""))
        .description(NSLocalizedString("widget_budget_desc", comment: ""))
        .supportedFamilies([.systemSmall])
    }
}
