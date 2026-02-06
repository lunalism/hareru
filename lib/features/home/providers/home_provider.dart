import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/category.dart';
import '../../../shared/models/transaction.dart';

// 이번 달 예산
final monthlyBudgetProvider = Provider<int>((ref) => 200000);

// 이번 달 총 지출 (이체 제외)
final monthlyExpenseProvider = Provider<int>((ref) => 125400);

// 지난달 총 지출
final lastMonthExpenseProvider = Provider<int>((ref) => 133600);

// 오늘 지출 목록
final todayTransactionsProvider = Provider<List<Transaction>>((ref) {
  final now = DateTime.now();
  return [
    Transaction(
      id: '1',
      amount: 1200,
      category: ExpenseCategory.food,
      note: '점심',
      createdAt: DateTime(now.year, now.month, now.day, 12, 30),
    ),
    Transaction(
      id: '2',
      amount: 340,
      category: ExpenseCategory.transport,
      note: '교통비',
      createdAt: DateTime(now.year, now.month, now.day, 8, 15),
    ),
    Transaction(
      id: '3',
      amount: 450,
      category: ExpenseCategory.cafe,
      note: '커피',
      createdAt: DateTime(now.year, now.month, now.day, 15, 0),
    ),
    Transaction(
      id: '4',
      amount: 5000,
      category: ExpenseCategory.transfer,
      note: '저축계좌 이체',
      createdAt: DateTime(now.year, now.month, now.day, 10, 0),
      isTransfer: true,
    ),
  ];
});

// 오늘 실질 지출 합계 (이체 제외)
final todayTotalProvider = Provider<int>((ref) {
  final transactions = ref.watch(todayTransactionsProvider);
  return transactions
      .where((t) => !t.isTransfer)
      .fold(0, (sum, t) => sum + t.amount);
});

// 이번 주 일별 지출 데이터
final weeklyExpensesProvider = Provider<List<DailyExpense>>((ref) {
  final now = DateTime.now();
  final weekday = now.weekday; // 1=Mon, 7=Sun

  return [
    DailyExpense(label: '월', amount: 3200, isFuture: weekday < 1),
    DailyExpense(label: '화', amount: 1800, isFuture: weekday < 2),
    DailyExpense(label: '수', amount: 2500, isFuture: weekday < 3),
    DailyExpense(label: '목', amount: 1200, isFuture: weekday < 4),
    DailyExpense(label: '금', amount: 4100, isFuture: weekday < 5),
    DailyExpense(label: '토', amount: 0, isFuture: weekday < 6),
    DailyExpense(label: '일', amount: 0, isFuture: weekday < 7),
  ];
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
