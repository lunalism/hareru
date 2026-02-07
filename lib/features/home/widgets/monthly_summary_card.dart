import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/custom_colors.dart';
import '../providers/home_provider.dart';

class MonthlySummaryCard extends ConsumerWidget {
  const MonthlySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final expense = ref.watch(monthlyExpenseProvider);
    final budget = ref.watch(monthlyBudgetProvider);
    final lastMonth = ref.watch(lastMonthExpenseProvider);
    final diff = lastMonth - expense;
    final ratio = expense / budget;
    final percent = (ratio * 100).round();
    final formatter = NumberFormat('#,###');
    final month = DateTime.now().month;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to detailed report
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                l10n.monthExpense(month),
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 14,
                  color: custom.nightLight,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '¥',
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    formatter.format(expense),
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildComparison(context, diff, formatter, custom, l10n),
              const SizedBox(height: 20),
              _buildProgressBar(context, ratio, percent, theme, custom),
              const SizedBox(height: 8),
              Text(
                l10n.budget(formatter.format(budget)),
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 12,
                  color: custom.nightLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparison(BuildContext context, int diff, NumberFormat formatter, CustomColors custom, AppLocalizations l10n) {
    final isSaving = diff > 0;
    final color = isSaving ? custom.incomeGreen : custom.expenseRed;
    final text = isSaving
        ? l10n.comparedLastMonthDown(formatter.format(diff.abs()))
        : l10n.comparedLastMonthUp(formatter.format(diff.abs()));

    return Text(
      text,
      style: TextStyle(
        fontFamily: 'PretendardJP',
        fontSize: 12,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double ratio, int percent, ThemeData theme, CustomColors custom) {
    Color barColor;
    if (ratio < 0.6) {
      barColor = theme.colorScheme.primary;
    } else if (ratio < 0.8) {
      barColor = theme.colorScheme.secondary;
    } else {
      barColor = custom.expenseRed;
    }

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: theme.colorScheme.outline,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$percent%',
          style: TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: custom.nightLight,
          ),
        ),
      ],
    );
  }
}
