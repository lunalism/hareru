import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/screens/home/widgets/add_transaction_screen.dart';
import 'package:hareru/screens/home/widgets/home/budget_dialog.dart';
import 'package:hareru/screens/settings/category_management_screen.dart';

class EmptyMainCard extends StatelessWidget {
  const EmptyMainCard({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardColor = isDark ? HareruColors.darkCard : HareruColors.headerCardLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            l10n.monthlyRealExpense,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¥ --',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextTertiary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.emptyStateTitle,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.emptyStateDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextTertiary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class GuideCards extends ConsumerWidget {
  const GuideCards({super.key, required this.isDark});

  final bool isDark;

  void _openAddTransactionScreen(BuildContext context, WidgetRef ref) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AddTransactionScreen(
          onSave: (transaction) {
            ref.read(transactionProvider.notifier).add(transaction);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final guides = [
      _GuideItem(Icons.receipt_long_outlined, l10n.guideExpenseTitle,
          l10n.guideExpenseDesc, const Color(0xFFE8453C), onTap: () {
        _openAddTransactionScreen(context, ref);
      }),
      _GuideItem(Icons.account_balance_wallet_outlined, l10n.guideBudgetTitle,
          l10n.guideBudgetDesc, const Color(0xFFE8453C), onTap: () {
        showHomeBudgetDialog(context, ref);
      }),
      _GuideItem(Icons.category_outlined, l10n.guideCategoryTitle,
          l10n.guideCategoryDesc, const Color(0xFFE8453C), onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CategoryManagementScreen(),
          ),
        );
      }),
    ];

    return Column(
      children: guides.map((g) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: g.onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: HareruColors.guideIconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(g.icon, size: 22, color: g.color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? HareruColors.darkTextPrimary
                                : HareruColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          g.desc,
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
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark
                        ? HareruColors.darkTextTertiary
                        : HareruColors.lightTextTertiary,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GuideItem {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  final VoidCallback? onTap;
  const _GuideItem(this.icon, this.title, this.desc, this.color, {this.onTap});
}
