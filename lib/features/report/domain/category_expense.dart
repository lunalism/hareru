import 'dart:ui';

class CategoryExpense {
  const CategoryExpense({
    required this.categoryKey,
    required this.categoryName,
    required this.emoji,
    required this.amount,
    required this.count,
    required this.percentage,
    required this.color,
  });

  final String categoryKey;
  final String categoryName;
  final String emoji;
  final int amount;
  final int count;
  final double percentage;
  final Color color;
}
