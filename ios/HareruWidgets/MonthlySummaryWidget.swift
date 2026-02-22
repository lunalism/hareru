import SwiftUI
import WidgetKit

// MARK: - Large: Full Dashboard Widget

struct DashboardWidgetView: View {
    let entry: HareruEntry

    private var data: HareruWidgetData { entry.data }
    private var hasTransfer: Bool { data.apparentExpense != data.realExpense }
    private var diff: Int { data.apparentExpense - data.realExpense }

    private var categoryRows: [(color: Color, label: String, amount: Int)] {
        [
            (.hareruExpense, NSLocalizedString("expense", comment: ""), data.realExpense),
            (.hareruTransfer, NSLocalizedString("transfer_label", comment: ""), data.transfer),
            (.hareruSaving, NSLocalizedString("saving", comment: ""), data.saving),
            (.hareruIncome, NSLocalizedString("income_label", comment: ""), data.income),
        ]
    }

    private var budgetBarColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.85 { return .budgetRed }
        if pct > 0.60 { return .budgetYellow }
        return .budgetGreen
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Hareru")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatMonth(data.month))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Spacer().frame(height: 14)

            // Section 1: Real expense
            VStack(alignment: .leading, spacing: 2) {
                Text(NSLocalizedString("real_expense", comment: ""))
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Text(formatYen(data.realExpense, currency: data.currency))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                if hasTransfer {
                    Text(NSLocalizedString("apparent_short", comment: "") + " " + formatYen(data.apparentExpense, currency: data.currency) + " · −" + formatYen(abs(diff), currency: data.currency) + " " + NSLocalizedString("transfer_excluded", comment: ""))
                        .font(.system(size: 12))
                        .foregroundColor(.tertiary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }

            Spacer().frame(height: 12)

            // Divider
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 0.5)

            Spacer().frame(height: 12)

            // Section 2: Category breakdown
            VStack(spacing: 4) {
                ForEach(Array(categoryRows.enumerated()), id: \.offset) { _, row in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(row.color)
                            .frame(width: 5, height: 5)
                        Text(row.label)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatYen(row.amount, currency: data.currency))
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(row.color)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                }
            }

            Spacer().frame(height: 12)

            // Divider
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 0.5)

            Spacer().frame(height: 10)

            // Section 3: Budget
            if data.hasBudget {
                HStack(spacing: 10) {
                    Text(NSLocalizedString("budget", comment: ""))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(UIColor.separator).opacity(0.25))
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(budgetBarColor)
                                .frame(width: geo.size.width * min(data.budgetPercentUsed, 1.0), height: 6)
                        }
                    }
                    .frame(height: 6)

                    Text(formatYen(data.budgetRemaining, currency: data.currency) + " / " + formatYen(data.budgetTotal, currency: data.currency))
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            } else {
                HStack {
                    Text(NSLocalizedString("budget", comment: ""))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(NSLocalizedString("set_budget", comment: ""))
                        .font(.system(size: 11))
                        .foregroundColor(.tertiary)
                }
            }

            Spacer()
        }
        .padding(16)
    }
}

struct MonthlySummaryWidget: Widget {
    let kind = "MonthlySummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                DashboardWidgetView(entry: entry)
                    .containerBackground(.fill, for: .widget)
            } else {
                DashboardWidgetView(entry: entry)
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_dashboard_title", comment: ""))
        .description(NSLocalizedString("widget_dashboard_desc", comment: ""))
        .supportedFamilies([.systemLarge])
    }
}
