import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _key = 'dark_mode';

class DarkModeNotifier extends StateNotifier<ThemeMode> {
  DarkModeNotifier() : super(ThemeMode.light) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    final isDark = box.get(_key, defaultValue: false) as bool;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    final isDark = state == ThemeMode.dark;
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_key, !isDark);
    state = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, ThemeMode>(
  (ref) => DarkModeNotifier(),
);
