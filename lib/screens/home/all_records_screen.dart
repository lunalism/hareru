import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/home/record_detail_screen.dart';
import 'package:hareru/widgets/type_badge.dart';

class AllRecordsScreen extends ConsumerWidget {
  const AllRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final transactions = ref.watch(transactionProvider);

    // Filter current month only
    final now = DateTime.now();
    final monthly = transactions
        .where((t) => t.createdAt.year == now.year && t.createdAt.month == now.month)
        .toList();

    // Group by date
    final grouped = <DateTime, List<Transaction>>{};
    for (final t in monthly) {
      final key = DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: isDark
                          ? HareruColors.darkTextPrimary
                          : HareruColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    l10n.allRecords,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? HareruColors.darkTextPrimary
                          : HareruColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: monthly.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: isDark
                                ? HareruColors.darkTextTertiary
                                : HareruColors.lightTextTertiary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.noRecordsEmpty,
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark
                                  ? HareruColors.darkTextSecondary
                                  : HareruColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      itemCount: sortedDates.length,
                      itemBuilder: (context, sectionIndex) {
                        final date = sortedDates[sectionIndex];
                        final items = grouped[date]!;
                        final dateLabel = _dateHeader(date, l10n, lang);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sectionIndex > 0) const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 8),
                              child: Text(
                                dateLabel,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? HareruColors.darkTextSecondary
                                      : HareruColors.lightTextSecondary,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? HareruColors.darkCard
                                    : HareruColors.lightCard,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: items.asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final t = entry.value;
                                  return Column(
                                    children: [
                                      _buildRecordItem(
                                          context, t, isDark, l10n, ref),
                                      if (i < items.length - 1)
                                        Divider(
                                          height: 1,
                                          indent: 70,
                                          color: isDark
                                              ? HareruColors.darkDivider
                                              : HareruColors.lightDivider,
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateHeader(DateTime date, AppLocalizations l10n, String lang) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return l10n.today;
    if (date == yesterday) return l10n.yesterday;

    return switch (lang) {
      'ko' => '${date.month}월 ${date.day}일',
      'en' => '${_monthNameEn(date.month)} ${date.day}',
      _ => '${date.month}月${date.day}日',
    };
  }

  String _monthNameEn(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildRecordItem(BuildContext context, Transaction t, bool isDark,
      AppLocalizations l10n, WidgetRef ref) {
    final isExpense = t.type == TransactionType.expense;
    final isIncome = t.type == TransactionType.income;
    final cat = ref.read(categoryProvider.notifier).getCategoryById(t.category);
    final emoji = cat?.emoji ?? '\u{1F4DD}';
    final catLabel = cat == null
        ? resolveL10nKey(t.category, l10n)
        : cat.isDefault
            ? resolveL10nKey(cat.name, l10n)
            : cat.name;
    final title = t.memo ?? catLabel;
    final hour = t.createdAt.hour.toString().padLeft(2, '0');
    final minute = t.createdAt.minute.toString().padLeft(2, '0');
    final time = '$hour:$minute';

    return Dismissible(
      key: Key(t.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 24),
      ),
      confirmDismiss: (_) => _confirmDelete(context, l10n, isDark),
      onDismissed: (_) {
        ref.read(transactionProvider.notifier).delete(t.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.recordDeleted)),
        );
      },
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecordDetailScreen(transaction: t),
          ),
        ),
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
                        TypeBadge(type: t.type),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
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
                '${isExpense ? '-' : isIncome ? '+' : ''}\u00a5${_formatAmount(t.amount)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isIncome
                      ? const Color(0xFFF59E0B)
                      : isExpense
                          ? (isDark
                              ? HareruColors.darkTextPrimary
                              : HareruColors.lightTextPrimary)
                          : const Color(0xFF64748B),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(
      BuildContext context, AppLocalizations l10n, bool isDark) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? HareruColors.darkCard : HareruColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.deleteConfirm,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
        ),
        content: Text(
          l10n.deleteConfirmSub,
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? HareruColors.darkTextSecondary
                : HareruColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.deleteRecord,
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  String _formatAmount(double value) {
    final intVal = value.truncateToDouble() == value ? value.toInt() : value;
    final s = intVal.toString();
    if (s.contains('.')) {
      final parts = s.split('.');
      return '${_addCommas(parts[0])}.${parts[1]}';
    }
    return _addCommas(s);
  }

  String _addCommas(String s) {
    final result = StringBuffer();
    var count = 0;
    for (var i = s.length - 1; i >= 0; i--) {
      result.write(s[i]);
      count++;
      if (count % 3 == 0 && i > 0) result.write(',');
    }
    return result.toString().split('').reversed.join();
  }
}
