import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/models/transaction.dart';

class ExpenseItemTile extends StatelessWidget {
  const ExpenseItemTile({
    super.key,
    required this.transaction,
    required this.onDismissed,
  });

  final Transaction transaction;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final formatter = NumberFormat('#,###');
    final isTransfer = transaction.isTransfer;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.expense,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.skyBlueLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                transaction.categoryEmoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.note,
                    style: isTransfer
                        ? AppTypography.bodyList.copyWith(
                            color: AppColors.transfer,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.transfer,
                          )
                        : AppTypography.bodyList,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${timeFormat.format(transaction.createdAt)} · ${transaction.categoryName}',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            Text(
              '¥${formatter.format(transaction.amount)}',
              style: isTransfer
                  ? AppTypography.amountMedium.copyWith(
                      color: AppColors.transfer,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.transfer,
                    )
                  : AppTypography.amountMedium,
            ),
          ],
        ),
      ),
    );
  }
}
