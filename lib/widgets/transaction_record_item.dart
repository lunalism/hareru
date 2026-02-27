import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/utils/number_formatter.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/widgets/emoji_badge.dart';
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
    final c = context.colors;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            EmojiBadge(emoji: emoji, isDark: isDark, fontSize: 20),
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
                            color: c.textPrimary,
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
                      color: c.textTertiary,
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
                    ? HareruColors.income
                    : isExpense
                        ? c.textPrimary
                        : c.textSecondary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
