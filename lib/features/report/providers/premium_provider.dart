import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final isPremiumProvider =
    NotifierProvider<PremiumNotifier, bool>(PremiumNotifier.new);

class PremiumNotifier extends Notifier<bool> {
  @override
  bool build() {
    final box = Hive.box('settings');
    return box.get('isPremium', defaultValue: false) as bool;
  }

  void toggle(bool value) {
    state = value;
    Hive.box('settings').put('isPremium', value);
  }
}
