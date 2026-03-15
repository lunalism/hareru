import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hareru/core/services/hive_encryption_service.dart';

const _boxName = 'settings';
const _key = 'viewed_terms';

class ViewedTermsNotifier extends StateNotifier<List<String>> {
  ViewedTermsNotifier() : super([]) {
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
      debugPrint('[ViewedTermsProvider] _load error (may be pre-encryption data): $e');
      try {
        await Hive.deleteBoxFromDisk(_boxName);
        debugPrint('[ViewedTermsProvider] deleted corrupted box, starting fresh');
      } catch (_) {}
    }
  }

  Future<void> markViewed(String termKey) async {
    if (state.contains(termKey)) return;
    final updated = [...state, termKey];
    state = updated;
    await _persist(updated);
  }

  Future<void> _persist(List<String> keys) async {
    final box = await HiveEncryptionService.openBox<dynamic>(_boxName);
    await box.put(_key, jsonEncode(keys));
  }
}

final viewedTermsProvider =
    StateNotifierProvider<ViewedTermsNotifier, List<String>>(
  (ref) => ViewedTermsNotifier(),
);
