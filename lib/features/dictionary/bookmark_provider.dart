import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hareru/core/services/hive_encryption_service.dart';

const _boxName = 'settings';
const _key = 'bookmarked_terms';

class BookmarkNotifier extends StateNotifier<List<String>> {
  BookmarkNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final box = await HiveEncryptionService.openBox<dynamic>(_boxName);
      final saved = box.get(_key) as String?;
      if (saved != null) {
        final list = (jsonDecode(saved) as List<dynamic>).cast<String>();
        state = list;
      }
    } catch (e) {
      debugPrint('[BookmarkProvider] _load error (may be pre-encryption data): $e');
      // Delete corrupted box and retry with fresh state
      try {
        await Hive.deleteBoxFromDisk(_boxName);
        debugPrint('[BookmarkProvider] deleted corrupted box, starting fresh');
      } catch (_) {}
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
    final box = await HiveEncryptionService.openBox<dynamic>(_boxName);
    await box.put(_key, jsonEncode(keys));
  }
}

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, List<String>>(
  (ref) => BookmarkNotifier(),
);
