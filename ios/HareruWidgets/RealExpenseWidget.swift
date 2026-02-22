import SwiftUI
import WidgetKit

struct RealExpenseWidgetView: View {
    let entry: HareruEntry

    private var data: HareruWidgetData { entry.data }
    private var hasTransfer: Bool { data.apparentExpense != data.realExpense }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Brand
            Text("◇ Hareru")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)

            Spacer()

            // Main amount
            VStack(alignment: .leading, spacing: 2) {
                Text(NSLocalizedString("real_expense", comment: ""))
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Text(formatYen(data.realExpense, currency: data.currency))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }

            Spacer()

            // Apparent expense
            if hasTransfer {
                Rectangle()
                    .fill(Color(UIColor.separator))
                    .frame(height: 0.5)
                Spacer().frame(height: 8)
                Text(NSLocalizedString("apparent_short", comment: "") + " " + formatYen(data.apparentExpense, currency: data.currency))
                    .font(.system(size: 12))
                    .foregroundColor(.tertiary)
            }
        }
        .padding(16)
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
                    .containerBackground(.fill, for: .widget)
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
