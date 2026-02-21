import SwiftUI
import WidgetKit

struct RealExpenseWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var bg: Color {
        colorScheme == .dark ? Color(white: 0.12) : .white
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Logo
            HStack(spacing: 4) {
                Text("◇")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.hareruPrimary)
                Text(NSLocalizedString("app_name", comment: ""))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.hareruPrimary)
            }

            Spacer()

            // Label
            Text(NSLocalizedString("real_expense", comment: ""))
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            // Amount
            Text(formatYen(entry.data.realExpense, currency: entry.data.currency))
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.hareruExpense)
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            Spacer()

            // Apparent
            Text("\(NSLocalizedString("apparent_short", comment: "")) \(formatYen(entry.data.apparentExpense, currency: entry.data.currency))")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .widgetURL(URL(string: "hareru://report"))
    }
}

struct RealExpenseWidget: Widget {
    let kind = "RealExpenseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                RealExpenseWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RealExpenseWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_real_expense_title", comment: ""))
        .description(NSLocalizedString("widget_real_expense_desc", comment: ""))
        .supportedFamilies([.systemSmall])
    }
}
