enum DictionaryCategory {
  all,
  banking,
  household,
  tax,
  insurance,
  savings,
  loan,
  system,
  payment,
}

DictionaryCategory _parseCategory(String value) {
  return DictionaryCategory.values.firstWhere(
    (c) => c.name == value,
    orElse: () => DictionaryCategory.all,
  );
}

class DictionaryTerm {
  final String id;
  final String emoji;
  final String nameJa;
  final String nameKo;
  final String nameEn;
  final String summaryJa;
  final String summaryKo;
  final String summaryEn;
  final String descriptionJa;
  final String descriptionKo;
  final String descriptionEn;
  final String exampleJa;
  final String exampleKo;
  final String exampleEn;
  final DictionaryCategory category;
  final List<String> relatedTermIds;

  const DictionaryTerm({
    required this.id,
    required this.emoji,
    required this.nameJa,
    required this.nameKo,
    required this.nameEn,
    required this.summaryJa,
    required this.summaryKo,
    required this.summaryEn,
    required this.descriptionJa,
    required this.descriptionKo,
    required this.descriptionEn,
    required this.exampleJa,
    required this.exampleKo,
    required this.exampleEn,
    required this.category,
    required this.relatedTermIds,
  });

  factory DictionaryTerm.fromSupabase(Map<String, dynamic> json) {
    return DictionaryTerm(
      id: json['term_key'] as String,
      emoji: (json['emoji'] as String?) ?? '',
      nameJa: json['name_ja'] as String,
      nameKo: (json['name_ko'] as String?) ?? '',
      nameEn: (json['name_en'] as String?) ?? '',
      summaryJa: (json['summary_ja'] as String?) ?? '',
      summaryKo: (json['summary_ko'] as String?) ?? '',
      summaryEn: (json['summary_en'] as String?) ?? '',
      descriptionJa: (json['description_ja'] as String?) ?? '',
      descriptionKo: (json['description_ko'] as String?) ?? '',
      descriptionEn: (json['description_en'] as String?) ?? '',
      exampleJa: (json['example_ja'] as String?) ?? '',
      exampleKo: (json['example_ko'] as String?) ?? '',
      exampleEn: (json['example_en'] as String?) ?? '',
      category: _parseCategory(json['category'] as String),
      relatedTermIds: (json['related_term_keys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  factory DictionaryTerm.fromJson(Map<String, dynamic> json) {
    return DictionaryTerm(
      id: json['id'] as String,
      emoji: (json['emoji'] as String?) ?? '',
      nameJa: json['nameJa'] as String,
      nameKo: (json['nameKo'] as String?) ?? '',
      nameEn: (json['nameEn'] as String?) ?? '',
      summaryJa: (json['summaryJa'] as String?) ?? '',
      summaryKo: (json['summaryKo'] as String?) ?? '',
      summaryEn: (json['summaryEn'] as String?) ?? '',
      descriptionJa: (json['descriptionJa'] as String?) ?? '',
      descriptionKo: (json['descriptionKo'] as String?) ?? '',
      descriptionEn: (json['descriptionEn'] as String?) ?? '',
      exampleJa: (json['exampleJa'] as String?) ?? '',
      exampleKo: (json['exampleKo'] as String?) ?? '',
      exampleEn: (json['exampleEn'] as String?) ?? '',
      category: _parseCategory(json['category'] as String),
      relatedTermIds: (json['relatedTermIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'emoji': emoji,
        'nameJa': nameJa,
        'nameKo': nameKo,
        'nameEn': nameEn,
        'summaryJa': summaryJa,
        'summaryKo': summaryKo,
        'summaryEn': summaryEn,
        'descriptionJa': descriptionJa,
        'descriptionKo': descriptionKo,
        'descriptionEn': descriptionEn,
        'exampleJa': exampleJa,
        'exampleKo': exampleKo,
        'exampleEn': exampleEn,
        'category': category.name,
        'relatedTermIds': relatedTermIds,
      };

  String name(String langCode) => switch (langCode) {
        'ko' => nameKo,
        'en' => nameEn,
        _ => nameJa,
      };

  String summary(String langCode) => switch (langCode) {
        'ko' => summaryKo,
        'en' => summaryEn,
        _ => summaryJa,
      };

  String description(String langCode) => switch (langCode) {
        'ko' => descriptionKo,
        'en' => descriptionEn,
        _ => descriptionJa,
      };

  String example(String langCode) => switch (langCode) {
        'ko' => exampleKo,
        'en' => exampleEn,
        _ => exampleJa,
      };
}
