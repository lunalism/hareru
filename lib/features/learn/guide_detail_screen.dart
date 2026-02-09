import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:hareru/models/financial_guide.dart';
import 'package:hareru/services/guide_service.dart';

class GuideDetailScreen extends StatelessWidget {
  const GuideDetailScreen({super.key, required this.guideId});

  final String guideId;

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
    final l10n = AppLocalizations.of(context)!;
    final guideService = const GuideService();
    final guide = guideService.getGuideById(guideId);

    if (guide == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Guide not found')),
      );
    }

    final relatedGuides = guideService.getRelatedGuides(guide);
    final catNames = _categoryNames[guide.category] ?? {};
    final categoryName =
        catNames[locale] ?? catNames['en'] ?? guide.category;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Text(guide.icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),

            // Title
            Text(
              guide.title(locale),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'PretendardJP',
                color: theme.colorScheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Badges
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _Chip(
                  label: categoryName,
                  color: theme.colorScheme.primary,
                ),
                _DifficultyChip(
                  difficulty: guide.difficulty,
                  locale: locale,
                ),
                if (guide.foreignerRelevant)
                  _Chip(
                    label: switch (locale) {
                      'ja' => '🌏 外国人向け',
                      'en' => '🌏 For foreigners',
                      _ => '🌏 외국인용',
                    },
                    color: const Color(0xFFFF9800),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Body
            _RichBody(text: guide.body(locale), theme: theme),

            // Related
            if (relatedGuides.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                l10n.learnRelated,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PretendardJP',
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: relatedGuides.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final related = relatedGuides[index];
                    return _RelatedCard(
                      guide: related,
                      locale: locale,
                      theme: theme,
                      onTap: () =>
                          context.push('/learn/guide/${related.id}'),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _RichBody extends StatelessWidget {
  const _RichBody({required this.text, required this.theme});
  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final paragraphs = text.split('\n\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((paragraph) {
        final trimmed = paragraph.trim();
        if (trimmed.isEmpty) return const SizedBox.shrink();

        // Handle bullet points
        if (trimmed.startsWith('・') || trimmed.startsWith('- ')) {
          final lines = trimmed.split('\n');
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((line) {
                final content =
                    line.startsWith('・') ? line.substring(1).trim() : line;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '  •  ',
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.colorScheme.primary,
                          fontFamily: 'PretendardJP',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          content,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            fontFamily: 'PretendardJP',
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }

        // Handle bold (text between ** markers)
        if (trimmed.contains('**')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildRichText(trimmed, theme),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            trimmed,
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              fontFamily: 'PretendardJP',
              color: theme.colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRichText(String text, ThemeData theme) {
    final spans = <TextSpan>[];
    final parts = text.split('**');

    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          fontWeight: i.isOdd ? FontWeight.w700 : FontWeight.normal,
          fontSize: 15,
          height: 1.7,
          fontFamily: 'PretendardJP',
          color: theme.colorScheme.onSurface,
        ),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'PretendardJP',
          color: color,
        ),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({required this.difficulty, required this.locale});
  final String difficulty;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (difficulty) {
      'beginner' => (
          switch (locale) { 'ja' => '初級', 'en' => 'Beginner', _ => '초급' },
          const Color(0xFF4CAF50),
        ),
      'intermediate' => (
          switch (locale) {
            'ja' => '中級',
            'en' => 'Intermediate',
            _ => '중급',
          },
          const Color(0xFFFF9800),
        ),
      'advanced' => (
          switch (locale) {
            'ja' => '上級',
            'en' => 'Advanced',
            _ => '상급',
          },
          const Color(0xFFE57373),
        ),
      _ => ('', Colors.grey),
    };

    return _Chip(label: label, color: color);
  }
}

class _RelatedCard extends StatelessWidget {
  const _RelatedCard({
    required this.guide,
    required this.locale,
    required this.theme,
    required this.onTap,
  });

  final FinancialGuide guide;
  final String locale;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(guide.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                guide.title(locale),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'PretendardJP',
                  color: theme.colorScheme.onSurface,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
