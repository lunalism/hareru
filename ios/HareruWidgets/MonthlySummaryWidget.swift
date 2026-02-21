import SwiftUI
import WidgetKit

struct MonthlySummaryWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                HStack(spacing: 4) {
                    Text("◇")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.hareruPrimary)
                    Text("Hareru")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.hareruPrimary)
                }
                Spacer()
                Text(formatMonth(data.month))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Spacer().frame(height: 12)

            // 2x2 grid
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    typeSummaryRow(
                        label: NSLocalizedString("expense", comment: ""),
                        amount: data.realExpense,
                        color: .hareruExpense
                    )
                    typeSummaryRow(
                        label: NSLocalizedString("transfer_label", comment: ""),
                        amount: data.transfer,
                        color: .hareruTransfer
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 10) {
                    typeSummaryRow(
                        label: NSLocalizedString("saving", comment: ""),
                        amount: data.saving,
                        color: .hareruSaving
                    )
                    typeSummaryRow(
                        label: NSLocalizedString("income_label", comment: ""),
                        amount: data.income,
                        color: .hareruIncome
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            // Footer
            HStack {
                Text("\(NSLocalizedString("real_expense", comment: "")) \(formatYen(data.realExpense, currency: data.currency))")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.hareruExpense)

                Spacer()

                if data.hasBudget {
                    let pct = Int((1.0 - data.budgetPercentUsed) * 100)
                    Text(String(format: NSLocalizedString("budget_remaining_pct", comment: ""), max(pct, 0)))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(14)
        .widgetURL(URL(string: "hareru://report"))
    }

    private func typeSummaryRow(label: String, amount: Int, color: Color) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(formatYen(amount, currency: data.currency))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
        }
    }
}

struct MonthlySummaryWidget: Widget {
    let kind = "MonthlySummaryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlySummaryWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MonthlySummaryWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_summary_title", comment: ""))
        .description(NSLocalizedString("widget_summary_desc", comment: ""))
        .supportedFamilies([.systemMedium])
    }
}
