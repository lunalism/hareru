import WidgetKit
import SwiftUI

@main
struct HareruWidgetsBundle: WidgetBundle {
    var body: some Widget {
        RealExpenseWidget()
        BudgetWidget()
        MonthlySummaryWidget()
        LockScreenWidget()
    }
}
