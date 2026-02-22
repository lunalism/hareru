import SwiftUI
import WidgetKit

struct LockScreenCircularView: View {
    let entry: HareruEntry

    var body: some View {
        VStack(spacing: 1) {
            Text("◇")
                .font(.system(size: 8, weight: .bold))
            Text(formatYen(entry.data.realExpense, currency: entry.data.currency))
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
}

struct LockScreenRectangularView: View {
    let entry: HareruEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 3) {
                    Text("◇")
                        .font(.system(size: 10, weight: .bold))
                    Text(NSLocalizedString("real_expense", comment: ""))
                        .font(.system(size: 11))
                }
                Text(formatYen(entry.data.realExpense, currency: entry.data.currency))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }
            Spacer()
        }
    }
}

struct LockScreenEntryView: View {
    let entry: HareruEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            LockScreenCircularView(entry: entry)
        case .accessoryRectangular:
            LockScreenRectangularView(entry: entry)
        default:
            LockScreenRectangularView(entry: entry)
        }
    }
}

struct LockScreenWidget: Widget {
    let kind = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                LockScreenEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                LockScreenEntryView(entry: entry)
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_lockscreen_title", comment: ""))
        .description(NSLocalizedString("widget_lockscreen_desc", comment: ""))
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }
}
