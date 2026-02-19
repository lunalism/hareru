import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/data/dictionary_data.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/dictionary_term.dart';
import 'package:hareru/screens/dictionary/bank_comparison_screen.dart';
import 'package:hareru/screens/dictionary/term_detail_screen.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  DictionaryCategory _selectedCategory = DictionaryCategory.all;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DictionaryTerm> _filteredTerms(String lang) {
    var terms = dictionaryTerms.toList();

    if (_selectedCategory != DictionaryCategory.all) {
      terms = terms.where((t) => t.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      terms = terms.where((t) {
        return t.name(lang).toLowerCase().contains(q) ||
            t.summary(lang).toLowerCase().contains(q) ||
            t.description(lang).toLowerCase().contains(q);
      }).toList();
    }

    return terms;
  }

  String _categoryLabel(DictionaryCategory cat, AppLocalizations l10n) {
    return switch (cat) {
      DictionaryCategory.all => l10n.allCategories,
      DictionaryCategory.banking => l10n.bankingDeposit,
      DictionaryCategory.household => l10n.householdBasics,
      DictionaryCategory.tax => l10n.taxPension,
      DictionaryCategory.insurance => l10n.insurance,
      DictionaryCategory.savings => l10n.savingsInvestment,
      DictionaryCategory.loan => l10n.loanDebt,
      DictionaryCategory.system => l10n.japanSystem,
      DictionaryCategory.payment => l10n.cashlessPayment,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeProvider).languageCode;
    final terms = _filteredTerms(lang);

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
                l10n.dictionary,
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

            // Featured banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildFeaturedBanner(isDark, l10n),
            ),
            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSearchBar(isDark, l10n),
            ),
            const SizedBox(height: 16),

            // Category filter
            SizedBox(
              height: 38,
              child: _buildCategoryTabs(isDark, l10n),
            ),
            const SizedBox(height: 16),

            // Term list
            Expanded(
              child: terms.isEmpty
                  ? _buildEmptyState(isDark, l10n)
                  : _buildTermList(terms, isDark, lang, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner(bool isDark, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const BankComparisonScreen(),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E3A8A)]
                : [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '\u{1F3E6}',
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.bankComparison,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.bankComparisonSub,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${l10n.viewComparison} \u2192',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: TextStyle(
          fontSize: 15,
          color: isDark
              ? HareruColors.darkTextPrimary
              : HareruColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: l10n.searchTerms,
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
          suffixIcon: _searchQuery.isNotEmpty
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
                    setState(() => _searchQuery = '');
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

  Widget _buildCategoryTabs(bool isDark, AppLocalizations l10n) {
    final categories = DictionaryCategory.values;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: categories.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final cat = categories[i];
        final isSelected = cat == _selectedCategory;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : (isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _categoryLabel(cat, l10n),
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

  Widget _buildTermList(
      List<DictionaryTerm> terms, bool isDark, String lang, AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: terms.length + 1, // +1 for AI banner
      itemBuilder: (_, i) {
        if (i == terms.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: _buildAiBanner(isDark, l10n),
          );
        }
        final term = terms[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildTermCard(term, isDark, lang),
        );
      },
    );
  }

  Widget _buildTermCard(DictionaryTerm term, bool isDark, String lang) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => TermDetailScreen(term: term),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? HareruColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          children: [
            Text(term.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    term.name(lang),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? HareruColors.darkTextPrimary
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    term.summary(lang),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? HareruColors.darkTextSecondary
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextTertiary,
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
              ? [HareruColors.darkCard, HareruColors.darkBg]
              : [const Color(0xFFEFF6FF), const Color(0xFFF0F9FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF1E3A8A)
              : const Color(0xFFBFDBFE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2728 ${l10n.askAi}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.askAiDescription,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : const Color(0xFF64748B),
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
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${l10n.unlockWithClear} \u2192',
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
