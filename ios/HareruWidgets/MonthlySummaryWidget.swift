import SwiftUI
import WidgetKit

struct MonthlySummaryWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    private var budgetPercentRemaining: Double {
        max(1.0 - data.budgetPercentUsed, 0)
    }

    private var miniRingColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.85 { return .budgetRed }
        if pct > 0.60 { return .budgetYellow }
        return .budgetGreen
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header bar
            HStack {
                Text("◇ Hareru")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)

                Spacer()

                Text(formatMonth(data.month))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Spacer().frame(height: 10)

            // 2x2 grid
            HStack(spacing: 6) {
                VStack(spacing: 6) {
                    categoryCard(
                        label: NSLocalizedString("expense", comment: ""),
                        amount: data.realExpense,
                        color: .hareruExpense
                    )
                    categoryCard(
                        label: NSLocalizedString("transfer_label", comment: ""),
                        amount: data.transfer,
                        color: .hareruTransfer
                    )
                }

                VStack(spacing: 6) {
                    categoryCard(
                        label: NSLocalizedString("saving", comment: ""),
                        amount: data.saving,
                        color: .hareruSaving
                    )
                    categoryCard(
                        label: NSLocalizedString("income_label", comment: ""),
                        amount: data.income,
                        color: .hareruIncome
                    )
                }
            }

            Spacer().frame(height: 10)

            // Separator
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 0.5)

            Spacer().frame(height: 10)

            // Footer bar
            HStack(spacing: 0) {
                // Real expense
                Text(NSLocalizedString("real_expense", comment: ""))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.hareruExpense)
                Text(" ")
                Text(formatYen(data.realExpense, currency: data.currency))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.hareruExpense)

                Spacer()

                // Mini progress ring + percentage
                if data.hasBudget {
                    HStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .stroke(
                                    Color(UIColor.separator).opacity(0.3),
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                                )
                            Circle()
                                .trim(from: 0, to: budgetPercentRemaining)
                                .stroke(
                                    miniRingColor,
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                        }
                        .frame(width: 24, height: 24)

                        Text("\(Int(budgetPercentRemaining * 100))%")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(miniRingColor)
                    }
                }
            }
        }
        .padding(16)
        .widgetURL(URL(string: "hareru://report"))
    }

    private func categoryCard(label: String, amount: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            // Color dot + category name
            HStack(spacing: 5) {
                Circle()
                    .fill(color)
                    .frame(width: 7, height: 7)
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }

            // Amount
            Text(formatYen(amount, currency: data.currency))
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.12))
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
