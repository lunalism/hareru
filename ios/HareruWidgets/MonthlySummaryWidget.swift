import SwiftUI
import WidgetKit

struct MonthlySummaryWidgetView: View {
    let entry: HareruEntry

    private var data: HareruWidgetData { entry.data }
    private var hasTransfer: Bool { data.apparentExpense != data.realExpense }

    private var categoryRows: [(color: Color, label: String, amount: Int)] {
        [
            (.hareruIncome, NSLocalizedString("income_label", comment: ""), data.income),
            (.hareruExpense, NSLocalizedString("expense", comment: ""), data.realExpense),
            (.hareruTransfer, NSLocalizedString("transfer_label", comment: ""), data.transfer),
            (.hareruSaving, NSLocalizedString("saving", comment: ""), data.saving),
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            // Main content
            HStack(alignment: .top, spacing: 0) {
                // Left half: main expense
                VStack(alignment: .leading, spacing: 0) {
                    Text("◇ Hareru")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)

                    Spacer()

                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("real_expense", comment: ""))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        Text(formatYen(data.realExpense, currency: data.currency))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }

                    Spacer().frame(height: 6)

                    if hasTransfer {
                        Text(NSLocalizedString("apparent_short", comment: "") + " " + formatYen(data.apparentExpense, currency: data.currency))
                            .font(.system(size: 12))
                            .foregroundColor(.tertiary)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right half: category list
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    ForEach(Array(categoryRows.enumerated()), id: \.offset) { _, row in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(row.color)
                                .frame(width: 4, height: 4)
                            Text(row.label)
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(formatYen(row.amount, currency: data.currency))
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(row.color)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Footer
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 0.5)

            Spacer().frame(height: 6)

            HStack {
                if data.hasBudget {
                    Text(NSLocalizedString("budget_remaining_label", comment: "") + " " + formatYen(data.budgetRemaining, currency: data.currency))
                        .font(.system(size: 12))
                        .foregroundColor(.primary)
                } else {
                    Text(NSLocalizedString("no_budget", comment: ""))
                        .font(.system(size: 12))
                        .foregroundColor(.tertiary)
                }
                Spacer()
                Text(formatMonth(data.month))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
    }
}

struct MonthlySummaryWidget: Widget {
    let kind = "MonthlySummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlySummaryWidgetView(entry: entry)
                    .containerBackground(.fill, for: .widget)
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
