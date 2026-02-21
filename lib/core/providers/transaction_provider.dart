import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/services/widget_data_service.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'transactions';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier(this._ref) : super([]) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final box = await Hive.openBox<Transaction>(_boxName);
    final items = box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
    _syncWidget();
  }

  Future<void> add(Transaction transaction) async {
    final box = await Hive.openBox<Transaction>(_boxName);
    await box.put(transaction.id, transaction);
    final items = box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
    _syncWidget();
  }

  Future<void> update(Transaction transaction) async {
    final box = await Hive.openBox<Transaction>(_boxName);
    await box.put(transaction.id, transaction);
    final items = box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
    _syncWidget();
  }

  Future<void> delete(String id) async {
    final box = await Hive.openBox<Transaction>(_boxName);
    await box.delete(id);
    final items = box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = items;
    _syncWidget();
  }

  void _syncWidget() {
    final budget = _ref.read(budgetProvider);
    WidgetDataService.updateWidgetData(
      transactions: state,
      budget: budget,
    );
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
  (ref) => TransactionNotifier(ref),
);
