import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hareru/features/dictionary/models/dictionary_term.dart';

class DictionaryRepository {
  final SupabaseClient _client;

  DictionaryRepository(this._client);

  Future<List<DictionaryTerm>> fetchAllTerms() async {
    final response = await _client
        .from('dictionary_terms')
        .select()
        .eq('is_active', true)
        .order('display_order', ascending: true);
    return (response as List)
        .map((e) => DictionaryTerm.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
