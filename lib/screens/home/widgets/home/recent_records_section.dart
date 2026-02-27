import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/home/all_records_screen.dart';
import 'package:hareru/screens/home/record_detail_screen.dart';
import 'package:hareru/widgets/delete_confirmation_dialog.dart';
import 'package:hareru/widgets/transaction_record_item.dart';

class RecentRecordsSection extends ConsumerWidget {
  const RecentRecordsSection({
    super.key,
    required this.transactions,
    required this.isDark,
  });

  final List<Transaction> transactions;
  final bool isDark;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
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
                color: c.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AllRecordsScreen()),
              ),
              child: Text(
                l10n.seeAll,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: HareruColors.primaryStart,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: recent.asMap().entries.map((entry) {
              final i = entry.key;
              final t = entry.value;
              final catNotifier = ref.read(categoryProvider.notifier);
              final emoji = emojiForCategory(t.category, t.type, catNotifier);
              final title = t.memo ?? categoryLabel(t.category, l10n, catNotifier);
              final date = _formatDate(t.createdAt, l10n);

              return Column(
                children: [
                  Dismissible(
                    key: Key(t.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: HareruColors.expense,
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Colors.white, size: 24),
                    ),
                    confirmDismiss: (_) =>
                        showDeleteConfirmation(
                            context: context, l10n: l10n, isDark: isDark),
                    onDismissed: (_) {
                      ref
                          .read(transactionProvider.notifier)
                          .delete(t.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.recordDeleted)),
                      );
                    },
                    child: TransactionRecordItem(
                      emoji: emoji,
                      title: title,
                      subtitle: date,
                      transaction: t,
                      isDark: isDark,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RecordDetailScreen(transaction: t),
                        ),
                      ),
                    ),
                  ),
                  if (i < recent.length - 1)
                    Divider(
                      height: 1,
                      indent: 70,
                      color: c.divider,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
