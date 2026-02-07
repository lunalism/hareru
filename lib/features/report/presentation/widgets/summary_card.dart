import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../providers/report_providers.dart';

class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realExpense = ref.watch(reportRealExpenseProvider);
    final income = ref.watch(reportIncomeProvider);
    final excludedTransfer = ref.watch(reportExcludedTransferProvider);
    final prevExpense = ref.watch(reportPrevExpenseProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat('#,##0');

    final balance = income - realExpense;
    final diff = prevExpense > 0 ? realExpense - prevExpense : 0;
    final diffPct =
        prevExpense > 0 ? ((diff / prevExpense) * 100).round() : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.brightness == Brightness.light
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))]
            : null,
        border: theme.brightness == Brightness.dark
            ? Border.all(color: theme.colorScheme.outline)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.realExpense,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '¥${fmt.format(realExpense)}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          // Transfer excluded badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.swap_horiz,
                    size: 14, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  l10n.transferExcluded(fmt.format(excludedTransfer)),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Income / Expense / Balance
          _SummaryRow(
            label: l10n.income,
            amount: income,
            color: const Color(0xFF4CAF50),
            fmt: fmt,
          ),
          const SizedBox(height: 4),
          _SummaryRow(
            label: l10n.expense,
            amount: realExpense,
            color: theme.colorScheme.onSurface,
            fmt: fmt,
          ),
          const SizedBox(height: 4),
          _SummaryRow(
            label: l10n.balance,
            amount: balance,
            color: balance >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFEF5350),
            fmt: fmt,
            showSign: true,
          ),
          // Month comparison
          if (prevExpense > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${l10n.comparedToPrevMonth} ',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  diff <= 0 ? '▼ ${diffPct.abs()}%' : '▲ $diffPct%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: diff <= 0
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFEF5350),
                  ),
                ),
                Text(
                  ' (¥${fmt.format(diff.abs())}${diff <= 0 ? '↓' : '↑'})',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    required this.color,
    required this.fmt,
    this.showSign = false,
  });

  final String label;
  final int amount;
  final Color color;
  final NumberFormat fmt;
  final bool showSign;

  @override
  Widget build(BuildContext context) {
    final prefix = showSign ? (amount >= 0 ? '+' : '-') : '';
    final display = showSign ? amount.abs() : amount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Text(
          '$prefix¥${fmt.format(display)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
