import SwiftUI
import WidgetKit

struct RealExpenseWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    private var diff: Int { data.apparentExpense - data.realExpense }
    private var isSaving: Bool { diff > 0 }
    private var barRatio: CGFloat {
        guard data.apparentExpense > 0 else { return 1.0 }
        return CGFloat(data.realExpense) / CGFloat(data.apparentExpense)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Brand mark
            Text("◇ Hareru")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)

            Spacer()

            // Bar chart comparison
            VStack(alignment: .leading, spacing: 10) {
                // Real expense bar
                barRow(
                    label: NSLocalizedString("real_expense_short", comment: ""),
                    amount: data.realExpense,
                    ratio: barRatio,
                    barColor: .hareruExpense,
                    amountFont: .system(size: 20, weight: .bold, design: .rounded),
                    amountColor: .hareruExpense
                )

                // Apparent expense bar
                barRow(
                    label: NSLocalizedString("apparent_short", comment: ""),
                    amount: data.apparentExpense,
                    ratio: 1.0,
                    barColor: Color(UIColor.separator),
                    amountFont: .system(size: 14, weight: .medium, design: .rounded),
                    amountColor: .secondary
                )
            }

            Spacer()

            // Savings indicator
            if diff > 0 {
                HStack(spacing: 3) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 10, weight: .bold))
                    Text(formatYen(diff, currency: data.currency) + " " + NSLocalizedString("saved", comment: ""))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
                .foregroundColor(.hareruSaving)
            } else if diff < 0 {
                HStack(spacing: 3) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 10, weight: .bold))
                    Text(formatYen(abs(diff), currency: data.currency) + " " + NSLocalizedString("over", comment: ""))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
                .foregroundColor(.hareruExpense)
            } else {
                Text(NSLocalizedString("no_transfer", comment: ""))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .widgetURL(URL(string: "hareru://report"))
    }

    private func barRow(
        label: String,
        amount: Int,
        ratio: CGFloat,
        barColor: Color,
        amountFont: Font,
        amountColor: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.secondary)

            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 6)
                    .fill(barColor)
                    .frame(width: geo.size.width * min(ratio, 1.0), height: 12)
            }
            .frame(height: 12)

            Text(formatYen(amount, currency: data.currency))
                .font(amountFont)
                .foregroundColor(amountColor)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
}

// Tertiary color helper
extension Color {
    static let tertiary = Color(UIColor.tertiaryLabel)
}

struct RealExpenseWidget: Widget {
    let kind = "RealExpenseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                RealExpenseWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color(UIColor.systemBackground)
                    }
            } else {
                RealExpenseWidgetView(entry: entry)
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_real_expense_title", comment: ""))
        .description(NSLocalizedString("widget_real_expense_desc", comment: ""))
        .supportedFamilies([.systemSmall])
    }
}
