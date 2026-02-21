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
                HStack(spacing: 5) {
                    Text("◇")
                        .font(.system(size: 12, weight: .heavy))
                    Text("Hareru")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule().fill(Color.hareruBrandBlue)
                )

                Spacer()

                Text(formatMonth(data.month))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
            }

            Spacer().frame(height: 12)

            // 2x2 grid with tinted cards
            HStack(spacing: 8) {
                VStack(spacing: 8) {
                    typeCard(
                        label: NSLocalizedString("expense", comment: ""),
                        amount: data.realExpense,
                        color: .hareruExpense,
                        tint: .expenseTint
                    )
                    typeCard(
                        label: NSLocalizedString("transfer_label", comment: ""),
                        amount: data.transfer,
                        color: .hareruTransfer,
                        tint: .transferTint
                    )
                }

                VStack(spacing: 8) {
                    typeCard(
                        label: NSLocalizedString("saving", comment: ""),
                        amount: data.saving,
                        color: .hareruSaving,
                        tint: .savingTint
                    )
                    typeCard(
                        label: NSLocalizedString("income_label", comment: ""),
                        amount: data.income,
                        color: .hareruIncome,
                        tint: .incomeTint
                    )
                }
            }

            Spacer().frame(height: 10)

            // Footer banner
            HStack {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.hareruExpense)
                        .frame(width: 6, height: 6)
                    Text(NSLocalizedString("real_expense", comment: ""))
                        .font(.system(size: 10, weight: .semibold))
                    Text(formatYen(data.realExpense, currency: data.currency))
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)

                Spacer()

                if data.hasBudget {
                    let pct = Int((1.0 - data.budgetPercentUsed) * 100)
                    Text(String(format: NSLocalizedString("budget_remaining_pct", comment: ""), max(pct, 0)))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.hareruBrandBlue)
            )
        }
        .padding(14)
        .widgetURL(URL(string: "hareru://report"))
    }

    private func typeCard(label: String, amount: Int, color: Color, tint: Color) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
                Text(formatYen(amount, currency: data.currency))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(tint)
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
                        WidgetGradientBackground()
                    }
            } else {
                MonthlySummaryWidgetView(entry: entry)
                    .padding()
                    .background(WidgetGradientBackground())
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_summary_title", comment: ""))
        .description(NSLocalizedString("widget_summary_desc", comment: ""))
        .supportedFamilies([.systemMedium])
    }
}
