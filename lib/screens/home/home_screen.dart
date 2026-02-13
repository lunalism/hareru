import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/widgets/type_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final transactions = ref.watch(transactionProvider);
    final isEmpty = transactions.isEmpty;

    return Scaffold(
      backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeader(context, isDark),
              const SizedBox(height: 20),
              _buildMonthSelector(context, isDark),
              const SizedBox(height: 16),
              if (isEmpty) ...[
                _buildEmptyMainCard(context, isDark),
                const SizedBox(height: 24),
                _buildGuideCards(context, isDark),
              ] else ...[
                _buildMainAmountCard(context, isDark, ref),
                const SizedBox(height: 24),
                _buildRecentRecords(context, isDark, transactions),
                const SizedBox(height: 24),
                _buildAiInsightCard(context, isDark),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              isDark
                  ? 'assets/icon/hareru-symbol-white.svg'
                  : 'assets/icon/hareru-symbol-color.svg',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Hareru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? HareruColors.darkTextPrimary
                    : HareruColors.primaryStart,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _headerIcon(Icons.notifications_none_rounded, isDark),
            const SizedBox(width: 4),
            _headerIcon(Icons.settings_outlined, isDark),
          ],
        ),
      ],
    );
  }

  Widget _headerIcon(IconData icon, bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 22,
        color: isDark
            ? HareruColors.darkTextSecondary
            : HareruColors.lightTextSecondary,
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.chevron_left_rounded,
          color: isDark
              ? HareruColors.darkTextTertiary
              : HareruColors.lightTextTertiary,
        ),
        const SizedBox(width: 12),
        Text(
          l10n.monthFormat(now.year, now.month),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.chevron_right_rounded,
          color: isDark
              ? HareruColors.darkTextTertiary
              : HareruColors.lightTextTertiary,
        ),
      ],
    );
  }

  String _formatAmount(double value) {
    if (value == value.truncateToDouble()) {
      return _addCommas(value.truncate().toString());
    }
    return _addCommas(value.toStringAsFixed(2));
  }

  String _addCommas(String s) {
    final parts = s.split('.');
    final intPart = parts[0];
    final result = StringBuffer();
    var count = 0;
    for (var i = intPart.length - 1; i >= 0; i--) {
      result.write(intPart[i]);
      count++;
      if (count % 3 == 0 && i > 0) result.write(',');
    }
    final formatted = result.toString().split('').reversed.join();
    return parts.length > 1 ? '$formatted.${parts[1]}' : formatted;
  }

  Widget _buildMainAmountCard(
      BuildContext context, bool isDark, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(transactionProvider.notifier);
    final expenseTotal = notifier.expenseTotal;
    final transferTotal = notifier.transferTotal;
    final savingsTotal = notifier.savingsTotal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [HareruColors.primaryStart, HareruColors.primaryEnd],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: HareruColors.primaryStart.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative diamonds
          Positioned(
            right: -20,
            top: -20,
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: -10,
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.monthlyRealExpense,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '¥${_formatAmount(expenseTotal)}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              // 3-column: expense / transfer / savings (dark glass)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _killerColumn(
                      l10n.expense,
                      '¥${_formatAmount(expenseTotal)}',
                      const Color(0xFFEF4444),
                    ),
                    _killerColumn(
                      l10n.transfer,
                      '¥${_formatAmount(transferTotal)}',
                      const Color(0xFF3B82F6),
                    ),
                    _killerColumn(
                      l10n.savings,
                      '¥${_formatAmount(savingsTotal)}',
                      const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _killerColumn(String label, String amount, Color dotColor) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  String _emojiForCategory(String category) {
    return switch (category) {
      'catFood' => '🍚',
      'catTransport' => '🚃',
      'catDaily' => '🛒',
      'catCafe' => '☕',
      'catHobby' => '🎮',
      'catClothing' => '👕',
      'catMedical' => '🏥',
      'catPhone' => '📱',
      'catHousing' => '🏠',
      'catSocial' => '🍻',
      'catEducation' => '📚',
      'catOther' => '📦',
      'catBankTransfer' => '🏦',
      'catCard' => '💳',
      'catEMoney' => '📲',
      'catTransferOther' => '📦',
      'catSavings' => '🏦',
      'catInvestment' => '📈',
      'catGoal' => '🎯',
      'catSavingsOther' => '📦',
      _ => '📝',
    };
  }

  String _categoryLabel(String category, AppLocalizations l10n) {
    return switch (category) {
      'catFood' => l10n.catFood,
      'catTransport' => l10n.catTransport,
      'catDaily' => l10n.catDaily,
      'catCafe' => l10n.catCafe,
      'catHobby' => l10n.catHobby,
      'catClothing' => l10n.catClothing,
      'catMedical' => l10n.catMedical,
      'catPhone' => l10n.catPhone,
      'catHousing' => l10n.catHousing,
      'catSocial' => l10n.catSocial,
      'catEducation' => l10n.catEducation,
      'catOther' => l10n.catOther,
      'catBankTransfer' => l10n.catBankTransfer,
      'catCard' => l10n.catCard,
      'catEMoney' => l10n.catEMoney,
      'catTransferOther' => l10n.catTransferOther,
      'catSavings' => l10n.catSavings,
      'catInvestment' => l10n.catInvestment,
      'catGoal' => l10n.catGoal,
      'catSavingsOther' => l10n.catSavingsOther,
      _ => category,
    };
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final time = '$hour:$minute';

    if (dateOnly == today) {
      return '${l10n.today} $time';
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return '${l10n.yesterday} $time';
    } else {
      return '${date.month}/${date.day} $time';
    }
  }

  Widget _buildRecentRecords(
      BuildContext context, bool isDark, List<Transaction> transactions) {
    final l10n = AppLocalizations.of(context)!;
    final recent = transactions.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentRecords,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? HareruColors.darkTextPrimary
                    : HareruColors.lightTextPrimary,
              ),
            ),
            Text(
              l10n.seeAll,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: HareruColors.primaryStart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: recent.asMap().entries.map((entry) {
              final i = entry.key;
              final t = entry.value;
              final isExpense = t.type == TransactionType.expense;
              final emoji = _emojiForCategory(t.category);
              final title = t.memo ?? _categoryLabel(t.category, l10n);
              final date = _formatDate(t.createdAt, l10n);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isDark
                                ? HareruColors.darkBg
                                : HareruColors.lightBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child:
                              Text(emoji, style: const TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? HareruColors.darkTextPrimary
                                            : HareruColors.lightTextPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  TypeBadge(type: t.type),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? HareruColors.darkTextTertiary
                                      : HareruColors.lightTextTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${isExpense ? '-' : ''}¥${_formatAmount(t.amount)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isExpense
                                ? (isDark
                                    ? HareruColors.darkTextPrimary
                                    : HareruColors.lightTextPrimary)
                                : const Color(0xFF64748B),
                            fontFeatures: const [
                              FontFeature.tabularFigures()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < recent.length - 1)
                    Divider(
                      height: 1,
                      indent: 70,
                      color: isDark
                          ? HareruColors.darkDivider
                          : HareruColors.lightDivider,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAiInsightCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: HareruColors.primaryStart.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [HareruColors.primaryStart, HareruColors.primaryEnd],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child:
                const Icon(Icons.auto_awesome, size: 22, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiInsightTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? HareruColors.darkTextPrimary
                        : HareruColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.aiInsightMessage,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? HareruColors.darkTextSecondary
                        : HareruColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ Empty State ============

  Widget _buildEmptyMainCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [HareruColors.darkCard, HareruColors.darkCard]
              : [HareruColors.primaryStart, HareruColors.primaryEnd],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            l10n.monthlyRealExpense,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¥ --',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : Colors.white.withValues(alpha: 0.5),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.emptyStateTitle,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.emptyStateDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : Colors.white.withValues(alpha: 0.5),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCards(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    final guides = [
      _GuideItem(Icons.receipt_long_outlined, l10n.guideExpenseTitle,
          l10n.guideExpenseDesc, const Color(0xFFEF4444)),
      _GuideItem(Icons.account_balance_wallet_outlined, l10n.guideBudgetTitle,
          l10n.guideBudgetDesc, const Color(0xFF4A90D9)),
      _GuideItem(Icons.category_outlined, l10n.guideCategoryTitle,
          l10n.guideCategoryDesc, const Color(0xFF10B981)),
    ];

    return Column(
      children: guides.map((g) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: g.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(g.icon, size: 22, color: g.color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        g.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? HareruColors.darkTextPrimary
                              : HareruColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        g.desc,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? HareruColors.darkTextTertiary
                              : HareruColors.lightTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? HareruColors.darkTextTertiary
                      : HareruColors.lightTextTertiary,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GuideItem {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _GuideItem(this.icon, this.title, this.desc, this.color);
}
