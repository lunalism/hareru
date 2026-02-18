import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _payDayKey = 'pay_day';

class PayDayNotifier extends StateNotifier<int> {
  PayDayNotifier() : super(0) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    state = box.get(_payDayKey, defaultValue: 0) as int;
  }

  Future<void> setPayDay(int day) async {
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_payDayKey, day);
    state = day;
  }

  bool get isPayDaySet => state > 0;
}

final payDayProvider = StateNotifierProvider<PayDayNotifier, int>(
  (ref) => PayDayNotifier(),
);
