import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:hareru/models/financial_guide.dart';
import 'package:hareru/services/guide_service.dart';

class LearnTab extends StatefulWidget {
  const LearnTab({super.key});

  @override
  State<LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> {
  final _guideService = const GuideService();
  final _searchController = TextEditingController();
  List<FinancialGuide> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final locale = Localizations.localeOf(context).languageCode;
      setState(() {
        if (query.trim().isEmpty) {
          _isSearching = false;
          _searchResults = [];
        } else {
          _isSearching = true;
          _searchResults = _guideService.searchGuides(query, locale);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final currentMonth = DateTime.now().month;

    final recommended = _guideService.getRecommendedGuides(
      locale: locale,
      currentMonth: currentMonth,
    );
    final seasonal = _guideService.getSeasonalGuides(currentMonth);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.learn),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.learnSearchHint,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _isSearching = false;
                            _searchResults = [];
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isSearching
                ? _buildSearchResults(l10n, locale, theme)
                : _buildMainContent(
                    l10n, locale, theme, recommended, seasonal),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
      AppLocalizations l10n, String locale, ThemeData theme) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.learnNoResults,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final guide = _searchResults[index];
        return _GuideListTile(
          guide: guide,
          locale: locale,
          onTap: () => context.push('/learn/guide/${guide.id}'),
        );
      },
    );
  }

  Widget _buildMainContent(
    AppLocalizations l10n,
    String locale,
    ThemeData theme,
    List<FinancialGuide> recommended,
    List<FinancialGuide> seasonal,
  ) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // For You section
        _SectionHeader(title: l10n.learnForYou),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommended.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final guide = recommended[index];
              return _RecommendedCard(
                guide: guide,
                locale: locale,
                onTap: () => context.push('/learn/guide/${guide.id}'),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Category grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: _categories.map((cat) {
              final count =
                  _guideService.getGuidesCountByCategory(cat['id'] as String);
              return _CategoryCard(
                emoji: cat['emoji'] as String,
                nameJa: cat['nameJa'] as String,
                nameKo: cat['nameKo'] as String,
                nameEn: cat['nameEn'] as String,
                locale: locale,
                articleCount: count,
                onTap: () =>
                    context.push('/learn/category/${cat['id'] as String}'),
              );
            }).toList(),
          ),
        ),

        // This Month section
        if (seasonal.isNotEmpty) ...[
          const SizedBox(height: 24),
          _SectionHeader(title: l10n.learnThisMonth),
          ...seasonal.map((guide) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _GuideListTile(
                  guide: guide,
                  locale: locale,
                  onTap: () => context.push('/learn/guide/${guide.id}'),
                ),
              )),
        ],
      ],
    );
  }
}

const _categories = [
  {
    'id': 'daily',
    'emoji': '\u{1F4B0}',
    'nameJa': '日常の節約',
    'nameKo': '일상 절약',
    'nameEn': 'Daily Saving',
  },
  {
    'id': 'tax',
    'emoji': '\u{1F3DB}',
    'nameJa': '税金・控除',
    'nameKo': '세금·공제',
    'nameEn': 'Tax',
  },
  {
    'id': 'investment',
    'emoji': '\u{1F4C8}',
    'nameJa': '貯蓄・投資',
    'nameKo': '저축·투자',
    'nameEn': 'Investment',
  },
  {
    'id': 'insurance',
    'emoji': '\u{1F6E1}',
    'nameJa': '保険・社会保障',
    'nameKo': '보험·사회보장',
    'nameEn': 'Insurance',
  },
  {
    'id': 'foreigner',
    'emoji': '\u{1F30F}',
    'nameJa': '外国人ガイド',
    'nameKo': '외국인 가이드',
    'nameEn': 'For Foreigners',
  },
  {
    'id': 'saving',
    'emoji': '\u{1F9E0}',
    'nameJa': '家計の知恵',
    'nameKo': '가계 지혜',
    'nameEn': 'Smart Money',
  },
];

// --- Widgets ---

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          fontFamily: 'PretendardJP',
        ),
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.guide,
    required this.locale,
    required this.onTap,
  });

  final FinancialGuide guide;
  final String locale;
  final VoidCallback onTap;

  Color _gradientStart(String category, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    switch (category) {
      case 'daily':
        return isLight ? const Color(0xFFE0F7FA) : const Color(0xFF1A3A3A);
      case 'tax':
        return isLight ? const Color(0xFFE3F2FD) : const Color(0xFF1A2A3A);
      case 'investment':
        return isLight ? const Color(0xFFE8F5E9) : const Color(0xFF1A3A1A);
      case 'insurance':
        return isLight ? const Color(0xFFF3E5F5) : const Color(0xFF2A1A3A);
      case 'foreigner':
        return isLight ? const Color(0xFFFFF3E0) : const Color(0xFF3A2A1A);
      case 'saving':
        return isLight ? const Color(0xFFFFFDE7) : const Color(0xFF3A3A1A);
      default:
        return isLight ? const Color(0xFFF5F5F5) : const Color(0xFF2A2A2A);
    }
  }

  Color _gradientEnd(String category, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    switch (category) {
      case 'daily':
        return isLight ? const Color(0xFFB2EBF2) : const Color(0xFF0D2828);
      case 'tax':
        return isLight ? const Color(0xFFBBDEFB) : const Color(0xFF0D1A28);
      case 'investment':
        return isLight ? const Color(0xFFC8E6C9) : const Color(0xFF0D280D);
      case 'insurance':
        return isLight ? const Color(0xFFE1BEE7) : const Color(0xFF1A0D28);
      case 'foreigner':
        return isLight ? const Color(0xFFFFE0B2) : const Color(0xFF281A0D);
      case 'saving':
        return isLight ? const Color(0xFFFFF9C4) : const Color(0xFF28280D);
      default:
        return isLight ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _gradientStart(guide.category, brightness),
              _gradientEnd(guide.category, brightness),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(guide.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                guide.title(locale),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'PretendardJP',
                  color: theme.colorScheme.onSurface,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            _DifficultyBadge(difficulty: guide.difficulty),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.emoji,
    required this.nameJa,
    required this.nameKo,
    required this.nameEn,
    required this.locale,
    required this.articleCount,
    required this.onTap,
  });

  final String emoji;
  final String nameJa;
  final String nameKo;
  final String nameEn;
  final String locale;
  final int articleCount;
  final VoidCallback onTap;

  String get _name {
    switch (locale) {
      case 'ja':
        return nameJa;
      case 'en':
        return nameEn;
      default:
        return nameKo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outline, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              _name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'PretendardJP',
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$articleCount articles',
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'PretendardJP',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideListTile extends StatelessWidget {
  const _GuideListTile({
    required this.guide,
    required this.locale,
    required this.onTap,
  });

  final FinancialGuide guide;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = guide.body(locale);
    final preview = body.length > 50 ? '${body.substring(0, 50)}...' : body;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outline, width: 0.5),
        ),
        child: Row(
          children: [
            Text(guide.icon, style: const TextStyle(fontSize: 32)),
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
                  _DifficultyBadge(difficulty: guide.difficulty),
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

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});
  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (difficulty) {
      'beginner' => (
          _beginnerLabel(Localizations.localeOf(context).languageCode),
          const Color(0xFF4CAF50),
        ),
      'intermediate' => (
          _intermediateLabel(Localizations.localeOf(context).languageCode),
          const Color(0xFFFF9800),
        ),
      'advanced' => (
          _advancedLabel(Localizations.localeOf(context).languageCode),
          const Color(0xFFE57373),
        ),
      _ => ('', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'PretendardJP',
          color: color,
        ),
      ),
    );
  }

  static String _beginnerLabel(String locale) => switch (locale) {
        'ja' => '初級',
        'en' => 'Beginner',
        _ => '초급',
      };

  static String _intermediateLabel(String locale) => switch (locale) {
        'ja' => '中級',
        'en' => 'Intermediate',
        _ => '중급',
      };

  static String _advancedLabel(String locale) => switch (locale) {
        'ja' => '上級',
        'en' => 'Advanced',
        _ => '상급',
      };
}
