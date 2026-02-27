import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/utils/number_formatter.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';

class BreakdownCard extends ConsumerWidget {
  const BreakdownCard({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(transactionProvider.notifier);
    final labelColor =
        isDark ? HareruColors.darkTextSecondary : HareruColors.lightTextSecondary;
    final dividerColor =
        isDark ? HareruColors.darkDivider : HareruColors.lightDivider;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor),
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
                amount: '¥${formatAmount(notifier.expenseTotal)}',
                typeColor: const Color(0xFFEF4444),
                labelColor: labelColor,
              ),
              Container(width: 1, height: 32, color: dividerColor),
              _TypeColumn(
                label: l10n.transfer,
                amount: '¥${formatAmount(notifier.transferTotal)}',
                typeColor: const Color(0xFF5B7FCC),
                labelColor: labelColor,
              ),
              Container(width: 1, height: 32, color: dividerColor),
              _TypeColumn(
                label: l10n.savings,
                amount: '¥${formatAmount(notifier.savingsTotal)}',
                typeColor: const Color(0xFF10B981),
                labelColor: labelColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: dividerColor),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                l10n.income,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
              const Spacer(),
              Text(
                '¥${formatAmount(notifier.incomeTotal)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF59E0B),
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
