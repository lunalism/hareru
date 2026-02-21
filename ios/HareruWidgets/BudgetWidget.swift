import SwiftUI
import WidgetKit

struct BudgetWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    private var barColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.9 { return .hareruExpense }
        if pct > 0.7 { return .orange }
        return .hareruSaving
    }

    private var remainingColor: Color {
        data.budgetRemaining < 0 ? .hareruExpense : barColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Logo
            HStack(spacing: 4) {
                Text("◇")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.hareruPrimary)
                Text(NSLocalizedString("budget", comment: ""))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.hareruPrimary)
            }

            Spacer()

            if data.hasBudget {
                // Remaining
                Text(NSLocalizedString("remaining", comment: ""))
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)

                Text(formatYen(data.budgetRemaining, currency: data.currency))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(remainingColor)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)

                Spacer().frame(height: 8)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorScheme == .dark
                                  ? Color(white: 0.25)
                                  : Color(white: 0.9))
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(barColor)
                            .frame(
                                width: geo.size.width * min(data.budgetPercentUsed, 1.0),
                                height: 8
                            )
                    }
                }
                .frame(height: 8)

                Spacer().frame(height: 6)

                // Budget total
                let man = data.budgetTotal / 10000
                let remainder = data.budgetTotal % 10000
                Text(remainder == 0 && man > 0
                     ? String(format: NSLocalizedString("budget_of_man", comment: ""), man)
                     : formatYen(data.budgetTotal, currency: data.currency))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            } else {
                Text(NSLocalizedString("set_budget", comment: ""))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Spacer()
        }
        .padding(14)
        .widgetURL(URL(string: "hareru://report"))
    }
}

struct BudgetWidget: Widget {
    let kind = "BudgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                BudgetWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BudgetWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_budget_title", comment: ""))
        .description(NSLocalizedString("widget_budget_desc", comment: ""))
        .supportedFamilies([.systemSmall])
    }
}
