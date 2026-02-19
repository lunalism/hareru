import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'transactions';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<Transaction>(_boxName);
    final items = box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
  }

  Future<void> add(Transaction transaction) async {
    final box = await Hive.openBox<Transaction>(_boxName);
    await box.put(transaction.id, transaction);
    final items = box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
  }

  Future<void> update(Transaction transaction) async {
    final box = await Hive.openBox<Transaction>(_boxName);
    await box.put(transaction.id, transaction);
    final items = box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
  }

  Future<void> delete(String id) async {
    final box = await Hive.openBox<Transaction>(_boxName);
    await box.delete(id);
    final items = box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
  }

  double get expenseTotal => state
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get transferTotal => state
      .where((t) => t.type == TransactionType.transfer)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get savingsTotal => state
      .where((t) => t.type == TransactionType.savings)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get incomeTotal => state
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>(
  (ref) => TransactionNotifier(),
);
