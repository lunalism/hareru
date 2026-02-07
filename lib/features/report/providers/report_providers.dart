import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/transaction.dart';
import '../../../shared/models/transaction_type.dart';
import '../../home/providers/home_provider.dart';
import '../domain/category_expense.dart';
import '../domain/daily_expense.dart';
import '../domain/insight.dart';

// Period selection
enum ReportPeriod { weekly, monthly, yearly }

final reportPeriodProvider = StateProvider<ReportPeriod>((ref) {
  return ReportPeriod.monthly;
});

// Current reference date (used to compute date range)
final reportReferenceDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Computed date range based on period + reference date
final reportDateRangeProvider = Provider<DateTimeRange>((ref) {
  final period = ref.watch(reportPeriodProvider);
  final refDate = ref.watch(reportReferenceDateProvider);

  switch (period) {
    case ReportPeriod.weekly:
      final weekday = refDate.weekday; // 1=Mon
      final monday = DateTime(refDate.year, refDate.month, refDate.day)
          .subtract(Duration(days: weekday - 1));
      final sunday = monday.add(const Duration(days: 7));
      return DateTimeRange(start: monday, end: sunday);
    case ReportPeriod.monthly:
      final start = DateTime(refDate.year, refDate.month, 1);
      final end = DateTime(refDate.year, refDate.month + 1, 1);
      return DateTimeRange(start: start, end: end);
    case ReportPeriod.yearly:
      final start = DateTime(refDate.year, 1, 1);
      final end = DateTime(refDate.year + 1, 1, 1);
      return DateTimeRange(start: start, end: end);
  }
});

// Previous period date range (for comparison)
final reportPrevDateRangeProvider = Provider<DateTimeRange>((ref) {
  final period = ref.watch(reportPeriodProvider);
  final refDate = ref.watch(reportReferenceDateProvider);

  switch (period) {
    case ReportPeriod.weekly:
      final weekday = refDate.weekday;
      final monday = DateTime(refDate.year, refDate.month, refDate.day)
          .subtract(Duration(days: weekday - 1));
      final prevMonday = monday.subtract(const Duration(days: 7));
      return DateTimeRange(
          start: prevMonday, end: prevMonday.add(const Duration(days: 7)));
    case ReportPeriod.monthly:
      final start = DateTime(refDate.year, refDate.month - 1, 1);
      final end = DateTime(refDate.year, refDate.month, 1);
      return DateTimeRange(start: start, end: end);
    case ReportPeriod.yearly:
      final start = DateTime(refDate.year - 1, 1, 1);
      final end = DateTime(refDate.year, 1, 1);
      return DateTimeRange(start: start, end: end);
  }
});

// Filtered transactions for current period
final reportTransactionsProvider = Provider<List<Transaction>>((ref) {
  final range = ref.watch(reportDateRangeProvider);
  final all = ref.watch(allTransactionsProvider);
  return all
      .where((t) => !t.date.isBefore(range.start) && t.date.isBefore(range.end))
      .toList();
});

// Previous period transactions
final reportPrevTransactionsProvider = Provider<List<Transaction>>((ref) {
  final range = ref.watch(reportPrevDateRangeProvider);
  final all = ref.watch(allTransactionsProvider);
  return all
      .where((t) => !t.date.isBefore(range.start) && t.date.isBefore(range.end))
      .toList();
});

// Real expense (excludes transfers)
final reportRealExpenseProvider = Provider<int>((ref) {
  final transactions = ref.watch(reportTransactionsProvider);
  return transactions
      .where((t) => t.transactionType == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);
});

// Total income
final reportIncomeProvider = Provider<int>((ref) {
  final transactions = ref.watch(reportTransactionsProvider);
  return transactions
      .where((t) => t.transactionType == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);
});

// Excluded transfer amount
final reportExcludedTransferProvider = Provider<int>((ref) {
  final transactions = ref.watch(reportTransactionsProvider);
  return transactions
      .where((t) => t.transactionType == TransactionType.transfer)
      .fold(0, (sum, t) => sum + t.amount);
});

// Previous period expense
final reportPrevExpenseProvider = Provider<int>((ref) {
  final transactions = ref.watch(reportPrevTransactionsProvider);
  return transactions
      .where((t) => t.transactionType == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);
});

// Chart color palette
const _chartColors = [
  Color(0xFF4A90D9),
  Color(0xFFFFD54F),
  Color(0xFF4CAF50),
  Color(0xFFFF7043),
  Color(0xFFAB47BC),
  Color(0xFF26A69A),
  Color(0xFFEF5350),
  Color(0xFF78909C),
  Color(0xFF8D6E63),
  Color(0xFFBDBDBD),
];

// Category expenses (grouped, sorted by amount desc)
final reportCategoryExpensesProvider =
    Provider<List<CategoryExpense>>((ref) {
  final transactions = ref.watch(reportTransactionsProvider);
  final expenses =
      transactions.where((t) => t.transactionType == TransactionType.expense);

  final Map<String, _CategoryAccumulator> grouped = {};
  for (final t in expenses) {
    final acc = grouped.putIfAbsent(
      t.categoryKey,
      () => _CategoryAccumulator(
        categoryKey: t.categoryKey,
        emoji: t.categoryEmoji,
      ),
    );
    acc.amount += t.amount;
    acc.count++;
  }

  final totalExpense =
      grouped.values.fold(0, (sum, acc) => sum + acc.amount);

  final sorted = grouped.values.toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  return sorted.asMap().entries.map((entry) {
    final i = entry.key;
    final acc = entry.value;
    return CategoryExpense(
      categoryKey: acc.categoryKey,
      categoryName: acc.categoryKey,
      emoji: acc.emoji,
      amount: acc.amount,
      count: acc.count,
      percentage:
          totalExpense > 0 ? (acc.amount / totalExpense * 100) : 0,
      color: _chartColors[i % _chartColors.length],
    );
  }).toList();
});

// Daily expenses for trend chart
final reportDailyExpensesProvider =
    Provider<List<ReportDailyExpense>>((ref) {
  final range = ref.watch(reportDateRangeProvider);
  final transactions = ref.watch(reportTransactionsProvider);
  final expenses =
      transactions.where((t) => t.transactionType == TransactionType.expense);

  final Map<String, int> dailyMap = {};
  for (final t in expenses) {
    final key =
        '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}';
    dailyMap[key] = (dailyMap[key] ?? 0) + t.amount;
  }

  final days = range.end.difference(range.start).inDays;
  return List.generate(days, (i) {
    final date = range.start.add(Duration(days: i));
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return ReportDailyExpense(date: date, amount: dailyMap[key] ?? 0);
  });
});

// Monthly expenses for yearly trend
final reportMonthlyExpensesProvider =
    Provider<List<ReportDailyExpense>>((ref) {
  final range = ref.watch(reportDateRangeProvider);
  final transactions = ref.watch(reportTransactionsProvider);
  final expenses =
      transactions.where((t) => t.transactionType == TransactionType.expense);

  final Map<int, int> monthlyMap = {};
  for (final t in expenses) {
    monthlyMap[t.date.month] = (monthlyMap[t.date.month] ?? 0) + t.amount;
  }

  return List.generate(12, (i) {
    final month = i + 1;
    return ReportDailyExpense(
      date: DateTime(range.start.year, month, 1),
      amount: monthlyMap[month] ?? 0,
    );
  });
});

// Insights
final reportInsightsProvider = Provider<List<Insight>>((ref) {
  final transactions = ref.watch(reportTransactionsProvider);
  final prevTransactions = ref.watch(reportPrevTransactionsProvider);
  final period = ref.watch(reportPeriodProvider);

  final expenses =
      transactions.where((t) => t.transactionType == TransactionType.expense).toList();
  if (expenses.isEmpty) return [];

  final insights = <Insight>[];

  // 1. Top spending day
  final Map<String, int> dailyTotals = {};
  final Map<String, DateTime> dailyDates = {};
  for (final t in expenses) {
    final key = '${t.date.year}-${t.date.month}-${t.date.day}';
    dailyTotals[key] = (dailyTotals[key] ?? 0) + t.amount;
    dailyDates[key] = DateTime(t.date.year, t.date.month, t.date.day);
  }
  if (dailyTotals.isNotEmpty) {
    final topKey =
        dailyTotals.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final topDate = dailyDates[topKey]!;
    final dayNames = ['', '(월)', '(화)', '(수)', '(목)', '(금)', '(토)', '(일)'];
    final amount = _formatAmount(dailyTotals[topKey]!);
    insights.add(Insight(
      emoji: '📅',
      title: '',
      description:
          '${topDate.month}/${topDate.day} ${dayNames[topDate.weekday]} — ¥$amount',
    ));
  }

  // 2. Category change vs previous period (monthly only)
  if (period == ReportPeriod.monthly && prevTransactions.isNotEmpty) {
    final prevExpenses = prevTransactions
        .where((t) => t.transactionType == TransactionType.expense);

    final Map<String, int> currentCats = {};
    for (final t in expenses) {
      currentCats[t.categoryKey] =
          (currentCats[t.categoryKey] ?? 0) + t.amount;
    }
    final Map<String, int> prevCats = {};
    for (final t in prevExpenses) {
      prevCats[t.categoryKey] = (prevCats[t.categoryKey] ?? 0) + t.amount;
    }

    String? biggestChangeKey;
    int biggestChangePct = 0;
    for (final key in currentCats.keys) {
      final prev = prevCats[key] ?? 0;
      if (prev > 0) {
        final pct =
            (((currentCats[key]! - prev) / prev) * 100).round().abs();
        if (pct > biggestChangePct) {
          biggestChangePct = pct;
          biggestChangeKey = key;
        }
      }
    }
    if (biggestChangeKey != null && biggestChangePct > 5) {
      final current = currentCats[biggestChangeKey]!;
      final prev = prevCats[biggestChangeKey] ?? 0;
      final increased = current > prev;
      insights.add(Insight(
        emoji: '📈',
        title: '',
        description: '$biggestChangeKey|$biggestChangePct|${increased ? 'up' : 'down'}',
      ));
    }
  }

  // 3. Least spending week (if 2+ weeks of data)
  if (dailyTotals.length >= 7) {
    final weeklyTotals = <int, int>{};
    for (final entry in dailyDates.entries) {
      final weekNum = _weekOfMonth(entry.value);
      weeklyTotals[weekNum] =
          (weeklyTotals[weekNum] ?? 0) + (dailyTotals[entry.key] ?? 0);
    }
    if (weeklyTotals.length >= 2) {
      final leastWeek = weeklyTotals.entries
          .reduce((a, b) => a.value < b.value ? a : b);
      final amount = _formatAmount(leastWeek.value);
      insights.add(Insight(
        emoji: '🏆',
        title: '',
        description: '${leastWeek.key}|¥$amount',
      ));
    }
  }

  return insights;
});

// Whether current period is the latest (disable forward navigation)
final reportIsLatestPeriodProvider = Provider<bool>((ref) {
  final range = ref.watch(reportDateRangeProvider);
  return range.end.isAfter(DateTime.now());
});

// Helper
int _weekOfMonth(DateTime date) {
  return ((date.day - 1) ~/ 7) + 1;
}

String _formatAmount(int amount) {
  if (amount >= 1000) {
    final str = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
  return amount.toString();
}

class _CategoryAccumulator {
  _CategoryAccumulator({required this.categoryKey, required this.emoji});
  final String categoryKey;
  final String emoji;
  int amount = 0;
  int count = 0;
}
