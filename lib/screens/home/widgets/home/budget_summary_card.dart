import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/utils/number_formatter.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/home/widgets/home/budget_dialog.dart';

class BudgetSummaryCard extends ConsumerWidget {
  const BudgetSummaryCard({
    super.key,
    required this.isDark,
    required this.transactions,
  });

  final bool isDark;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final expenseTotal = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final budget = ref.watch(budgetProvider);
    final isBudgetSet = budget > 0;
    final progress = isBudgetSet ? expenseTotal / budget : 0.0;
    final remaining = budget - expenseTotal;
    final isOver = remaining < 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: c.headerCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.monthlyRealExpense,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '¥${formatAmount(expenseTotal)}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (isBudgetSet) ...[
            const SizedBox(height: 12),
            _ProgressBar(progress: progress, isDark: isDark),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isOver
                      ? l10n.overBudget('¥${formatAmount(remaining.abs())}')
                      : l10n.remainingBudget('¥${formatAmount(remaining)}'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isOver
                        ? HareruColors.expense
                        : c.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () => showHomeBudgetDialog(context, ref),
                  child: Text(
                    '✏️ ${l10n.editBudget}',
                    style: TextStyle(
                      fontSize: 12,
                      color: c.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () => showHomeBudgetDialog(context, ref),
                child: Text(
                  '${l10n.setBudget} →',
                  style: TextStyle(
                    fontSize: 13,
                    color: c.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentage = (progress * 100).toStringAsFixed(1);

    final barColor = progress > 1.0
        ? HareruColors.expense
        : progress > 0.9
            ? HareruColors.budgetWarning
            : progress > 0.7
                ? HareruColors.budgetCaution
                : HareruColors.primaryStart;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: c.divider,
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
            color: c.textSecondary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
