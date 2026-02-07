import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/custom_colors.dart';
import '../../../shared/models/default_categories.dart';
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
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final timeFormat = DateFormat('HH:mm');
    final formatter = NumberFormat('#,###');
    final isTransfer = transaction.isTransfer;
    final categoryDisplay = CategoryEntry(
      emoji: transaction.categoryEmoji,
      localeKey: transaction.categoryKey,
    ).getDisplayName(context);
    final displayNote = transaction.note.isNotEmpty
        ? transaction.note
        : categoryDisplay;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: custom.expenseRed,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: custom.skyBlueLight,
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
                    displayNote,
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 15,
                      color: isTransfer
                          ? custom.transferGray
                          : theme.colorScheme.onSurface,
                      decoration:
                          isTransfer ? TextDecoration.lineThrough : null,
                      decorationColor:
                          isTransfer ? custom.transferGray : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${timeFormat.format(transaction.createdAt)} · $categoryDisplay',
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 12,
                      color: custom.nightLight,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '¥${formatter.format(transaction.amount)}',
              style: TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isTransfer
                    ? custom.transferGray
                    : theme.colorScheme.onSurface,
                decoration: isTransfer ? TextDecoration.lineThrough : null,
                decorationColor: isTransfer ? custom.transferGray : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
