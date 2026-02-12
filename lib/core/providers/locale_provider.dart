import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _key = 'locale';
const _supportedCodes = ['ja', 'ko', 'en'];

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ja')) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox(_boxName);
    final saved = box.get(_key) as String?;

    if (saved != null && _supportedCodes.contains(saved)) {
      state = Locale(saved);
    } else {
      // Use system locale if supported, otherwise default to ja
      final systemCode = PlatformDispatcher.instance.locale.languageCode;
      state = Locale(_supportedCodes.contains(systemCode) ? systemCode : 'ja');
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final box = await Hive.openBox(_boxName);
    await box.put(_key, locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
