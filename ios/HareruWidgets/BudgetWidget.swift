import SwiftUI
import WidgetKit

struct BudgetWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    private var percentUsed: Double { data.budgetPercentUsed }

    private var gaugeColor: Color {
        if percentUsed > 0.85 { return .budgetRed }
        if percentUsed > 0.60 { return .budgetYellow }
        return .budgetGreen
    }

    var body: some View {
        VStack(spacing: 0) {
            // Brand mark
            HStack {
                Text("◇ Hareru")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
            }

            if data.hasBudget {
                Spacer().frame(height: 4)
                budgetGauge
            } else {
                Spacer()
                noBudgetContent
                Spacer()
            }
        }
        .padding(16)
    }

    private var budgetGauge: some View {
        VStack(spacing: 0) {
            // Semi-circle gauge
            ZStack(alignment: .bottom) {
                // Background arc (180 degrees, bottom half = upside down arc)
                SemiCircleArc()
                    .stroke(
                        Color(UIColor.separator).opacity(0.25),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(height: 55)

                // Foreground arc
                SemiCircleArc()
                    .trim(from: 0, to: min(percentUsed, 1.0))
                    .stroke(
                        gaugeColor,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(height: 55)

                // Center label (below arc center)
                VStack(spacing: 0) {
                    Spacer().frame(height: 12)
                    Text(NSLocalizedString("remaining", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(formatYen(data.budgetRemaining, currency: data.currency))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                }
            }

            Spacer().frame(height: 4)

            // Gauge end labels
            HStack {
                Text(data.currency + "0")
                    .font(.system(size: 9))
                    .foregroundColor(.tertiary)
                Spacer()
                Text(formatYen(data.budgetTotal, currency: data.currency))
                    .font(.system(size: 9))
                    .foregroundColor(.tertiary)
            }
        }
    }

    private var noBudgetContent: some View {
        VStack(spacing: 8) {
            // Dashed semi-circle
            SemiCircleArc()
                .stroke(
                    Color(UIColor.separator).opacity(0.3),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round, dash: [6, 8])
                )
                .frame(width: 100, height: 50)

            Text(NSLocalizedString("set_budget", comment: ""))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

/// A shape that draws a 180-degree arc (top half of a circle)
struct SemiCircleArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: min(rect.width / 2, rect.height),
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        return path
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
