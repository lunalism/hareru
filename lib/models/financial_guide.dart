class FinancialGuide {
  final String id;
  final String titleJa;
  final String titleKo;
  final String titleEn;
  final String bodyJa;
  final String bodyKo;
  final String bodyEn;
  final String category;
  final String icon;
  final List<String> tags;
  final List<String> relatedSpendingCategories;
  final List<int> seasonalMonths;
  final String difficulty;
  final bool foreignerRelevant;

  const FinancialGuide({
    required this.id,
    required this.titleJa,
    required this.titleKo,
    required this.titleEn,
    required this.bodyJa,
    required this.bodyKo,
    required this.bodyEn,
    required this.category,
    required this.icon,
    this.tags = const [],
    this.relatedSpendingCategories = const [],
    this.seasonalMonths = const [],
    this.difficulty = 'beginner',
    this.foreignerRelevant = false,
  });

  String title(String locale) {
    switch (locale) {
      case 'ja':
        return titleJa;
      case 'en':
        return titleEn;
      default:
        return titleKo;
    }
  }

  String body(String locale) {
    switch (locale) {
      case 'ja':
        return bodyJa;
      case 'en':
        return bodyEn;
      default:
        return bodyKo;
    }
  }
}
