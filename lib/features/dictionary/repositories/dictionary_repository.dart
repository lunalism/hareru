import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hareru/features/dictionary/models/dictionary_term.dart';

class DictionaryRepository {
  final SupabaseClient _client;

  DictionaryRepository(this._client);

  Future<List<DictionaryTerm>> fetchAllTerms() async {
    try {
      final response = await _client
          .from('dictionary_terms')
          .select()
          .eq('is_active', true)
          .order('display_order', ascending: true);
      final terms = (response as List)
          .map((e) => DictionaryTerm.fromJson(e as Map<String, dynamic>))
          .toList();
      debugPrint('[DictionaryRepository] fetched ${terms.length} terms');
      return terms;
    } catch (e, st) {
      debugPrint('[DictionaryRepository] fetchAllTerms error: $e');
      debugPrint('[DictionaryRepository] stackTrace: $st');
      rethrow;
    }
  }
}
