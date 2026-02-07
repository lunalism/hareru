import 'transaction_type.dart';

class Transaction {
  const Transaction({
    required this.id,
    required this.amount,
    required this.transactionType,
    required this.categoryEmoji,
    required this.categoryKey,
    this.note = '',
    required this.date,
    this.fromAccount,
    this.toAccount,
    this.isExcludedFromBudget = false,
    required this.createdAt,
  });

  final String id;
  final int amount;
  final TransactionType transactionType;
  final String categoryEmoji;
  final String categoryKey;
  final String note;
  final DateTime date;
  final String? fromAccount;
  final String? toAccount;
  final bool isExcludedFromBudget;
  final DateTime createdAt;

  bool get isTransfer => transactionType == TransactionType.transfer;
  bool get isIncome => transactionType == TransactionType.income;
  bool get isExpense => transactionType == TransactionType.expense;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'transactionType': transactionType.key,
      'categoryEmoji': categoryEmoji,
      'categoryKey': categoryKey,
      'note': note,
      'date': date.toIso8601String(),
      'fromAccount': fromAccount,
      'toAccount': toAccount,
      'isExcludedFromBudget': isExcludedFromBudget,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<dynamic, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      amount: map['amount'] as int,
      transactionType: TransactionType.fromKey(map['transactionType'] as String),
      categoryEmoji: map['categoryEmoji'] as String,
      categoryKey: map['categoryKey'] as String,
      note: map['note'] as String? ?? '',
      date: DateTime.parse(map['date'] as String),
      fromAccount: map['fromAccount'] as String?,
      toAccount: map['toAccount'] as String?,
      isExcludedFromBudget: map['isExcludedFromBudget'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Transaction copyWith({
    String? id,
    int? amount,
    TransactionType? transactionType,
    String? categoryEmoji,
    String? categoryKey,
    String? note,
    DateTime? date,
    String? fromAccount,
    String? toAccount,
    bool? isExcludedFromBudget,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      categoryEmoji: categoryEmoji ?? this.categoryEmoji,
      categoryKey: categoryKey ?? this.categoryKey,
      note: note ?? this.note,
      date: date ?? this.date,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      isExcludedFromBudget: isExcludedFromBudget ?? this.isExcludedFromBudget,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
