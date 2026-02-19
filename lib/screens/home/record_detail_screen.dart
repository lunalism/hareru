import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/home/widgets/add_transaction_sheet.dart';

class RecordDetailScreen extends ConsumerStatefulWidget {
  const RecordDetailScreen({super.key, required this.transaction});

  final Transaction transaction;

  @override
  ConsumerState<RecordDetailScreen> createState() =>
      _RecordDetailScreenState();
}

class _RecordDetailScreenState extends ConsumerState<RecordDetailScreen> {
  late Transaction _transaction;

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
  }

  String _categoryLabel(String category, AppLocalizations l10n) {
    final cat = ref.read(categoryProvider.notifier).getCategoryById(category);
    if (cat == null) return resolveL10nKey(category, l10n);
    if (!cat.isDefault) return cat.name;
    return resolveL10nKey(cat.name, l10n);
  }

  String _emojiForCategory(String category) {
    final cat = ref.read(categoryProvider.notifier).getCategoryById(category);
    return cat?.emoji ?? '\u{1F4DD}';
  }

  String _typeLabel(TransactionType type, AppLocalizations l10n) {
    return switch (type) {
      TransactionType.expense => l10n.expense,
      TransactionType.transfer => l10n.transfer,
      TransactionType.savings => l10n.savings,
      TransactionType.income => l10n.income,
    };
  }

  Color _typeColor(TransactionType type) {
    return switch (type) {
      TransactionType.expense => const Color(0xFFEF4444),
      TransactionType.transfer => const Color(0xFF3B82F6),
      TransactionType.savings => const Color(0xFF10B981),
      TransactionType.income => const Color(0xFFF59E0B),
    };
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

  String _formatDateTime(DateTime date, AppLocalizations l10n, String lang) {
    final month = date.month;
    final day = date.day;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final time = '$hour:$minute';

    return switch (lang) {
      'ko' => '$month월 $day일 $time',
      'en' => '${_monthNameEn(month)} $day, $time',
      _ => '$month月$day日 $time',
    };
  }

  String _monthNameEn(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  void _showDeleteDialog() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
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
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(transactionProvider.notifier)
                  .delete(_transaction.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.recordDeleted)),
              );
            },
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
  }

  void _openEditSheet() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.92,
        child: AddTransactionSheet(
          editTransaction: _transaction,
          onSave: (updated) {
            ref.read(transactionProvider.notifier).update(updated);
            Navigator.pop(context); // close sheet
            setState(() => _transaction = updated);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.recordUpdated)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final t = _transaction;
    final emoji = _emojiForCategory(t.category);
    final catLabel = _categoryLabel(t.category, l10n);
    final typeColor = _typeColor(t.type);
    final isExpense = t.type == TransactionType.expense;
    final isIncome = t.type == TransactionType.income;

    final amountPrefix = isExpense ? '-' : isIncome ? '+' : '';
    final amountText = '$amountPrefix\u00a5${_formatAmount(t.amount)}';

    return Scaffold(
      backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: _openEditSheet,
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 22,
                          color: isDark
                              ? HareruColors.darkTextSecondary
                              : HareruColors.lightTextSecondary,
                        ),
                      ),
                      IconButton(
                        onPressed: _showDeleteDialog,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 22,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Emoji
                    Text(emoji, style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    // Category name
                    Text(
                      catLabel,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? HareruColors.darkTextPrimary
                            : HareruColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Detail card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Column(
                        children: [
                          _infoRow(
                            l10n.transactionType,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: typeColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _typeLabel(t.type, l10n),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: typeColor,
                                  ),
                                ),
                              ],
                            ),
                            isDark,
                          ),
                          _divider(isDark),
                          _infoRow(
                            l10n.transactionAmount,
                            Text(
                              amountText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: typeColor,
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                            isDark,
                          ),
                          _divider(isDark),
                          _infoRow(
                            l10n.transactionDateTime,
                            Text(
                              _formatDateTime(t.createdAt, l10n, lang),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            isDark,
                          ),
                          _divider(isDark),
                          _infoRow(
                            l10n.category,
                            Text(
                              catLabel,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            isDark,
                          ),
                          _divider(isDark),
                          _infoRow(
                            l10n.transactionMemo,
                            Text(
                              t.memo ?? l10n.noMemo,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: t.memo == null
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                color: t.memo == null
                                    ? const Color(0xFF94A3B8)
                                    : (isDark
                                        ? const Color(0xFFF1F5F9)
                                        : const Color(0xFF1E293B)),
                              ),
                            ),
                            isDark,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Edit button
                    GestureDetector(
                      onTap: _openEditSheet,
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.editRecord,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Delete button
                    GestureDetector(
                      onTap: _showDeleteDialog,
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEF4444)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.deleteRecord,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, Widget value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          Expanded(child: value),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? HareruColors.darkDivider : HareruColors.lightDivider,
    );
  }
}
