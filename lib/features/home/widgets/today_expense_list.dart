import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/custom_colors.dart';
import '../../../shared/repositories/transaction_repository.dart';
import '../providers/home_provider.dart';
import 'expense_item_tile.dart';

class TodayExpenseList extends ConsumerWidget {
  const TodayExpenseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final transactions = ref.watch(todayTransactionsProvider);
    final todayTotal = ref.watch(todayTotalProvider);
    final formatter = NumberFormat('#,###');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
                Text(
                  l10n.todayExpense,
                  style: TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${l10n.total} ¥${formatter.format(todayTotal)}',
                  style: TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: 14,
                    color: custom.nightLight,
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
                    color: theme.colorScheme.secondary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noExpenseToday,
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 14,
                      color: custom.nightLight,
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
                color: theme.colorScheme.outline,
                thickness: 0.5,
                indent: 68,
                height: 0.5,
              ),
              itemBuilder: (context, index) {
                return ExpenseItemTile(
                  transaction: transactions[index],
                  onDismissed: () {
                    ref.read(transactionRepositoryProvider).delete(
                      transactions[index].id,
                    );
                    ref.invalidate(allTransactionsProvider);
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
