import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionRepository {
  static const _boxName = 'transactions';

  Box get _box => Hive.box(_boxName);

  List<Transaction> getAll() {
    final raw = _box.values.toList();
    return raw
        .map((e) => Transaction.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Transaction> getByDateRange(DateTime start, DateTime end) {
    return getAll()
        .where((t) =>
            !t.date.isBefore(start) &&
            t.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  Future<void> add(Transaction transaction) async {
    await _box.put(transaction.id, transaction.toMap());
  }

  Future<void> update(Transaction transaction) async {
    await _box.put(transaction.id, transaction.toMap());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});
