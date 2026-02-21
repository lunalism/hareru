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
            // Header banner
            HStack(spacing: 5) {
                Text("◇")
                    .font(.system(size: 11, weight: .heavy))
                Text("Hareru")
                    .font(.system(size: 11, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule().fill(Color.hareruBrandBlue)
            )

            Spacer()

            // Label
            Text(NSLocalizedString("real_expense", comment: ""))
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            // Amount
            Text(formatYen(data.realExpense, currency: data.currency))
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundColor(.hareruExpense)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Spacer().frame(height: 6)

            // Apparent + arrow
            HStack(spacing: 4) {
                Text(NSLocalizedString("apparent_short", comment: ""))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(formatYen(data.apparentExpense, currency: data.currency))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
                if diff != 0 {
                    Image(systemName: isSaving ? "arrow.down.right" : "arrow.up.right")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(isSaving ? .hareruSaving : .hareruExpense)
                }
            }

            Spacer().frame(height: 6)

            // Bottom accent line
            RoundedRectangle(cornerRadius: 1.5)
                .fill(Color.hareruBrandBlue)
                .frame(height: 3)
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
                    .containerBackground(for: .widget) {
                        WidgetGradientBackground()
                    }
            } else {
                RealExpenseWidgetView(entry: entry)
                    .padding()
                    .background(WidgetGradientBackground())
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_real_expense_title", comment: ""))
        .description(NSLocalizedString("widget_real_expense_desc", comment: ""))
        .supportedFamilies([.systemSmall])
    }
}
