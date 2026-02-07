class InsightItem {
  const InsightItem({
    required this.title,
    required this.detail,
    required this.category,
    required this.savingPotential,
  });

  final String title;
  final String detail;
  final String category;
  final int savingPotential;

  Map<String, dynamic> toMap() => {
        'title': title,
        'detail': detail,
        'category': category,
        'savingPotential': savingPotential,
      };

  factory InsightItem.fromMap(Map<dynamic, dynamic> map) => InsightItem(
        title: map['title'] as String,
        detail: map['detail'] as String,
        category: map['category'] as String,
        savingPotential: map['savingPotential'] as int,
      );
}

class AiInsight {
  const AiInsight({
    required this.id,
    required this.generatedAt,
    required this.periodStart,
    required this.periodEnd,
    required this.discoveries,
    required this.suggestion,
    required this.healthScore,
    required this.healthComment,
  });

  final String id;
  final DateTime generatedAt;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<InsightItem> discoveries;
  final String suggestion;
  final int healthScore;
  final String healthComment;

  Map<String, dynamic> toMap() => {
        'id': id,
        'generatedAt': generatedAt.toIso8601String(),
        'periodStart': periodStart.toIso8601String(),
        'periodEnd': periodEnd.toIso8601String(),
        'discoveries': discoveries.map((d) => d.toMap()).toList(),
        'suggestion': suggestion,
        'healthScore': healthScore,
        'healthComment': healthComment,
      };

  factory AiInsight.fromMap(Map<dynamic, dynamic> map) => AiInsight(
        id: map['id'] as String,
        generatedAt: DateTime.parse(map['generatedAt'] as String),
        periodStart: DateTime.parse(map['periodStart'] as String),
        periodEnd: DateTime.parse(map['periodEnd'] as String),
        discoveries: (map['discoveries'] as List)
            .map((d) => InsightItem.fromMap(d as Map<dynamic, dynamic>))
            .toList(),
        suggestion: map['suggestion'] as String,
        healthScore: map['healthScore'] as int,
        healthComment: map['healthComment'] as String,
      );
}
