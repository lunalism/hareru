import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hareru/models/dictionary_term.dart';

const _cacheBoxName = 'dictionary_cache';
const _cacheKey = 'dictionary_terms';

final dictionaryTermsProvider =
    FutureProvider<List<DictionaryTerm>>((ref) async {
  final cachedTerms = await _getCachedTerms();

  try {
    final response = await Supabase.instance.client
        .from('dictionary_terms')
        .select()
        .eq('is_active', true)
        .order('display_order', ascending: true);

    final terms = (response as List)
        .map((json) => DictionaryTerm.fromSupabase(json))
        .toList();

    await _cacheTerms(terms);
    return terms;
  } catch (e) {
    if (cachedTerms != null && cachedTerms.isNotEmpty) {
      return cachedTerms;
    }
    rethrow;
  }
});

final filteredDictionaryTermsProvider = Provider.family<
    AsyncValue<List<DictionaryTerm>>, DictionaryCategory>((ref, category) {
  final termsAsync = ref.watch(dictionaryTermsProvider);
  return termsAsync.whenData((terms) {
    if (category == DictionaryCategory.all) return terms;
    return terms.where((t) => t.category == category).toList();
  });
});

Future<List<DictionaryTerm>?> _getCachedTerms() async {
  try {
    final box = await Hive.openBox<String>(_cacheBoxName);
    final cached = box.get(_cacheKey);
    if (cached == null) return null;

    final list = jsonDecode(cached) as List<dynamic>;
    return list.map((e) => DictionaryTerm.fromJson(e as Map<String, dynamic>)).toList();
  } catch (_) {
    return null;
  }
}

Future<void> _cacheTerms(List<DictionaryTerm> terms) async {
  try {
    final box = await Hive.openBox<String>(_cacheBoxName);
    final json = jsonEncode(terms.map((t) => t.toJson()).toList());
    await box.put(_cacheKey, json);
  } catch (_) {
    // Silently fail — cache is best-effort
  }
}
