import Foundation
import WidgetKit

struct HareruWidgetData {
    let realExpense: Int
    let apparentExpense: Int
    let income: Int
    let transfer: Int
    let saving: Int
    let budgetTotal: Int
    let budgetUsed: Int
    let month: String
    let currency: String

    var budgetRemaining: Int { budgetTotal - budgetUsed }

    var budgetPercentUsed: Double {
        guard budgetTotal > 0 else { return 0 }
        return Double(budgetUsed) / Double(budgetTotal)
    }

    var hasBudget: Bool { budgetTotal > 0 }

    static let placeholder = HareruWidgetData(
        realExpense: 128500,
        apparentExpense: 185000,
        income: 280000,
        transfer: 30000,
        saving: 26500,
        budgetTotal: 200000,
        budgetUsed: 128500,
        month: "2026-02",
        currency: "¥"
    )

    static func load() -> HareruWidgetData {
        let defaults = UserDefaults(suiteName: "group.com.lunalism.hareru")
        return HareruWidgetData(
            realExpense: defaults?.integer(forKey: "widget_real_expense") ?? 0,
            apparentExpense: defaults?.integer(forKey: "widget_apparent_expense") ?? 0,
            income: defaults?.integer(forKey: "widget_income") ?? 0,
            transfer: defaults?.integer(forKey: "widget_transfer") ?? 0,
            saving: defaults?.integer(forKey: "widget_saving") ?? 0,
            budgetTotal: defaults?.integer(forKey: "widget_budget_total") ?? 0,
            budgetUsed: defaults?.integer(forKey: "widget_budget_used") ?? 0,
            month: defaults?.string(forKey: "widget_month") ?? "",
            currency: defaults?.string(forKey: "widget_currency") ?? "¥"
        )
    }
}

struct HareruEntry: TimelineEntry {
    let date: Date
    let data: HareruWidgetData
}

struct HareruTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> HareruEntry {
        HareruEntry(date: .now, data: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (HareruEntry) -> Void) {
        let entry = HareruEntry(
            date: .now,
            data: context.isPreview ? .placeholder : .load()
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HareruEntry>) -> Void) {
        let entry = HareruEntry(date: .now, data: .load())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

// MARK: - Formatting

func formatYen(_ amount: Int, currency: String = "¥") -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    let formatted = formatter.string(from: NSNumber(value: abs(amount))) ?? "\(abs(amount))"
    let prefix = amount < 0 ? "-" : ""
    return "\(prefix)\(currency)\(formatted)"
}

func formatMonth(_ monthStr: String) -> String {
    guard monthStr.count >= 7 else { return "" }
    let parts = monthStr.split(separator: "-")
    guard parts.count == 2,
          let year = Int(parts[0]),
          let month = Int(parts[1]) else { return monthStr }

    let locale = Locale.current.language.languageCode?.identifier ?? "ja"
    switch locale {
    case "ko": return "\(year)년 \(month)월"
    case "en": return "\(month)/\(year)"
    default:   return "\(year)年\(month)月"
    }
}
