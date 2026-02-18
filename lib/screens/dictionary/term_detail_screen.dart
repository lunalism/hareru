import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/data/dictionary_data.dart';
import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/dictionary_term.dart';

class TermDetailScreen extends ConsumerWidget {
  const TermDetailScreen({super.key, required this.term});

  final DictionaryTerm term;

  String _categoryLabel(DictionaryCategory cat, AppLocalizations l10n) {
    return switch (cat) {
      DictionaryCategory.all => l10n.allCategories,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeProvider).languageCode;

    return Scaffold(
      backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Emoji
            Center(
              child: Text(term.emoji, style: const TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 16),
            // Term name
            Center(
              child: Text(
                term.name(lang),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? HareruColors.darkTextPrimary
                      : HareruColors.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 6),
            // Other language names
            Center(
              child: Text(
                _otherNames(lang),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? HareruColors.darkTextTertiary
                      : HareruColors.lightTextTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            // Category tag
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E3A8A).withValues(alpha: 0.3)
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
            const SizedBox(height: 28),

            // Explanation section
            _sectionHeader(l10n.explanation, isDark),
            const SizedBox(height: 12),
            Text(
              term.description(lang),
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: isDark
                    ? HareruColors.darkTextPrimary
                    : const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 28),

            // Example section
            _sectionHeader(l10n.example, isDark),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? HareruColors.darkCard
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                term.example(lang),
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : const Color(0xFF475569),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Related terms
            if (term.relatedTermIds.isNotEmpty) ...[
              _sectionHeader(l10n.relatedTerms, isDark),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: term.relatedTermIds.map((id) {
                  final related = dictionaryTerms
                      .where((t) => t.id == id)
                      .firstOrNull;
                  if (related == null) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            TermDetailScreen(term: related),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? HareruColors.darkCard
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? HareruColors.darkDivider
                              : HareruColors.lightDivider,
                        ),
                      ),
                      child: Text(
                        '${related.emoji} ${related.name(lang)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: HareruColors.primaryStart,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
            ],

            // AI banner
            _buildAiBanner(context, isDark, l10n),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _otherNames(String lang) {
    final names = <String>[];
    if (lang != 'en') names.add(term.nameEn);
    if (lang != 'ko') names.add(term.nameKo);
    if (lang != 'ja') names.add(term.nameJa);
    return names.join(' / ');
  }

  Widget _sectionHeader(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark
            ? HareruColors.darkTextTertiary
            : HareruColors.lightTextTertiary,
      ),
    );
  }

  Widget _buildAiBanner(
      BuildContext context, bool isDark, AppLocalizations l10n) {
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
            '\u2728 ${l10n.learnMoreWithAi}',
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
            l10n.learnMoreAiDescription,
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
