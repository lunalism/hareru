import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/ai_insight.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import 'health_score_calculator.dart';

class AiInsightMockGenerator {
  static final _fmt = NumberFormat('#,##0');
  static const _uuid = Uuid();

  static AiInsight generate(
    List<Transaction> transactions,
    List<Transaction> prevTransactions,
    DateTime periodStart,
    DateTime periodEnd, {
    int? monthlyBudget,
  }) {
    final expenses = transactions
        .where((t) => t.transactionType == TransactionType.expense)
        .toList();

    final discoveries = <InsightItem>[];

    final dayPattern = _detectDayPattern(expenses);
    if (dayPattern != null) discoveries.add(dayPattern);

    final frequentSmall = _detectFrequentSmall(expenses, periodStart, periodEnd);
    if (frequentSmall != null) discoveries.add(frequentSmall);

    final increase = _detectIncrease(expenses, prevTransactions);
    if (increase != null) discoveries.add(increase);

    // Sort by saving potential descending, take top 3
    discoveries.sort((a, b) => b.savingPotential.compareTo(a.savingPotential));
    final topDiscoveries = discoveries.take(3).toList();

    final healthResult = HealthScoreCalculator.calculate(
      transactions,
      prevTransactions,
      monthlyBudget: monthlyBudget,
    );

    return AiInsight(
      id: _uuid.v4(),
      generatedAt: DateTime.now(),
      periodStart: periodStart,
      periodEnd: periodEnd,
      discoveries: topDiscoveries,
      suggestion: _generateSuggestion(topDiscoveries, expenses),
      healthScore: healthResult.total,
      healthComment: HealthScoreCalculator.generateHealthComment(healthResult),
    );
  }

  /// Rule 1: Detect day-of-week spending pattern
  static InsightItem? _detectDayPattern(List<Transaction> expenses) {
    if (expenses.isEmpty) return null;

    // Build weekday x category matrix
    final Map<int, Map<String, int>> weekdayCat = {};
    final Map<String, int> catTotals = {};

    for (final t in expenses) {
      final wd = t.date.weekday;
      weekdayCat.putIfAbsent(wd, () => {});
      weekdayCat[wd]![t.categoryKey] =
          (weekdayCat[wd]![t.categoryKey] ?? 0) + t.amount;
      catTotals[t.categoryKey] = (catTotals[t.categoryKey] ?? 0) + t.amount;
    }

    // Find weekday+category combination where weekday accounts for 30%+ of category total
    final dayNames = ['', '월', '화', '수', '목', '금', '토', '일'];
    InsightItem? best;
    int bestAmount = 0;

    for (final wdEntry in weekdayCat.entries) {
      for (final catEntry in wdEntry.value.entries) {
        final catTotal = catTotals[catEntry.key] ?? 0;
        if (catTotal > 0 && catEntry.value / catTotal >= 0.30) {
          final monthlyAmount = catEntry.value;
          if (monthlyAmount > bestAmount) {
            bestAmount = monthlyAmount;
            best = InsightItem(
              title: '${dayNames[wdEntry.key]}요일 ${_categoryLabel(catEntry.key)} 패턴 감지',
              detail: '→ 월 ¥${_fmt.format(monthlyAmount)} (연 ¥${_fmt.format(monthlyAmount * 12)})',
              category: catEntry.key,
              savingPotential: (monthlyAmount * 0.3).round(),
            );
          }
        }
      }
    }

    return best;
  }

  /// Rule 2: Detect frequent small spending
  static InsightItem? _detectFrequentSmall(
    List<Transaction> expenses,
    DateTime periodStart,
    DateTime periodEnd,
  ) {
    if (expenses.isEmpty) return null;

    final weeks = periodEnd.difference(periodStart).inDays / 7;
    if (weeks <= 0) return null;

    // Group by category
    final Map<String, List<Transaction>> catGroups = {};
    for (final t in expenses) {
      catGroups.putIfAbsent(t.categoryKey, () => []).add(t);
    }

    InsightItem? best;
    int bestSaving = 0;

    for (final entry in catGroups.entries) {
      final weeklyFreq = entry.value.length / weeks;
      final avgAmount =
          entry.value.fold(0, (sum, t) => sum + t.amount) / entry.value.length;

      // Weekly 3+ times & average under 1000 yen
      if (weeklyFreq >= 3 && avgAmount <= 1000) {
        // Estimated savings: 30% reduction
        final monthlySaving = (avgAmount * weeklyFreq * 4 * 0.3).round();
        if (monthlySaving > bestSaving) {
          bestSaving = monthlySaving;
          best = InsightItem(
            title: '${_categoryLabel(entry.key)} 소액결제 주 ${weeklyFreq.toStringAsFixed(1)}회',
            detail: '→ 횟수를 줄이면 월 ¥${_fmt.format(monthlySaving)} 절약',
            category: entry.key,
            savingPotential: monthlySaving,
          );
        }
      }
    }

    return best;
  }

  /// Rule 3: Detect biggest increase vs previous period
  static InsightItem? _detectIncrease(
    List<Transaction> current,
    List<Transaction> previous,
  ) {
    final prevExpenses = previous
        .where((t) => t.transactionType == TransactionType.expense)
        .toList();
    if (prevExpenses.isEmpty) return null;

    final Map<String, int> currentCats = {};
    for (final t in current) {
      currentCats[t.categoryKey] =
          (currentCats[t.categoryKey] ?? 0) + t.amount;
    }
    final Map<String, int> prevCats = {};
    for (final t in prevExpenses) {
      prevCats[t.categoryKey] = (prevCats[t.categoryKey] ?? 0) + t.amount;
    }

    String? biggestKey;
    int biggestIncrease = 0;
    double biggestPct = 0;

    for (final entry in currentCats.entries) {
      final prev = prevCats[entry.key] ?? 0;
      if (prev > 0) {
        final increase = entry.value - prev;
        final pct = increase / prev;
        if (pct >= 0.20 && increase >= 3000 && increase > biggestIncrease) {
          biggestIncrease = increase;
          biggestPct = pct;
          biggestKey = entry.key;
        }
      }
    }

    if (biggestKey == null) return null;

    return InsightItem(
      title: '${_categoryLabel(biggestKey)} 지출이 전월 대비 ${(biggestPct * 100).round()}% 증가',
      detail: '→ 증가분 ¥${_fmt.format(biggestIncrease)} 줄이면 절약',
      category: biggestKey,
      savingPotential: biggestIncrease,
    );
  }

  static String _generateSuggestion(
    List<InsightItem> discoveries,
    List<Transaction> expenses,
  ) {
    if (discoveries.isEmpty) {
      return '지출 기록을 더 모으면 맞춤 분석을 해드릴게요!';
    }

    final topItem = discoveries.first;
    final totalExpense = expenses.fold(0, (sum, t) => sum + t.amount);
    if (totalExpense <= 0) {
      return '지출 기록을 더 모으면 맞춤 분석을 해드릴게요!';
    }

    final savingPct = (topItem.savingPotential / totalExpense * 100).round();
    return '${_categoryLabel(topItem.category)} 지출을 $savingPct% 줄이면 '
        '¥${_fmt.format(topItem.savingPotential)} 절약 가능해요. 도전해볼까요?';
  }

  static String _categoryLabel(String key) {
    const labels = {
      'food': '식비',
      'transport': '교통',
      'shopping': '쇼핑',
      'cafe': '카페',
      'entertainment': '여가',
      'medical': '의료',
      'transfer': '이체',
      'other': '기타',
    };
    return labels[key] ?? key;
  }
}
