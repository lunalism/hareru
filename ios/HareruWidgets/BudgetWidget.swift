import SwiftUI
import WidgetKit

struct BudgetWidgetView: View {
    let entry: HareruEntry
    @Environment(\.colorScheme) var colorScheme

    private var data: HareruWidgetData { entry.data }

    private var barColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.9 { return .hareruExpense }
        if pct > 0.7 { return .orange }
        return .hareruSaving
    }

    private var remainingColor: Color {
        data.budgetRemaining < 0 ? .hareruExpense : barColor
    }

    private var percentText: String {
        let pct = Int(data.budgetPercentUsed * 100)
        return "\(min(pct, 999))%"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header banner
            HStack(spacing: 5) {
                Text("◇")
                    .font(.system(size: 11, weight: .heavy))
                Text(NSLocalizedString("budget", comment: ""))
                    .font(.system(size: 11, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule().fill(Color.hareruBrandBlue)
            )

            Spacer()

            if data.hasBudget {
                // Yen icon + remaining label
                HStack(spacing: 4) {
                    Image(systemName: "yensign.circle.fill")
                        .font(.system(size: 13))
                        .foregroundColor(remainingColor)
                    Text(NSLocalizedString("remaining", comment: ""))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                // Amount
                Text(formatYen(data.budgetRemaining, currency: data.currency))
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(remainingColor)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                Spacer().frame(height: 10)

                // Progress bar + percent
                HStack(spacing: 8) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(colorScheme == .dark
                                      ? Color(white: 0.22)
                                      : Color(red: 0.93, green: 0.94, blue: 0.96))
                                .frame(height: 8)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(barColor)
                                .frame(
                                    width: geo.size.width * min(data.budgetPercentUsed, 1.0),
                                    height: 8
                                )
                        }
                    }
                    .frame(height: 8)

                    Text(percentText)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(barColor)
                        .frame(width: 36, alignment: .trailing)
                }

                Spacer().frame(height: 6)

                // Budget total
                let man = data.budgetTotal / 10000
                let remainder = data.budgetTotal % 10000
                Text(remainder == 0 && man > 0
                     ? String(format: NSLocalizedString("budget_of_man", comment: ""), man)
                     : formatYen(data.budgetTotal, currency: data.currency))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            } else {
                Spacer()
                VStack(spacing: 6) {
                    Image(systemName: "yensign.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text(NSLocalizedString("set_budget", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            Spacer()
        }
        .padding(14)
        .widgetURL(URL(string: "hareru://report"))
    }
}

struct BudgetWidget: Widget {
    let kind = "BudgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                BudgetWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        WidgetGradientBackground()
                    }
            } else {
                BudgetWidgetView(entry: entry)
                    .padding()
                    .background(WidgetGradientBackground())
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_budget_title", comment: ""))
        .description(NSLocalizedString("widget_budget_desc", comment: ""))
        .supportedFamilies([.systemSmall])
    }
}
