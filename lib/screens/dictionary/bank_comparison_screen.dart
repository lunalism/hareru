import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/features/dictionary/bank_comparison/bank_product_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';

class BankComparisonScreen extends ConsumerWidget {
  const BankComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeProvider).languageCode;
    final bankProducts = ref.watch(bankProductsProvider);

    return Scaffold(
      backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: isDark
                          ? HareruColors.darkTextPrimary
                          : HareruColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: bankProducts.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: HareruColors.primaryStart,
                  ),
                ),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
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
                      TextButton(
                        onPressed: () =>
                            ref.invalidate(bankProductsProvider),
                        child: Text(
                          l10n.bankRetry,
                          style: const TextStyle(
                            color: HareruColors.primaryStart,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                data: (banks) => ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  children: [
                    // Header
                    const Text(
                      '\u{1F3E6}',
                      style: TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.bankComparison,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? HareruColors.darkTextPrimary
                            : HareruColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      banks.isNotEmpty
                          ? banks.first.dataAsOf
                          : l10n.asOf,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? HareruColors.darkTextTertiary
                            : HareruColors.lightTextTertiary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bank cards
                    ...banks.map(
                      (bank) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildBankCard(bank, isDark, lang, l10n),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Foreigner tip card
                    _buildForeignerTip(isDark, l10n),
                    const SizedBox(height: 16),

                    // Korea comparison tip (Korean only)
                    if (lang == 'ko') ...[
                      _buildKoreaTip(isDark, l10n),
                      const SizedBox(height: 16),
                    ],

                    // AI recommendation banner
                    _buildAiBanner(context, isDark, l10n),
                    const SizedBox(height: 20),

                    // Disclaimer
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\u26A0\uFE0F ',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? HareruColors.darkTextTertiary
                                : HareruColors.lightTextTertiary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            l10n.rateDisclaimer,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? HareruColors.darkTextTertiary
                                  : HareruColors.lightTextTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCard(
    BankProduct bank,
    bool isDark,
    String lang,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bank name
          Text(
            '${bank.bankIcon ?? ''} ${bank.getLocalizedName(lang)}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.darkCard,
            ),
          ),
          const SizedBox(height: 16),

          // Info rows
          _buildInfoRow(
            l10n.interestRate,
            '\u5E74${bank.interestRate}%',
            isDark,
            isRate: true,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            l10n.minimumAmount,
            bank.minAmount != null ? '${bank.minAmount}\u5186\u301C' : '-',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            l10n.depositPeriod,
            [bank.periodMin, bank.periodMax]
                .where((e) => e != null)
                .join('\u301C'),
            isDark,
          ),
          const SizedBox(height: 14),

          // Feature
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('\u{1F4A1} ', style: TextStyle(fontSize: 13)),
              Expanded(
                child: Text(
                  bank.getLocalizedFeatures(lang),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? HareruColors.darkTextSecondary
                        : HareruColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Recommendation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('\u{1F464} ', style: TextStyle(fontSize: 13)),
              Expanded(
                child: Text(
                  bank.getLocalizedRecommendedFor(lang),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: HareruColors.primaryStart,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    bool isDark, {
    bool isRate = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextTertiary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isRate ? FontWeight.w700 : FontWeight.w600,
              color: isRate
                  ? HareruColors.savings
                  : (isDark
                      ? HareruColors.darkTextPrimary
                      : HareruColors.darkCard),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForeignerTip(bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF431407) : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF9A3412) : const Color(0xFFFED7AA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u{1F4A1} ${l10n.foreignerTipTitle}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFFED7AA) : const Color(0xFF9A3412),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.foreignerTipBody,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFFFDBA74) : const Color(0xFF78350F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKoreaTip(bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C1D3A) : HareruColors.guideIconBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? HareruColors.darkDivider : HareruColors.lightDivider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u{1F1F0}\u{1F1F7} ${l10n.koreaCompareTitle}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? HareruColors.primaryStart : const Color(0xFFB33A32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.koreaCompareBody,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? HareruColors.primaryStart : HareruColors.darkDivider,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiBanner(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [HareruColors.darkBg, HareruColors.darkCard]
              : [
                  HareruColors.guideIconBg,
                  HareruColors.guideIconBg,
                  HareruColors.savingsBgLight,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? HareruColors.darkDivider : HareruColors.lightDivider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2728 ${l10n.aiBankRecommend}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.darkCard,
            ),
          ),
          const SizedBox(height: 14),
          _buildAiQuestion(l10n.aiBankQ1, isDark),
          const SizedBox(height: 6),
          _buildAiQuestion(l10n.aiBankQ2, isDark),
          const SizedBox(height: 6),
          _buildAiQuestion(l10n.aiBankQ3, isDark),
          const SizedBox(height: 14),
          Text(
            l10n.aiBankDescription,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.premiumComingSoon)),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: HareruColors.primaryStart,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${l10n.unlockWithClear} \u2192',
                style: const TextStyle(
                  fontSize: 14,
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

  Widget _buildAiQuestion(String text, bool isDark) {
    return Text(
      '\u{1F4AC} $text',
      style: TextStyle(
        fontSize: 13,
        color: isDark
            ? HareruColors.darkTextSecondary
            : HareruColors.lightTextSecondary,
      ),
    );
  }
}
