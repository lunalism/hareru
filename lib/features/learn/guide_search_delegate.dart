import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:hareru/models/financial_guide.dart';
import 'package:hareru/services/guide_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GuideSearchDelegate extends SearchDelegate<String?> {
  GuideSearchDelegate({required this.locale});

  final String locale;
  final _guideService = const GuideService();

  static const _recentSearchesKey = 'recentGuideSearches';
  static const _maxRecent = 10;

  List<String> _getRecentSearches() {
    final box = Hive.box('settings');
    final list = box.get(_recentSearchesKey, defaultValue: <dynamic>[]);
    return (list as List).cast<String>();
  }

  void _addRecentSearch(String query) {
    if (query.trim().isEmpty) return;
    final box = Hive.box('settings');
    final recent = _getRecentSearches();
    recent.remove(query);
    recent.insert(0, query);
    if (recent.length > _maxRecent) {
      recent.removeLast();
    }
    box.put(_recentSearchesKey, recent);
  }

  void _clearRecentSearches() {
    final box = Hive.box('settings');
    box.put(_recentSearchesKey, <String>[]);
  }

  @override
  String get searchFieldLabel {
    return switch (locale) {
      'ja' => '用語や気になるトピックを検索',
      'en' => 'Search topics',
      _ => '용어나 관심 주제를 검색',
    };
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) _addRecentSearch(query);
    final results = _guideService.searchGuides(query, locale);
    return _buildResultList(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildRecentSearches(context);
    }
    final results = _guideService.searchGuides(query, locale);
    return _buildResultList(context, results);
  }

  Widget _buildRecentSearches(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final recent = _getRecentSearches();

    if (recent.isEmpty) return const SizedBox.shrink();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.learnRecentSearches,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'PretendardJP',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _clearRecentSearches();
                  query = query; // trigger rebuild
                },
                child: Text(
                  l10n.learnClearHistory,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'PretendardJP',
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...recent.map((term) => ListTile(
              leading: Icon(
                Icons.history,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 20,
              ),
              title: Text(
                term,
                style: const TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 14,
                ),
              ),
              onTap: () {
                query = term;
                showResults(context);
              },
            )),
      ],
    );
  }

  Widget _buildResultList(BuildContext context, List<FinancialGuide> results) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (results.isEmpty) {
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
                fontFamily: 'PretendardJP',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final guide = results[index];
        final body = guide.body(locale);
        final preview =
            body.length > 50 ? '${body.substring(0, 50)}...' : body;

        return GestureDetector(
          onTap: () {
            _addRecentSearch(query);
            close(context, null);
            context.push('/learn/guide/${guide.id}');
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: theme.colorScheme.outline, width: 0.5),
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
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
