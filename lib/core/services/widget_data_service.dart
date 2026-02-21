import 'package:hareru/models/transaction.dart';
import 'package:home_widget/home_widget.dart';

const _appGroupId = 'group.com.lunalism.hareru';
const _iOSWidgetName = 'HareruWidgets';

class WidgetDataService {
  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  static Future<void> updateWidgetData({
    required List<Transaction> transactions,
    required int budget,
  }) async {
    final now = DateTime.now();
    final monthTxns = transactions
        .where((t) =>
            t.createdAt.year == now.year && t.createdAt.month == now.month)
        .toList();

    double totalByType(TransactionType type) =>
        monthTxns.where((t) => t.type == type).fold(0.0, (s, t) => s + t.amount);

    final expense = totalByType(TransactionType.expense);
    final transfer = totalByType(TransactionType.transfer);
    final saving = totalByType(TransactionType.savings);
    final income = totalByType(TransactionType.income);
    final apparent = expense + transfer + saving;

    await Future.wait([
      HomeWidget.saveWidgetData('widget_real_expense', expense.truncate()),
      HomeWidget.saveWidgetData('widget_apparent_expense', apparent.truncate()),
      HomeWidget.saveWidgetData('widget_income', income.truncate()),
      HomeWidget.saveWidgetData('widget_transfer', transfer.truncate()),
      HomeWidget.saveWidgetData('widget_saving', saving.truncate()),
      HomeWidget.saveWidgetData('widget_budget_total', budget),
      HomeWidget.saveWidgetData('widget_budget_used', expense.truncate()),
      HomeWidget.saveWidgetData(
          'widget_month', '${now.year}-${now.month.toString().padLeft(2, '0')}'),
      HomeWidget.saveWidgetData('widget_currency', '\u00a5'),
      HomeWidget.saveWidgetData('widget_last_updated', now.toIso8601String()),
    ]);

    await HomeWidget.updateWidget(iOSName: _iOSWidgetName);
  }
}
