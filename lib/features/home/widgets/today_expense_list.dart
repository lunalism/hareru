import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../providers/home_provider.dart';
import 'expense_item_tile.dart';

class TodayExpenseList extends ConsumerWidget {
  const TodayExpenseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(todayTransactionsProvider);
    final todayTotal = ref.watch(todayTotalProvider);
    final formatter = NumberFormat('#,###');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('今日の支出', style: AppTypography.sectionHeader),
                Text(
                  '合計 ¥${formatter.format(todayTotal)}',
                  style: AppTypography.body.copyWith(
                    color: AppColors.nightLight,
                  ),
                ),
              ],
            ),
          ),
          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.wb_sunny_rounded,
                    size: 48,
                    color: AppColors.sunlight.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '今日はまだ支出がありません',
                    style: AppTypography.body.copyWith(
                      color: AppColors.nightLight,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (_, _) => Divider(
                color: AppColors.border,
                thickness: 0.5,
                indent: 68,
                height: 0.5,
              ),
              itemBuilder: (context, index) {
                return ExpenseItemTile(
                  transaction: transactions[index],
                  onDismissed: () {
                    // TODO: delete transaction
                  },
                );
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
