import 'package:hareru/data/financial_guides_data.dart';
import 'package:hareru/models/financial_guide.dart';

class GuideService {
  const GuideService();

  static const _categoryMapping = {
    'food': ['food', 'dining', 'convenience'],
    'transport': ['transport'],
    'shopping': ['shopping', 'subscription', 'communication'],
    'cafe': ['cafe', 'dining'],
    'entertainment': ['entertainment', 'subscription'],
    'medical': ['medical'],
    'other': ['utilities', 'other'],
  };

  List<FinancialGuide> getRecommendedGuides({
    required String locale,
    required int currentMonth,
    List<String> topSpendingCategoryKeys = const [],
    bool isForeigner = false,
  }) {
    final guides = List<FinancialGuide>.from(financialGuidesData);
    final scores = <String, double>{};

    for (final guide in guides) {
      double score = 0;

      // Seasonal relevance
      if (guide.seasonalMonths.contains(currentMonth)) {
        score += 30;
      }

      // Spending category relevance
      for (final catKey in topSpendingCategoryKeys) {
        final mapped = _categoryMapping[catKey] ?? [catKey];
        for (final relCat in guide.relatedSpendingCategories) {
          if (mapped.contains(relCat)) {
            score += 20;
            break;
          }
        }
      }

      // Foreigner preference
      if (isForeigner && guide.foreignerRelevant) {
        score += 15;
      }

      // Beginner-friendly boost
      if (guide.difficulty == 'beginner') {
        score += 5;
      }

      scores[guide.id] = score;
    }

    guides.sort((a, b) => (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0));
    return guides.take(5).toList();
  }

  List<FinancialGuide> searchGuides(String query, String locale) {
    if (query.trim().isEmpty) return [];

    final q = query.toLowerCase();
    return financialGuidesData.where((guide) {
      final title = guide.title(locale).toLowerCase();
      final body = guide.body(locale).toLowerCase();
      final tagMatch = guide.tags.any((t) => t.toLowerCase().contains(q));
      return title.contains(q) || body.contains(q) || tagMatch;
    }).toList();
  }

  List<FinancialGuide> getGuidesByCategory(String category) {
    return financialGuidesData
        .where((g) => g.category == category)
        .toList();
  }

  FinancialGuide? getGuideById(String id) {
    try {
      return financialGuidesData.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  List<FinancialGuide> getSeasonalGuides(int month) {
    return financialGuidesData
        .where((g) => g.seasonalMonths.contains(month))
        .toList();
  }

  int getGuidesCountByCategory(String category) {
    return financialGuidesData.where((g) => g.category == category).length;
  }

  List<FinancialGuide> getRelatedGuides(FinancialGuide guide, {int limit = 3}) {
    return financialGuidesData
        .where((g) =>
            g.id != guide.id &&
            (g.category == guide.category ||
                g.tags.any((t) => guide.tags.contains(t))))
        .take(limit)
        .toList();
  }
}
