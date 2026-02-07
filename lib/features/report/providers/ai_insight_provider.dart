import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../shared/models/ai_insight.dart';
import '../../../shared/models/transaction_type.dart';
import '../../../shared/services/ai_insight_generator.dart';
import '../../../shared/services/health_score_calculator.dart';
import '../../settings/providers/settings_provider.dart';
import 'report_providers.dart';

/// Provides cached AI insight for the current report period.
final aiInsightProvider = Provider<AiInsight?>((ref) {
  final transactions = ref.watch(reportTransactionsProvider);
  final prevTransactions = ref.watch(reportPrevTransactionsProvider);
  final range = ref.watch(reportDateRangeProvider);
  final period = ref.watch(reportPeriodProvider);
  final budget = ref.watch(settingsProvider).monthlyBudget;

  // Build cache key
  final cacheKey = _buildCacheKey(period, range.start);
  final box = Hive.box('ai_insights');

  // Check cache
  final cachedMap = box.get(cacheKey);
  if (cachedMap != null) {
    try {
      final cached = AiInsight.fromMap(cachedMap as Map<dynamic, dynamic>);
      final daysSince = DateTime.now().difference(cached.generatedAt).inDays;
      if (daysSince < 7) return cached;
    } catch (_) {
      // Invalid cache, regenerate
    }
  }

  // Generate new insight (even for free users - so blur shows real data behind it)
  final insight = AiInsightMockGenerator.generate(
    transactions,
    prevTransactions,
    range.start,
    range.end,
    monthlyBudget: budget,
  );

  // Cache it
  box.put(cacheKey, insight.toMap());

  return insight;
});

/// Health score for current period (available regardless of premium status)
final healthScoreProvider = Provider<HealthScoreResult>((ref) {
  final transactions = ref.watch(reportTransactionsProvider);
  final prevTransactions = ref.watch(reportPrevTransactionsProvider);
  final budget = ref.watch(settingsProvider).monthlyBudget;

  return HealthScoreCalculator.calculate(
    transactions,
    prevTransactions,
    monthlyBudget: budget,
  );
});

/// Clear comparison: total with transfers vs real expense
final clearComparisonProvider = Provider<({int totalWithTransfers, int realExpense, int transferAmount})>((ref) {
  final transactions = ref.watch(reportTransactionsProvider);

  final allExpenseAndTransfer = transactions
      .where((t) =>
          t.transactionType == TransactionType.expense ||
          t.transactionType == TransactionType.transfer);

  final totalWithTransfers =
      allExpenseAndTransfer.fold(0, (sum, t) => sum + t.amount);

  final realExpense = transactions
      .where((t) => t.transactionType == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  final transferAmount = totalWithTransfers - realExpense;

  return (
    totalWithTransfers: totalWithTransfers,
    realExpense: realExpense,
    transferAmount: transferAmount,
  );
});

String _buildCacheKey(ReportPeriod period, DateTime start) {
  switch (period) {
    case ReportPeriod.weekly:
      final weekNum = ((start.difference(DateTime(start.year, 1, 1)).inDays) / 7).ceil();
      return 'weekly_${start.year}-W${weekNum.toString().padLeft(2, '0')}';
    case ReportPeriod.monthly:
      return 'monthly_${start.year}-${start.month.toString().padLeft(2, '0')}';
    case ReportPeriod.yearly:
      return 'yearly_${start.year}';
  }
}
