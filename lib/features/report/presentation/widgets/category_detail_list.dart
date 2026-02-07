import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../shared/models/default_categories.dart';
import '../../domain/category_expense.dart';
import '../../providers/report_providers.dart';

class CategoryDetailList extends ConsumerWidget {
  const CategoryDetailList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(reportCategoryExpensesProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat('#,##0');

    if (categories.isEmpty) return const SizedBox.shrink();

    final maxAmount = categories.first.amount;

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
            l10n.categoryDetail,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...categories.asMap().entries.map((entry) {
            final i = entry.key;
            final cat = entry.value;
            final ratio = maxAmount > 0 ? cat.amount / maxAmount : 0.0;
            final displayName = _resolveCategoryName(context, cat);
            final isLast = i == categories.length - 1;

            return Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    // Future: navigate to category detail
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '¥${fmt.format(cat.amount)}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  Text(
                                    l10n.transactionCount(cat.count),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Progress bar
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final maxWidth = constraints.maxWidth * 0.6;
                                  return Container(
                                    height: 6,
                                    width: maxWidth,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      height: 6,
                                      width: maxWidth * ratio,
                                      decoration: BoxDecoration(
                                        color: cat.color,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _resolveCategoryName(BuildContext context, CategoryExpense cat) {
    for (final entry in DefaultCategories.expense) {
      if (entry.localeKey == cat.categoryKey) {
        return entry.getDisplayName(context);
      }
    }
    for (final entry in DefaultCategories.income) {
      if (entry.localeKey == cat.categoryKey) {
        return entry.getDisplayName(context);
      }
    }
    return cat.categoryName;
  }
}
