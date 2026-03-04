import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _key = 'bookmarked_terms';

class BookmarkNotifier extends StateNotifier<List<String>> {
  BookmarkNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    final saved = box.get(_key) as String?;
    if (saved != null) {
      final list = (jsonDecode(saved) as List<dynamic>).cast<String>();
      state = list;
    }
  }

  bool isBookmarked(String termKey) => state.contains(termKey);

  Future<void> toggle(String termKey) async {
    final updated = isBookmarked(termKey)
        ? state.where((k) => k != termKey).toList()
        : [...state, termKey];
    state = updated;
    await _persist(updated);
  }

  Future<void> _persist(List<String> keys) async {
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_key, jsonEncode(keys));
  }
}

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, List<String>>(
  (ref) => BookmarkNotifier(),
);
