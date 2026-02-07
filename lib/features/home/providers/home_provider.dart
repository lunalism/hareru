import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/transaction.dart';
import '../../../shared/models/transaction_type.dart';
import '../../../shared/repositories/transaction_repository.dart';
import '../../settings/providers/settings_provider.dart';

// All transactions (re-reads on any change)
final allTransactionsProvider = Provider<List<Transaction>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.getAll();
});

// Budget from settings
final monthlyBudgetProvider = Provider<int>((ref) {
  return ref.watch(settingsProvider).monthlyBudget;
});

// This month's expense transactions (excludes income & transfers)
final monthlyExpenseProvider = Provider<int>((ref) {
  final transactions = ref.watch(allTransactionsProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);

  return transactions
      .where((t) =>
          t.transactionType == TransactionType.expense &&
          !t.date.isBefore(startOfMonth) &&
          t.date.isBefore(DateTime(now.year, now.month + 1, 1)))
      .fold(0, (sum, t) => sum + t.amount);
});

// Last month's expense total
final lastMonthExpenseProvider = Provider<int>((ref) {
  final transactions = ref.watch(allTransactionsProvider);
  final now = DateTime.now();
  final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
  final startOfThisMonth = DateTime(now.year, now.month, 1);

  return transactions
      .where((t) =>
          t.transactionType == TransactionType.expense &&
          !t.date.isBefore(startOfLastMonth) &&
          t.date.isBefore(startOfThisMonth))
      .fold(0, (sum, t) => sum + t.amount);
});

// Today's transactions
final todayTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(allTransactionsProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  return transactions
      .where((t) => !t.date.isBefore(today) && t.date.isBefore(tomorrow))
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

// Today's total (expenses only, exclude transfers)
final todayTotalProvider = Provider<int>((ref) {
  final transactions = ref.watch(todayTransactionsProvider);
  return transactions
      .where((t) => t.transactionType == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);
});

// Weekly expenses data
final weeklyExpensesProvider = Provider<List<DailyExpense>>((ref) {
  final transactions = ref.watch(allTransactionsProvider);
  final now = DateTime.now();
  final todayWeekday = now.weekday; // 1=Mon, 7=Sun
  final mondayOfThisWeek = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: todayWeekday - 1));

  return List.generate(7, (i) {
    final day = mondayOfThisWeek.add(Duration(days: i));
    final nextDay = day.add(const Duration(days: 1));
    final isFuture = (i + 1) > todayWeekday;

    final dayTotal = isFuture
        ? 0
        : transactions
            .where((t) =>
                t.transactionType == TransactionType.expense &&
                !t.date.isBefore(day) &&
                t.date.isBefore(nextDay))
            .fold(0, (sum, t) => sum + t.amount);

    return DailyExpense(
      label: '',
      amount: dayTotal,
      isFuture: isFuture,
    );
  });
});

class DailyExpense {
  const DailyExpense({
    required this.label,
    required this.amount,
    this.isFuture = false,
  });

  final String label;
  final int amount;
  final bool isFuture;
}
