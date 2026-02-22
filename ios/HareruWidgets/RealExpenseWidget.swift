import SwiftUI
import WidgetKit

struct RealExpenseWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    private var diff: Int { data.apparentExpense - data.realExpense }
    private var isSaving: Bool { diff > 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Brand mark
            Text("◇ Hareru")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)

            Spacer()

            // Label
            Text(NSLocalizedString("real_expense", comment: ""))
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            Spacer().frame(height: 2)

            // Amount
            Text(formatYen(data.realExpense, currency: data.currency))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.hareruExpense)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Spacer()

            // Separator
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 0.5)

            Spacer().frame(height: 8)

            // Apparent + diff
            HStack(spacing: 0) {
                Text(NSLocalizedString("apparent_short", comment: ""))
                    .font(.system(size: 11))
                    .foregroundColor(.tertiary)
                Text(" ")
                Text(formatYen(data.apparentExpense, currency: data.currency))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.tertiary)

                Spacer()

                if diff != 0 {
                    Text(isSaving ? "▼ " : "▲ ")
                        .font(.system(size: 11))
                        .foregroundColor(isSaving ? .hareruSaving : .hareruExpense)
                    Text(formatYen(abs(diff), currency: data.currency))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(isSaving ? .hareruSaving : .hareruExpense)
                }
            }
        }
        .padding(16)
        .widgetURL(URL(string: "hareru://report"))
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
