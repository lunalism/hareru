import SwiftUI
import WidgetKit

struct MonthlySummaryWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    // 2x2 grid items: expense, income, transfer, saving
    private var cards: [(color: Color, label: String, amount: Int)] {
        [
            (.hareruExpense, NSLocalizedString("expense", comment: ""), data.realExpense),
            (.hareruIncome, NSLocalizedString("income_label", comment: ""), data.income),
            (.hareruTransfer, NSLocalizedString("transfer_label", comment: ""), data.transfer),
            (.hareruSaving, NSLocalizedString("saving", comment: ""), data.saving),
        ]
    }

    private var maxAmount: Int {
        max(cards.map(\.amount).max() ?? 1, 1)
    }

    private var budgetBarColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.85 { return .budgetRed }
        if pct > 0.60 { return .budgetYellow }
        return .budgetGreen
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("◇ Hareru")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatMonth(data.month))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Spacer().frame(height: 8)

            // 2x2 mini card grid
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    miniCard(cards[0])
                    miniCard(cards[1])
                }
                HStack(spacing: 8) {
                    miniCard(cards[2])
                    miniCard(cards[3])
                }
            }

            Spacer().frame(height: 8)

            // Footer
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 0.5)

            Spacer().frame(height: 6)

            HStack {
                // Left: real expense
                HStack(spacing: 4) {
                    Text(NSLocalizedString("real_expense", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(formatYen(data.realExpense, currency: data.currency))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.hareruExpense)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }

                Spacer()

                // Right: budget progress or "no budget"
                if data.hasBudget {
                    HStack(spacing: 6) {
                        // Mini progress bar
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(UIColor.separator).opacity(0.25))
                                .frame(width: 60, height: 6)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(budgetBarColor)
                                .frame(width: 60 * min(data.budgetPercentUsed, 1.0), height: 6)
                        }

                        Text("\(Int(data.budgetPercentUsed * 100))%")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(budgetBarColor)
                    }
                } else {
                    Text(NSLocalizedString("no_budget", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.tertiary)
                }
            }
        }
        .padding(16)
        .widgetURL(URL(string: "hareru://home")!)
    }

    private func miniCard(_ item: (color: Color, label: String, amount: Int)) -> some View {
        let ratio = CGFloat(item.amount) / CGFloat(maxAmount)

        return VStack(alignment: .leading, spacing: 4) {
            // Category dot + label
            HStack(spacing: 4) {
                Circle()
                    .fill(item.color)
                    .frame(width: 6, height: 6)
                Text(item.label)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }

            // Amount
            Text(formatYen(item.amount, currency: data.currency))
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(item.color)
                .minimumScaleFactor(0.4)
                .lineLimit(1)

            // Mini bar chart
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(item.color.opacity(0.15))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(item.color)
                        .frame(width: geo.size.width * ratio, height: 4)
                }
            }
            .frame(height: 4)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(item.color.opacity(0.10))
        )
    }
}

struct MonthlySummaryWidget: Widget {
    let kind = "MonthlySummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlySummaryWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color(UIColor.systemBackground)
                    }
            } else {
                MonthlySummaryWidgetView(entry: entry)
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_summary_title", comment: ""))
        .description(NSLocalizedString("widget_summary_desc", comment: ""))
        .supportedFamilies([.systemMedium])
    }
}
