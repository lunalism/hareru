import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/custom_colors.dart';
import '../../../shared/models/transaction_type.dart';
import '../providers/input_provider.dart';

class AmountDisplay extends ConsumerWidget {
  const AmountDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final formState = ref.watch(inputProvider);
    final displayAmount = formState.displayAmount;
    final type = formState.transactionType;

    final Color amountColor;
    switch (type) {
      case TransactionType.expense:
        amountColor = custom.expenseRed;
      case TransactionType.income:
        amountColor = custom.incomeGreen;
      case TransactionType.transfer:
        amountColor = custom.transferGray;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '¥',
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: amountColor.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              displayAmount,
              style: TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: displayAmount.length > 10 ? 32 : 40,
                fontWeight: FontWeight.w700,
                color: formState.amountString.isEmpty
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.2)
                    : amountColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
