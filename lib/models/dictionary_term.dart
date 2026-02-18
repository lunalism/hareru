enum DictionaryCategory {
  all,
  household,
  tax,
  insurance,
  savings,
  loan,
  system,
  payment,
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
