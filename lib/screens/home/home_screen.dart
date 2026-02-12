import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/widgets/type_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Toggle: true → empty state, false → filled state
  static const _showEmptyState = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              if (_showEmptyState) ...[
                _buildEmptyMainCard(context, isDark),
                const SizedBox(height: 24),
                _buildGuideCards(context, isDark),
              ] else ...[
                _buildMainAmountCard(context, isDark),
                const SizedBox(height: 24),
                _buildRecentRecords(context, isDark),
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

  Widget _buildMainAmountCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    const budgetPercent = 62;

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
              const Text(
                '¥23,480',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 16),
              // Budget progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.budgetUsed(budgetPercent),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        l10n.budgetRemaining('93,220'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: budgetPercent / 100,
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFFD54F)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Divider
              Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.12),
              ),
              const SizedBox(height: 16),
              // 3-column: 支出 / 振替 / 貯金 (Killer Feature)
              Row(
                children: [
                  _killerColumn(
                    l10n.expense,
                    '¥23,480',
                    const Color(0xFFEF4444),
                    const Color(0xFFFCA5A5),
                  ),
                  _killerDivider(),
                  _killerColumn(
                    l10n.transfer,
                    '¥50,000',
                    const Color(0xFF3B82F6),
                    const Color(0xFF93C5FD),
                  ),
                  _killerDivider(),
                  _killerColumn(
                    l10n.savings,
                    '¥30,000',
                    const Color(0xFF10B981),
                    const Color(0xFF6EE7B7),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _killerColumn(
      String label, String amount, Color dotColor, Color amountColor) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: amountColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _killerDivider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }

  Widget _buildRecentRecords(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    final records = [
      _RecordItem('🛒', 'セブンイレブン', '${l10n.today} 12:30',
          TransactionType.expense, '¥850'),
      _RecordItem(
          '🍜', 'すき家', '${l10n.today} 11:45', TransactionType.expense, '¥780'),
      _RecordItem('🏦', '貯金口座へ', '${l10n.today} 10:00',
          TransactionType.transfer, '¥50,000'),
      _RecordItem('💰', 'つみたて貯金', '${l10n.yesterday} 09:00',
          TransactionType.savings, '¥30,000'),
      _RecordItem('☕', 'スターバックス', '${l10n.yesterday} 15:20',
          TransactionType.expense, '¥590'),
      _RecordItem('🚃', 'Suicaチャージ', '2/10 08:30',
          TransactionType.transfer, '¥3,000'),
    ];

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
            children: records.asMap().entries.map((entry) {
              final i = entry.key;
              final r = entry.value;
              final isExpense = r.type == TransactionType.expense;

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
                          child: Text(r.emoji,
                              style: const TextStyle(fontSize: 20)),
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
                                      r.title,
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
                                  TypeBadge(type: r.type),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                r.date,
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
                          '${isExpense ? '-' : ''}¥${r.amount.replaceAll('¥', '')}',
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
                  if (i < records.length - 1)
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

class _RecordItem {
  final String emoji;
  final String title;
  final String date;
  final TransactionType type;
  final String amount;
  const _RecordItem(this.emoji, this.title, this.date, this.type, this.amount);
}

class _GuideItem {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _GuideItem(this.icon, this.title, this.desc, this.color);
}
