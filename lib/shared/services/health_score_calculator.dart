import '../models/transaction.dart';
import '../models/transaction_type.dart';

class HealthScoreResult {
  const HealthScoreResult({
    required this.total,
    required this.budgetScore,
    required this.savingScore,
    required this.balanceScore,
    required this.clearScore,
  });

  final int total;
  final int budgetScore;
  final int savingScore;
  final int balanceScore;
  final int clearScore; // Always 25

  String get grade {
    if (total >= 90) return 'excellent';
    if (total >= 75) return 'good';
    if (total >= 60) return 'average';
    if (total >= 40) return 'caution';
    return 'danger';
  }
}

class HealthScoreCalculator {
  /// Total: 100 points (4 criteria x 25 each)
  static HealthScoreResult calculate(
    List<Transaction> currentTransactions,
    List<Transaction> prevTransactions, {
    int? monthlyBudget,
  }) {
    final budgetScore = _budgetAdherence(currentTransactions, monthlyBudget);
    final savingScore = _savingEffort(currentTransactions, prevTransactions);
    final balanceScore = _spendingBalance(currentTransactions);
    const clearScore = 25;
    final total = budgetScore + savingScore + balanceScore + clearScore;

    return HealthScoreResult(
      total: total,
      budgetScore: budgetScore,
      savingScore: savingScore,
      balanceScore: balanceScore,
      clearScore: clearScore,
    );
  }

  /// Budget adherence (25 points)
  /// Ratio of real expenses vs budget
  static int _budgetAdherence(List<Transaction> transactions, int? budget) {
    final realExpense = transactions
        .where((t) => t.transactionType == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);

    if (budget == null || budget <= 0) {
      // No budget set - give moderate score
      return 15;
    }

    final ratio = realExpense / budget;
    if (ratio <= 0.9) return 25;
    if (ratio <= 1.0) return 20;
    if (ratio <= 1.1) return 15;
    if (ratio <= 1.2) return 10;
    return 5;
  }

  /// Saving effort (25 points)
  /// Spending decrease vs previous period
  static int _savingEffort(
    List<Transaction> current,
    List<Transaction> previous,
  ) {
    final currentExpense = current
        .where((t) => t.transactionType == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
    final prevExpense = previous
        .where((t) => t.transactionType == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);

    if (prevExpense <= 0) return 15; // No previous data

    final changeRate = (currentExpense - prevExpense) / prevExpense;
    if (changeRate <= -0.10) return 25;
    if (changeRate <= -0.05) return 20;
    if (changeRate <= 0.0) return 15;
    if (changeRate <= 0.05) return 10;
    return 5;
  }

  /// Spending balance (25 points)
  /// Distribution across categories
  static int _spendingBalance(List<Transaction> transactions) {
    final expenses = transactions
        .where((t) => t.transactionType == TransactionType.expense)
        .toList();
    if (expenses.isEmpty) return 15;

    final totalExpense = expenses.fold(0, (sum, t) => sum + t.amount);
    if (totalExpense <= 0) return 15;

    final Map<String, int> catTotals = {};
    for (final t in expenses) {
      catTotals[t.categoryKey] = (catTotals[t.categoryKey] ?? 0) + t.amount;
    }

    if (catTotals.length <= 1) return 5;

    final maxCatRatio =
        catTotals.values.reduce((a, b) => a > b ? a : b) / totalExpense;
    if (maxCatRatio <= 0.30) return 25;
    if (maxCatRatio <= 0.40) return 20;
    if (maxCatRatio <= 0.50) return 15;
    if (maxCatRatio <= 0.60) return 10;
    return 5;
  }

  /// Generate health comment based on scores
  static String generateHealthComment(HealthScoreResult result) {
    final total = result.total;
    if (total >= 90) {
      return '훌륭해요! 지출 관리의 달인이시네요. 이 페이스를 유지해보세요!';
    }
    if (total >= 75) {
      if (result.balanceScore < 15) {
        return '전체적으로 잘 관리하고 있어요! 지출 균형만 조금 더 신경 쓰면 완벽해요.';
      }
      if (result.budgetScore < 15) {
        return '절약 노력이 보여요! 예산을 조금만 더 지켜보면 좋겠어요.';
      }
      return '양호해요! 조금만 더 노력하면 훌륭한 등급에 도달할 수 있어요.';
    }
    if (total >= 60) {
      return '보통이에요. 소비 패턴을 점검해보면 개선점이 보일 거예요.';
    }
    return '지출이 다소 많은 편이에요. 핵심 발견을 참고해서 조금씩 줄여보는 건 어떨까요?';
  }
}
