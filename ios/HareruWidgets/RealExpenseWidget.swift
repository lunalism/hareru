import SwiftUI
import WidgetKit

// MARK: - Medium: Real Expense + Comparison Widget

struct RealExpenseWidgetView: View {
    let entry: HareruEntry

    private var data: HareruWidgetData { entry.data }
    private var hasTransfer: Bool { data.apparentExpense != data.realExpense }
    private var diff: Int { data.apparentExpense - data.realExpense }

    var body: some View {
        VStack(spacing: 0) {
            // Main content
            HStack(alignment: .top, spacing: 0) {
                // Left half
                VStack(alignment: .leading, spacing: 0) {
                    Text("Hareru")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)

                    Spacer()

                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("real_expense", comment: ""))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        Text(formatYen(data.realExpense, currency: data.currency))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right half
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()

                    if hasTransfer {
                        VStack(alignment: .leading, spacing: 6) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(NSLocalizedString("apparent_expense", comment: ""))
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                Text(formatYen(data.apparentExpense, currency: data.currency))
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.tertiary)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                            }

                            Text("−" + formatYen(abs(diff), currency: data.currency) + " " + NSLocalizedString("transfer_excluded", comment: ""))
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.hareruSaving)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                    } else {
                        Text(NSLocalizedString("same_as_apparent", comment: ""))
                            .font(.system(size: 14))
                            .foregroundColor(.tertiary)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Footer
            Rectangle()
                .fill(Color(UIColor.separator))
                .frame(height: 0.5)
            Spacer().frame(height: 6)

            HStack {
                if data.hasBudget {
                    Text(NSLocalizedString("budget_remaining_label", comment: "") + " " + formatYen(data.budgetRemaining, currency: data.currency))
                        .font(.system(size: 11))
                        .foregroundColor(.primary)
                } else {
                    Text(NSLocalizedString("no_budget", comment: ""))
                        .font(.system(size: 11))
                        .foregroundColor(.tertiary)
                }
                Spacer()
                Text(formatMonth(data.month))
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
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
        .supportedFamilies([.systemMedium])
    }
}
