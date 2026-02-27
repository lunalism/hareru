import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/utils/number_formatter.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/widgets/type_badge.dart';

class TransactionRecordItem extends StatelessWidget {
  const TransactionRecordItem({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.transaction,
    required this.isDark,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Transaction transaction;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final isIncome = transaction.type == TransactionType.income;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark ? HareruColors.darkBg : HareruColors.lightBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
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
                      TypeBadge(type: transaction.type),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
              '${isExpense ? '-' : isIncome ? '+' : ''}\u00a5${formatAmount(transaction.amount)}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isIncome
                    ? const Color(0xFFF59E0B)
                    : isExpense
                        ? (isDark
                            ? HareruColors.darkTextPrimary
                            : HareruColors.lightTextPrimary)
                        : (isDark
                            ? HareruColors.darkTextSecondary
                            : HareruColors.lightTextSecondary),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
