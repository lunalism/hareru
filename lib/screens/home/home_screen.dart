import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/category_provider.dart';
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
                const SizedBox(height: 8),
                _buildBreakdownCard(context, isDark, ref),
                const SizedBox(height: 24),
                _buildRecentRecords(context, isDark, transactions, ref),
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
    final expenseTotal = ref.read(transactionProvider.notifier).expenseTotal;
    final budget = ref.watch(budgetProvider);
    final isBudgetSet = budget > 0;
    final progress = isBudgetSet ? expenseTotal / budget : 0.0;
    final remaining = budget - expenseTotal;
    final isOver = remaining < 0;

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
              if (isBudgetSet) ...[
                const SizedBox(height: 12),
                _buildProgressBar(progress),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isOver
                          ? l10n.overBudget('¥${_formatAmount(remaining.abs())}')
                          : l10n.remainingBudget('¥${_formatAmount(remaining)}'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isOver
                            ? const Color(0xFFFECACA)
                            : Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showBudgetDialog(context, ref),
                      child: Text(
                        '✏️ ${l10n.editBudget}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () => _showBudgetDialog(context, ref),
                    child: Text(
                      '${l10n.setBudget} →',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentage = (progress * 100).toStringAsFixed(1);

    // Color based on progress level
    final barColor = progress > 1.0
        ? const Color(0xFFEF4444)
        : progress > 0.9
            ? const Color(0xFFFCA5A5)
            : progress > 0.7
                ? const Color(0xFFFCD34D)
                : Colors.white.withValues(alpha: 0.9);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: clampedProgress),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, value, _) {
                  return FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.7),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  void _showBudgetDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentBudget = ref.read(budgetProvider);
    final controller = TextEditingController(
      text: currentBudget > 0 ? currentBudget.toString() : '',
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              isDark ? HareruColors.darkCard : HareruColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.setBudgetTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: true,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              prefixText: '¥ ',
              prefixStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: HareruColors.primaryStart,
              ),
              hintText: '150000',
              hintStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? HareruColors.darkTextTertiary
                    : HareruColors.lightTextTertiary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? HareruColors.darkDivider
                      : HareruColors.lightDivider,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: HareruColors.primaryStart,
                  width: 2,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : HareruColors.lightTextSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final value = int.tryParse(controller.text) ?? 0;
                ref.read(budgetProvider.notifier).setBudget(value);
                Navigator.pop(dialogContext);
              },
              child: Text(
                l10n.save,
                style: const TextStyle(
                  color: HareruColors.primaryStart,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBreakdownCard(
      BuildContext context, bool isDark, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(transactionProvider.notifier);
    final labelColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final dividerColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          _killerColumn(
            l10n.expense,
            '¥${_formatAmount(notifier.expenseTotal)}',
            const Color(0xFFEF4444),
            labelColor,
          ),
          Container(width: 1, height: 32, color: dividerColor),
          _killerColumn(
            l10n.transfer,
            '¥${_formatAmount(notifier.transferTotal)}',
            const Color(0xFF3B82F6),
            labelColor,
          ),
          Container(width: 1, height: 32, color: dividerColor),
          _killerColumn(
            l10n.savings,
            '¥${_formatAmount(notifier.savingsTotal)}',
            const Color(0xFF10B981),
            labelColor,
          ),
          Container(width: 1, height: 32, color: dividerColor),
          _killerColumn(
            l10n.income,
            '¥${_formatAmount(notifier.incomeTotal)}',
            const Color(0xFFF59E0B),
            labelColor,
          ),
        ],
      ),
    );
  }

  Widget _killerColumn(
      String label, String amount, Color typeColor, Color labelColor) {
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
                  color: typeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: typeColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  String _emojiForCategory(String category, WidgetRef ref) {
    final cat = ref.read(categoryProvider.notifier).getCategoryById(category);
    return cat?.emoji ?? '\u{1F4DD}';
  }

  String _categoryLabel(String category, AppLocalizations l10n, WidgetRef ref) {
    final cat = ref.read(categoryProvider.notifier).getCategoryById(category);
    if (cat == null) return category;
    if (!cat.isDefault) return cat.name;
    return _resolveL10nKey(cat.name, l10n);
  }

  String _resolveL10nKey(String key, AppLocalizations l10n) {
    return switch (key) {
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
      'catUtility' => l10n.catUtility,
      'catBankTransfer' => l10n.catBankTransfer,
      'catCard' => l10n.catCard,
      'catEMoney' => l10n.catEMoney,
      'catTransferOther' => l10n.catTransferOther,
      'catSavings' => l10n.catSavings,
      'catInvestment' => l10n.catInvestment,
      'catGoal' => l10n.catGoal,
      'catSavingsOther' => l10n.catSavingsOther,
      'salary' => l10n.salary,
      'sideJob' => l10n.sideJob,
      'bonus' => l10n.bonus,
      'allowance' => l10n.allowance,
      'investmentReturn' => l10n.investmentReturn,
      'fleaMarket' => l10n.fleaMarket,
      'extraIncome' => l10n.extraIncome,
      'otherIncome' => l10n.otherIncome,
      _ => key,
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
      BuildContext context, bool isDark, List<Transaction> transactions, WidgetRef ref) {
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
              final isIncome = t.type == TransactionType.income;
              final emoji = _emojiForCategory(t.category, ref);
              final title = t.memo ?? _categoryLabel(t.category, l10n, ref);
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
                          '${isExpense ? '-' : isIncome ? '+' : ''}¥${_formatAmount(t.amount)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isIncome
                                ? const Color(0xFFF59E0B)
                                : isExpense
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
