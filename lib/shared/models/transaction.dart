import 'category.dart';

class Transaction {
  const Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.note,
    required this.createdAt,
    this.isTransfer = false,
  });

  final String id;
  final int amount;
  final ExpenseCategory category;
  final String note;
  final DateTime createdAt;
  final bool isTransfer;

  String get categoryEmoji => category.emoji;
  String get categoryName => category.label;
}
