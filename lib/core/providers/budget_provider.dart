import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _budgetKey = 'monthly_budget';

class BudgetNotifier extends StateNotifier<int> {
  BudgetNotifier() : super(0) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    state = box.get(_budgetKey, defaultValue: 0) as int;
  }

  Future<void> setBudget(int amount) async {
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_budgetKey, amount);
    state = amount;
  }

  bool get isBudgetSet => state > 0;
}

final budgetProvider = StateNotifierProvider<BudgetNotifier, int>(
  (ref) => BudgetNotifier(),
);
