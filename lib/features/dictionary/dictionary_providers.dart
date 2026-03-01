import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/features/dictionary/models/dictionary_term.dart';
import 'package:hareru/features/dictionary/repositories/dictionary_repository.dart';

final dictionaryRepositoryProvider = Provider((ref) {
  return DictionaryRepository(Supabase.instance.client);
});

final allTermsProvider = FutureProvider<List<DictionaryTerm>>((ref) {
  return ref.read(dictionaryRepositoryProvider).fetchAllTerms();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredTermsProvider =
    Provider<AsyncValue<List<DictionaryTerm>>>((ref) {
  final termsAsync = ref.watch(allTermsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  final locale = ref.watch(localeProvider).languageCode;

  return termsAsync.whenData((terms) {
    var filtered = terms;
    if (category != null) {
      filtered = filtered.where((t) => t.category == category).toList();
    }
    if (query.isNotEmpty) {
      filtered = filtered.where((t) {
        final name = t.name(locale).toLowerCase();
        final summary = (t.summary(locale) ?? '').toLowerCase();
        final desc = (t.description(locale) ?? '').toLowerCase();
        return name.contains(query) ||
            summary.contains(query) ||
            desc.contains(query);
      }).toList();
    }
    return filtered;
  });
});
