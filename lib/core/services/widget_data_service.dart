import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hareru/models/transaction.dart';

const _iOSWidgetName = 'HareruWidgets';

class WidgetDataService {
  static const _channel = MethodChannel('app.hareru.ios/widget');
  static bool _available = false;

  static Future<void> init() async {
    _available = Platform.isIOS;
  }

  static Future<void> updateWidgetData({
    required List<Transaction> transactions,
    required int budget,
  }) async {
    if (!_available) return;

    try {
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

      final data = <String, dynamic>{
        'widget_real_expense': expense.truncate(),
        'widget_apparent_expense': apparent.truncate(),
        'widget_income': income.truncate(),
        'widget_transfer': transfer.truncate(),
        'widget_saving': saving.truncate(),
        'widget_budget_total': budget,
        'widget_budget_used': expense.truncate(),
        'widget_month': '${now.year}-${now.month.toString().padLeft(2, '0')}',
        'widget_currency': '\u00a5',
        'widget_last_updated': now.toIso8601String(),
      };

      for (final entry in data.entries) {
        await _channel.invokeMethod('saveWidgetData', {
          'id': entry.key,
          'data': entry.value,
        });
      }

      await _channel.invokeMethod('updateWidget', {
        'ios_name': _iOSWidgetName,
      });
    } catch (_) {
      // Widget sync may fail silently
    }
  }
}
