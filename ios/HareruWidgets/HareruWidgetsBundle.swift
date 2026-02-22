import WidgetKit
import SwiftUI

@main
struct HareruWidgetsBundle: WidgetBundle {
    var body: some Widget {
        BudgetWidget()
        RealExpenseWidget()
        MonthlySummaryWidget()
    }
}
