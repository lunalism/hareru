import SwiftUI
import WidgetKit

struct BudgetWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    private var percentUsed: Double { data.budgetPercentUsed }
    private var percentRemaining: Double { max(1.0 - percentUsed, 0) }

    private var ringColor: Color {
        if percentUsed > 0.85 { return .budgetRed }
        if percentUsed > 0.60 { return .budgetYellow }
        return .budgetGreen
    }

    private var percentText: String {
        "\(Int(percentRemaining * 100))%"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Brand mark
            Text("◇ Hareru")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)

            Spacer()

            if data.hasBudget {
                budgetContent
            } else {
                noBudgetContent
            }

            Spacer()
        }
        .padding(16)
        .widgetURL(URL(string: "hareru://report"))
    }

    private var budgetContent: some View {
        HStack(spacing: 0) {
            Spacer()

            // Progress ring
            ZStack {
                // Background ring
                Circle()
                    .stroke(
                        Color(UIColor.separator).opacity(0.3),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )

                // Foreground ring
                Circle()
                    .trim(from: 0, to: percentRemaining)
                    .stroke(
                        ringColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                // Inner text
                VStack(spacing: 0) {
                    Text(NSLocalizedString("remaining", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)

                    Text(formatYen(data.budgetRemaining, currency: data.currency))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)

                    Text("/ " + formatYen(data.budgetTotal, currency: data.currency))
                        .font(.system(size: 9))
                        .foregroundColor(.tertiary)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                .padding(.horizontal, 12)
            }
            .frame(width: 110, height: 110)

            // Percentage outside ring
            Text(percentText)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(ringColor)
                .frame(width: 36, alignment: .leading)

            Spacer()
        }
    }

    private var noBudgetContent: some View {
        VStack(spacing: 8) {
            Spacer()

            ZStack {
                Circle()
                    .stroke(
                        Color(UIColor.separator).opacity(0.3),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)

                Image(systemName: "yensign")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(.secondary.opacity(0.5))
            }

            Text(NSLocalizedString("set_budget", comment: ""))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct BudgetWidget: Widget {
    let kind = "BudgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                BudgetWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color(UIColor.systemBackground)
                    }
            } else {
                BudgetWidgetView(entry: entry)
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_budget_title", comment: ""))
        .description(NSLocalizedString("widget_budget_desc", comment: ""))
        .supportedFamilies([.systemSmall])
    }
}
