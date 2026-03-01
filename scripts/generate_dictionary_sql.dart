// ignore_for_file: avoid_print
// Usage: dart run scripts/generate_dictionary_sql.dart > scripts/dictionary_seed.sql

import 'package:hareru/data/dictionary_data.dart';
import 'package:hareru/models/dictionary_term.dart';

String escape(String s) => s.replaceAll("'", "''");

String categoryToString(DictionaryCategory cat) => cat.name;

void main() {
  print('-- Dictionary terms seed data');
  print('-- Generated from lib/data/dictionary_data.dart');
  print('-- Run this in Supabase SQL Editor');
  print('');
  print('CREATE TABLE IF NOT EXISTS dictionary_terms (');
  print('  id SERIAL PRIMARY KEY,');
  print('  term_key TEXT NOT NULL UNIQUE,');
  print('  emoji TEXT,');
  print('  category TEXT NOT NULL,');
  print('  name_ja TEXT NOT NULL,');
  print('  summary_ja TEXT,');
  print('  description_ja TEXT,');
  print('  example_ja TEXT,');
  print('  name_ko TEXT,');
  print('  summary_ko TEXT,');
  print('  description_ko TEXT,');
  print('  example_ko TEXT,');
  print('  name_en TEXT,');
  print('  summary_en TEXT,');
  print('  description_en TEXT,');
  print('  example_en TEXT,');
  print('  related_term_keys TEXT[] DEFAULT \'{}\',');
  print('  display_order INTEGER DEFAULT 0,');
  print('  is_active BOOLEAN DEFAULT TRUE');
  print(');');
  print('');

  for (var i = 0; i < dictionaryTerms.length; i++) {
    final t = dictionaryTerms[i];
    final relatedKeys = t.relatedTermIds.map((id) => "'${escape(id)}'").join(', ');

    print('INSERT INTO dictionary_terms (');
    print('  term_key, emoji, category,');
    print('  name_ja, summary_ja, description_ja, example_ja,');
    print('  name_ko, summary_ko, description_ko, example_ko,');
    print('  name_en, summary_en, description_en, example_en,');
    print('  related_term_keys, display_order, is_active');
    print(') VALUES (');
    print("  '${escape(t.id)}',");
    print("  '${escape(t.emoji)}',");
    print("  '${categoryToString(t.category)}',");
    print("  '${escape(t.nameJa)}',");
    print("  '${escape(t.summaryJa)}',");
    print("  '${escape(t.descriptionJa)}',");
    print("  '${escape(t.exampleJa)}',");
    print("  '${escape(t.nameKo)}',");
    print("  '${escape(t.summaryKo)}',");
    print("  '${escape(t.descriptionKo)}',");
    print("  '${escape(t.exampleKo)}',");
    print("  '${escape(t.nameEn)}',");
    print("  '${escape(t.summaryEn)}',");
    print("  '${escape(t.descriptionEn)}',");
    print("  '${escape(t.exampleEn)}',");
    print("  ARRAY[$relatedKeys],");
    print('  $i,');
    print('  TRUE');
    print(');');
    print('');
  }

  print('-- Total: ${dictionaryTerms.length} terms inserted');
}
