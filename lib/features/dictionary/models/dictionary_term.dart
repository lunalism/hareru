class DictionaryTerm {
  final int id;
  final String termKey;
  final String? emoji;
  final String category;
  final String nameJa;
  final String? summaryJa;
  final String? descriptionJa;
  final String? exampleJa;
  final String? nameKo;
  final String? summaryKo;
  final String? descriptionKo;
  final String? exampleKo;
  final String? nameEn;
  final String? summaryEn;
  final String? descriptionEn;
  final String? exampleEn;
  final List<String> relatedTermKeys;
  final int displayOrder;
  final bool isActive;

  const DictionaryTerm({
    required this.id,
    required this.termKey,
    this.emoji,
    required this.category,
    required this.nameJa,
    this.summaryJa,
    this.descriptionJa,
    this.exampleJa,
    this.nameKo,
    this.summaryKo,
    this.descriptionKo,
    this.exampleKo,
    this.nameEn,
    this.summaryEn,
    this.descriptionEn,
    this.exampleEn,
    this.relatedTermKeys = const [],
    this.displayOrder = 0,
    this.isActive = true,
  });

  String name(String locale) => switch (locale) {
        'ko' => nameKo ?? nameJa,
        'en' => nameEn ?? nameJa,
        _ => nameJa,
      };

  String? summary(String locale) => switch (locale) {
        'ko' => summaryKo ?? summaryJa,
        'en' => summaryEn ?? summaryJa,
        _ => summaryJa,
      };

  String? description(String locale) => switch (locale) {
        'ko' => descriptionKo ?? descriptionJa,
        'en' => descriptionEn ?? descriptionJa,
        _ => descriptionJa,
      };

  String? example(String locale) => switch (locale) {
        'ko' => exampleKo ?? exampleJa,
        'en' => exampleEn ?? exampleJa,
        _ => exampleJa,
      };

  List<String> otherNames(String locale) {
    final names = <String>[];
    if (locale != 'en' && nameEn != null) names.add(nameEn!);
    if (locale != 'ko' && nameKo != null) names.add(nameKo!);
    if (locale != 'ja') names.add(nameJa);
    return names;
  }

  factory DictionaryTerm.fromJson(Map<String, dynamic> json) => DictionaryTerm(
        id: (json['id'] as num?)?.toInt() ?? 0,
        termKey: json['term_key'] as String? ?? '',
        emoji: json['emoji'] as String?,
        category: json['category'] as String? ?? '',
        nameJa: json['name_ja'] as String? ?? '',
        summaryJa: json['summary_ja'] as String?,
        descriptionJa: json['description_ja'] as String?,
        exampleJa: json['example_ja'] as String?,
        nameKo: json['name_ko'] as String?,
        summaryKo: json['summary_ko'] as String?,
        descriptionKo: json['description_ko'] as String?,
        exampleKo: json['example_ko'] as String?,
        nameEn: json['name_en'] as String?,
        summaryEn: json['summary_en'] as String?,
        descriptionEn: json['description_en'] as String?,
        exampleEn: json['example_en'] as String?,
        relatedTermKeys:
            List<String>.from(json['related_term_keys'] as List? ?? []),
        displayOrder: (json['display_order'] as int?) ?? 0,
        isActive: (json['is_active'] as bool?) ?? true,
      );
}
