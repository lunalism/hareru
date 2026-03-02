import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/utils/number_formatter.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';

class BreakdownCard extends StatelessWidget {
  const BreakdownCard({
    super.key,
    required this.isDark,
    required this.transactions,
  });

  final bool isDark;
  final List<Transaction> transactions;

  double _totalByType(TransactionType type) => transactions
      .where((t) => t.type == type)
      .fold(0.0, (sum, t) => sum + t.amount);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _TypeColumn(
                label: l10n.expense,
                amount: '¥${formatAmount(_totalByType(TransactionType.expense))}',
                typeColor: HareruColors.expense,
                labelColor: c.textSecondary,
              ),
              Container(width: 1, height: 32, color: c.divider),
              _TypeColumn(
                label: l10n.transfer,
                amount: '¥${formatAmount(_totalByType(TransactionType.transfer))}',
                typeColor: HareruColors.transferBlue,
                labelColor: c.textSecondary,
              ),
              Container(width: 1, height: 32, color: c.divider),
              _TypeColumn(
                label: l10n.savings,
                amount: '¥${formatAmount(_totalByType(TransactionType.savings))}',
                typeColor: HareruColors.savings,
                labelColor: c.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: c.divider),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: HareruColors.income,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                l10n.income,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '¥${formatAmount(_totalByType(TransactionType.income))}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HareruColors.income,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeColumn extends StatelessWidget {
  const _TypeColumn({
    required this.label,
    required this.amount,
    required this.typeColor,
    required this.labelColor,
  });

  final String label;
  final String amount;
  final Color typeColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: typeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              maxLines: 1,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: typeColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
