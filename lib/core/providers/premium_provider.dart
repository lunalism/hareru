import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _premiumKey = 'is_premium';

class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    state = box.get(_premiumKey, defaultValue: false) as bool;
  }

  Future<void> setPremium(bool value) async {
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_premiumKey, value);
    state = value;
  }
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, bool>(
  (ref) => PremiumNotifier(),
);
