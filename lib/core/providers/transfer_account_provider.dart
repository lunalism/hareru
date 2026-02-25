import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _key = 'transfer_accounts';

/// Default account keys — resolved via l10n at display time.
const defaultAccountKeys = ['mainAccount', 'savingsAccount', 'investmentAccount'];

class TransferAccountNotifier extends StateNotifier<List<String>> {
  TransferAccountNotifier() : super(defaultAccountKeys) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    final saved = box.get(_key) as List<dynamic>?;
    if (saved != null && saved.isNotEmpty) {
      state = saved.cast<String>();
    }
  }

  Future<void> addAccount(String name) async {
    if (name.trim().isEmpty || state.contains(name.trim())) return;
    final updated = [...state, name.trim()];
    state = updated;
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_key, updated);
  }
}

final transferAccountProvider =
    StateNotifierProvider<TransferAccountNotifier, List<String>>(
  (ref) => TransferAccountNotifier(),
);
