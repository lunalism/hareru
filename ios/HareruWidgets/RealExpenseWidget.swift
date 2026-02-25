import SwiftUI
import WidgetKit

// MARK: - Medium: 진짜 vs 겉보기 비교 (Killer Feature Widget)

struct RealExpenseWidgetView: View {
    @Environment(\.colorScheme) var colorScheme
    let entry: HareruEntry

    private var data: HareruWidgetData { entry.data }
    private var isDark: Bool { colorScheme == .dark }
    private var hasTransfer: Bool { data.apparentExpense != data.realExpense }
    private var diff: Int { data.apparentExpense - data.realExpense }

    private var textPrimary: Color {
        isDark ? .warmTextLight : .warmTextPrimary
    }

    private var mutedAmount: Color {
        isDark ? .warmMutedDark : .warmMuted
    }

    private var dividerColor: Color {
        isDark ? .warmDividerDark : .warmDivider
    }

    private var progressRatio: CGFloat {
        guard data.budgetTotal > 0 else { return 0 }
        return min(CGFloat(data.budgetPercentUsed), 1.0)
    }

    private var progressColor: Color {
        let pct = data.budgetPercentUsed
        if pct > 0.80 { return .budgetRed }
        if pct > 0.50 { return .budgetYellow }
        return .budgetGreen
    }

    var body: some View {
        VStack(spacing: 0) {
            // Main content
            HStack(alignment: .top, spacing: 0) {
                // Left — Real expense (hero)
                VStack(alignment: .leading, spacing: 0) {
                    Text(NSLocalizedString("real_expense_short", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.warmTextSub)

                    Spacer().frame(height: 6)

                    Text(formatYen(data.realExpense, currency: data.currency))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(textPrimary)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

                    Spacer().frame(height: 10)

                    // Progress bar (real expense vs budget)
                    if data.hasBudget {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 1.5)
                                    .fill(dividerColor)
                                    .frame(height: 3)
                                RoundedRectangle(cornerRadius: 1.5)
                                    .fill(progressColor)
                                    .frame(width: geo.size.width * progressRatio, height: 3)
                            }
                        }
                        .frame(height: 3)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right — Apparent expense (comparison)
                VStack(alignment: .leading, spacing: 0) {
                    Text(NSLocalizedString("apparent_expense_short", comment: ""))
                        .font(.system(size: 10))
                        .foregroundColor(.warmTextSub)

                    Spacer().frame(height: 6)

                    if hasTransfer {
                        Text(formatYen(data.apparentExpense, currency: data.currency))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(mutedAmount)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)

                        Spacer().frame(height: 8)

                        Text("−" + formatYen(abs(diff), currency: data.currency)
                             + " " + NSLocalizedString("transfer_excluded", comment: ""))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.warmGreen)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    } else {
                        Spacer().frame(height: 2)

                        HStack(spacing: 4) {
                            Text(NSLocalizedString("same_as_apparent", comment: ""))
                                .font(.system(size: 14))
                                .foregroundColor(.warmTextSub)
                            Text("✓")
                                .font(.system(size: 14))
                                .foregroundColor(.warmGreen)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            // Footer separator
            Rectangle()
                .fill(dividerColor)
                .frame(height: 0.5)

            Spacer().frame(height: 6)

            // Footer
            HStack(spacing: 0) {
                // Left: dot + budget usage
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.warmRed)
                        .frame(width: 6, height: 6)

                    if data.hasBudget {
                        Text(formatYen(data.realExpense, currency: data.currency)
                             + " / " + formatYen(data.budgetTotal, currency: data.currency))
                            .font(.system(size: 10))
                            .foregroundColor(.warmRed)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    } else {
                        Text(NSLocalizedString("no_budget", comment: ""))
                            .font(.system(size: 10))
                            .foregroundColor(.warmTextSub)
                    }
                }

                Spacer()

                // Right: month (short)
                Text(formatMonthShort(data.month))
                    .font(.system(size: 10))
                    .foregroundColor(.warmTextSub)
            }
        }
        .padding(16)
    }
}

struct RealExpenseWidget: Widget {
    let kind = "RealExpenseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HareruTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                RealExpenseWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        WidgetBackground()
                    }
            } else {
                RealExpenseWidgetView(entry: entry)
                    .padding()
                    .background(WidgetBackground())
            }
        }
        .configurationDisplayName(NSLocalizedString("widget_real_expense_title", comment: ""))
        .description(NSLocalizedString("widget_real_expense_desc", comment: ""))
        .supportedFamilies([.systemMedium])
    }
}
