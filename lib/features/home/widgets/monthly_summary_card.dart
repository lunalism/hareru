import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../providers/home_provider.dart';

class MonthlySummaryCard extends ConsumerWidget {
  const MonthlySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expense = ref.watch(monthlyExpenseProvider);
    final budget = ref.watch(monthlyBudgetProvider);
    final lastMonth = ref.watch(lastMonthExpenseProvider);
    final diff = lastMonth - expense;
    final ratio = expense / budget;
    final percent = (ratio * 100).round();
    final formatter = NumberFormat('#,###');
    final month = DateTime.now().month;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to detailed report
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                '$month月の支出',
                style: AppTypography.body.copyWith(
                  color: AppColors.nightLight,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('¥', style: AppTypography.currencySymbol),
                  Text(
                    formatter.format(expense),
                    style: AppTypography.amountLarge,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildComparison(diff, formatter),
              const SizedBox(height: 20),
              _buildProgressBar(ratio, percent),
              const SizedBox(height: 8),
              Text(
                '予算 ¥${formatter.format(budget)}',
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparison(int diff, NumberFormat formatter) {
    final isSaving = diff > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '先月より ¥${formatter.format(diff.abs())} ${isSaving ? '↓' : '↑'}  ',
          style: AppTypography.caption.copyWith(
            color: isSaving ? AppColors.income : AppColors.expense,
          ),
        ),
        Text(
          isSaving ? '節約！ 🎉' : '使いすぎ注意 ⚠️',
          style: AppTypography.caption.copyWith(
            color: isSaving ? AppColors.income : AppColors.expense,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double ratio, int percent) {
    Color barColor;
    if (ratio < 0.6) {
      barColor = AppColors.skyBlue;
    } else if (ratio < 0.8) {
      barColor = AppColors.sunlight;
    } else {
      barColor = AppColors.expense;
    }

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$percent%',
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
