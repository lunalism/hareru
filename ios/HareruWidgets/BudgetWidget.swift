import SwiftUI
import WidgetKit

struct BudgetWidgetView: View {
    let entry: HareruEntry

    private var data: HareruWidgetData { entry.data }

    private var percentUsed: Int {
        Int(data.budgetPercentUsed * 100)
    }

    private var remainingColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.85 { return .budgetRed }
        if pct > 0.60 { return .budgetYellow }
        return .budgetGreen
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Brand
            Text("◇ Hareru")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)

            if data.hasBudget {
                Spacer()

                // Main amount
                VStack(alignment: .leading, spacing: 2) {
                    Text(NSLocalizedString("remaining", comment: ""))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text(formatYen(data.budgetRemaining, currency: data.currency))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(remainingColor)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }

                Spacer()

                // Footer
                Rectangle()
                    .fill(Color(UIColor.separator))
                    .frame(height: 0.5)
                Spacer().frame(height: 8)
                Text(formatYen(data.budgetTotal, currency: data.currency) + " " + NSLocalizedString("budget_of_label", comment: "") + " · " + "\(percentUsed)%")
                    .font(.system(size: 12))
                    .foregroundColor(.tertiary)
            } else {
                Spacer()
                Text(NSLocalizedString("set_budget", comment: ""))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
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
                    .containerBackground(.fill, for: .widget)
            } else {
                BudgetWidgetView(entry: entry)
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_budget_title", comment: ""))
        .description(NSLocalizedString("widget_budget_desc", comment: ""))
        .supportedFamilies([.systemSmall])
    }
}
