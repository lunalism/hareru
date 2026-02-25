import SwiftUI
import WidgetKit

// MARK: - Small: Budget Widget

struct BudgetWidgetView: View {
    @Environment(\.colorScheme) var colorScheme
    let entry: HareruEntry

    private var data: HareruWidgetData { entry.data }
    private var isDark: Bool { colorScheme == .dark }

    private var percentUsed: Int {
        Int(data.budgetPercentUsed * 100)
    }

    private var remainingColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.85 { return .budgetRed }
        if pct > 0.60 { return .budgetYellow }
        return .budgetGreen
    }

    private var progressRatio: CGFloat {
        min(CGFloat(data.budgetPercentUsed), 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if data.hasBudget {
                // Label
                Text(NSLocalizedString("budget_remaining_label", comment: ""))
                    .font(.system(size: 12))
                    .foregroundColor(.warmTextSub)

                Spacer()

                // Hero amount
                Text(formatYen(data.budgetRemaining, currency: data.currency))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(remainingColor)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                Spacer().frame(height: 12)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(isDark ? Color.warmDividerDark : Color.warmDivider)
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(remainingColor)
                            .frame(width: geo.size.width * progressRatio, height: 4)
                    }
                }
                .frame(height: 4)

                Spacer().frame(height: 8)

                // Footer
                Text(formatYen(data.budgetTotal, currency: data.currency)
                     + " " + NSLocalizedString("budget_of_label", comment: "")
                     + " · " + "\(percentUsed)%")
                    .font(.system(size: 11))
                    .foregroundColor(.warmTextSub)
            } else {
                Spacer()
                Text(NSLocalizedString("set_budget", comment: ""))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.warmTextSub)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
        }
        .padding(16)
        .widgetURL(URL(string: "hareru://budget")!)
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
