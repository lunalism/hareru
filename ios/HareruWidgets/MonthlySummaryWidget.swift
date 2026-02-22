import SwiftUI
import WidgetKit

struct MonthlySummaryWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    // Donut segments: only include categories with amount > 0
    private var segments: [(color: Color, value: Double, label: String, amount: Int)] {
        let all: [(Color, Double, String, Int)] = [
            (.hareruExpense, Double(data.realExpense), NSLocalizedString("expense", comment: ""), data.realExpense),
            (.hareruTransfer, Double(data.transfer), NSLocalizedString("transfer_label", comment: ""), data.transfer),
            (.hareruSaving, Double(data.saving), NSLocalizedString("saving", comment: ""), data.saving),
            (.hareruIncome, Double(data.income), NSLocalizedString("income_label", comment: ""), data.income),
        ]
        return all
            .filter { $0.1 > 0 }
            .map { (color: $0.0, value: $0.1, label: $0.2, amount: $0.3) }
    }

    private var totalAmount: Double {
        segments.reduce(0) { $0 + $1.value }
    }

    // All 4 legend items (even if 0)
    private var legendItems: [(color: Color, label: String, amount: Int)] {
        [
            (.hareruExpense, NSLocalizedString("expense", comment: ""), data.realExpense),
            (.hareruTransfer, NSLocalizedString("transfer_label", comment: ""), data.transfer),
            (.hareruSaving, NSLocalizedString("saving", comment: ""), data.saving),
            (.hareruIncome, NSLocalizedString("income_label", comment: ""), data.income),
        ]
    }

    private var budgetBarColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.85 { return .budgetRed }
        if pct > 0.60 { return .budgetYellow }
        return .budgetGreen
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("◇ Hareru")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatMonth(data.month))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Spacer().frame(height: 8)

            // Main content: donut + legend
            HStack(alignment: .center, spacing: 10) {
                // Left: Donut chart (45%)
                ZStack {
                    DonutChart(segments: segments, totalAmount: totalAmount, lineWidth: 14)

                    // Center text
                    VStack(spacing: 0) {
                        Text(NSLocalizedString("real_expense", comment: ""))
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                        Text(formatYen(data.realExpense, currency: data.currency))
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.hareruExpense)
                            .minimumScaleFactor(0.4)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 4)
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)

                // Right: Legend (55%)
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(legendItems.enumerated()), id: \.offset) { _, item in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 8, height: 8)
                            Text(item.label)
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(formatYen(item.amount, currency: data.currency))
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }

            Spacer().frame(height: 8)

            // Bottom bar: separator + budget progress
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 0.5)

            Spacer().frame(height: 6)

            if data.hasBudget {
                // Budget labels
                HStack {
                    Text(NSLocalizedString("budget", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(formatYen(data.budgetUsed, currency: data.currency) + " / " + formatYen(data.budgetTotal, currency: data.currency))
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }

                Spacer().frame(height: 4)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(UIColor.separator).opacity(0.25))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(budgetBarColor)
                            .frame(width: geo.size.width * min(data.budgetPercentUsed, 1.0), height: 6)
                    }
                }
                .frame(height: 6)
            } else {
                HStack {
                    Text(NSLocalizedString("budget", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(NSLocalizedString("set_budget", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.tertiary)
                }
            }
        }
        .padding(16)
        .widgetURL(URL(string: "hareru://home")!)
    }
}

// MARK: - Donut Chart

struct DonutChart: View {
    let segments: [(color: Color, value: Double, label: String, amount: Int)]
    let totalAmount: Double
    let lineWidth: CGFloat

    // Gap between segments in degrees
    private let gapDegrees: Double = 4.0

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)

            ZStack {
                if segments.isEmpty {
                    // Empty state
                    Circle()
                        .stroke(Color(UIColor.separator).opacity(0.25), lineWidth: lineWidth)
                } else if segments.count == 1 {
                    // Single segment = full ring
                    Circle()
                        .stroke(segments[0].color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                } else {
                    // Multi-segment donut
                    let totalGap = gapDegrees * Double(segments.count)
                    let availableDegrees = 360.0 - totalGap

                    ForEach(Array(segments.enumerated()), id: \.offset) { index, segment in
                        let startAngle = segmentStartAngle(at: index, available: availableDegrees)
                        let sweepAngle = (segment.value / totalAmount) * availableDegrees

                        Circle()
                            .trim(
                                from: startAngle / 360.0,
                                to: (startAngle + sweepAngle) / 360.0
                            )
                            .stroke(segment.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                    }
                }
            }
            .frame(width: size, height: size)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }

    private func segmentStartAngle(at index: Int, available: Double) -> Double {
        var angle = 0.0
        for i in 0..<index {
            let sweep = (segments[i].value / totalAmount) * available
            angle += sweep + gapDegrees
        }
        return angle
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
