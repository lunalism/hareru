import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/models/financial_guide.dart';
import 'package:hareru/services/guide_service.dart';

class GuideListScreen extends StatelessWidget {
  const GuideListScreen({super.key, required this.categoryId});

  final String categoryId;

  static const _categoryNames = {
    'daily': {'ja': '日常の節約', 'ko': '일상 절약', 'en': 'Daily Saving'},
    'tax': {'ja': '税金・控除', 'ko': '세금·공제', 'en': 'Tax'},
    'investment': {'ja': '貯蓄・投資', 'ko': '저축·투자', 'en': 'Investment'},
    'insurance': {
      'ja': '保険・社会保障',
      'ko': '보험·사회보장',
      'en': 'Insurance',
    },
    'foreigner': {
      'ja': '外国人ガイド',
      'ko': '외국인 가이드',
      'en': 'For Foreigners',
    },
    'saving': {'ja': '家計の知恵', 'ko': '가계 지혜', 'en': 'Smart Money'},
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final guideService = const GuideService();
    final guides = guideService.getGuidesByCategory(categoryId);
    final names = _categoryNames[categoryId] ?? {};
    final title = names[locale] ?? names['en'] ?? categoryId;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: guides.length,
        itemBuilder: (context, index) {
          final guide = guides[index];
          return _GuideCard(
            guide: guide,
            locale: locale,
            theme: theme,
            onTap: () => context.push('/learn/guide/${guide.id}'),
          );
        },
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({
    required this.guide,
    required this.locale,
    required this.theme,
    required this.onTap,
  });

  final FinancialGuide guide;
  final String locale;
  final ThemeData theme;
  final VoidCallback onTap;

  String get _difficultyLabel => switch (guide.difficulty) {
        'beginner' => switch (locale) {
            'ja' => '初級',
            'en' => 'Beginner',
            _ => '초급',
          },
        'intermediate' => switch (locale) {
            'ja' => '中級',
            'en' => 'Intermediate',
            _ => '중급',
          },
        'advanced' => switch (locale) {
            'ja' => '上級',
            'en' => 'Advanced',
            _ => '상급',
          },
        _ => '',
      };

  Color get _difficultyColor => switch (guide.difficulty) {
        'beginner' => const Color(0xFF4CAF50),
        'intermediate' => const Color(0xFFFF9800),
        'advanced' => const Color(0xFFE57373),
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final body = guide.body(locale);
    final preview = body.length > 50 ? '${body.substring(0, 50)}...' : body;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outline, width: 0.5),
        ),
        child: Row(
          children: [
            Text(guide.icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.title(locale),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'PretendardJP',
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preview,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'PretendardJP',
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _difficultyColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _difficultyLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'PretendardJP',
                            color: _difficultyColor,
                          ),
                        ),
                      ),
                      if (guide.foreignerRelevant) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9800)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '🌏',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
