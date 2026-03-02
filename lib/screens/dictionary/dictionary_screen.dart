import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/features/dictionary/dictionary_providers.dart';
import 'package:hareru/features/dictionary/models/dictionary_term.dart';
import 'package:hareru/features/subscription/ad_placeholder.dart';
import 'package:hareru/l10n/app_localizations.dart';

class _CategoryChip {
  final String? key;
  final String emoji;
  final String Function(AppLocalizations l10n) label;

  const _CategoryChip(this.key, this.emoji, this.label);
}

final _categoryChips = <_CategoryChip>[
  _CategoryChip(null, '\u2728', (l10n) => l10n.categoryAll),
  _CategoryChip('banking', '\u{1F3E6}', (l10n) => l10n.categoryBanking),
  _CategoryChip('household', '\u{1F3E0}', (l10n) => l10n.categoryHousehold),
  _CategoryChip('tax', '\u{1F3DB}\uFE0F', (l10n) => l10n.categoryTax),
  _CategoryChip('insurance', '\u{1F6E1}\uFE0F', (l10n) => l10n.categoryInsurance),
  _CategoryChip('savings', '\u{1F4B0}', (l10n) => l10n.categorySavings),
  _CategoryChip('loan', '\u{1F3D7}\uFE0F', (l10n) => l10n.categoryLoan),
  _CategoryChip('system', '\u{1F4CB}', (l10n) => l10n.categorySystem),
  _CategoryChip('payment', '\u{1F4B3}', (l10n) => l10n.categoryPayment),
];

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeProvider).languageCode;
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredAsync = ref.watch(filteredTermsProvider);

    return Scaffold(
      backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                l10n.dictionaryTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? HareruColors.darkTextPrimary
                      : HareruColors.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSearchBar(isDark, l10n),
            ),
            const SizedBox(height: 16),

            // Category filter chips
            SizedBox(
              height: 38,
              child: _buildCategoryChips(isDark, l10n, selectedCategory),
            ),
            const SizedBox(height: 16),

            // Term list
            Expanded(
              child: filteredAsync.when(
                data: (terms) {
                  if (terms.isEmpty) return _buildEmptyState(isDark, l10n);
                  return _buildTermList(terms, isDark, lang, l10n);
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, _) => _buildErrorState(isDark, l10n, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, AppLocalizations l10n) {
    final searchQuery = ref.watch(searchQueryProvider);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkDivider : HareruColors.lightBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) =>
            ref.read(searchQueryProvider.notifier).state = v,
        style: TextStyle(
          fontSize: 15,
          color: isDark
              ? HareruColors.darkTextPrimary
              : HareruColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: l10n.searchPlaceholder,
          hintStyle: TextStyle(
            fontSize: 15,
            color: isDark
                ? HareruColors.darkTextTertiary
                : HareruColors.lightTextTertiary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark
                ? HareruColors.darkTextTertiary
                : HareruColors.lightTextTertiary,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: isDark
                        ? HareruColors.darkTextTertiary
                        : HareruColors.lightTextTertiary,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(
      bool isDark, AppLocalizations l10n, String? selectedCategory) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _categoryChips.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final chip = _categoryChips[i];
        final isSelected = chip.key == selectedCategory;
        return GestureDetector(
          onTap: () =>
              ref.read(selectedCategoryProvider.notifier).state = chip.key,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : (isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(chip.emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  chip.label(l10n),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? HareruColors.darkTextSecondary
                            : const Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: isDark
                ? HareruColors.darkTextTertiary
                : HareruColors.lightTextTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noTermsFound,
            style: TextStyle(
              fontSize: 15,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : HareruColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      bool isDark, AppLocalizations l10n, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: isDark
                ? HareruColors.darkTextTertiary
                : HareruColors.lightTextTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.bankLoadError,
            style: TextStyle(
              fontSize: 15,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : HareruColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => ref.invalidate(allTermsProvider),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l10n.bankRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildTermList(List<DictionaryTerm> terms, bool isDark, String lang,
      AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: terms.length + 2, // +1 AI banner, +1 ad placeholder
      itemBuilder: (_, i) {
        if (i == terms.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildAiBanner(isDark, l10n),
          );
        }
        if (i == terms.length + 1) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: AdPlaceholder(),
          );
        }
        final term = terms[i];
        return Column(
          children: [
            _buildTermItem(term, isDark, lang, l10n),
            if (i < terms.length - 1)
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE5E0DB),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTermItem(
      DictionaryTerm term, bool isDark, String lang, AppLocalizations l10n) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showTermDetail(term, isDark, lang, l10n),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(term.emoji ?? '', style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    term.name(lang),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFF1F5F9)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    term.summary(lang) ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiBanner(bool isDark, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
              : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2728 ${l10n.aiAskAboutMoney}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.aiPersonalizedAdvice,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : HareruColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.premiumComingSoon)),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: HareruColors.primaryStart,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.unlockWithClear,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermDetail(
      DictionaryTerm term, bool isDark, String lang, AppLocalizations l10n) {
    final allTerms = ref.read(allTermsProvider).valueOrNull ?? [];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? HareruColors.darkBg : HareruColors.lightBg,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Emoji
              Center(
                child: Text(term.emoji ?? '',
                    style: const TextStyle(fontSize: 40)),
              ),
              const SizedBox(height: 12),

              // Term name
              Center(
                child: Text(
                  term.name(lang),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? HareruColors.darkTextPrimary
                        : const Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),

              // Other language names
              Center(
                child: Text(
                  term.otherNames(lang).join(' / '),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),

              // Category tag
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E3A5F)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _categoryLabel(term.category, l10n),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF93C5FD)
                          : const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Explanation section
              if (term.description(lang)?.isNotEmpty ?? false) ...[
                _sectionHeader(l10n.sectionExplanation, isDark),
                const SizedBox(height: 8),
                Text(
                  term.description(lang)!,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: isDark
                        ? HareruColors.darkTextPrimary
                        : const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Example section
              if (term.example(lang)?.isNotEmpty ?? false) ...[
                _sectionHeader(l10n.sectionExample, isDark),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? HareruColors.darkCard
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    term.example(lang)!,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark
                          ? HareruColors.darkTextSecondary
                          : const Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Related terms
              if (term.relatedTermKeys.isNotEmpty) ...[
                _sectionHeader(l10n.sectionRelated, isDark),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: term.relatedTermKeys.map((key) {
                    final related = allTerms
                        .where((t) => t.termKey == key)
                        .firstOrNull;
                    if (related == null) return const SizedBox.shrink();
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Future.delayed(
                          const Duration(milliseconds: 200),
                          () {
                            if (mounted) {
                              _showTermDetail(
                                  related, isDark, lang, l10n);
                            }
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${related.emoji ?? ''} ${related.name(lang)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // AI learn more banner
              _buildDetailAiBanner(isDark, l10n),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(String category, AppLocalizations l10n) {
    return switch (category) {
      'banking' => l10n.categoryBanking,
      'household' => l10n.categoryHousehold,
      'tax' => l10n.categoryTax,
      'insurance' => l10n.categoryInsurance,
      'savings' => l10n.categorySavings,
      'loan' => l10n.categoryLoan,
      'system' => l10n.categorySystem,
      'payment' => l10n.categoryPayment,
      _ => category,
    };
  }

  Widget _sectionHeader(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark
            ? HareruColors.darkTextTertiary
            : const Color(0xFF94A3B8),
      ),
    );
  }

  Widget _buildDetailAiBanner(bool isDark, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C4A6E) : const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2728 ${l10n.aiLearnMore}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.aiExplainForYou,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : HareruColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.premiumComingSoon)),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: HareruColors.primaryStart,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.unlockWithClear,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
